/**
 * @description       : Atualiza detalhe de contato
 * @author            : Samuel Sirkis
 * @group             :
 * @last modified on  : 08-04-2022
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   08-04-2022   Samuel Sirkis   Initial Version
 **/
@isTest
public with sharing class ContactDetailUpdateBatchTest {
    static final string PARCEIROS_RT_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Parceiros').getRecordTypeId();
    static final string CONCIERGE_RT_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());

        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        Account customer = AccountDataFactory.insertPersonAccount();
        customer = [SELECT Id, Name, PersonContactId FROM Account WHERE Id = :customer.Id];

        Account customer2 = AccountDataFactory.insertPersonAccount();
        customer2 = [SELECT Id, Name, PersonContactId FROM Account WHERE Id = :customer2.Id];

        ContactDetail__c ctd1 = new ContactDetail__c(Name = customer.Name, Contact__c = customer.PersonContactId, Source__c = 'Parceiros', RecordTypeId = PARCEIROS_RT_ID);
        ContactDetail__c ctd = new ContactDetail__c(Name = customer2.Name, Contact__c = customer2.PersonContactId, Source__c = 'Concierge', RecordTypeId = CONCIERGE_RT_ID);

        insert ctd1;
        insert ctd;
    }

    @isTest
    static void testImplementation(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());

        Test.startTest();
        ContactdetailUpdateBatch batch = new ContactdetailUpdateBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        ContactDetail__c ctd = [SELECT Id, Name, Source__c FROM ContactDetail__c WHERE RecordTypeId = :PARCEIROS_RT_ID];
        System.debug(ctd);
        String expected = ctd.Name;
        String actual = ctd.Name;
        System.assertEquals(expected, actual, 'Expected ' + ctd.Name);

        ContactDetail__c ctd1 = [SELECT Id, Name, Source__c FROM ContactDetail__c WHERE RecordTypeId = :CONCIERGE_RT_ID];
        System.debug(ctd1);
        expected = ctd1.Name;
        actual = ctd1.Name;
        System.assertEquals(expected, actual, 'Expected ' + ctd.Name);
    }
}