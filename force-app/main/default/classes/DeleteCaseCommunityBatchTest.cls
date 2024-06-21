/**
 * @description       :
 * @author            : pedrotofani@wiz.co
 * @group             :
 * @last modified on  : 01-04-2024
 * @last modified by  : pedrotofani@wiz.co
**/
@isTest
public class DeleteCaseCommunityBatchTest {
    @isTest
    static void testBatchExecution() {
    	Id profileId = [SELECT Id FROM Profile WHERE Name = 'Administrador'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Corporate - Benefícios - Gerente Regional'].Id;

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

        Contact iContact = new Contact(IndividualIdentificationNumber__c = '47635470866',LastName = 'LastName');
        insert iContact;

        Product2 objProduct = new Product2(name = 'Teste',Family = 'Beneficios',ProductCode = '002');
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);

        insert objPricebookEntry;
        
        Case iCaseToInsert = new Case(Routed__c = true,ToDelete__c = true, Description = 'Test Shared',Status = 'Novo pedido',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = iUser.Id);
        insert iCaseToInsert;
        
        List<Case> testCase = new List<Case>();
        testCase.add(iCaseToInsert);

        // Inicie o batch manualmente
        DeleteCaseCommunityBatch batch = new DeleteCaseCommunityBatch();
        Database.BatchableContext bc;
        batch.start(bc);

        // Execute o batch manualmente
        batch.execute(bc, testCase);

    }
}