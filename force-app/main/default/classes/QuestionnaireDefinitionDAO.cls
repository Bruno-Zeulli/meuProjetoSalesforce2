public with sharing class QuestionnaireDefinitionDAO {

    /**
     * Singleton implementation
     */
    private static final QuestionnaireDefinitionDAO INSTANCE = new QuestionnaireDefinitionDAO();
    public static QuestionnaireDefinitionDAO getInstance(){
        return INSTANCE;
    }

    public Questionnaire_Definition__c getQuestionnaireDefByName(String name){
        List<Questionnaire_Definition__c> questionnaireList = this.getQuestionnaireDefByName(new Set<String> { name });
        return questionnaireList.isEmpty() ? null : questionnaireList.get(0);
    }

    public List<Questionnaire_Definition__c> getQuestionnaireDefByName(Set<String> name){
        return [SELECT Id, Name, Allow_Places__c FROM Questionnaire_Definition__c WHERE Name IN :name];
    }
}