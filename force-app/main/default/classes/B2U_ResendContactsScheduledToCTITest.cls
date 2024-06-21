/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author                Modification
 * 1.0   06-03-2021     Marcelo Martins         Initial Version
 **/
@isTest
public class B2U_ResendContactsScheduledToCTITest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';

    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Id recordType = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('B2UCampaign').getRecordTypeId();
        Id recordTypeCD = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Multiseguradora').getRecordTypeId();
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        Account customer = AccountDataFactory.insertPersonAccount();
        customer = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer.Id];
        Account customer2 = AccountDataFactory.insertPersonAccount();
        customer2 = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer2.Id];

        ContactDetail__c conDetailCustomerMS = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(customer);
        conDetailCustomerMS.RecordTypeId = recordTypeCD;
        conDetailCustomerMS.Source__c = 'Conseg';
        update conDetailCustomerMS;

        ContactDetail__c conDetailCustomerConcierge = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(customer);

        ContactDetail__c conDetailCustomer2MS = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(customer2);
        conDetailCustomer2MS.RecordTypeId = recordTypeCD;
        conDetailCustomer2MS.Source__c = 'Conseg';
        update conDetailCustomer2MS;

        Opportunity oppcustomer = OpportunityDataFactory.createOpportunity();
        Opportunity oppcustomer2 = OpportunityDataFactory.createOpportunity();
        Opportunity oppcustomer3 = OpportunityDataFactory.createOpportunity();

        Campaign camp1 = new Campaign(Name = 'Teste', CTIListName__c = 'Teste', Type = 'Call Center Ativo', RecordTypeId = recordType);
        insert camp1;

        CampaignMember campMember1 = new CampaignMember(
            CampaignId = camp1.Id,
            ContactId = customer.PersonContactId,
            CreatedDate = System.today().addDays(-10),
            ContactDetail__c = conDetailCustomerMS.Id,
            IntegrationStatus__c = 'Enviado'
        );
        insert campMember1;

        CampaignMember campMember2 = new CampaignMember(
            CampaignId = camp1.Id,
            ContactId = customer2.PersonContactId,
            CreatedDate = System.today().addDays(-10),
            ContactDetail__c = conDetailCustomer2MS.Id,
            IntegrationStatus__c = 'Enviado'
        );
        insert campMember2;

        DispositionPath__c dispPath = new DispositionPath__c(
            Name = '1.2.18 Agendamento de retorno',
            Category__c = '1. Atendimento Realizado',
            Subcategory__c = '1.2 Informações ao Cliente',
            Reason__c = '1.2.18 Agendamento de retorno',
            SpecificReason__c = '1.2.18 Agendamento de retorno',
            Disposition__c = '1.2.18 Agendamento de retorno'
        );
        insert dispPath;

        Task disposition = TaskDataFactory.insertCallTaskWithAccountAndOpp(customer.PersonContactId, oppcustomer.Id);
        disposition.CallDisposition = 'Agendamento de retorno';
        disposition.Disposition__c = dispPath.Id;
        disposition.Status = 'Open';
        disposition.ContactSchedulingDate__c = System.today().addDays(-3);
        disposition.ActivityDate = System.today().addDays(-4);
        disposition.WhatId = oppcustomer.Id;
        disposition.WhoId = customer.PersonContactId;
        update disposition;

        // Task disposition2 = TaskDataFactory.insertCallTaskWithAccountAndOpp(customer2.PersonContactId, oppcustomer2.Id);
        // disposition2.CallDisposition = '1.2.18 Agendamento de retorno';
        // disposition.Disposition__c = dispPath.Id;
        // disposition2.Status = 'Not Started';
        // disposition2.ContactSchedulingDate__c = System.today().addDays(-3);
        // disposition2.ActivityDate = System.today().addDays(-4);
        // update disposition2;

        // Task disposition3 = TaskDataFactory.insertCallTaskWithAccountAndOpp(customer2.PersonContactId, oppcustomer3.Id);
        // disposition3.CallDisposition = '1.2.18 Agendamento de retorno';
        // disposition.Disposition__c = dispPath.Id;
        // disposition3.Status = 'Open';
        // disposition3.ContactSchedulingDate__c = System.today().addDays(-5);
        // disposition3.ActivityDate = System.today().addDays(-5);
        // update disposition3;
    }

    @isTest
    static void testImplementation(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new B2U_ResendContactsScheduledToCTISchedule());
        B2U_ResendContactsScheduledToCTISchedule.schedule();
        ManipulateTaskBasedCampaignMember.getTaskSchedulingContact();
        Test.stopTest();
        // CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        // System.assertEquals('2022-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2022-09-03 05:00:00');
    }
}