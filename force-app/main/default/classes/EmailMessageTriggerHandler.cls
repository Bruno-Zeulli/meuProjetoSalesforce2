public without sharing class EmailMessageTriggerHandler {
    private boolean isExecuting = false;
    public List<EmailMessage> oldRecordsList = null;
    public List<EmailMessage> newRecordsList = null;
    public Map<Id, EmailMessage> oldRecordsMap = null;
    public Map<Id, EmailMessage> newRecordsMap = null;

    public EmailMessageTriggerHandler(Boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert(){
        System.debug('Trigger After Insert EmailMessage');
        EmailMessageBO.getInstance().completeMilestoneTickets(newRecordsList);
    }

    /*public void onAfterUpdate(){
        System.debug('Trigger After Update EmailMessage');
    }

    public void onBeforeUpdate(){
        System.debug('Trigger Before Update EmailMessage');      
    }*/

    public void onBeforeInsert(){
        System.debug('Trigger Before Insert EmailMessage');
    }
}