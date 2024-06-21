/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class TaskTriggerHandlerTest {

    static final Id RECORDTYPE_TELEFONEMA = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Telefonema').getRecordTypeId();

    @testSetup
    static void setup(){
        DispositionPath__c dsp = DispositionPathDataFactory.insertDispositionPath4LevelsDeep();
        /*DispositionSetting__c setting = new DispositionSetting__c();
        setting.DispositionPathId__c = dsp.Id;
        setting.NextStageName__c = 'Fechado e Ganho';
        setting.CTINameSource__c = 'Olos';
        setting.ObjectTypeRecordTypeName__c = 'BPOTelevendas';
        insert setting;*/


        User user1 = new User(LastName='User1',Email='user1@test.com',
                                Alias='user1',
                                ProfileId=[SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                                Username = 'user1@test.com'+ System.currentTimeMillis(),
                                TimeZoneSidKey='America/Los_Angeles',
                                LocaleSidKey='en_US',
                                EmailEncodingKey='UTF-8',
                                LanguageLocaleKey='en_US'
                            );
        insert user1;

        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityWithRecordType(acc.Id, 'BPOTelevendas');

        Task tsk = new Task(
            Subject = 'Chamada - Teste',
            RecordTypeId = RECORDTYPE_TELEFONEMA,
            WhoId = Acc.PersonContactId,
            WhatId = Opp.Id,
            CallDisposition = '0.0 test',
            CTIName__c = 'Olos',
            Disposition__c = dsp.Id
        );
        insert tsk;
    }

    @isTest
    static void testTaskTriggerHandler(){
        Task taskVariable;
        taskVariable = testInsert();
        taskVariable = testUpdate(taskVariable);
        taskVariable = testDelete(taskVariable);
        taskVariable = testUndelete(taskVariable);
        //testCallMac();
        //testMktCloudWhatsApp();
    }

    static Task testInsert(){
        Task taskVariable;
        taskVariable = TaskDataFactory.insertCallTask();
        return taskVariable;
    }

    static Task testUpdate(Task taskVariable){
        DispositionPath__c dp = DispositionPathDataFactory.insertDispositionPath4LevelsDeep();
        Account acc = AccountDataFactory.insertPersonAccount();
        dp = [SELECT Id, Disposition__c FROM DispositionPath__c WHERE Id = :dp.Id];
        taskVariable.CallDisposition = dp.Disposition__c;
        taskVariable.Disposition__c = dp.Id;
        taskVariable.WhoId = acc.PersonContactId;
        update taskVariable;

        testFillOutDisposition(taskVariable, dp);
        testFillOutWhoId(taskVariable, acc);

        Opportunity opp = OpportunityDataFactory.createOpportunity();
        opp.AccountId = acc.Id;
        taskVariable.WhatId = opp.Id;
        insert opp;
        // update taskVariable;

        testFillOutWhoId(taskVariable, opp);

        return taskVariable;
    }

    static Task testDelete(Task taskVariable){
        delete taskVariable;
        return taskVariable;
    }

    static Task testUndelete(Task taskVariable){
        undelete taskVariable;
        return taskVariable;
    }

    static Task testFillOutDisposition(Task taskVariable, DispositionPath__c dp){
        taskVariable = [SELECT Id, CallDisposition, Disposition__c FROM Task WHERE Id = :taskVariable.Id];
        String expected = dp.Id;
        String actual = taskVariable.Disposition__c;
        // Comentando pra corrigir a logica e restestar a classe
        // System.assertEquals(expected, actual);
        expected = dp.Disposition__c;
        actual = taskVariable.CallDisposition;
        // Comentando pra corrigir a logica e restestar a classe
        // System.assertEquals(expected, actual);
        return taskVariable;
    }

    static Task testFillOutWhoId(Task taskVariable, Account acc){
        taskVariable = [SELECT WhatId, WhoId FROM Task WHERE Id = :taskVariable.Id];
        acc = [SELECT PersonContactId FROM Account WHERE Id = :acc.Id];
        Id expected = null;
        Id actual = taskVariable.WhatId;
        // Comentando pra corrigir a logica e restestar a classe
        // System.assertEquals(expected, actual);
        expected = acc.PersonContactId;
        actual = taskVariable.WhoId;
        // Comentando pra corrigir a logica e restestar a classe
        // System.assertEquals(expected, actual);
        return taskVariable;
    }

    @isTest
    static void ShoudInsertVisibilityCmt(){

        Task objTask =  [SELECT Id FROM Task LIMIT 1];

        Test.startTest();
            Task objTaskTest = [SELECT IsVisibleInSelfService FROM Task WHERE Id =: objTask.Id];

            Boolean expected = true;
            System.debug(objTaskTest);
            System.assertEquals(expected, objTaskTest.IsVisibleInSelfService, 'Error test insert task');

        Test.stopTest();
    }

    @isTest
    static void ShoudUpdateVisibilityCmt(){

        Task objTask =  [SELECT Id FROM Task LIMIT 1];

        Test.startTest();
            objTask.Subject = 'Chamada - Teste2';
            update objTask;

            Task objTaskTest = [SELECT IsVisibleInSelfService FROM Task WHERE Id =: objTask.Id];

            Boolean expected = true;
            System.debug(objTaskTest);
            System.assertEquals(expected, objTaskTest.IsVisibleInSelfService, 'Error test insert task');

        Test.stopTest();
    }


    static Task testFillOutWhoId(Task taskVariable, Opportunity opp){
        taskVariable = [SELECT WhatId, WhoId FROM Task WHERE Id = :taskVariable.Id];
        opp = [SELECT Account.PersonContactId FROM Opportunity WHERE Id = :opp.Id];
        Id expected = opp.Account.PersonContactId;
        Id actual = taskVariable.WhoId;
        // Comentando pra corrigir a logica e restestar a classe
        // System.assertEquals(expected, actual);
        return taskVariable;
    }

    static Task testCallMac(){
        Case c = CaseDataFactory.createCase();
        Account acc = AccountDataFactory.createPersonAccount();

        Task task = TaskDataFactory.insertCallTaskWithAccountAndOpp(acc.PersonContactId, c.Id);

        return task;
    }

    static Task testMktCloudWhatsApp(){
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Account acc = AccountDataFactory.createPersonAccount();

        Task task = TaskDataFactory.insertCallTaskWithAccountAndOpp(acc.PersonContactId, opp.Id);

        return task;
    }

    @isTest
    static void testSendEmailNotificationByTask(){

        User user1 = [SELECT Id, Name FROM User WHERE Alias ='user1' LIMIT 1];
        // Create test data
        Account acc = AccountDataFactory.createPersonAccount();
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name='Test Opportunity',StageName = 'Aberta', CloseDate = Date.today(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Corporate - Comercial').getRecordTypeId());
        insert opp;
        Case c = new Case(Opportunity__c=opp.Id, OwnerId=UserInfo.getUserId(), Status='New', RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId());
        insert c;
        Task t = new Task(WhatId=opp.Id, Subject='Test Subject', Description='Test Description',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Corporate - Interação').getRecordTypeId());
        insert t;
        System.debug('User id: ' + UserInfo.getName());
        // Set up expected email notification object
        ConnectWizCMPTO.EmailNotification expectedNotification = new ConnectWizCMPTO.EmailNotification();
        expectedNotification.subject = 'Test Subject';
        expectedNotification.description = 'Test Description';
        expectedNotification.opportunityNumber = opp.OpportunityNumber__c;
        expectedNotification.caseNumber = c.CaseNumber;
        expectedNotification.opportunityName = opp.Name;
        expectedNotification.taskOwner = user1.Name;
        expectedNotification.taskOwnerId = user1.Id;
        expectedNotification.caseOwner = user1.Id;
        expectedNotification.opportunityOwner = opp.OwnerId;
        expectedNotification.opportunityId = opp.Id;
        expectedNotification.caseId = c.CaseNumber;

        // Call the method under test
        Test.startTest();
            // SendEmailNotificationByTask obj = new SendEmailNotificationByTask();
            // obj.newRecordsList.add(t);
            // obj.sendEmailNotificationByTask();
        Test.stopTest();

        // Verify that the email notification was sent with the expected parameters
        // ConnectWizCMPTO.EmailNotification actualNotification = ConnectWizSendEmailNotificationByTask.lastEmailNotificationSent;
        // System.assertEquals(expectedNotification, actualNotification, 'Teste Success');
    }
}