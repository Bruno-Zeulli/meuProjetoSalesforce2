public with sharing class DocusignCalloutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    private static List<String> RTsCorporate = new List<String>{'CorporateComercial','CorporateLicitacao','CorporateMCMV','CorporateCBIC','CorporateBeneficios','WGarantia','CorporateWNetwork'};

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = 'SELECT Id, Envelope_Id_CN__c, AccountId, Account.IdentificationNumber__c, Account.IsPersonAccount ' +
                            'FROM Opportunity '+
                            'WHERE Envelope_Signed_CN__c=FALSE '+
                            'AND Envelope_Id_CN__c!=NULL '+
                            'AND RecordType.DeveloperName IN :RTsCorporate';
        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<Opportunity> oppsScope = (List<Opportunity>) scope;
        DocusignCallout.saveSignedDocuments(scope);
    }

    public void finish(Database.BatchableContext bc){

    }
}