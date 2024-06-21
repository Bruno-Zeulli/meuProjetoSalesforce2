public with sharing class QuestionnaireBO {
    /**
     * Singleton implementation
     */
    private static final QuestionnaireBO INSTANCE = new QuestionnaireBO();
    public static QuestionnaireBO getInstance() {
        return INSTANCE;
    }

    public Questionnaire__c insertQuestionnaire(Questionnaire__c questionnaire) {
        Savepoint sp = Database.setSavepoint();

        try{
            Database.SaveResult[] srListFiles = Database.insert(new List<SObject>{ questionnaire }, false);
            ErrorLogService.getInstance().saveResult(srListFiles, 'Erro ao inserir um questionário', new List<SObject>{ questionnaire });  
        } catch (Exception e){
            System.Debug(e);
            Database.rollback(sp);
        }

        return questionnaire;
    } 
}