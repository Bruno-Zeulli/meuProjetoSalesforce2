public with sharing class CertifiedTriggerHandler {

    private boolean isExecuting = false;
    public List<Certified__c> oldRecordsList = null;
    public List<Certified__c> newRecordsList = null;
    public Map<Id, Certified__c> oldRecordsMap = null;
    public Map<Id, Certified__c> newRecordsMap = null;



    public CertifiedTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    public void onBeforeUpdate(){
        checkRegistrationNumber();
    }
    public void onBeforeInsert(){
        checkRegistrationNumber();
    }

    private void checkRegistrationNumber(){
        CertifiedBO.getInstance().formatingForNumber(newRecordsList);
    }
}