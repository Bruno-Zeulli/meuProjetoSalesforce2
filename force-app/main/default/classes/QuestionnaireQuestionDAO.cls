public with sharing class QuestionnaireQuestionDAO {

    /**
     * Singleton implementation
     */
    private static final QuestionnaireQuestionDAO INSTANCE = new QuestionnaireQuestionDAO();
    public static QuestionnaireQuestionDAO getInstance(){
        return INSTANCE;
    }
    
    public List<Questionnaire_Question__c> getQuestionsByDefinitionIds(Set<String> definitionId){
        return [SELECT Id, Label__c, Type__c, Questionnaire_Definition__c, External_Code__c FROM Questionnaire_Question__c WHERE Questionnaire_Definition__c = :definitionId AND Type__c != 'Sessão'];
    }
}