@IsTest
public with sharing class QuestionnaireQuestionDataFactory {
    
    public static final String TEXT_RT_ID = Schema.SObjectType.Questionnaire_Question__c.getRecordTypeInfosByDeveloperName().get('Texto_Livre').getRecordTypeId();
    public static final String SESSION_RT_ID = Schema.SObjectType.Questionnaire_Question__c.getRecordTypeInfosByDeveloperName().get('Session').getRecordTypeId();
    public static final String LIST_RT_ID = Schema.SObjectType.Questionnaire_Question__c.getRecordTypeInfosByDeveloperName().get('Lista_de_Opcoes').getRecordTypeId();
    public static List<Questionnaire_Question__c> createQuestionnaireQuestions(Integer qtt, String questDefId){
        Questionnaire_Question__c session = new Questionnaire_Question__c();
        session.RecordTypeId = SESSION_RT_ID;
        session.Questionnaire_Definition__c = questDefId;
        session.Label__c = 'Sessão';
        session.External_Code__c = 'S';
        insert session;

        List<Questionnaire_Question__c> questions = new List<Questionnaire_Question__c>();
        Questionnaire_Question__c q0 = new Questionnaire_Question__c();
        q0.RecordTypeId = LIST_RT_ID;
        q0.Questionnaire_Definition__c = questDefId;
        q0.Label__c = 'Pergunta 0';
        q0.External_Code__c = 'P0';
        q0.Options__c = 'option1,option2,oprtion3';
        questions.add(q0);
        for (Integer i=1; i<qtt; i++){
            Questionnaire_Question__c q = new Questionnaire_Question__c();
            q.RecordTypeId = TEXT_RT_ID;
            q.Questionnaire_Definition__c = questDefId;
            q.Label__c = 'Pergunta ' + i;
            q.External_Code__c = 'P' + i;
            q.Session__c = session.Id;
            questions.add(q);
        }
        return questions;
    }

    public static List<Questionnaire_Question__c> insertQuestionnaireQuestions(Integer qtt, String questDefId){
        List<Questionnaire_Question__c> questions = createQuestionnaireQuestions(qtt, questDefId);
        insert questions;
        return questions;
    }
}