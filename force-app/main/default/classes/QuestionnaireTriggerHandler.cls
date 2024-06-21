public with sharing class QuestionnaireTriggerHandler {
    private boolean isExecuting = false;

    public List<Questionnaire__c> oldRecordsList;
    public List<Questionnaire__c> newRecordsList;
    public Map<Id, Questionnaire__c> oldRecordsMap;
    public Map<Id, Questionnaire__c> newRecordsMap;

    public QuestionnaireTriggerHandler(boolean isExecuting) {
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert() {
        createBlankAnswers();
    }

    private void createBlankAnswers() {
        QuestionnaireAnswerBO.getInstance().createBlankAnswers(newRecordsList);
    }
}