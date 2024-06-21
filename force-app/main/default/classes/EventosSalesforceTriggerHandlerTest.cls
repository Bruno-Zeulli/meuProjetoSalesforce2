@isTest
public with sharing class EventosSalesforceTriggerHandlerTest {
    @TestSetup
    static void configurarSetup(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Object__c = 'Account';
        evento.Body__c = '{"LastName":"Silva","RecordTypeName":"PF","IndividualIdentificationNumber__c":"71953119026"}';

        EventBus.publish(evento);
    }

    static testMethod void createLeadByEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"LastName":"Evento Lead","RecordTypeName":"Conseg","LeadSource":"CAOA"}';
        evento.Object__c = 'Lead';
        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(leads.size() > 0, true);
    }

    static testMethod void tryInsertLeadEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"RecordTypeName":"Conseg"}';
        evento.Object__c = 'Lead';
        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<LogIntegracao__c> listLogIntegracao = [SELECT Id FROM LogIntegracao__c];
        System.assertEquals(listLogIntegracao.size() > 0, true);
    }

    static testMethod void createTaskByEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"Subject":"Evento Task","Priority":"Normal","RecordTypeName":"Chat", "Status": "Open"}';
        evento.Object__c = 'Task';

        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(tasks.size() > 0, true);
    }

    static testMethod void tryInsertTaskEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"RecordTypeName":"Chat"}';
        evento.Object__c = 'Task';

        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<LogIntegracao__c> listLogIntegracao = [SELECT Id FROM LogIntegracao__c];
        System.assertEquals(listLogIntegracao.size() > 0, true);
    }

    static testMethod void createAccountByEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"LastName":"Evento Account","IdentificationNumber":"71953119026","RecordTypeName":"PF"}';
        evento.Object__c = 'Account';
        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<Account> accounts = [SELECT Id FROM Account];
        System.assertEquals(accounts.size() > 0, true);
    }

    static testMethod void tryInsertAccountByEvent(){
        EventosSalesforce__e evento = new EventosSalesforce__e();
        evento.Body__c = '{"RecordTypeName":"PF"}';
        evento.Object__c = 'Account';
        Test.startTest();
        EventBus.publish(evento);
        Test.stopTest();

        List<LogIntegracao__c> listLogIntegracao = [SELECT Id FROM LogIntegracao__c];
        System.assertEquals(listLogIntegracao.size() > 0, true);
    }
}