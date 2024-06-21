@isTest
public class Chatbot_ChangeBHFlag_Batch_Test {
    
    @isTest
    static void testBatchExecution() {
        List<beetalk__Contact__c> testContacts = new List<beetalk__Contact__c>();
        List<Case> testCases = new List<Case>();
        DateTime simulatedDateTime = DateTime.now().addMinutes(-1440);
        
         Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Em atendimento'  
        );
        insert testCase;
        
        beetalk__Message__c testMessage = new beetalk__Message__c(
            beetalk__Direction__c = 'IN',
            beetalk__Source__c = 'WHATSAPP',
            beetalk__Text__c = 'Teste',
            beetalk__Type__c = 'TEXT',
            CreatedDate = simulatedDateTime
        );
        insert testMessage;
        
        beetalk__Contact__c testContact = new beetalk__Contact__c(
            beetalk__LastInboundMessage__c = testMessage.Id,
            beetalk__Status__c = 'OPEN_AUTO',  
            beetalk__IntentName__c = '',
            DuringNPS__c = false,
            beetalk__Case__c = testCase.Id
        );
        insert testContact;
        
        Test.startTest();
        Chatbot_ChangeBusinessHoursFlag_Batch batchClass = new Chatbot_ChangeBusinessHoursFlag_Batch();
        Database.executeBatch(batchClass);
        Test.stopTest();
    }
}