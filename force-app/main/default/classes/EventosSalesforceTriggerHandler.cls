public without sharing class EventosSalesforceTriggerHandler {
    private boolean isExecuting = false;
    public List<EventosSalesforce__e> oldRecordsList = null;
    public List<EventosSalesforce__e> newRecordsList = null;
    public Map<Id, EventosSalesforce__e> oldRecordsMap = null;
    public Map<Id, EventosSalesforce__e> newRecordsMap = null;

    /**
     * @description starta a trigger
     * @param isExecuting
     */
    public EventosSalesforceTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert(){
        EventosBO.getInstance().distributionEvents(this.newRecordsList);
    }
}