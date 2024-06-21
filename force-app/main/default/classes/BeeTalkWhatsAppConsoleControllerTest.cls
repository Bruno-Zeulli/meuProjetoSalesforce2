/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-05-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public with sharing class BeeTalkWhatsAppConsoleControllerTest {
	
    @TestSetup
    static void setup(){
		
        Profile profileADM = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userStandard = new User(
            LastName = 'testeadm',
            Email = 'teste123adm@gmail.com',
            Username = 'teste123adm@gmail.com',
            Alias = 'testa',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = profileADM.Id,
            LanguageLocaleKey = 'pt_BR',
            OnlineToChat__c = false,
            AutomaticReceiverChat__c = false
        );
        insert userStandard;

        UserManagement__c userManagement = new UserManagement__c(
            PresenceStatus__c = 'Disponivel',
            AutomaticReceiverChat__c = true,
            Capacity__c = 4,
            User__c = userStandard.Id,
            UN__c = 'Conseg'
        );
        insert userManagement;


        Group objQueue = new Group(
            Name = 'Test Queue',
            Type = 'Queue'
        );
        insert objQueue;


        Group objGroup = new Group(
            Name = 'Test Group',
            Type = 'Regular'
        );
        insert objGroup;



        System.runAs(new User(Id=UserInfo.getUserId())){
            QueuesObject testQueue = new QueueSObject(QueueId = objQueue.id, SObjectType = 'Case');
            insert testQueue;
        }

        System.RunAs([SELECT Id FROM User where Id =:userStandard.Id][0]){
            GroupMember objQueueGroup = new GroupMember(
                GroupId = objQueue.Id,
                UserOrGroupId = objGroup.Id
            );
            insert objQueueGroup;

            GroupMember objGroupUser = new GroupMember(
                GroupId = objGroup.Id,
                UserOrGroupId = userStandard.Id
            );
            insert objGroupUser;
        }

        Case objCase = new Case(
            Origin = 'Teste Origin',
            Subject = 'Teste Subject',
            Status = 'Teste Status',
            UN__c = 'Concept',
            beetalk__SourceIdentification__c = 'Teste beetalk Source',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ChatBot').getRecordTypeId()
        );
        insert objCase;
	
    }

    @isTest
    static void testGetUserStatus(){
		
        Test.startTest();
        User userStandard = [SELECT Id, Username FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        UserManagement__c userManagement = [SELECT Id, PresenceStatus__c, AutomaticReceiverChat__c FROM UserManagement__c WHERE User__c =: userStandard.Id LIMIT 1];
        System.debug('userStandard-->>'+ userStandard);

        UserManagement__c result = BeeTalkWhatsAppConsoleController.getUserStatus(userStandard.Id);
        //System.assertEquals(userManagement.Id, result.Id);
        //System.assertEquals(userManagement.PresenceStatus__c, result.PresenceStatus__c);
        //System.assertEquals(userManagement.AutomaticReceiverChat__c, result.AutomaticReceiverChat__c);
        BeeTalkWhatsAppConsoleController.getInstance();
        Test.stopTest();
    }
	
    @isTest
    static void testGetMyCaseBTWhatsApp(){

        Test.startTest();

        User userStandard = [SELECT Id FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        System.debug('userStandard-->>'+ userStandard);

        Case objCase = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        System.debug('objCase-->>'+ objCase);

        objCase.OwnerId = userStandard.Id;
        objCase.Status = 'Em atendimento';
        update objCase;

        List<Case> lstCases = BeeTalkWhatsAppConsoleController.getMyCaseBTWhatsApp(userStandard.Id);

        //System.assertEquals(1,lstCases.size());
        Test.stopTest();

    }

    @isTest
    static void testGetCaseAwaitBTWhatsApp(){

        Test.startTest();

        User userStandard = [SELECT Id FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        System.debug('userStandard-->>'+ userStandard);

        Group objGroup = [SELECT Id FROM Group WHERE Name = 'Test Queue' LIMIT 1];
        System.debug('objGroup-->>'+ objGroup);

        Case objCase = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        System.debug('objCase-->>'+ objCase);

        objCase.OwnerId = objGroup.Id;
        objCase.Status = 'Aguardando atendimento';
        update objCase;

        List<Case> lstCases = BeeTalkWhatsAppConsoleController.getCaseAwaitBTWhatsApp(userStandard.Id);

        //System.assertEquals(0,lstCases.size());
        Test.stopTest();
    }

    @isTest
    static void testGetCaseToMe(){



        Test.startTest();

        User userStandard = [SELECT Id FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        System.debug('userStandard-->>'+ userStandard);

        Case objCase = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        System.debug('objCase-->>'+ objCase);

        BeeTalkWhatsAppConsoleController.getCaseToMe(userStandard.Id,objCase.Id);

        Case updatedCaseToMe = [SELECT Id, OwnerId, Status FROM Case WHERE Id =: objCase.Id];
        //System.assertEquals(userStandard.Id, updatedCaseToMe.OwnerId);
        //System.assertEquals('Em atendimento', updatedCaseToMe.Status);

        Test.stopTest();

    }

    @isTest
    static void testChangeOnlineChat(){

        Test.startTest();


        User userStandard = [SELECT Id FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];


        System.debug('userStandard-->>'+ userStandard);
        String presenceStatus = 'Disponivel';
        BeeTalkWhatsAppConsoleController.changeOnlineChat(userStandard.Id, presenceStatus);

        UserManagement__c userManagement = [SELECT Id, PresenceStatus__c, User__c FROM UserManagement__c WHERE User__c =: userStandard.Id LIMIT 1];
        //System.assertEquals(userStandard.Id, userManagement.User__c);
        //System.assertEquals('Disponivel', userManagement.PresenceStatus__c);

        Test.stopTest();

    }

    @isTest
    static void testGetCaseData(){
        Test.startTest();
        User userStandard = [SELECT Id, Username FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        Case objCase = [SELECT Id, Status FROM Case LIMIT 1];

        Case result = BeeTalkWhatsAppConsoleController.getCaseData(objCase.Id);
        Test.stopTest();
    }

    @isTest
    static void testChangeActualPage(){
        Test.startTest();
        User userStandard = [SELECT Id, Username FROM User WHERE Username = 'teste123adm@gmail.com' LIMIT 1];
        Case objCase = [SELECT Id, Status FROM Case LIMIT 1];

        BeeTalkWhatsAppConsoleController.changeActualPage(objCase.Id, true);
        Test.stopTest();
    }
	
}