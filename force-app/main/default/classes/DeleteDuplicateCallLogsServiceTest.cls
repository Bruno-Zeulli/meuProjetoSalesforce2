@isTest
public class DeleteDuplicateCallLogsServiceTest {
    
    @TestSetup
    static void setup() {
    	CallLog__c log = new CallLog__c(
            Message__c = '{"id":"e45b938b-4a3d-493e-9bfc-0c3d8f799228","connectedTime":"2024-01-16T14:51:54.828Z","endTime":"2024-01-16T14:56:45.492Z","phone":"tel:+5561985003975","name":"Customer","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":true,"isDialer":true,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Cliente","recordingState":"none","displayAddress":"","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5561985003975","interactionDurationSeconds":291,"totalAcdDurationSeconds":6,"disposition":"VENDA REALIZADA - RAFAEL","dispositionDurationSeconds":3,"direction":"Outbound","isInternal":false,"startTime":"2024-01-16T14:51:49.282Z","isDialerPreview":true,"dialerContactId":"4be2abae5737bf5cc26c9d2d6e760f8c","dialerContactListId":"eb0fcf62-64ed-470f-9017-87be20b164d6","dialerCampaignId":"56d5e140-90ed-4979-9ede-da769be577f9","callbackNumbers":["+5561985003975","+5561985003975"]}',
            ReferenceId__c = 'conversationIdTeste',
            Queue__c = 'Fila Teste',
            Address__c = '+5519999415861',
            Status__c = 'CONECTADO'
        );
        insert log;
        
        CallLog__c log2 = new CallLog__c(
            Message__c = '{"id":"e45b938b-4a3d-493e-9bfc-0c3d8f799228","connectedTime":"2024-01-16T14:51:54.828Z","endTime":"2024-01-16T14:56:45.492Z","phone":"tel:+5561985003975","name":"Customer","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":true,"isDialer":true,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Cliente","recordingState":"none","displayAddress":"","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5561985003975","interactionDurationSeconds":291,"totalAcdDurationSeconds":6,"disposition":"VENDA REALIZADA - RAFAEL","dispositionDurationSeconds":3,"direction":"Outbound","isInternal":false,"startTime":"2024-01-16T14:51:49.282Z","isDialerPreview":true,"dialerContactId":"4be2abae5737bf5cc26c9d2d6e760f8c","dialerContactListId":"eb0fcf62-64ed-470f-9017-87be20b164d6","dialerCampaignId":"56d5e140-90ed-4979-9ede-da769be577f9","callbackNumbers":["+5561985003975","+5561985003975"]}',
            ReferenceId__c = 'conversationIdTeste',
            Queue__c = 'Fila Teste',
            Address__c = '+5519999415861',
            Status__c = 'DESCONECTADO'
        );
        insert log2;
    }
    
	@isTest
    public static void executeTest(){
        Test.startTest();
        new DeleteDuplicateCallLogsService().execute();
        Test.stopTest();
        
        List<CallLog__c> abandonLogList = [SELECT Id, ReferenceId__c, Queue__c FROM CallLog__c WHERE ReferenceId__c = 'conversationIdTeste' LIMIT 1];
        
        System.assertEquals(abandonLogList.size(), 1, 'Não deve existir mais de um call log com o mesmo ReferenceId');
    }
}