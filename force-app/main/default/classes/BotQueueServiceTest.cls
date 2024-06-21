@isTest
public with sharing class BotQueueServiceTest {
    
    @testSetup static void setup() {

        Group gp = new Group(Name='CONSEG', DeveloperName='TEST');
        insert gp;

    }

    @IsTest
    static void testMethodName() {
        
        Id p = [SELECT Id FROM Profile WHERE Name='Administrador'].id;
       
        Account ac = new Account(name ='Test', CompanyIdentificationNumber__c = '14343271000154') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;  
                    
        User user = new User(alias = 'test123', email='test123@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    BusinessUnit__c = 'CONSEG',
                    timezonesidkey='America/Los_Angeles', username='tester@noemail.com' + System.currentTimeMillis());
        
        insert user;

        system.runAs(user) {
            Assert.areNotEqual(0, BotQueueService.getBotQueueByLoggedUser().size());
        }
    }
}