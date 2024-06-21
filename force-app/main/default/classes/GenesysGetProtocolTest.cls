@isTest
public class GenesysGetProtocolTest {
    @TestSetup
    static void makeData(){
        CallLog__c log = new CallLog__c(
            Address__c = 'getProtocolTeste',
            Queue__c = 'Conseg'
        );
        insert log;
    }

    @isTest
    public static void getProtocolTest(){
        CallLog__c log = [SELECT Id, Name FROM CallLog__c WHERE Address__c = 'getProtocolTeste' LIMIT 1];

        Test.startTest();
            String protocolo = GenesysGetProtocol.getProtocol(log.Id);

            System.assertEquals(log.Name, protocolo, 'Protocolo esperado não bate');

            // testar exception
            GenesysGetProtocol.getProtocol('');
        Test.stopTest();
    }
}