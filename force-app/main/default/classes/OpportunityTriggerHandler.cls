/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 09-25-2023
* @last modified by  : samuelsirkis@wiz.co
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class OpportunityTriggerHandler {
    private boolean isExecuting = false;
    public List<Opportunity> oldRecordsList = null;
    public List<Opportunity> newRecordsList = null;
    public Map<Id, Opportunity> oldRecordsMap = null;
    public Map<Id, Opportunity> newRecordsMap = null;
    public static final String ERROR_MSG_DELETE_OPPORTUNITY_WITH_ORDERS_CORPORATE = 'Esta oportunidade não pode ser excluída, pois, possui apólice(s) e/ou endosso(s) vinculado(s).';
    public static final String ERROR_MSG_DELETE_OPPORTUNITY_CLOSED_CORPORATE = 'Esta oportunidade não pode ser excluída, pois, já foi fechada.';
    public static final Integer LIMIT_FOR_FUTURE_METHOD_REQUEST = 49;

    public OpportunityTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){
        changeOwnerOppIfApoio();
        // checkOppIsCorporate();

    }

    public void onBeforeUpdate(){
        checkHasQuote();
        // checkOppIsCorporate();
        // changeCaseStatusPlacement();
        updateStatusCorporateOnBeforeUpdate();
    }

    public void onAfterInsert(){
        updateContactSync();
        updateOpportunityTeamMemberCorporate();
        distributionOpportunityConsegRemote();
        createRelatedAssetByOpportunityDescription();
        updateParentOpportunityOnAfterInsert();
    }

    public void onAfterUpdate(){
        //checkOppIsCorporate();
        changeCaseStatusPlacement();
        changeStatusPlacement();
        insertLatestDocument();
        updateParentAccountAndOppOnAfterUpdate();
    }

    public void onBeforeDelete(){
        checkOrderCorporate();
    }

    public void onAfterDelete(){
        updateParentOppOnDelete();
    }
    public void checkOppIsCorporate(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');

        for(Opportunity newRecord : newRecordsList){
            if(lstRecordTypeId.contains(newRecord.RecordTypeId)){
                sendUpdateOpportunityToWFlow();
            }
        }
    }

    public void changeOwnerOppIfApoio(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> IdsAccount = new List<Id>();
        List<Account> contasComProprietario = new List<Account>();
        List<OpportunityTeamMember> oppTeamMemberToAdd = new List<OpportunityTeamMember>();
        List<AccountTeamMember> accountTeamMember = new List<AccountTeamMember>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<Id,Account> mapContas = new Map<Id,Account>();

        for(Opportunity newRecord : newRecordsList){
            if(lstRecordTypeId.contains(newRecord.RecordTypeId)){
                IdsAccount.add(newRecord.AccountId);
            }
        }

        if(!IdsAccount.isEmpty()){
            accountTeamMember = [SELECT Id, AccountId, UserId, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :IdsAccount];
        }

        if(!IdsAccount.isEmpty()){
            contasComProprietario = [SELECT Id, OwnerId FROM Account WHERE Id IN :IdsAccount];
            for(Account acc : contasComProprietario){
                mapContas.put(acc.Id, acc);
            }
        }

        if(!accountTeamMember.isEmpty()){
            for(Opportunity newRecord : newRecordsList){
                for(AccountTeamMember atm : accountTeamMember){
                    if(atm.AccountId == newRecord.AccountId){
                        if(newRecord.CreatedById == atm.UserId){
                            newRecord.OwnerId = mapContas.get(atm.AccountId).OwnerId;
                            oppToUpdate.add(newRecord);
                        }
                    }
                }
            }
        }
    }

    public void updateOpportunityTeamMemberCorporate(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> IdsAccount = new List<Id>();
        Map<Id,Opportunity> oppAndAccount = new Map<Id,Opportunity>();
        Map<Id,Account> mapContas = new Map<Id,Account>();
        List<AccountTeamMember> accountTeamMember = new List<AccountTeamMember>();
        List<Account> contasComProprietario = new List<Account>();
        List<OpportunityTeamMember> oppTeamMemberToAdd = new List<OpportunityTeamMember>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        for(Opportunity newRecord : newRecordsList){
            if(lstRecordTypeId.contains(newRecord.RecordTypeId)){
                IdsAccount.add(newRecord.AccountId);
                oppAndAccount.put(newRecord.AccountId, newRecord);
            }
        }

        if(!IdsAccount.isEmpty()){
            accountTeamMember = [SELECT Id, AccountId, UserId, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :IdsAccount];
        }

        if(!accountTeamMember.isEmpty()){
            for(Opportunity newRecord : newRecordsList){

                for(AccountTeamMember atm : accountTeamMember){
                    if(atm.AccountId == newRecord.AccountId){
                        OpportunityTeamMember otm = new OpportunityTeamMember();
                        otm.OpportunityId = newRecord.Id;
                        otm.UserId = atm.UserId;
                        otm.OpportunityAccessLevel = 'Edit';
                        otm.TeamMemberRole = atm.TeamMemberRole;
                        oppTeamMemberToAdd.add(otm);
                    }
                }
            }
        }

        if(!oppTeamMemberToAdd.isEmpty()){
            insert oppTeamMemberToAdd;
        }
    }

    // Impede a exclusão das Oportunidades dos tipos Corporate - Comercial, Corporate - CBIC, Corporate - MCMV ou Corporate - Licitação que:
    // 1 - possuam Apólices ou Endossos emitidos;
    // 2 - estejam fechadas.
    public void checkOrderCorporate(){

        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');

        // Recupera o perfil do usuário logado.
        Profile prof = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];

        // Para cada Oportunidade do bulk...
        for(Opportunity record : oldRecordsList){
            // Verifica se o usuário possui permissão para excluir Oportunidade da Wiz Corporate.
            // Não havendo, impede a exclusão do registro.
            if(prof.Name != 'Corporate - Marketing' && !prof.Name.contains('Administrador') &&
                prof.Name != 'Integrador - Corporate' &&
                (lstRecordTypeId.contains(record.RecordTypeId)) &&
                record.IsClosed
            ){
                record.addError(ERROR_MSG_DELETE_OPPORTUNITY_CLOSED_CORPORATE);
            }
        }

        // Recupera as Apólices e Endossos vinculados às Oportunidades do bulk.
        Set<Id> oppWithOrderIds = new Map<Id, AggregateResult>([SELECT OpportunityId Id
                                                                FROM Order
                                                                WHERE
                                                                    OpportunityId = :oldRecordsMap.keySet()
                                                                    AND (Opportunity.RecordTypeId = :lstRecordTypeId)
                                                                GROUP BY OpportunityId
                                                                ]).keySet();
        // Para cada Oportunidade do bulk...
        for(Opportunity record : oldRecordsList){
            // Se houver Apólice ou Endosso da Wiz Corporate vinculado, impede a exclusão do registro.
            if(oppWithOrderIds.contains(record.Id)){
                record.addError(ERROR_MSG_DELETE_OPPORTUNITY_WITH_ORDERS_CORPORATE);
            }
        }
    }

    public void sendUpdateOpportunityToWFlow(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Opportunity> lstOpportunityToWflow = new List<Opportunity>();
        if(!Test.isRunningTest()){
            // Recupera o perfil do usuário logado.
            Profile prof = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];

            // Para cada Oportunidade do bulk...
            for(Opportunity record : oldRecordsList){
                Opportunity newRecord = newRecordsMap.get(record.Id);
                // Verifica se as opps são corporate e se a alteração foi realizada pelo usuário de interface.
                // Não havendo, impede a exclusão do registro.
                if((prof.Name != 'Integrador - Corporate' || prof.Name != 'Adminstrador') && lstRecordTypeId.contains(record.RecordTypeId) &&
                    record.StageName != 'Aberto' && newRecord.StageName != 'Levantamento de Necessidades' &&
                    record.ExternalReferenceId__c != null
                ){
                    lstOpportunityToWflow.add(record);
                }
            }
        }

        //Validar se não é contexto de carga , para chamar o método futuro
        if(!Test.isRunningTest() && !lstOpportunityToWflow.isEmpty() && lstOpportunityToWflow.size() < LIMIT_FOR_FUTURE_METHOD_REQUEST){

            Corporate_WFlowService.updateOpportunityInWFlow(JSON.serialize(lstOpportunityToWflow));
        }
    }

    public void checkHasQuote(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<String> lstRecordTypeIdBenficios = getListRecordTypeIds('CorporateBeneficios');
        List<Opportunity> lstOpportunitiesCorporate = new List<Opportunity>();
        List<Opportunity> lstOpportunitiesCorporateBeneficios = new List<Opportunity>();
        List<Quote> lQuotes = new List<Quote>();

        for(Opportunity newRecord : newRecordsList){
            Opportunity oldRecord = oldRecordsMap.get(newRecord.Id);

            if(newRecord.QuoteCount__c > oldRecord.QuoteCount__c &&
               lstRecordTypeId.contains(newRecord.RecordTypeId)
            ){
                lstOpportunitiesCorporate.add(newRecord);
            }
            // if(newRecord.QuoteCount__c == 1 && lstRecordTypeIdBenficios.contains(newRecord.RecordTypeId)){
            //     newRecord.StageName = 'Construção da proposta';
            // }else if(newRecord.QuoteCount__c > 1 && lstRecordTypeIdBenficios.contains(newRecord.RecordTypeId)){
            //     newRecord.StageName = 'Em negociação';
            // }
        }
        // if(!lstOpportunitiesCorporateBeneficios.isEmpty()){
        //     OpportunityBO.getInstance().lstUpdOpportunities(lstOpportunitiesCorporateBeneficios);
        // }
        if(!lstOpportunitiesCorporate.isEmpty() && lstOpportunitiesCorporate.size() < LIMIT_FOR_FUTURE_METHOD_REQUEST){
            OpportunityBO.getInstance().sendNofiticationHasQuotes(lstOpportunitiesCorporate);
        }

    }

    public void createRelatedAssetByOpportunityDescription(){
        Set<Id> setOpportunitiesIds = new Set<Id>();
        List<String> lstRecordTypeId = getListRecordTypeIds('Conseg');

        for(Opportunity objOpportunity : newRecordsList){
            String strObjOpportunity = JSON.serialize(objOpportunity);

            if(lstRecordTypeId.contains(objOpportunity.RecordTypeId) &&
                objOpportunity.Asset__c == null &&
                strObjOpportunity.contains('Description')
            ){
                setOpportunitiesIds.add(objOpportunity.Id);
            }
        }

        if(!setOpportunitiesIds.isEmpty()){
            AssetBO.getInstance().createAssetAutomobilesByOpportunityDescription(setOpportunitiesIds);
        }
    }

    private void checksWhetherAssetMeetsSpecialConditions(){

        Set<Id> setOpportunitiesIds = new Set<Id>();
        List<String> lstRecordTypeId = getListRecordTypeIds('Conseg');

        for(Opportunity objOpportunity : newRecordsList){
            String strObjOpportunity = JSON.serialize(objOpportunity);

            if(lstRecordTypeId.contains(objOpportunity.RecordTypeId) &&
                objOpportunity.Asset__c == null &&
                strObjOpportunity.contains('Description')
            ){
                setOpportunitiesIds.add(objOpportunity.Id);
            }
        }

        if(!setOpportunitiesIds.isEmpty()){
            AssetBO.getInstance().createAssetAutomobilesByOpportunityDescription(setOpportunitiesIds);
        }
    }

    private void distributionOpportunityConsegRemote(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Conseg');
        List<String> lstLeadSource = getSourceByRecordTypeDeveloperName('Conseg');
        List<Opportunity> lstOpportunities = new List<Opportunity>();

        for(Opportunity objOpportunity : newRecordsList){
            if(lstRecordTypeId.contains(objOpportunity.RecordTypeId) &&
                lstLeadSource.contains(objOpportunity.LeadSource) &&
                (   objOpportunity.Type == 'New' ||
                    objOpportunity.Type == null)
                ){
                    lstOpportunities.add(objOpportunity);
                }
        }
        if(!lstOpportunities.isEmpty()){
            lstOpportunities = Conseg_OpportunityBO.distributionOpportunityConsegRemote(lstOpportunities);
            update lstOpportunities;
        }
    }

    // Recupera os tipos de registro de Oportunidade que a Wiz Corporate usa.
    private List<String> getListRecordTypeIds(String businessUnit){
        List<String> lstRecordTypeId = new List<String>();

        switch on businessUnit {
            when 'Corporate' {
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateComercial')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateLicitacao')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateMCMV')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateCBIC')
                .getRecordTypeId());
                 lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateBeneficios')
                .getRecordTypeId());
            }
            when 'Conseg' {
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('Auto')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('BPOTelevendas')
                .getRecordTypeId());
            }
            when 'BPOTelevendas' {
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('BPOTelevendas')
                .getRecordTypeId());
            }
        }
        return lstRecordTypeId;
    }

    //TODO - migrar valores para o MDT DinamicPicklistValues que consta na sandbox Conseg2
    private List<String> getSourceByRecordTypeDeveloperName(String recordTypeDeveloperName){
        List<String> lstLeadSource = new List<String>();
        switch on recordTypeDeveloperName {
             when 'Conseg' {
                lstLeadSource.add('Abracaf');
                lstLeadSource.add('Barigui');
                lstLeadSource.add('CAVEPE');
                lstLeadSource.add('Close Car');
                lstLeadSource.add('Conseg');
                lstLeadSource.add('LE LAC');
                lstLeadSource.add('Leven');
                lstLeadSource.add('Minauto');
                lstLeadSource.add('Primavia');
                lstLeadSource.add('RIVEL');
                lstLeadSource.add('VENTURE');
                lstLeadSource.add('WIZ');
                lstLeadSource.add('CAOA');
            }
        }
        return lstLeadSource;
    }

	public void changeCaseStatusPlacement(){
         try{
            List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
            List<Case> lCases = new List<Case>();
            List<Case> casesToUpdate = new List<Case>();
            Map<String,String> oppStageToCaseStatus = getCaseStatusToChange('corporateStages');
            Map<Id,String> caseIndexedByStateToUpdate = new Map<Id, String>();
            Map<Id,Task> registerHistory = new Map<Id,Task>();

            for(Opportunity newOpp : newRecordsList){
                if(lstRecordTypeId.contains(newOpp.RecordTypeId) &&
                    oppStageToCaseStatus.containsKey(newOpp.StageName)
                ){
                    lCases = CaseDAO.getInstance().getCasesByOpportunityId(newOpp.Id);
                    if(!lCases.isEmpty()){
                        for(Case cs : lCases){
                            if(cs.Status != oppStageToCaseStatus.get(newOpp.StageName)){
                                // oppStageToCaseStatus.get(newOpp.StageName);
                                cs.Status = oppStageToCaseStatus.get(newOpp.StageName);
                                casesToUpdate.add(cs);
                            }

                            System.debug('Case status =>  ' + cs.Status);
                        }
                    }

                    System.debug('Lista de casos => '+ casesToUpdate);
                    System.debug('Oportunidade => '+ newOpp);
                }
            }

            if(!casesToUpdate.isEmpty()){
                CaseBO.getInstance().updateCases(casesToUpdate);
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }

	}

    private Map<String,String> getCaseStatusToChange(String recordTypeDeveloperName){
        Map<String,String> oppStageToCaseStatus = new Map<String,String>();

        switch on recordTypeDeveloperName {
             when 'corporateStages' {
                // oppStageToCaseStatus.put('Aberto','');
                // oppStageToCaseStatus.put('Levantamento de nececidades','Novo Pedido');.
                oppStageToCaseStatus.put('Cotação enviada','Novo Pedido');
                oppStageToCaseStatus.put('Em Cotação','Análise de dados da oportunidade');
                oppStageToCaseStatus.put('Cotação com pendência','Com pendência');
                oppStageToCaseStatus.put('Construção da proposta','Aguardando cotação');
                oppStageToCaseStatus.put('Em negociação','Aguardando aprovação da cotação');
                oppStageToCaseStatus.put('Repique','Repique');
                oppStageToCaseStatus.put('Em Emissão','Aguardando emissão da apólice');
                oppStageToCaseStatus.put('Fechado e perdido','Processo anulado');
                oppStageToCaseStatus.put('Fechado e ganho','Apólice registrada');
            }
        }
        return oppStageToCaseStatus;
    }
    /**
     * @autor
     * @description
     */
    public void changeStatusPlacement(){
         try{
            List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
            Map<String,String> oppStageToCaseStatus = getCaseStatusToChange('corporateStages');
            Map<Id,Task> registerHistory = new Map<Id,Task>();
            for(Opportunity newOpp : newRecordsList){
                if(lstRecordTypeId.contains(newOpp.RecordTypeId) &&
                    oppStageToCaseStatus.containsKey(newOpp.StageName) &&
                     (Trigger.isUpdate && oldRecordsMap.get(newOpp.Id).StageName != newOpp.StageName)){
                        TaskBO.getInstance().createTaskHistory(newOpp.Id,
                            newOpp.ContactId,
                            'Atualização de Status - ' + newOpp.StageName,
                            '',
                            'Atualização de Status' ,
                            Schema.SObjectType.Task.getRecordTypeInfosByName().get('Connect@Wiz').getRecordTypeId(),
                            'CORPORATE'
                        );
                    }
                }
        } catch (Exception e){
            System.debug(e.getMessage());
        }
	}

    public void insertLatestDocument(){
if (!MethodSwitch__mdt.getInstance('DocumentReuse').MethodDisabled__c || Test.isRunningTest()) {
            
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> lstOpportunitiesIds = new List<Id>();

        for(Opportunity newRecord : newRecordsList){
            if (lstRecordTypeId.contains(newRecord.RecordTypeId) && newRecord.HasOpportunityLineItem == true && oldRecordsMap.get(newRecord.Id).HasOpportunityLineItem == false) {
                lstOpportunitiesIds.add(newRecord.Id);
            }
        }

        if(!lstOpportunitiesIds.isEmpty())
            GetLatestDocuments.createDocuments(lstOpportunitiesIds);
        }
	}



    public void updateContactSync(){
        Id oppRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();
        Id accountBRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> accToUpdateLst = new List<Account>();
        List<Contact> contactToUpdateLst = new List<Contact>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();

        for(Opportunity newRecord : newRecordsList){
            if(newRecord.RecordTypeId == oppRTId){
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


    private void updateParentOpportunityOnAfterInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<String> lstRecordTypeId = getListRecordTypeIdsCorporate();
            Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
        
            for(Opportunity opp:newRecordsList){
                if(lstRecordTypeId.contains(opp.RecordTypeId) && opp.ParentOpportunity__c != null && opp.Type == 'ReNew'){
                    Opportunity oppToUpdate = new Opportunity(Id = opp.ParentOpportunity__c,Latest_Child_Opportunity__c = opp.Id, Latest_Child_Opportunity_Status_Portal__c = opp.Status_Portal__c);
                    mapOpportunities.put(opp.ParentOpportunity__c,oppToUpdate);
                }
            }
            if(!mapOpportunities.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(mapOpportunities.values());
            }
        }
    }
    
    private void updateParentOppOnDelete(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<String> lstRecordTypeId = getListRecordTypeIdsCorporate();
            Set<Id> oppIdsToFilter = new Set<Id>();
            for(Opportunity opp:oldRecordsList){
                if(lstRecordTypeId.contains(opp.RecordTypeId) && opp.ParentOpportunity__c != null && opp.Type == 'ReNew'){
                    oppIdsToFilter.add(opp.ParentOpportunity__c);
                }
            }
            List<Opportunity> oppsToUpdate = [SELECT Id FROM Opportunity WHERE Id IN :oppIdsToFilter AND Latest_Child_Opportunity__c = NULL AND Latest_Child_Opportunity_Status_Portal__c != null];
            for(Opportunity opp : oppsToUpdate){
                opp.Latest_Child_Opportunity_Status_Portal__c = null;
            }
            if(!oppsToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppsToUpdate);
            }
        }
    }

    private void updateStatusCorporateOnBeforeUpdate(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<String> lstRecordTypeId = getListRecordTypeIdsCorporate();
            List<Opportunity> lstOpportunities = new List<Opportunity>();
        
            for(Opportunity opp:newRecordsList){
                if(lstRecordTypeId.contains(opp.RecordTypeId) 
                    && (oldRecordsMap.get(opp.Id).Status_Portal__c != opp.Status_Portal__c ||
                        oldRecordsMap.get(opp.Id).Latest_Order__c != opp.Latest_Order__c ||
                        oldRecordsMap.get(opp.Id).StageName != opp.StageName ||
                        oldRecordsMap.get(opp.Id).Product_Name__c != opp.Product_Name__c ||
                        oldRecordsMap.get(opp.Id).Portal_Visible__c != opp.Portal_Visible__c ||
                        oldRecordsMap.get(opp.Id).Latest_Order_Status__c != opp.Latest_Order_Status__c ||
                        oldRecordsMap.get(opp.Id).Latest_Order_EndDate__c != opp.Latest_Order_EndDate__c ||
                        oldRecordsMap.get(opp.Id).Latest_Child_Opportunity__c != opp.Latest_Child_Opportunity__c ||
                        oldRecordsMap.get(opp.Id).Latest_Child_Opportunity_Status_Portal__c != opp.Latest_Child_Opportunity_Status_Portal__c ||
                        oldRecordsMap.get(opp.Id).Product_Renewal_Start_Term__c != opp.Product_Renewal_Start_Term__c)
                    && !(oldRecordsMap.get(opp.Id).Status_Portal__c == 'Vigente' && opp.Status_Portal__c == 'A Expirar')
                    && !(oldRecordsMap.get(opp.Id).Status_Portal__c == 'A Expirar' && opp.Status_Portal__c == 'Vencida')
                    && !(oldRecordsMap.get(opp.Id).Status_Portal__c == 'Em Renovação - Vigente' && opp.Status_Portal__c == 'Em Renovação - A Expirar')
                    && !(oldRecordsMap.get(opp.Id).Status_Portal__c == 'Em Renovação - A Expirar' && opp.Status_Portal__c == 'Em Renovação - Vencida')){
                        opp.Status_Portal__c = OpportunityCorporateHelper.getStatusPortal(opp);
                }
            }
        }
    }

    private void updateParentAccountAndOppOnAfterUpdate(){
        List<String> lstRecordTypeId = getListRecordTypeIdsCorporate();
        Set<Id> accSetIds = new Set<Id>();
        Map<Id,Opportunity> oppIdToOppMap = new Map<Id,Opportunity>();
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            for(Opportunity opp:newRecordsList){
                if(lstRecordTypeId.contains(opp.RecordTypeId) && opp.Status_Portal__c!=oldRecordsMap.get(opp.Id).Status_Portal__c){
                    accSetIds.add(opp.AccountId);
                    if(opp.ParentOpportunity__c != null && opp.Type == 'ReNew'){
                        oppIdToOppMap.put(opp.Id,opp);
                    }
                }
            }
            if(!accSetIds.isEmpty()){        
                OpportunityCorporateHelper.updateProductCount(accSetIds);
            }
            if(!oppIdToOppMap.isEmpty()){
                OpportunityCorporateHelper.updateParentOpportunity(oppIdToOppMap);
            }
        }
    }

    public List<String> getListRecordTypeIdsCorporate(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WGarantia').getRecordTypeId());
        lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateWNetwork').getRecordTypeId());
        lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corretora_Externa').getRecordTypeId());
        return lstRecordTypeId;
    }
}