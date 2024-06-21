/**
 * @description       : Teste Atualiza Oportunidade com Detalhe de Contato
 * @author            : matheusmelo@wiz.co
 * @group             :
 * @last modified on  : 01-18-2024
 * @last modified by  : matheusmelo@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   01-18-2024   matheusmelo@wiz.co                   Initial Version
 **/
@isTest
public class OpportunityUpdateContactDetailBatchTest {
 
    @isTest
    static void testBatchExecution() {

 
        // Criar uma conta
        Account testAccount = new Account(Name = 'Test Account', CompanyIdentificationNumber__c = '07034340000182');
        insert testAccount;
 
        // Criar um contato associado à conta
        Contact testContact = new Contact(AccountId = testAccount.Id, FirstName = 'Test', LastName = 'Contact');
        insert testContact;
 
        // Criar uma oportunidade associada à conta
        Opportunity testOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Amount = 10000,
            RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Conseg').getRecordTypeId()
        );
        insert testOpportunity;
 
        // Criar um detalhe de contato associado ao contato
        ContactDetail__c testContactDetail = new ContactDetail__c(Contact__c = testContact.Id, name = 'Test Value', Source__c = 'Conseg');
        insert testContactDetail;
 
        // Inicie o job em lote
        Test.startTest();
        Database.executeBatch(new OpportunityUpdateContactDetailBatch(), 200);
        Test.stopTest();
 
        // Verifique se as Oportunidades foram atualizadas corretamente
        Opportunity updatedOpportunity = [SELECT Id, ContactDetail__c FROM Opportunity WHERE Id = :testOpportunity.Id];
        System.assertEquals(testContactDetail.Id, updatedOpportunity.ContactDetail__c, 'O detalhe de contato não foi atualizado corretamente na oportunidade');
    }
}