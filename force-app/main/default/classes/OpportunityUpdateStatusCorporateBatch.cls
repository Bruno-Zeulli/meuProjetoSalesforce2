public with sharing class OpportunityUpdateStatusCorporateBatch implements Database.Batchable<sObject>{

    private static final String STATUS_VIGENTE = 'Vigente';
    private static final String STATUS_VENCIDA = 'Vencida';
    private static final String STATUS_EXPIRANDO = 'A Expirar';
    private static final String STATUS_EM_RENOVACAO_VIGENTE = 'Em Renovação - Vigente';
    private static final String STATUS_EM_RENOVACAO_EXPIRANDO = 'Em Renovação - A Expirar';
    private static final String STATUS_EM_RENOVACAO_VENCIDA = 'Em Renovação - Vencida';
    @TestVisible
    private Date todayDate = System.Today();
    @TestVisible
    private Date last1Day = System.Today().addDays(-1);
    @TestVisible
    private Date next120Day = System.Today().addDays(120);
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> lstRecordTypeId = new OpportunityTriggerHandler(true).getListRecordTypeIdsCorporate();
        
        String queryString = 'SELECT Id, Status_Portal__c, Latest_Order_EndDate__c, Product_Renewal_Start_Date__c '+
                              'FROM Opportunity '+
                              'WHERE RecordTypeId IN :lstRecordTypeId AND '+
                                    '(Product_Renewal_Start_Date__c = :todayDate OR '+
                                    '(Latest_Order_EndDate__c = :next120Day AND Product_Renewal_Start_Date__c=NULL) OR '+
                                    'Latest_Order_EndDate__c = :last1Day)';
        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope){

        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        List<Opportunity> oppsScope = (List<Opportunity>) scope;
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            for(Opportunity opp:oppsScope){
                if(opp.Status_Portal__c == STATUS_EXPIRANDO && opp.Latest_Order_EndDate__c == last1Day){
                    opp.Status_Portal__c = STATUS_VENCIDA;
                    oppListToUpdate.add(opp);
                }else if(opp.Status_Portal__c == STATUS_EM_RENOVACAO_EXPIRANDO && opp.Latest_Order_EndDate__c == last1Day){
                    opp.Status_Portal__c = STATUS_EM_RENOVACAO_VENCIDA;
                    oppListToUpdate.add(opp);
                }else if(opp.Status_Portal__c == STATUS_VIGENTE && (opp.Product_Renewal_Start_Date__c == todayDate || (opp.Latest_Order_EndDate__c == next120Day && opp.Product_Renewal_Start_Date__c == null))){
                    opp.Status_Portal__c = STATUS_EXPIRANDO;
                    oppListToUpdate.add(opp);
                }else if(opp.Status_Portal__c == STATUS_EM_RENOVACAO_VIGENTE && (opp.Product_Renewal_Start_Date__c == todayDate || (opp.Latest_Order_EndDate__c == next120Day && opp.Product_Renewal_Start_Date__c == null))){
                    opp.Status_Portal__c = STATUS_EM_RENOVACAO_EXPIRANDO;
                    oppListToUpdate.add(opp);
                }
            }
            if(!oppListToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppListToUpdate);
            }
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}