@isTest
public with sharing class ExpurgoBatchTest {
    @TestSetup
    static void makeData(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        List<ContactDetail__c> lstContactDetail = new List<ContactDetail__c>();

        Id recordTypePJ = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PJ').getRecordTypeId();
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ(), RecordTypeId = recordTypePJ);
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;

        insert acc;

        Contact contato = new Contact();
        contato.LastName = 'sILVA';
        contato.AccountId = acc.Id;
        insert contato;

        Id recordType = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            //Contact__c = contact.Id,
            MobilePhone__c = '61984609897',
            HomePhone__c = '6132746636',
            Email__c = 'teste@teste.com',
            Street__c = 'Street',
            District__c = 'District',
            City__c = 'Brasilia',
            State__c = 'DF',
            Contact__c = contato.Id,
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            RecordTypeId = recordType
        );

        insert contactDetail;
    }

    static testMethod void testMethod1(){
        Test.startTest();

        ContactDetailExpurgoBatch contactDetailBatch = new ContactDetailExpurgoBatch();
        DataBase.executeBatch(contactDetailBatch);

        Test.stopTest();
    }
}