@IsTest
public with sharing class QuestionnaireDefinitionDataFactory {
    
    public static Questionnaire_Definition__c createQuestionnaireDefinition(){
        Questionnaire_Definition__c def = new Questionnaire_Definition__c();
        def.Name = 'Test';
        def.Status__c = 'Ativo';
        def.Allow_Places__c = true;
        def.Product__c = 'product';
        def.Sub_Product__c = 'subproduct';
        def.External_Code__c = 'Test';
        return def;
    }

    public static Questionnaire_Definition__c insertQuestionnaireDefinition(){
        Questionnaire_Definition__c def = createQuestionnaireDefinition();
        insert def;
        return def;
    }
}