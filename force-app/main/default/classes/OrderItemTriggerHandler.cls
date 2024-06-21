public with sharing class OrderItemTriggerHandler {
    
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
    public List<OrderItem> oldRecordsList = null;
    public List<OrderItem> newRecordsList = null;
    public Map<Id, OrderItem> oldRecordsMap = null;
    public Map<Id, OrderItem> newRecordsMap = null;

    public OrderItemTriggerHandler(Boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    
    public void onAfterInsert(){
        updateParentOpportunityOnAfterInsert();
    }

    private void updateParentOpportunityOnAfterInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            Map<Id,Opportunity> oppsToUpdate = new Map<Id,Opportunity>();
            Set<Id> orderIds = new Set<Id>();
            for(OrderItem oi:newRecordsList){
                orderIds.add(oi.OrderId);
            }
            for(OrderItem oi:[SELECT Order.OpportunityId, 
                                     Order.Opportunity.Product_Name__c, 
                                     Product2.Name, 
                                     Product2.Renewal_Start_Term__c 
                              FROM OrderItem 
                              WHERE Id IN :newRecordsList
                              AND Order.Opportunity.Latest_Order__c IN :orderIds 
                              AND Order.Opportunity.RecordTypeId IN :oppRTIds]){
                                
                if(oi.Order.Opportunity.Product_Name__c != oi.Product2.Name){
                    Opportunity opp = new Opportunity(
                                                      Id = oi.Order.OpportunityId, 
                                                      Product_Name__c = oi.Product2.Name, 
                                                      Product_Renewal_Start_Term__c = oi.Product2.Renewal_Start_Term__c);
                    oppsToUpdate.put(oi.Order.OpportunityId,opp);
                }                
            }
            if(!oppsToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppsToUpdate.values());
            }
        }
    }
}