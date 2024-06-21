public with sharing class OpportunityLineItemTriggerHandler {

    private Id corporateComercial = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateComercial').getRecordTypeId();
    private Id corporateLicitacao = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateLicitacao').getRecordTypeId();
    private Id corporateMCMV = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateMCMV').getRecordTypeId();
    private Id corporateCBIC = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateCBIC').getRecordTypeId();
    private Id corporateBeneficios = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateBeneficios').getRecordTypeId();
    private Id corporateWNetwork = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateWNetwork').getRecordTypeId();
    private Id wGarantia = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WGarantia').getRecordTypeId();
    private Id corretoraExterna = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Corretora_Externa').getRecordTypeId();
    private Set<Id> oppRTIds = new Set<Id>{corporateComercial,corporateLicitacao,corporateMCMV,corporateCBIC,corporateBeneficios,corporateWNetwork,wGarantia,corretoraExterna};
    private boolean isExecuting = false;

    public List<OpportunityLineItem> newRecordsList = null;
    public Map<Id,OpportunityLineItem> newRecordsMap = null;

    public OpportunityLineItemTriggerHandler(boolean isExecuting) {
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert(){
        updateParentOpportunity();
    }

    @TestVisible
    private void updateParentOpportunity(){
        Map<Id,Opportunity> oppsToUpdate = new Map<Id,Opportunity>();
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            for(OpportunityLineItem oli:[SELECT Id, OpportunityId, Product2.Name, Product2.Renewal_Start_Term__c FROM OpportunityLineItem WHERE Id IN :newRecordsList AND Opportunity.RecordTypeId IN :oppRTIds]){
                Opportunity opp = new Opportunity(Id = oli.OpportunityId, Product_Name__c = oli.Product2.Name, Product_Renewal_Start_Term__c = oli.Product2.Renewal_Start_Term__c);
                oppsToUpdate.put(oli.OpportunityId,opp);
            }
            if(!oppsToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppsToUpdate.values());
            }
        }
    }
}