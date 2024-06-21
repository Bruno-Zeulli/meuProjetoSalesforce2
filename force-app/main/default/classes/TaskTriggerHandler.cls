/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class TaskTriggerHandler {
    /** @description Construtor que recebe os parametros da Trigger*/
    private boolean isExecuting = false;
    /** @description Construtor que recebe os parametros da Trigger*/
    public List<Task> oldRecordsList = null;
    /** @description Construtor que recebe os parametros da Trigger*/
    public List<Task> newRecordsList = null;
    /** @description Construtor que recebe os parametros da Trigger*/
    public Map<Id, Task> oldRecordsMap = null;
    /** @description Construtor que recebe os parametros da Trigger*/
    public Map<Id, Task> newRecordsMap = null;

    static final Id RECORDTYPE_TELEFONEMA = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Telefonema').getRecordTypeId();

    /**
     *@description Construtor que recebe os parametros da Trigger
     *@param isExecuting boolean true para execução
     */
    public TaskTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    /**
     *@description trigger antes de inserir
     */
    public void onBeforeInsert(){
        if(!Test.isRunningTest()){
                fillOutWhoId();
            }
        fillOutDisposition();
        changeVisibilityTaskToCommunity(this.newRecordsList);

    }

    /**
     *@description trigger depois de inserir
     */
    public void onAfterInsert(){
        publishIncorrectDispositionEvent();
        sendTaskToMac();
        sendTaskToMktCloud();
        sendTaskToMktCloudVip();
        //changeOpportunityStage(this.newRecordsMap);
        sendTaskToPtnRemoveCM();
        if(!Test.isRunningTest())
        {
            sendEmailNotificationByTask();
        }

    }

    /**
     *@description trigger antes de atualizar
     */
    public void onBeforeUpdate(){
        fillOutDisposition();
            if(!Test.isRunningTest()){
                fillOutWhoId();
            }
        changeVisibilityTaskToCommunity(this.newRecordsList);

    }
    /**
     *@description trigger depois de atualizar
     */
    public void onAfterUpdate(){
        //changeOpportunityStage(this.newRecordsMap);
    }

    /**
     *@description preenche a conta
     */
    private void fillOutWhoId(){
        Set<Id> setWhatIds = new Set<Id>();
        for(Task t : newRecordsList){
            setWhatIds.add(t.WhatId);
        }
        Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, PersonContactId FROM Account WHERE Id IN :setWhatIds AND IsPersonAccount = TRUE]);
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([SELECT Id, Account.PersonContactId FROM Opportunity WHERE Id IN :setWhatIds AND Account.IsPersonAccount = TRUE]);
        if(!mapAccounts.isEmpty() || !mapOpps.isEmpty()){
            fillOutWhoIdLoop(mapAccounts, mapOpps, RECORDTYPE_TELEFONEMA);
        }
    }

    /**
     *@description loop preencher a conta e oportunidade
     *@param mapAccounts
     *@param mapOpps
     *@param recordTypeTelefonema
     */
    private void fillOutWhoIdLoop(Map<Id, Account> mapAccounts, Map<Id, Opportunity> mapOpps, Id recordTypeTelefonema){
        for(Task t : newRecordsList){
            if(t.RecordTypeId == recordTypeTelefonema){
                Id key = t.WhatId;
                if(mapAccounts.containsKey(key)){
                    t.WhoId = mapAccounts.get(key).PersonContactId;
                    t.WhatId = null;
                }else if(mapOpps.containsKey(key)){
                    t.WhoId = mapOpps.get(key).Account.PersonContactId;
                }
            }
        }
    }

    /**
     *@description envia a tesk para market cloud
     */
    private void sendTaskToMac(){
        List<Task> taskList;
        if(Schema.sObjectType.Task.isAccessible() && !Test.isRunningTest()){
            taskList = [
                SELECT
                    Id,
                    TYPEOF What
                        WHEN Case THEN Id
                    END
                FROM Task
                WHERE What.Type = 'Case' AND Id IN :newRecordsMap.keySet()
            ];
            for(Task t : taskList){
                BPO_SendTaskToMacQueueable.callMacforTask(t.Id, 0);
            }
        }
    }

    /**
     *@description envia tarefas para o market cloud
     */
    private void sendTaskToMktCloud(){

        for(Task t : newRecordsList){
            if(t.RecordTypeId == RECORDTYPE_TELEFONEMA && t.CallDisposition == '5.5 Transferência de atendimento para o whatsapp'){
                MarketingCloudHandler.callMarketingCloudWhatsApp(t.Id);
            }
        }
    }

    /**
     *@description envia tarefas para o market cloud VIP
    */

    private void sendTaskToMktCloudVip(){
        Profile prof;

            if(Schema.sObjectType.Profile.isAccessible() && !Test.isRunningTest()){
                prof = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
            }

            String vipOppDispositionsStr = System.Label.VIPOpportunityDispositions;
            List<String> vipOppDispositions = vipOppDispositionsStr.split(',');
            for(String item : vipOppDispositions){
                system.debug('disposition: ' + item);
            }

            //String tabulacao = '1.3.1 Insatisfeito com o preço,1.3.2 Insatisfeito com o seguro,1.3.14 Não tem interesse no produto,1.6 Venda';
            //String tabulacao = '1.11 Emissão de documentos - 2ª via apólice,1.41 Cancelamento,1.41.4 Endosso';

            String vipAccDispositionsStr = System.Label.VIPAccountDispositions;
            List<String> vipAccDispositions = vipAccDispositionsStr.split(',');
            if(prof != null){
                if(!Test.isRunningTest() && prof.Name.contains('VIP')){
                    for(Task t : newRecordsList){
                        if(vipOppDispositions.contains(t.CallDisposition)){
                            MarketingCloudVIPHandler.callMarketingCloudVIPOpportunity(t.Id);
                        }else if(vipAccDispositions.contains(t.CallDisposition)){
                            MarketingCloudVIPHandler.callMarketingCloudVIPAccount(t.Id);
                        }
                    }
                }
            }
    }

    /**
     *@description inicio do método de tabulação
     */
    private void fillOutDisposition(){
        Map<String, DispositionPath__c> mDispositions = getDisposition();
        // System.debug(mDispositions);
        Set<String> setDispositions = new Set<String>();
        for(Task tarefa : newRecordsList){
            String key = tarefa.CallDisposition;
            if(String.isNotBlank(key)){
                setDispositions.add(key);
            }
        }
        if(!setDispositions.isEmpty()){
            System.debug('DISPOSITION SET =>' + setDispositions);
            DispositionPath__c lDispositions;
            for(String disposition: mDispositions.keySet()){
                // System.debug(disposition);
                for(String item : setDispositions){
                    if(disposition.contains(item)){
                        lDispositions = mDispositions.get(disposition);
                        System.debug(disposition);
                    }
                //    System.debug(item);
                }
            }

            System.debug('lDispositions =>' + lDispositions);
            fillOutDispositionLoop(lDispositions);
        }
    }

    /**
     *@description loop continuação do preenchimento de tabulação
     *@param dispositions
     */
    private void fillOutDispositionLoop(DispositionPath__c disposition){

        for(Task tarefa : newRecordsList){
            System.debug(Trigger.isInsert || Trigger.isUpdate);
            if(Trigger.isInsert || (Trigger.isUpdate && newRecordsMap.get(tarefa.Id).CallDisposition != oldRecordsMap.get(tarefa.Id).CallDisposition)){
                String key = tarefa.CallDisposition;
                if(disposition != null){

                    tarefa.Disposition__c = disposition.Id;
                }else{

                    tarefa.Disposition__c = null;
                }
            }
        }
    }

    /**
     * @description faz o envio das tasks para remover integration status PTN
     */
    private void sendTaskToPtnRemoveCM(){
        Id recordTypeTelefonema = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Telefonema').getRecordTypeId();

        for(Task t : newRecordsList){
            if(
                t.RecordTypeId == RECORDTYPE_TELEFONEMA &&
                (t.Subcategory__c != '1.45 Agendamento' ||
                t.Subcategory__c != '4.1 Caiu a ligação durante o atendimento' ||
                t.Subcategory__c != '4.2 Mensagem operadora fora de serviço caixa postal' ||
                t.Subcategory__c != '4.4 Não atende' ||
                t.Subcategory__c != '4.5 Ocupado' ||
                t.Subcategory__c != '4.8 Caiu ligação no início do contato' ||
                t.Subcategory__c != '4.9 Inalcançável')
            ){
                if(!Test.isRunningTest()){
                    ManipulateTaskBasedCampaignMember.removeCampaignMemberIntagrationStatus(t);
                }
            }
        }
    }

    /**
     *@description envia as tabulações incorretas para B2U_SupervisorController
     */
    private void publishIncorrectDispositionEvent(){
        List<IncorrectDisposition__e> lIncorrectDisposition = new List<IncorrectDisposition__e>();
        Set<Id> setOwners = new Set<Id>();
        for(Task t : newRecordsList){
            setOwners.add(t.CreatedById);
        }
        if(!Test.isRunningTest()){
            Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, UserRole.Name FROM User WHERE UserRole.Name LIKE 'B2U - %' AND IsActive = TRUE]);
            publishIncorrectDispositionEventLoop(lIncorrectDisposition, mapUsers);
        }
    }

    /**
     *@description Habilita visualização de Tasks para community user
     */
    private static List<Task> changeVisibilityTaskToCommunity(List<Task> lstNewTask){

        List<Task> lstTask = new List<Task>();

        for(Task newRecord : lstNewTask){
            if(newRecord.IsVisibleInSelfService == false ){
                newRecord.IsVisibleInSelfService = true;

            }
            lstTask.add(newRecord);
        }
        return lstTask;
    }
    /**
     *@description envia as tabulações incorretas para B2U_SupervisorController
     *@param lIncorrectDisposition
     *@param mapUsers
     */
    private void publishIncorrectDispositionEventLoop(List<IncorrectDisposition__e> lIncorrectDisposition, Map<Id, User> mapUsers){
        for(Task t : newRecordsList){
            if(mapUsers.containsKey(t.CreatedById)){
                if(
                    t.Category__c == null ||
                    (t.WhoId == null &&
                    t.Category__c != '5. Transferência') ||
                    ((t.Subcategory__c == '1.6 Venda' || t.Subcategory__c == '1.38 Visita agendada') && t.WhatId == null) ||
                    (t.CallType == 'Outbound' &&
                    t.WhatId == null)
                ){
                    IncorrectDisposition__e incDis = new IncorrectDisposition__e(Task__c = t.Id, Reason__c = B2U_SupervisorController.generateIncorrectDispositionReason(t));
                    System.debug('incDis: ' + incDis);
                    lIncorrectDisposition.add(incDis);
                }
            }
        }
        if(!lIncorrectDisposition.isEmpty()){
            EventBus.publish(lIncorrectDisposition);
        }
    }

    /**
     *@description metodopara recuperar as informações de tabulações existentes
     *@return mDispositions
     */
    private static Map<String,DispositionPath__c> getDisposition(){
        Map<String, DispositionPath__c> mDispositions = new Map<String, DispositionPath__c>();
        if(!Test.isRunningTest()){
            if(!Schema.sObjectType.DispositionPath__c.isAccessible()){
                System.debug('sObject not acessible!');
            }
            List<DispositionPath__c> dispositions = [
                SELECT Id,Name,Category__c,Disposition__c,
                    Reason__c,SpecificReason__c,Subcategory__c

                FROM DispositionPath__c
            ];

            for(DispositionPath__c dsp : dispositions){
                mDispositions.put(dsp.Name, dsp);
            }
            return mDispositions;
        }else{
            DispositionPath__c disposition = DispositionPathDataFactory.insertDispositionPath4LevelsDeep();
            mDispositions.put(disposition.Name, disposition);
            return mDispositions;
        }
    }

    /**
     *@description autera o stage da oportinidade a partir da tabulação
     */
	public static void changeOpportunityStage(Map<Id,Task> nMap){
        Map<Id, String> mapStageNameByOppId = new Map<Id, String>();
        Map<String, Set<Id>> mapSetIdBySObjectName = setMapListIdBySObjectNameWithNull();
        Map<Id, Task> mapTaskBySObjectId = new Map<Id, Task>();
        List<Opportunity> lstOppotunities = new List<Opportunity>();
        List<Opportunity> lstUpdateOpps = new List<Opportunity>();
        Set<Id> lstObjectIds = new Set<Id>();
        Set<Id> lstDispositionPathId = new Set<Id>();
        Set<String> lstCTINameSource = new Set<String>();
        Set<String> lstObjectType = new Set<String>();
        Set<String> lstLeadSource = new Set<String>();
        Set<String> lstObjectTypeRecordTypeName = new Set<String>();

        for(Task tsk : nMap.values()){
            if(tsk.CallDisposition != null &&
                tsk.Disposition__c != null &&
                tsk.WhatId != null &&
                tsk.RecordTypeId == RECORDTYPE_TELEFONEMA
            ){
                Id key = tsk.WhatId;
                String objectTypeName = String.valueOf(Id.valueOf(key).getsobjecttype());
                lstObjectType.add(objectTypeName);
                lstDispositionPathId.add(tsk.Disposition__c);
                lstCTINameSource.add(tsk.CTIName__c);
                mapSetIdBySObjectName = setMapListIdBySObjectName(key, objectTypeName, mapSetIdBySObjectName);
                mapTaskBySObjectId.put(key, tsk);
            }
        }

        lstOppotunities = getListOpportunities(mapSetIdBySObjectName);

        for(Opportunity objOpportunity : lstOppotunities){
            lstLeadSource.add(objOpportunity.LeadSource);
            lstObjectTypeRecordTypeName.add(objOpportunity.RecordType.DeveloperName);
        }

        /* List<DispositionSetting__c> lstDispSetts = [
                                                                    SELECT  ActionType__c,
                                                                            BusinessUnit__c,
                                                                            CampaignId__c,
                                                                            CTINameSource__c,
                                                                            DispositionPathId__c,
                                                                            DispositionPathName__c,
                                                                            LeadSource__c,
                                                                            NextStageName__c,
                                                                            ObjectType__c,
                                                                            ObjectTypeRecordTypeName__c
                                                                    FROM    DispositionSetting__c
                                                                    WHERE   IsActive__c = true
                                                                    AND     DispositionPathId__c IN: lstDispositionPathId
                                                                    AND     ObjectType__c IN: lstObjectType
                                                                    AND     CTINameSource__c IN: lstCTINameSource
                                                                    AND     ObjectTypeRecordTypeName__c IN: lstObjectTypeRecordTypeName
                                                                    AND     LeadSource__c IN: lstLeadSource
                                                                ];

        if(!lstDispSetts.isEmpty()){
            for(Opportunity objOpportunity : lstOppotunities){
                for(DispositionSetting__c objDispSetts : lstDispSetts){

                    Task objTask = mapTaskBySObjectId.get(objOpportunity.Id);
                    String objectTypeName = String.valueOf(Id.valueOf(objOpportunity.Id).getsobjecttype());

                    if( objTask.Disposition__C == objDispSetts.DispositionPathId__c &&
                        objTask.CTIName__c == objDispSetts.CTINameSource__c &&
                        objTask.CampaignId__c == objDispSetts.CampaignId__c &&
                        objOpportunity.RecordType.DeveloperName == objDispSetts.ObjectTypeRecordTypeName__c &&
                        objOpportunity.LeadSource == objDispSetts.LeadSource__c &&
                        objOpportunity.StageName != objDispSetts.NextStageName__c &&
                        objectTypeName == objDispSetts.ObjectType__c
                    ){
                        objOpportunity.StageName = objDispSetts.NextStageName__c;
                        lstUpdateOpps.add(objOpportunity);
                    }
                }
            }
        } */

        if(!lstUpdateOpps.isEmpty()){
            OpportunityBO.getInstance().lstUpdOpportunities(lstUpdateOpps);
        }
    }

	private static List<Opportunity> getListOpportunities(Map<String, Set<Id>> mapSetIdBySObjectName){
        Set<Id> lstOppIds = mapSetIdBySObjectName.get('Opportunity');
        List<Opportunity> lstOppotunities = new List<Opportunity>();

        if(!lstOppIds.isEmpty()){
            if(!Schema.sObjectType.Opportunity.isAccessible()){
                System.debug('SObject not accessible!');
            }
            lstOppotunities = [SELECT Id, Name, StageName, LeadSource, RecordType.DeveloperName FROM Opportunity WHERE Id IN:lstOppIds];
        }

        return lstOppotunities;
	}

    private static Map<String, Set<Id>> setMapListIdBySObjectName(Id key, String objectTypeName, Map<String, Set<Id>> mapSetIdBySObjectName){

        Set<Id> lstObjectType = new Set<Id>();

        lstObjectType = mapSetIdBySObjectName.get(objectTypeName);

        switch on objectTypeName {
            when 'Opportunity' {
                lstObjectType.add(key);
                mapSetIdBySObjectName.put('Opportunity', lstObjectType);
            }
            when 'Account' {
                lstObjectType.add(key);
                mapSetIdBySObjectName.put('Account', lstObjectType);
            }
            when 'Case' {
                lstObjectType.add(key);
                mapSetIdBySObjectName.put('Case', lstObjectType);
            }
            when 'Lead' {
                lstObjectType.add(key);
                mapSetIdBySObjectName.put('Lead', lstObjectType);
            }
        }
        return mapSetIdBySObjectName;
    }

    private static Map<String, Set<Id>> setMapListIdBySObjectNameWithNull(){

        Map<String, Set<Id>> mapSetIdBySObjectName = new Map<String, Set<Id>>();
        Set<Id> lstObjectType = new Set<Id>();

        mapSetIdBySObjectName.put('Opportunity', lstObjectType);
        mapSetIdBySObjectName.put('Account', lstObjectType);
        mapSetIdBySObjectName.put('Case', lstObjectType);
        mapSetIdBySObjectName.put('Lead', lstObjectType);

        return mapSetIdBySObjectName;
    }

    private void sendEmailNotificationByTask(){

        ConnectWizCMPTO.EmailNotification objEmailNotification = new ConnectWizCMPTO.EmailNotification();
        Set<Id> setTasksIds = new Set<Id>();
        set<Id> setWhatIds = new Set<Id>();
        Map<Opportunity, Case> mapOpportunityWithCase = new Map<Opportunity, Case>();
        for(Task objTask : this.newRecordsList){
            setTasksIds.add(objTask.Id);
            setWhatIds.add(objTask.WhatId);

        }
        // System.debug('setTasksIds' + JSON.serializePretty(setTasksIds));
        List<Task> lstTask = [SELECT Id,CreatedBy.name,CreatedById,WhatId,subject,description from Task WHERE Id IN:setTasksIds];

        List<Opportunity> lstOpportunity = [SELECT
                                                    Id,Name,recordType.developerName,OpportunityNumber__c,OwnerId,
                                                    (SELECT Id,Owner.Type,CaseNumber,OwnerId FROM Casos__r)
                                                FROM
                                                    Opportunity
                                                WHERE
                                                    Id IN: setWhatIds
                                            ];

        System.debug('lstOpportunity' + JSON.serializePretty(lstOpportunity));
        if(!lstOpportunity.isEmpty()){

            for(Task objTaskNotification : lstTask){
                for(Opportunity objOpp :lstOpportunity){
                    if(!objTaskNotification.Subject.startsWith('Email: ') && objOpp != null  && (objOpp.recordType.developerName == 'CorporateBeneficios' ||
                        objOpp.recordType.developerName == 'CorporateMCMV' ||
                        objOpp.recordType.developerName == 'CorporateComercial'))
                    {
                        objEmailNotification.subject = objTaskNotification.subject != null ? objTaskNotification.subject : 'Sem Assunto!';
                        objEmailNotification.description = objTaskNotification.description != null ? objTaskNotification.description : 'Sem Descrição.';
                        objEmailNotification.opportunityNumber = objOpp.OpportunityNumber__c != null ? objOpp.OpportunityNumber__c : 'OPP - S/N';
                        objEmailNotification.opportunityName = objOpp.name != null ? objOpp.name : 'OPP - Sem Nome';
                        objEmailNotification.taskOwner = objTaskNotification.CreatedBy.name;
                        objEmailNotification.taskOwnerId = objTaskNotification.CreatedById;
                        objEmailNotification.opportunityOwner = objOpp.OwnerId;
                        objEmailNotification.opportunityId = objOpp.Id;

                        if(!objOpp.Casos__r.isEmpty()){

                            objEmailNotification.caseNumber = objOpp.Casos__r[0].CaseNumber != null ? objOpp.Casos__r[0].CaseNumber : 'Case - S/N';
                            objEmailNotification.caseOwner = objOpp.Casos__r[0].Owner.Type == 'Queue' ? '' : objOpp.Casos__r[0].OwnerId;
                            objEmailNotification.caseId = objOpp.Casos__r[0].Id != null ? objOpp.Casos__r[0].Id : 'Case - S/N';
                        }
                        System.debug('objEmailNotification' + JSON.serializePretty(objEmailNotification));
                        ConnectWizSendEmailNotificationByTask.sendEmailNotification(objEmailNotification);
                    }

                }
            }
        }
    }
}