@IsTest
public with sharing class QuestionnaireDataFactory {
    
    public static Questionnaire__c createQuestionnaire(){
        Questionnaire_Definition__c def = QuestionnaireDefinitionDataFactory.insertQuestionnaireDefinition();
        List<Questionnaire_Question__c> questions = QuestionnaireQuestionDataFactory.insertQuestionnaireQuestions(3, def.Id);
        Account acc = AccountDataFactory.insertBusinessAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        opp.AccountId = acc.Id;
        insert opp;

        Questionnaire__c quest = new Questionnaire__c();
        quest.Name = 'Test';
        quest.Questionnaire_Definition__c = def.Id;
        quest.Opportunity__c = opp.Id;
        return quest;
    }
    
    public static Questionnaire__c insertQuestionnaire(){
        Questionnaire__c quest = createQuestionnaire();
        insert quest;
        return quest;
    }
}