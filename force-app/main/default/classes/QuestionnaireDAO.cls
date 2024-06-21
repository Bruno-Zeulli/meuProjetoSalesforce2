public with sharing class QuestionnaireDAO {
    /**
     * Singleton implementation
     */
    private static final QuestionnaireDAO INSTANCE = new QuestionnaireDAO();
    public static QuestionnaireDAO getInstance() {
        return INSTANCE;
    }

    public Questionnaire__c getQuestionnaireById(String questionnaireId) {
        List<Questionnaire__c> questionnaireList = getQuestionnaireById(new List<String>{ questionnaireId });
        return questionnaireList.isEmpty() ? null : questionnaireList.get(0);
    }

    public List<Questionnaire__c> getQuestionnaireById(List<String> questionnaireIds){
        return [SELECT Id, Opportunity__r.AccountId, Opportunity__r.Name FROM Questionnaire__c WHERE Id IN :questionnaireIds];
    }
}