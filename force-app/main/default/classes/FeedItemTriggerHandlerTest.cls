@isTest
public class FeedItemTriggerHandlerTest {
    
    @testSetup
    public static void setup(){
        
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId();
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Integrador - PARCEIROS'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Parceiros - Tickets'].Id;
        
        List<User> iUserList = new List<User>();
        User iUser = new User(
            ProfileId = profileId,
            LastName = 'last',
            Email = 'testEmail@wiz.com',
            Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ',
            Title = 'Usuario WIZ test',
            Alias = 'Wizzer',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser);
        
        User iUser2 = new User(
            ProfileId = profileId2,
            LastName = 'last2',
            Email = 'testEmail2@wiz.com',
            Username = 'wizeruser0002@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ2',
            Title = 'Usuario WIZ test2',
            Alias = 'Wizzer2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser2);
        
        insert iUserList;
        
        Account iAccount = new Account(
            FirstName = 'Conta',
            LastName = 'Segurado',
            IndividualIdentificationNumber__pc = '44154707698',
            PersonEmail = 'teste@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId()
        );
        insert iAccount;
        
        Contact iContact = new Contact();
        iContact.IndividualIdentificationNumber__c = '47635470866';
        iContact.LastName = 'LastName';
        insert iContact;
        
        Case iCaseToInsert = new Case();
        iCaseToInsert.RecordTypeId = recordTypeId;
        iCaseToInsert.Description = 'Test FeedItem';
        iCaseToInsert.StatusTickets__c = 'Em Atendimento';
        iCaseToInsert.AccountId = iAccount.Id;
        iCaseToInsert.ContactId = iContact.Id;
        
        insert iCaseToInsert;
    }
    
    @isTest
    public static void testInsertFeedItem(){
        
        Case iCase = [SELECT Id, Status FROM Case LIMIT 1];
        User iUser = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com' LIMIT 1];
        
        FeedItem item = new FeedItem(
            parentId = iCase.Id,
            createdById = iUser.Id,
            body = 'FeedItem change Case status'
        );
        
        insert item;
        
        update iCase;
        
        system.assertEquals([SELECT Id, Status FROM Case LIMIT 1].Status, iCase.Status);
    }
    
    @isTest
    public static void testUpdateFeedItem(){
        
        Case iCase = [SELECT Id, Status FROM Case LIMIT 1];
        User iUser = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com' LIMIT 1];
        
        FeedItem item = new FeedItem(
            parentId = iCase.Id,
            createdById = iUser.Id,
            body = 'FeedItem change Case status'
        );
        
        insert item;
        
        item.Body = 'new body';
        update item;
        
        update iCase;
        
        system.assertEquals([SELECT Id, Status FROM Case LIMIT 1].Status, iCase.Status);
    }
    
    @isTest
    public static void testInsertFeedItemAguardandoSolicitante(){
        
        //User iUser = [SELECT Id FROM User WHERE Email = 'testEmail2@wiz.com' LIMIT 1];
        Case iCase = [SELECT Id, Status, OwnerId FROM Case LIMIT 1];
        iCase.OwnerId = UserInfo.getUserId();
        update iCase;
        
        FeedItem item = new FeedItem(
            parentId = iCase.Id,
            createdById = UserInfo.getUserId(),
            body = 'FeedItem change Case status: Aguardando solicitante'
        );
        
        insert item;
        
        update iCase;
        
        system.assertEquals([SELECT Id, Status FROM Case LIMIT 1].Status, iCase.Status);
    }
    
}