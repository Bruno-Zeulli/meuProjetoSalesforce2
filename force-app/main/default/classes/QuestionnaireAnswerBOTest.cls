@IsTest
private class QuestionnaireAnswerBOTest {
    
    @IsTest
    static void createQuestionnaireShouldCreateEmptyAnswers(){
        
        Questionnaire__c quest = QuestionnaireDataFactory.createQuestionnaire();

        Test.startTest();
        insert quest;
        Test.stopTest();
        
        List<Questionnaire_Answer__c> answers = [SELECT Id, Answer__c FROM Questionnaire_Answer__c WHERE Questionnaire__c = :quest.Id];
        Assert.areEqual(3, answers.size(), 'The answer number is not as expected');
        Assert.isNull(answers.get(0).Answer__c, 'The answer should be empty');
        Assert.isNull(answers.get(1).Answer__c, 'The answer should be empty');
        Assert.isNull(answers.get(2).Answer__c, 'The answer should be empty');
    }

    @isTest
    static void updateAnswerShouldReplaceTheFieldValue(){
        Questionnaire__c quest = QuestionnaireDataFactory.insertQuestionnaire();

        List<Questionnaire_Answer__c> answers = [SELECT Id, Answer__c FROM Questionnaire_Answer__c WHERE Questionnaire__c = :quest.Id];
        answers.get(0).Answer__c = 'new answer';
        answers.get(1).Answer__c = 'new answer';
        answers.get(2).Answer__c = 'new answer';

        Test.startTest();
        QuestionnaireAnswerBO.getInstance().updateByUniqueCode(answers);
        Test.stopTest();

        List<Questionnaire_Answer__c> answersNew = [SELECT Id, Answer__c FROM Questionnaire_Answer__c WHERE Questionnaire__c = :quest.Id];
        Assert.areNotEqual(answers.get(0).Answer__c, answersNew.get(0).Answer__c, 'The answer was not updated as expected');
        Assert.areNotEqual(answers.get(1).Answer__c, answersNew.get(1).Answer__c, 'The answer was not updated as expected');
        Assert.areNotEqual(answers.get(2).Answer__c, answersNew.get(2).Answer__c, 'The answer was not updated as expected');

    }
}