@isTest
public without sharing class ConnectWizNotificationControllerTest {
    @TestSetup
    static void makeData(){
        Id recordTypeCorporateTaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
        User usuario = [SELECT Id FROM User WHERE UserNickName__c Like '%Marcelo Martins%'];
        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.CloseDate = Date.today() + 3;
        insert opp;

        Product2 objProduct = new Product2();
        objProduct.name = 'Teste';
        objProduct.Family = 'Beneficios';
        objProduct.ProductCode = '002';
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry();
        objPricebookEntry.Product2Id = objProduct.Id;
        objPricebookEntry.PriceBook2Id = pricebookId;
        objPricebookEntry.IsActive = true;
        objPricebookEntry.UnitPrice = 100;

        insert objPricebookEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem();
        objOppLineItem.Product2Id = objProduct.Id;
        objOppLineItem.OpportunityId = opp.Id;
        objOppLineItem.Quantity = 2;
        objOppLineItem.PricebookEntryId = objPricebookEntry.Id;
        objOppLineItem.UnitPrice = 100;
        insert objOppLineItem;

        Case caso = new Case();
        caso.OwnerId = usuario.Id;
        caso.Opportunity__c = opp.Id;
       	insert caso;

        Task t = new Task();
        t.WhatId = caso.Id;
        t.ownerId =usuario.Id;
        t.Subject = 'Atribuído para técnico' ;
        t.RecordTypeId = recordTypeCorporateTaskId;
        insert t;

        Task t2 = new Task();
        t2.WhatId = caso.Id;
        t2.ownerId =usuario.Id;
        t2.Subject = 'Nova oportunidade disponível' ;
        t2.RecordTypeId = recordTypeCorporateTaskId;
        insert t2;
    }

    @isTest
    public static void checkIfUserHasTasksTest(){
        User usuario = [SELECT Id FROM User WHERE Profile.Name Like '%Admin%' AND IsActive = true LIMIT 1];
        System.runAs(usuario){
            Test.startTest();
            List<ConnectWizNotificationTO.Notification> lstNotification = ConnectWizNotificationController.checkIfUserHasTasks();
            System.debug('List<ConnectWizNotificationTO.Notification>' +lstNotification);
            System.assertEquals(false,lstNotification.isEmpty(),'A lista deve conter ao menos uma task');
            Test.stopTest();
        }
    }

    @isTest
    public static void completeTaskTest(){
        Task objTask = [SELECT Id FROM Task WHERE Subject = 'Atribuído para técnico' LIMIT 1];
        Task objTask2 = [SELECT Id FROM Task WHERE Subject = 'Nova oportunidade disponível' LIMIT 1];

        Test.startTest();
        Boolean isCompletedTask = ConnectWizNotificationController.completeTask(objTask.Id);
        Boolean isCompletedTask2 = ConnectWizNotificationController.completeTask(objTask2.Id);
        System.assertEquals(true,isCompletedTask,'A task deve mudar o status para completed');
        System.assertEquals(true,isCompletedTask2,'A task deve mudar o status para completed');
        Test.stopTest();
    }

    @isTest
    public static void completeAllTasksTest(){

        Task objTask = [SELECT Id FROM Task WHERE Subject = 'Atribuído para técnico' LIMIT 1];
        Task objTask2 = [SELECT Id FROM Task WHERE Subject = 'Nova oportunidade disponível' LIMIT 1];
        Case objCase = [SELECT Id FROM Case LIMIT 1];
        List<ConnectWizNotificationTO.Notification> lstNotificationTO = new List<ConnectWizNotificationTO.Notification>();

        ConnectWizNotificationTO.Notification objNotificationTO = new ConnectWizNotificationTO.Notification();
        ConnectWizNotificationTO.Notification objNotificationTO2 = new ConnectWizNotificationTO.Notification();

        objNotificationTO.caseId = objCase.Id;
        objNotificationTO.taskId = objTask.Id;
        objNotificationTO2.caseId = objCase.Id;
        objNotificationTO2.taskId = objTask2.Id;
        lstNotificationTO.add(objNotificationTO);
        lstNotificationTO.add(objNotificationTO2);

        Test.startTest();
        Boolean isAllUpdated = ConnectWizNotificationController.completeAllTasks(lstNotificationTO);
        System.assertEquals(true, isAllUpdated , 'deve atualizar todas as tasks');
        Test.stopTest();
    }
}