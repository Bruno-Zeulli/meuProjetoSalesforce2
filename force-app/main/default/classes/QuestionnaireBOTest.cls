@IsTest
private class QuestionnaireBOTest {
    
    @IsTest
    static void createQuestionnaireShouldCreateAValidQuestionnaire(){
        Questionnaire__c quest = QuestionnaireDataFactory.createQuestionnaire();

        Test.startTest();
        QuestionnaireBO.getInstance().insertQuestionnaire(quest);
        Test.stopTest();

        List<Questionnaire__c> questList = [SELECT Id FROM Questionnaire__c];
        Assert.areEqual(1, questList.size(), 'The number of created questionnaires is not as expected');
    }
}