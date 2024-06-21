public with sharing class QuestionnaireAnswerBO {
    /**
     * Singleton implementation
     */
    private static final QuestionnaireAnswerBO INSTANCE = new QuestionnaireAnswerBO();
    public static QuestionnaireAnswerBO getInstance(){
        return INSTANCE;
    }

    public void createBlankAnswers(List<Questionnaire__c> formList){
        // Bulk operation to get all questions
        Set<String> definitionIds = new Set<String>();
        for (Questionnaire__c form : formList) {
            definitionIds.add(form.Questionnaire_Definition__c);
        }

        // Get and sort questions by Questionnaire Definition
        List<Questionnaire_Question__c> questions = QuestionnaireQuestionDAO.getInstance().getQuestionsByDefinitionIds(definitionIds);
        Map<Id, List<Questionnaire_Question__c>> formDefQuestionListMap = new Map<Id, List<Questionnaire_Question__c>>();
        for (Questionnaire_Question__c question : questions) {
            List<Questionnaire_Question__c> questionsList = formDefQuestionListMap.get(question.Questionnaire_Definition__c);
            if (questionsList == null) {
                questionsList = new List<Questionnaire_Question__c>(); 
            }
            questionsList.add(question);
            formDefQuestionListMap.put(question.Questionnaire_Definition__c, questionsList);
        }

        // Iterate over trigger questionnaire creating the relevant questions
        List<Questionnaire_Answer__c> answersList = new List<Questionnaire_Answer__c>();
        for (Questionnaire__c form : formList) {
            List<Questionnaire_Question__c> questionsList = formDefQuestionListMap.get(form.Questionnaire_Definition__c);
            for (Questionnaire_Question__c question : questionsList) {
                Questionnaire_Answer__c answer = new Questionnaire_Answer__c();
                answer.Questionnaire_Question__c = question.Id;
                answer.Questionnaire__c = form.Id;
                answer.Question_Label__c = question.Label__c;
                answer.Question_Type__c = question.Type__c;
                answer.Unique_Code__c = form.Id + question.External_Code__c;
                answersList.add(answer);
            }
        }

        if (!answersList.isEmpty()) {
            Savepoint sp = Database.setSavepoint();

            try{
                Database.SaveResult[] srListFiles = Database.insert(answersList, false);
                ErrorLogService.getInstance().saveResult(srListFiles, 'Erro ao criar as respostas em branco', answersList);  
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    public void updateByUniqueCode(List<Questionnaire_Answer__c> answersList){
        Savepoint sp = Database.setSavepoint();

        try{
            Database.UpsertResult[] urListFiles = Database.upsert(answersList, Questionnaire_Answer__c.Unique_Code__c, false);
            // ErrorLogService.getInstance().saveResult(srListFiles, 'Erro ao criar as respostas em branco', answersList);  
        } catch (Exception e){
            System.Debug(e);
            Database.rollback(sp);
        }
    }
}