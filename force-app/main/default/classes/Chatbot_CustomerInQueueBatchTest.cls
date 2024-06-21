@isTest
public class Chatbot_CustomerInQueueBatchTest {
    
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
        testCases.add(testCase);

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
            beetalk__IntentName__c = 'Test Intent',
            DuringNPS__c = false,
            beetalk__Case__c = testCase.Id
        );
        insert testContact;
        testContacts.add(testContact);
        
        Test.startTest();
        Chatbot_CustomerInQueueBatch batchClass = new Chatbot_CustomerInQueueBatch();
        Database.executeBatch(batchClass);
        Test.stopTest();
        
        
        List<beetalk__Contact__c> updatedContacts = [SELECT beetalk__Status__c, beetalk__IntentName__c, DuringNPS__c FROM beetalk__Contact__c WHERE Id IN :testContacts];
        List<Case> updatedCases = [SELECT Status FROM Case WHERE Id IN :testCases];
        
        //System.assertEquals('CLOSED', updatedContacts[0].beetalk__Status__c);
        //System.assertEquals('', updatedContacts[0].beetalk__IntentName__c);
        //System.assertEquals(false, updatedContacts[0].DuringNPS__c);
        //System.assertEquals('Closed', updatedCases[0].Status);
    }
}