public with sharing class InsuredLocationDAO {
    /**
     * Singleton implementation
     */
    private static final InsuredLocationDAO INSTANCE = new InsuredLocationDAO();
    public static InsuredLocationDAO getInstance(){
        return INSTANCE;
    }

    public List<Insured_Location__c> getInsuredLocationByQuestionnaireIds(Set<String> questId){
        return [SELECT Id, Asset__c, Questionnaire__c FROM Insured_Location__c WHERE Questionnaire__c IN :questId];
    }
}