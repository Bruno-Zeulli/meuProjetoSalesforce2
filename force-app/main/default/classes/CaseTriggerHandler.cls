/**
 * @description       : Resposável por acionar manipulações no objeto 'Case', após inserções ou atualizações nesse objeto.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 10-20-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 2.1   03-15-2021   MarceloMartins                       Refatoração da classe e inclusão da condição prestamista com residual
 **/
public without sharing class CaseTriggerHandler {
    /**@discription declaração das variáveis */
    private boolean isExecuting = false;

    public List<Case> oldRecordsList = null;
    public List<Case> newRecordsList = null;

    public Map<Id, Case> oldRecordsMap = null;
    public Map<Id, Case> newRecordsMap = null;

    Id idCase = null;
    Case oldCase = new Case();

    private List<Id> casosMktCloud = new List<Id>();
    private List<Id> casosMktCloudRCPM = new List<Id>();
    private List<Id> casosMktCloudAgro = new List<Id>();
    private List<Id> casosMktCloudPrestamista = new List<Id>();
    private List<Id> casosRemoveAtivo = new List<Id>();
    private List<String> filasWorkflow = new List<String>();

    private Map<Id, List<String>> mapaComunicados = new Map<Id, List<String>>();

    private String recordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
    private String recordTypeIdHabitacional = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroHabitacional').getRecordTypeId();
    private String recordTypeIdPrestamista = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroPrestamista').getRecordTypeId();
    private String recordTypeIdComunicadoRCPM = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPORcpm').getRecordTypeId();
    private String recordTypeIdComunicadoAgro = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOAgro').getRecordTypeId();
    private String recordTypeIdChatBot = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ChatBot').getRecordTypeId();

    /**
     *@description Construtor que recebe os parametros da Trigger
     *@param isExecuting boolean true para execução
     */
    public CaseTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){
        updateCaseTicketsOwnersWithQueue();
        routeCaseTicketsOwnersWithQueue();
        // changeOpportunityStagePlacement();
    }

    /**
     *@description trigger depois de inserir
     */
    public void onAfterInsert(){
        updateContactSync();
        callMarketingCloud();
        sendComunicadoSinistro();
        callDistribuite();
        // createTaskNotification();
    }
    /**
     *@description trigger antes de atualizar
     */
    public void onBeforeUpdate(){
        updateMilestoneChatBot();
        changeCaseStatusByOwner();
        changeOpportunityStagePlacement();
        fillBandeiraAndProdutoTicketsFromOldRecord();
    }

    /**
     *@description trigger depois de atualizar case
     */
    public void onAfterUpdate(){
        callMarketingCloud();
        shareCaseWithQueueTickets();
        //completeMilestoneTickets();
        sendComunicadoSinistro();
        createTaskNotification();
        // callDistribuite();
        // changeOpportunityStagePlacement();
    }

    public void callDistribuite(){
        for(Case objCase : newRecordsList){
            if(objCase.RecordTypeId == recordTypeIdChatBot){
                User objUser = [SELECT Id, Profile.Name, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                if( (
                        objUser.Profile.Name == 'System Administrator' ||
                        objUser.Profile.Name == 'Administrador' ||
                        objUser.Profile.Name.startsWith('Integrador')
                    )
                    &&
                    (
                        objUser.UserRole.Name == '' ||
                        objUser.UserRole.Name == null
                    )
                ){
                    BeeTalkWhatsAppConsoleController.getInstance().DistribuiteCaseToOperador();
                }
            }
        }
    }

    private id getQueueIdTickets(String queueName){
        String idReturn = '';
        List<Group> lstGroup = new List<Group>();
        lstGroup = [SELECT Id,Name FROM Group WHERE Type = 'Queue' AND Name =: queueName];

        if(!lstGroup.isEmpty())
        idReturn = lstGroup.get(0).id;

        return idReturn;
    }

    private void updateCaseTicketsOwnersWithQueue(){
        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(Case c : newRecordsList){
            //Adesao
            if(c.Grupo_Tkt__c == 'Adesão' || c.Grupo_Tkt__c == 'Adesao'){
                    if(c.Bandeira_Tkt__c == 'CNP'){
                        c.OwnerId = getQueueIdTickets('Adesão CNP');
                    }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Adesão BB');
                }
            }
            //Alocacoes
            else if(c.Grupo_Tkt__c == 'Alocações' || c.Grupo_Tkt__c == 'Alocacoes')
            {
                if(c.Bandeira_Tkt__c == 'CNP')
                {
                    c.OwnerId = getQueueIdTickets('Alocações CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Alocações BB');
                }else{
                        c.OwnerId = getQueueIdTickets('Adesão CNP');
                }
            }
            //Boletos
            else if(c.Grupo_Tkt__c == 'Boletos ' ){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Boletos  CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                    c.OwnerId = getQueueIdTickets('Boletos  BB');
                }
            }
            //Comissao
            if(c.Grupo_Tkt__c == 'Comissão' || c.Grupo_Tkt__c == 'Comissao'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Comissão CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Comissão BB');
                }else{
                    c.OwnerId = getQueueIdTickets('Comissão CREDITO');
                }
            }
            //Boletos
            else if(c.Grupo_Tkt__c == 'Boletos ' ){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Boletos  CNP');
                }
                else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Boletos  BB');
                }
            }
            //Comissao
            if(c.Grupo_Tkt__c == 'Comissão' || c.Grupo_Tkt__c == 'Comissao'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Comissão CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Comissão BB');
                }else{
                        c.OwnerId = getQueueIdTickets('Comissão CREDITO');
                }
            }
            //Conformidade de adesão
            else if(c.Grupo_Tkt__c == 'Conformidade de adesão' || c.Grupo_Tkt__c == 'Conformidade de adesao'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Conformidade de adesão CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Conformidade de adesão BB');
                }
            }
            //Marketing
            else if(c.Grupo_Tkt__c == 'Marketing'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Marketing CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Marketing BB');
                }else{
                        c.OwnerId = getQueueIdTickets('Marketing CREDITO');
                }
            }
            //Núcleo de Inteligência de Crédito
            else if(c.Grupo_Tkt__c == 'Núcleo de Inteligência de Crédito' || c.Grupo_Tkt__c == 'Nucleo de Inteligencia de Credito'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Núcleo de Inteligência de Crédito CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Núcleo de Inteligência de Crédito BB');
                }
            }
            //Treinamento
            else if(c.Grupo_Tkt__c == 'Treinamento'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Treinamento CNP');
                }
                else if(c.Bandeira_Tkt__c == 'BB')
                {
                        c.OwnerId = getQueueIdTickets('Treinamento BB');
                }else{
                        c.OwnerId = getQueueIdTickets('Treinamento CREDITO');
                }
            }
            //Wizity
            else if(c.Grupo_Tkt__c == 'Wizity'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Wizity CNP');
                }else{
                        c.OwnerId = getQueueIdTickets('Wizity CREDITO');
                }
            }
            //PPW
            else if(c.Grupo_Tkt__c == 'PPW'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('PPW CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('PPW BB');
                }else{
                        c.OwnerId = getQueueIdTickets('PPW CREDITO');
                }
            }
            //Qualidade
            else if(c.Grupo_Tkt__c == 'Qualidade' || c.Grupo_Tkt__c == 'Nucleo de Inteligencia de Credito'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Qualidade CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Qualidade BB');
                }else{
                        c.OwnerId = getQueueIdTickets('Qualidade CREDITO');
                }
            }
            //Pagamentos /Cobranças
            else if(c.Grupo_Tkt__c == 'Pagamentos /Cobranças' || c.Grupo_Tkt__c == 'Pagamentos Cobranças'){
                if(c.Bandeira_Tkt__c == 'CNP'){
                    c.OwnerId = getQueueIdTickets('Pagamentos /Cobranças CNP');
                }else if(c.Bandeira_Tkt__c == 'BB'){
                        c.OwnerId = getQueueIdTickets('Pagamentos /Cobranças BB');
                }
            }
        }
    }

