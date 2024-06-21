/**
 * @description       :
 * @author            : marcelomartins@wizsoluceos.com.br
 * @group             :
 * @last modified on  : 10-29-2022
 * @last modified by  : marcelomartins@wizsoluceos.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   10-29-2022   marcelomartins@wizsoluceos.com.br    Initial Version
 **/
@isTest
public with sharing class PTN_RetentionCampaignLoadingAutoSclTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';
    public static String expected;
    public static String actual;

    @testSetup
    static void setup(){

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;

        Id recordTypeContract = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('Consortium').getRecordTypeId();
        Id rtContactDetail = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName()
                                                                    .get('Parceiros')
                                                                    .getRecordTypeId();


        Account customer = AccountDataFactory.insertPersonAccount();
        Contact objContact =  ContactDataFactory.insertContact();
        ContactDetail__c objContacDetail = ContactDetailDataFactory.createContactDetail();
        objContacDetail.Contact__c = objContact.Id;
        objContacDetail.RecordTypeId = rtContactDetail;
        objContacDetail.Source__c = 'Parceiros';
        insert objContacDetail;

        Campaign objCampaign = CampaignDataFactory.insertCampaign('PartnerCampaign');
        objCampaign.CTIListName__c = 'PARCEIROS - Retencao CNP';
        update objCampaign;

        List<DialingStrategy__c> lDialingStrategy = new List<DialingStrategy__c>();
        lDialingStrategy.add(
            new DialingStrategy__c(
                Name = 'CNP001', 
                StrategyParameter__c = 'CNP001', 
                CTIListName__c = 'PARCEIROS - Retencao CNP', 
                Priority__c = 4
            )                        
        );

        lDialingStrategy.add(
            new DialingStrategy__c(
                Name = 'DO0001', 
                StrategyParameter__c = 'DO0001', 
                CTIListName__c = 'PARCEIROS - Retencao CNP', 
                Priority__c = 1 
            )                        
        );

        

        Contract2__c contract = new Contract2__c(
            Name = 'Consórcio Imóvel',
            Account__c = customer.Id,
            Contact__c = objContact.Id,
            StartDate__c = System.today().addDays(-50),
            EndDate__c = System.today().addDays(+30),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '1',
            CertificateNumber__c = '1',
            BidNumber__c = '0000008595665475044444',
            Status__c = 'Ativo',
            ProductName__c = 'Consórcio Auto',
            ProductFamily__c = 'Consórcio',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract,
            SalesBusinessUnity__c = 'PARCEIROS',
            SalesAgency__c = 'DO0001',
            Company__c = 'Caixa Consorcios S.A.'
        );

        Contract2__c contract1 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Contact__c = objContact.Id,
            StartDate__c = System.today().addDays(-5),
            EndDate__c = System.today().addDays(+20),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '3',
            CertificateNumber__c = '3',
            BidNumber__c = '095572958692395633333',
            Status__c = 'Ativo',
            ProductName__c = 'Consórcio Auto',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Cancelada',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract,
            SalesBusinessUnity__c = 'PARCEIROS',
            SalesAgency__c = 'CNP001',
            Company__c = 'Caixa Consorcios S.A.'
        );

        insert contract;
        insert contract1;

    }

    @isTest
    static void testImplementationSchedule(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;

        Test.startTest();
        PTN_RetentionCampaignLoadingAutoSchedule.schedule(cronEXP);
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new PTN_RetentionCampaignLoadingAutoSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testImplementationBatch(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;
        
        Test.startTest();
        PTN_RetentionCampaignLoadingBatch batch = new PTN_RetentionCampaignLoadingBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}