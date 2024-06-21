@IsTest
public with sharing class InsuredLocationDataFactory {

    public static Insured_Location__c createInsuredLocation(String assetId, String questionnaireId){
        Insured_Location__c location = new Insured_Location__c();
        location.Asset__c = assetId;
        location.Questionnaire__c = questionnaireId;
        return location;
    }

    public static Insured_Location__c insertInsuredLocation(String assetId, String questionnaireId){
        Insured_Location__c location = createInsuredLocation(assetId, questionnaireId);
        insert location;
        return location;
    }
}