private void routeCaseTicketsOwnersWithQueue(){
AggregateResultWrapper[] lstAggregateResultWrapper = new List<AggregateResultWrapper>();
        Set<Id> caseIdSet = new Set<Id>();
        Set<String> filasName = new Set<String>();
        Set<Id> groupMemberSet = new Set<Id>();
        Set<Id> rtIdSet = new Set<Id>();
        Set<String> rtDevName = new Set<String>();
        Map<Id, String> groupIdMap = new Map<Id, String>();
        Map<Id, String> rtDevNameMap = new Map<Id, String>();
        List<Id> groupMemberLst = new List<Id>();
        List<Case> caseAvailable = new List<Case>();
        List<AggregateResult> lstAggregateResult = new List<AggregateResult>();


        for(Case iCase : newRecordsList){
            caseIdSet.add(iCase.Id);
            rtIdSet.add(iCase.RecordTypeId);
        }

        for(RecordType iRt : [SELECT Id, DeveloperName FROM RecordType WHERE Id IN : rtIdSet]){
            rtDevNameMap.put(iRt.Id, iRt.DeveloperName);
        }

        for(Case iCase : newRecordsList){
            if(rtDevNameMap.get(iCase.RecordTypeId).contains('_Tkt')){
                caseAvailable.add(iCase);
                String rtName = rtDevNameMap.get(iCase.RecordTypeId).substring(0, rtDevNameMap.get(iCase.RecordTypeId).length()-4);
                String bandeiraName;
                //filasName.add(rtDevNameMap.get(iCase.RecordTypeId));
                if(iCase.Bandeira_Tkt__c == 'BANCO DO BRASIL'){
                    bandeiraName = 'BB';
                }else if(iCase.Bandeira_Tkt__c == 'EMBRACON'){
                    bandeiraName = 'Embracon';
                }else if(iCase.Bandeira_Tkt__c == 'ITAÚ'){
                    bandeiraName = 'Itau';
                }else if(iCase.Bandeira_Tkt__c == 'PORTO'){
                    bandeiraName = 'Porto';
                }else if(iCase.Bandeira_Tkt__c == 'Santander'){
                    bandeiraName = 'Santander';
                }else if(iCase.Bandeira_Tkt__c == 'CNP'){
                    bandeiraName = 'CNP';
                }else{
                    bandeiraName = '';
                }
                filasName.add(rtName+bandeiraName+'_Tkt');
                rtDevName.add(rtDevNameMap.get(iCase.RecordTypeId));
            }
        }

        List<Group> searchGroup = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN : filasName];
        if(!searchGroup.isEmpty()){
            for(Group iGroup : [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN : filasName]){
                    groupIdMap.put(iGroup.Id, iGroup.DeveloperName);
            }
        }else{
            for(Group iGroup : [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN : rtDevName]){
                    groupIdMap.put(iGroup.Id, iGroup.DeveloperName);
            }
        }

        Map<String, Integer> userIdMap = new Map<String, Integer>();
        for(GroupMember iGroupMember : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN :groupIdMap.keySet()]){
            groupMemberSet.add(iGroupMember.UserOrGroupId);
            userIdMap.put(iGroupMember.UserOrGroupId, 0);

        }

        for(User iUser : [SELECT Id, IsActive FROM User WHERE Id IN : groupMemberSet]){
            if(iUser.IsActive){
                groupMemberLst.add(iUser.Id);
            }
        }

        if(!groupMemberLst.isEmpty()){
            for(Case iCases : caseAvailable){
                Integer randomNumber = Integer.valueof((Math.random() * groupMemberLst.size()));
                iCases.OwnerId = groupMemberLst[randomNumber];
                iCases.Routed__c = true;
            }
        }
    }

    private void fillBandeiraAndProdutoTicketsFromOldRecord(){
        for(Case c : newRecordsList){
            // System.debug('Caso: '+c);
            // System.debug('Caso origin: '+c.Origin);
            if(c.Origin == 'PPW' || c.Origin == 'Email'){
                // System.debug('Caso Bandeira_Tkt__c: '+c.Bandeira_Tkt__c);
                // System.debug('oldRecordsMap.get(c.Id).Bandeira_Tkt__c: '+oldRecordsMap.get(c.Id).Bandeira_Tkt__c);
                if((c.Bandeira_Tkt__c == '' || c.Bandeira_Tkt__c == null) && (oldRecordsMap.get(c.Id).Bandeira_Tkt__c != '' && oldRecordsMap.get(c.Id).Bandeira_Tkt__c != null)){
                    c.Bandeira_Tkt__c = oldRecordsMap.get(c.Id).Bandeira_Tkt__c;
                }

                // System.debug('Caso Produto_Tkt__c: '+c.Produto_Tkt__c);
                // System.debug('oldRecordsMap.get(c.Id).Produto_Tkt__c: '+oldRecordsMap.get(c.Id).Produto_Tkt__c);
                if((c.Produto_Tkt__c == '' || c.Produto_Tkt__c == null) && (oldRecordsMap.get(c.Id).Produto_Tkt__c != '' && oldRecordsMap.get(c.Id).Produto_Tkt__c != null)){
                    c.Produto_Tkt__c = oldRecordsMap.get(c.Id).Produto_Tkt__c;
                }
            }
        }
    }

    /**
     *@description verifica quais cases são do tipo sinistro e prepara a lista de Ids que devem ser enviados ao MktCloudTriggerHandler
     */
    private void callMarketingCloud(){
        Id returneCase = null;

        for(Case c : newRecordsList){
            if(!Trigger.isInsert){
                oldCase = oldRecordsMap.get(c.Id);
            }
            if(c.RecordTypeId == recordTypeIdComunicado ||
                c.RecordTypeId == recordTypeIdHabitacional ||
                c.RecordTypeId == recordTypeIdPrestamista ||
                c.RecordTypeId == recordTypeIdComunicadoRCPM ||
                c.RecordTypeId == recordTypeIdComunicadoAgro
            ){
                casosMktCloud.add(isBPOComunicadoDeSinistro(c, oldCase));
                casosMktCloudRCPM.add(isCaseRCPM(c, oldCase));
                casosMktCloudAgro.add(isCaseAgro(c));
                casosMktCloudPrestamista.add(isCasePrestamista(c, oldCase));
            }
        }
        if(!casosMktCloud.isEmpty() && casosMktCloud.size() < 50){
            MarketingCloudHandler.callMarketingcloud(casosMktCloud);
        }
        if(!casosMktCloudRCPM.isEmpty()){
            MarketingCloudHandler.callMarketingcloudRCPM(casosMktCloudRCPM);
        }
        if(!casosMktCloudAgro.isEmpty() && !Test.isRunningTest()){
            MarketingCloudHandler.callMarketingcloudAgro(casosMktCloudAgro);
        }
        if(!casosMktCloudPrestamista.isEmpty()){
            MarketingCloudHandler.callMarketingcloudPrestamista(casosMktCloudPrestamista);
        }
    }
    /**
     * @description Verifica se é um sinistro Habtacional ou prestamista para retornar o Id para lista casosMktCloud
     * @param c recebe o objeto case  inserido ou atualizado
     * @param oldCase recebe o objeto case com os dados antes da atualização
     * @return retorn o Id do case no tipo Id para ser adicionado a lista casosMktCloud
     **/
    private Id isBPOComunicadoDeSinistro(Case c, Case oldCase){
        if(c.RecordTypeId == recordTypeIdComunicado){
            if(Trigger.isInsert && (c.Status == 'BPO - Comunicado Aberto' || c.Status == 'Comunicado Aberto')){
                idCase = c.Id;
                return idCase;
            }else{
                idCase = comunicadoDeSinistroWithChangeStatus(c, oldCase);
                return idCase;
            }
        }
        return null;
    }
    /**
     * @description Verifica se é um sinistro atualizado teve alteração no status e retorna o Id para o método isBPOComunicadoDeSinistro
     * @param c recebe o objeto case inserido ou atualizado
     * @param oldCase recebe o objeto case com os dados antes da atualização
     * @return retorn o Id do case no tipo Id para o método isBPOComunicadoDeSinistro
     **/
    private Id comunicadoDeSinistroWithChangeStatus(Case c, Case oldCase){
        if(oldCase.Status != c.Status && (c.Status == 'BPO - Comunicado Aberto' ||
            c.Status == 'BPO - Documentação Básica Pendente' ||
            c.Status == 'BPO - Documentação Beneficiário Pendente' ||
            c.Status == 'BPO - Documentação Complementar Pendente' ||
            c.Status == 'BPO - Finalizado' ||
            c.Status == 'BPO - Pedido Suspenso Por Falta de Documentação' ||
            c.Status == 'BPO - Vistoria' ||
            c.Status == 'BPO - Em Análise' ||
            c.Status == 'BPO - Contato Segurado' ||
            c.Status == 'BPO - Processo reaberto' ||
            c.Status == 'BPO - Tratativas com Mutuario' ||
            c.Status == 'BPO - Reanalise' ||
            c.Status == 'BPO - Agendamento de vistoria' ||
            c.Status == 'Comunicado Aberto' ||
            c.Status == 'Documentação Básica Pendente' ||
            c.Status == 'Documentação Beneficiário Pendente' ||
            c.Status == 'Documentação Complementar Pendente' ||
            c.Status == 'Finalizado' ||
            c.Status == 'Pedido Suspenso Por Falta de Documentação' ||
            c.Status == 'Contato Segurado' ||
            c.Status == 'Processo reaberto' ||
            c.Status == 'Tratativas com Mutuario' ||
            c.Status == 'Agendamento de vistoria' ||
            c.Status == 'Vistoria' ||
            c.Status == 'Reanalise' ||
            c.Status == 'Em Análise' ||
            c.Status == 'BPO - Parecer Conclusivo - CAIXA' ||
            c.Status == 'BPO - Parecer Conclusivo - Beneficiário' ||
            c.Status == 'Parecer Conclusivo - CAIXA' ||
            c.Status == 'Parecer Conclusivo - Beneficiário')
        ){
            idCase = c.Id;
            return idCase;
        }
        return null;
    }
    /**
     * @description Verifica se é um sinistro RCPM para retornar o Id para lista casosMktCloudAgro
     * @param c recebe o objeto case inserido ou atualizado
     * @return retorn o Id do case no tipo Id para ser adicionado a lista casosMktCloudAgro
     **/
    private Id isCaseAgro(Case c){
        if((c.RecordTypeId == recordTypeIdComunicadoAgro) && (Trigger.isInsert || Trigger.isUpdate)){
            idCase = c.Id;
            return idCase;
        }
        return null;
    }
    /**
     * @description Verifica se é um sinistro RCPM para retornar o Id para lista casosMktCloudRCPM
     * @param c recebe o objeto case inserido ou atualizado
     * @param oldCase recebe o objeto case com os dados antes da atualização
     * @return retorn o Id do case no tipo Id para ser adicionado a lista casosMktCloudRCPM
     **/
    private Id isCaseRCPM(Case c, Case oldCase){
        if(c.RecordTypeId == recordTypeIdComunicadoRCPM){
            if(Trigger.isInsert){
                idCase = c.Id;
                return idCase;
            }else{
                if(oldCase.Status != c.Status && (c.Status == 'BPO - Comunicado Aberto' ||
                    c.Status == 'BPO - Vistoria' ||
                    c.Status == 'BPO - Documentação Básica Pendente' ||
                    c.Status == 'BPO - Finalizado' ||
                    c.Status == 'BPO - Tratativas com Mutuario' ||
                    c.Status == 'BPO - Agendamento de vistoria' ||
                    c.Status == 'Comunicado Aberto' ||
                    c.Status == 'Vistoria' ||
                    c.Status == 'Documentação Básica Pendente' ||
                    c.Status == 'Finalizado' ||
                    c.Status == 'Tratativas com Mutuario' ||
                    c.Status == 'Agendamento de vistoria')
                ){
                    idCase = c.Id;
                    return idCase;
                }
            }
        }
        return null;
    }

    /**
     * @description
     * @param c
     * @param oldCase
     * @return
     **/
    private Id isCasePrestamista (Case c, Case oldCase){
        if(c.RecordTypeId == recordTypeIdPrestamista){
            if(Trigger.isInsert){
                idCase = c.Id;
                return idCase;
            }else{
                    idCase = c.Id;
                    return idCase;
            }
        }
        return null;
    }

    /**
     * @description Verifica a situação do status para remover a lista de ativos da central de sinistro BPO
     * @param c recebe o objeto case inserido ou atualizado
     * @return retorn lista de Id com os Ids a serem removidos da lista do CTI.
     **/
    /* private List<Id> caseRemoveAtivo(Case c){
        List <String> statusRemoveAtivo = new list <String> {
        'BPO - Em Análise',
        'BPO - Pedido Suspenso Por Falta de Documentação',
        'BPO - Documentação Complementar Pendente',
        'BPO - Vistoria',
        'BPO - Finalizado',
        'Em Análise',
        'Pedido Suspenso Por Falta de Documentação',
        'Documentação Complementar Pendente',
        'Vistoria',
        'Finalizado'
        };

        List<Case> sinistrosFinalizados = [ SELECT  Id, ParentId, Status, Concierge_IncidentWorkflowStatus__c
        FROM    Case
        WHERE   ParentId IN: newRecordsMap.keySet()
        WITH SECURITY_ENFORCED];

        for(Case c1: sinistrosFinalizados){
            if(mapaComunicados.containsKey(c.ParentId) && c1.Concierge_IncidentWorkflowStatus__c != null){
                List <String> filaWorkflow = mapaComunicados.get(c1.ParentId);

                if(!filaWorkflow.contains(c1.Concierge_IncidentWorkflowStatus__c)){
                    filaWorkflow.add(c1.Concierge_IncidentWorkflowStatus__c);
                }
                    mapaComunicados.put(c1.ParentId, filaWorkflow);
                }else{
                    mapaComunicados.put(c1.ParentId, new List <String> { c1.Concierge_IncidentWorkflowStatus__c });
                }
        }

        filasWorkflow = mapaComunicados.get(c.Id);
        if((filasWorkflow != null && (filasWorkflow.size() == 1 && filasWorkflow.contains(
                'BPO - Não É Cliente da Caixa Seguradora'
        )))){
            return casosRemoveAtivo.add(c.Id);
        }
    }  */
    /**
     * @description
     */
    private void sendComunicadoSinistro(){
        List<Id> casosComunicadoSinistro = new List<Id>();
        List<Id> casosSinistroHabitacional = new List<Id>();
        List<Id> casosSinistroPrestamista = new List<Id>();

        Set<String> contractsIds = new Set<String>();

        for(Case c : newRecordsList){
            contractsIds.add(c.Contract2__c);
        }

        Map<String, Contract2__c> contractsIndexById = getContracts(contractsIds);

        for(Case c : newRecordsList){
            Contract2__c contract = contractsIndexById.get(c.Contract2__c);

            if(contract != null && (c.RecordTypeId == recordTypeIdComunicado || c.RecordTypeId == recordTypeIdPrestamista || c.RecordTypeId == recordTypeIdHabitacional)){
                casosComunicadoSinistro.add(c.Id);

                if(contract.ProductFamily__c == 'Prestamista' && c.ExternalReferenceId__c== null){
                    casosSinistroPrestamista.add(c.Id);
                    // System.debug(casosSinistroPrestamista);
                }else if(contract.ProductFamily__c == 'Habitacional' && c.RecordTypeId == recordTypeIdHabitacional && c.ExternalReferenceId__c== null){
                    casosSinistroHabitacional.add(c.Id);
                    // System.debug(casosSinistroHabitacional);
                }
            }
        }
        // System.debug(casosSinistroHabitacional);
        // System.debug(casosSinistroPrestamista);

        if(!casosSinistroHabitacional.isEmpty()){
            BPO_SendHomeIncidentInvocable.sendToMAC(casosSinistroHabitacional);
        }
        if(!casosSinistroPrestamista.isEmpty()){
            BPO_SendIncidentNoticeInvocable.sendSipre(casosSinistroPrestamista);
        }
    }
    /**
     * @description
     * @param contractIds
     * @return mapContracts
     */
    private static Map<String, Contract2__c> getContracts(Set<String> contractIds){
        List<Contract2__c> contratos = [SELECT Id, ProductFamily__c FROM Contract2__c WHERE Id IN :contractIds];

        Map<String, Contract2__c> mapContracts = new Map<String, Contract2__c>();
        for(Contract2__c contrato : contratos){
            mapContracts.put(contrato.Id, contrato);
        }
        return mapContracts;
    }

    //REGRA COMPARTILHAMENTO DE CASOS COM O GRUPO DE TICKETS LOGO APÓS A ATRIBUIÇÃO DO MESMO
    private void shareCaseWithQueueTickets(){

        List<CaseShare> lstCaseShare;

        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(Case iCase : newRecordsList){

            if(rt_map.get(iCase.RecordTypeId).getDeveloperName().contains('_Tkt') && iCase.OwnerId != oldRecordsMap.get(iCase.Id).OwnerId){
                if(lstCaseShare == null){
                    lstCaseShare = new List<CaseShare>();
                }
                CaseShare objCaseShare  = new CaseShare();
                objCaseShare.CaseId = iCase.Id;
                objCaseShare.UserOrGroupId = oldRecordsMap.get(iCase.Id).OwnerId;
                objCaseShare.CaseAccessLevel = 'Edit';
                objCaseShare.RowCause = Schema.CaseShare.RowCause.Manual;

                lstCaseShare.add(objCaseShare);
            }
        }
        if(lstCaseShare != null){
            List<Database.SaveResult> sr = Database.insert(lstCaseShare,false);
        }
    }

    //REGRA FINALIZAÇÃO DOS MARCOS
    private void completeMilestoneTickets(){

        List<Id> updatePrimeiraResposta = new List<Id>();
        DateTime completionDate = System.now();

        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(Case iCase : newRecordsList){

            if(rt_map.get(iCase.RecordTypeId).getDeveloperName().contains('_Tkt') && iCase.Status != oldRecordsMap.get(iCase.Id).Status && iCase.Status != 'Em atendimento' && iCase.Status != 'Aguardando atendimento' && UserInfo.getUserId() != System.label.IdIntegradorParceiros){
                updatePrimeiraResposta.add(iCase.Id);
            }
        }
        if(updatePrimeiraResposta != null){
            milestoneUtils.completeMilestone(updatePrimeiraResposta, 'Tempo de primeira resposta', completionDate);
        }
    }

    public void changeCaseStatusByOwner(){

        for(Case newCase : newRecordsList)
        {

            System.debug('oldRecordsList: '+oldRecordsList);
            System.debug('newRecordsList: '+newRecordsList);
            if((newCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId()) && newCase.Opportunity__c != null)
            {

                for(Case oldCase : oldRecordsList){
                    String strId = newCase.OwnerId;
                    if((newCase.OwnerId != oldCase.OwnerId)  && strId.startsWith('005') ){
                        newCase.Status = 'Análise de dados da oportunidade';
                        // System.debug('user');
                    }
                    if((newCase.OwnerId != oldCase.OwnerId) && strId.startsWith('00G')){
                        newCase.Status = 'Novo pedido';
                        // System.debug('grupo');
                    }

                }
            }
            System.debug('newCase.RecordTypeId: '+newCase.RecordTypeId);
            System.debug('RECORDTYPE ID CHATBOT: '+Schema.SObjectType.Case.getRecordTypeInfosByName().get('ChatBot').getRecordTypeId());
            if((newCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('ChatBot').getRecordTypeId()))
            {

                System.debug('ENTROU NO IF DE CHATBOT');

                for(Case oldCase : oldRecordsList)
                {
                    String strId = newCase.OwnerId;
                    System.debug('strId: '+strId);
                    System.debug('newCase.OwnerId: '+newCase.OwnerId);
                    System.debug('oldCase.OwnerId: '+oldCase.OwnerId);
                    System.debug('strId.startsWith(005): '+strId.startsWith('005'));
                    System.debug('strId.startsWith(00G): '+strId.startsWith('00G'));
                    System.debug('oldCase.Id: '+oldCase.Id);

                    if((newCase.OwnerId != oldCase.OwnerId) && strId.startsWith('005') && newCase.Id == oldCase.Id){
                        System.debug('ENTROU NO IF DE CASE OWNER DIFERENTE 005');
                        System.debug('STATUS ANTES: '+newCase.Status);
                        newCase.Status = 'Em atendimento';
                        System.debug('STATUS DEPOIS: '+newCase.Status);

                        // System.debug('user');
                        continue;
                    }
                    if((newCase.OwnerId != oldCase.OwnerId) && strId.startsWith('00G') && newCase.Id == oldCase.Id){
                        System.debug('ENTROU NO IF DE CASE OWNER DIFERENTE 006');
                        System.debug('STATUS ANTES: '+newCase.Status);
                        newCase.Status = 'Aguardando atendimento';
                        System.debug('STATUS DEPOIS: '+newCase.Status);


                        // System.debug('grupo');
                        continue;
                    }

                }
            }
        }
    }

    public void changeOpportunityStagePlacement(){
         try{
            String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId();
            Id recordTypeCorporateTaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            List<Opportunity> lOppotunities = new List<Opportunity>();
            List<Opportunity> opporunitiesToUpdate = new List<Opportunity>();
            List<Task> lstTasksToCreate = new List<Task>();
            Map<String,String> caseStatusToOppStage = getCaseStatusToChange();
            Map<Id,String> caseIndexedByStateToUpdate = new Map<Id, String>();
            Map<Id,Task> registerHistory = new Map<Id,Task>();
            Map<Id,CaseMilestone> mapCaseMilestoneByCase = new Map<Id,CaseMilestone>();
            List<CaseMilestone> lstCaseMilestoneToUpdate = new List<CaseMilestone>();

            Entitlement objEntitlementCoporate = EntitlementDAO.getEntitlementByName('CorporatePlacementEntitlement');

            for(Case cs: newRecordsList){
                CaseMilestone caseMilestone = CaseMilestoneDAO.getMilestoneByCaseId(cs.Id);
                if(caseMilestone != null){
                    mapCaseMilestoneByCase.put(cs.Id,caseMilestone);
                }
            }

            for(Case newCase : newRecordsList){
                // System.debug(lOppotunities);
                if(recordTypeId.contains(newCase.RecordTypeId) &&
                caseStatusToOppStage.containsKey(newCase.Status) &&
                (newCase.Opportunity__c != null || newCase.Opportunity__c != '')
                ){
                    lOppotunities = OpportunityDAO.getInstance().getOpportunityByCaseId(newCase.Id);
                    for(Opportunity opp : lOppotunities){

                        if(opp.StageName != caseStatusToOppStage.get(newCase.Status)){
                            // caseStatusToOppStage.get(newCase.Status);
                            System.debug(newCase.Status);
                            opp.StageName = caseStatusToOppStage.get(newCase.Status);
                            // System.debug(opp.StageName);
                            opporunitiesToUpdate.add(opp);

                        }
                        // System.debug('Opp status =>  ' + opp.StageName);
                    }
                    if(newCase.Status == 'Análise de dados da oportunidade'){
                        if(newCase.SlaStartDate == null || String.valueOf(newCase.SlaStartDate) == ''){
                            newCase.SlaStartDate = System.Now();
                            newCase.EntitlementId = objEntitlementCoporate.Id;
                        }else{
                            newCase.isStopped = false;
                        }
                    }else if(newCase.Status == 'Com pendência'){
                        if(newCase.EntitlementId != null || newCase.EntitlementId != ''){
                            newCase.isStopped = true;
                        }
                    }else if(newCase.Status == 'Aguardando aprovação da cotação'){
                        CaseMilestone objCaseMilestone =  new CaseMilestone();
                        objCaseMilestone = mapCaseMilestoneByCase.get(newCase.Id);
                        objCaseMilestone.CompletionDate = System.Now();
                        lstCaseMilestoneToUpdate.add(objCaseMilestone);
                    }else{
                        newCase.isStopped = false;
                    }
                    // System.debug('Lista de opps => '+ opporunitiesToUpdate);
                    // System.debug('Caso => '+ newCase);
                    // System.debug('lstCaseMilestoneToUpdate => '+ lstCaseMilestoneToUpdate);
                }

            }

            if(!opporunitiesToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(opporunitiesToUpdate);
            }

            if(!lstCaseMilestoneToUpdate.isEmpty()){
                CaseMilestoneBO.updateCaseMilestones(lstCaseMilestoneToUpdate);
            }
            if(!lstTasksToCreate.isEmpty()){
                insert lstTasksToCreate;
            }
        } catch (Exception e){
            System.debug(e.getMessage());
        }

	}

    private Map<String,String> getCaseStatusToChange(){
        Map<String,String> caseStatusToOppStage = new Map<String,String>();

        caseStatusToOppStage.put('Novo pedido','Cotação enviada');
        caseStatusToOppStage.put('Análise de dados da oportunidade','Em Cotação');
        caseStatusToOppStage.put('Com pendência','Cotação com pendência');
        caseStatusToOppStage.put('Aguardando cotação','Construção da proposta');
        caseStatusToOppStage.put('Aguardando aprovação da cotação','Em negociação');
        caseStatusToOppStage.put('Repique','Repique');
        caseStatusToOppStage.put('Aguardando emissão da apólice','Em Emissão');
        caseStatusToOppStage.put('Processo anulado','Fechado e perdido');
        caseStatusToOppStage.put('Apólice registrada','Fechado e ganho');

        return caseStatusToOppStage;
    }

    public void createTaskNotification(){
         try{
            String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId();
            Id recordTypeCorporateTaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            List<Task> lstTasksToCreate = new List<Task>();
            List<Task> lstTasksToDelete = new List<Task>();
            Set<Id> setId = new Set<Id>();
            Set<Id> setIdOpps = new Set<Id>();
            for(Case newCase : newRecordsList){
                setId.add(newCase.Id);
            }
            List<Case> lstCasesWithOwnerType = [SELECT Id,Owner.Type,Opportunity__c,RecordTypeId,Status FROM Case WHERE Id IN: setId];
            for(Case caseWithOpp : lstCasesWithOwnerType){
                setIdOpps.add(caseWithOpp.Opportunity__c);
            }
            System.debug('setIdOpps' + setIdOpps);
            List<Task> lstCreatedTasks = [SELECT Id,WhatId FROM Task where WhatId IN: setIdOpps AND Subject = 'Atribuído para técnico'];
            System.debug('lstCreatedTasks' + lstCreatedTasks);
            Map<Id,Task> mapTasksByOpportunity = new Map<Id,Task>();
            for(Task objTaskAssigned : lstCreatedTasks){
                mapTasksByOpportunity.put(objTaskAssigned.WhatId,objTaskAssigned);
            }
            System.debug('mapTasksByOpportunity' + JSON.serializePretty(mapTasksByOpportunity));
            System.debug('lstCasesWithOwnerType' + JSON.serializePretty(lstCasesWithOwnerType));

            for(Case newCase : lstCasesWithOwnerType){
                if(recordTypeId.contains(newCase.RecordTypeId)){
                    if(newCase.Status == 'Novo pedido' && newCase.Owner.Type == 'Queue'){
                        Task newTask = new Task();
                        if(mapTasksByOpportunity.containsKey(newCase.Opportunity__c)){
                            lstTasksToDelete.add(mapTasksByOpportunity.get(newCase.Opportunity__c));
                        }
                        newTask.Subject = 'Nova oportunidade disponível';
                        newTask.RecordTypeId = recordTypeCorporateTaskId;
                        newTask.Status = 'Open';
                        newTask.WhatId = newCase.Opportunity__c;
                        newTask.OwnerId = UserInfo.getUserId();
                        lstTasksToCreate.add(newTask);
                    }else if(newCase.Status == 'Novo pedido' && newCase.Owner.Type == 'User'){
                        Task newTask = new Task();
                        newTask.Subject = 'Atribuído para técnico';
                        newTask.RecordTypeId = recordTypeCorporateTaskId;
                        newTask.Status = 'Open';
                        newTask.WhatId = newCase.Opportunity__c;
                        newTask.OwnerId = UserInfo.getUserId();
                        lstTasksToCreate.add(newTask);
                    }
                }
            }

            System.debug('lstTasksToCreate => '+ lstTasksToCreate);
            System.debug('lstTasksToDelete => '+ lstTasksToDelete);
            if(!lstTasksToCreate.isEmpty()){
                insert lstTasksToCreate;
            }
            if(!lstTasksToDelete.isEmpty()){
                delete lstTasksToDelete;
            }
        }catch (Exception e){
            System.debug(e.getMessage());
        }
    }

    public void updateMilestoneChatBot(){
        Id recordTypeChatBotCaseId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ChatBot').getRecordTypeId();
        DateTime completionDate = System.now();
        List<Id> lstCaseToCompleteMilestoneTimeOnQueue = new List<Id>();
        List<Id> lstCaseToCompleteMilestoneInAttendance = new List<Id>();


        for(Case objCase : newRecordsList){
            if(objCase.RecordTypeId == recordTypeChatBotCaseId){
                if(oldRecordsMap.get(objCase.Id).Status == 'Aguardando atendimento' && objCase.Status == 'Em atendimento'){
                    lstCaseToCompleteMilestoneTimeOnQueue.add(objCase.Id);
                }else if(oldRecordsMap.get(objCase.Id).Status == null && objCase.Status == 'Em atendimento'){
                    lstCaseToCompleteMilestoneTimeOnQueue.add(objCase.Id);
                }
                if(oldRecordsMap.get(objCase.Id).Status == 'Em atendimento' && objCase.Status == 'Closed'){
                    lstCaseToCompleteMilestoneInAttendance.add(objCase.Id);
                }
            }
        }
        if(lstCaseToCompleteMilestoneTimeOnQueue != null){
            milestoneUtils.completeMilestone(lstCaseToCompleteMilestoneTimeOnQueue, 'Tempo de fila', completionDate);
        }
        if(lstCaseToCompleteMilestoneInAttendance != null){
            milestoneUtils.completeMilestone(lstCaseToCompleteMilestoneInAttendance, 'Em atendimento', completionDate);
        }
    }


    public void updateContactSync(){
        Id caseRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();
        Id accountBRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> accToUpdateLst = new List<Account>();
        List<Contact> contactToUpdateLst = new List<Contact>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>(); 

        for(Case newRecord : newRecordsList){
            if(newRecord.RecordTypeId == caseRTId){
                accountIdSet.add(newRecord.AccountId);
                contactIdSet.add(newRecord.AccountId);
            }
        }

        if(!Test.isRunningTest()){
            for(Account iAcc : [SELECT Id, SyncMarketingCloud__pc, RecordTypeId FROM Account WHERE Id IN : accountIdSet]){
                if(iAcc.RecordTypeId == accountBRTId){
                    iAcc.SyncMarketingCloud__pc = true;
                    accToUpdateLst.add(iAcc);
                }
            }
        
        
            for(Contact iContact : [SELECT Id, SyncMarketingCloud__c FROM Contact WHERE AccountId IN : contactIdSet]){
                iContact.SyncMarketingCloud__c = true;
                contactToUpdateLst.add(iContact);
            }

            update accToUpdateLst;
            update contactToUpdateLst;
        }
    }
}