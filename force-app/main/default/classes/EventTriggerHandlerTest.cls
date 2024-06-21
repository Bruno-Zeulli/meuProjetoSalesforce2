/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class EventTriggerHandlerTest {
    @isTest
    static void testEventTriggerHandler(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Event eventVariable;
        eventVariable = testInsert();
        System.assert(eventVariable != null, 'test Insert');
        eventVariable = testUpdate(eventVariable);
        eventVariable = testDelete(eventVariable);
        eventVariable = testUndelete(eventVariable);
    }

    static Event testInsert(){
        Id lead2BusinessRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2U_Lead2Business').getRecordTypeId();
        Account acc = AccountDataFactory.insertBusinessAccount();
        Contact ct = ContactDataFactory.createContact();
        ct.AccountId = acc.Id;
        insert ct;
        ContactDetail__c cd = ContactDetailDataFactory.createContactDetail();
        cd.Contact__c = ct.Id;
        insert cd;
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        opp.RecordTypeId = lead2BusinessRecordType;
        opp.AccountId = acc.Id;
        insert opp;
        Event eventVariable = EventDataFactory.createEvent();
        eventVariable.WhatId = opp.Id;
        eventVariable.WhoId = ct.Id;
        insert eventVariable;
        return eventVariable;
    }

    static Event testUpdate(Event eventVariable){
        update eventVariable;
        return eventVariable;
    }

    static Event testDelete(Event eventVariable){
        delete eventVariable;
        return eventVariable;
    }

    static Event testUndelete(Event eventVariable){
        undelete eventVariable;
        return eventVariable;
    }
}