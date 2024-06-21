/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 06-12-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class CallLogTest {
    @TestSetup
    static void makeData(){
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'GenesysCloudTME',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            AccessToken__c = '123'
        );
        insert settings;

        CallLog__c log = new CallLog__c(
            Message__c = '{"id":"adb6fb8f-225a-4f27-b663-2f9ac4e08d3d","connectedTime":"2024-01-19T20:11:09.991Z","endTime":"2024-01-19T20:11:12.485Z","phone":"tel:7286495585999560029","name":"vonex 4004","isConnected":false,"isDisconnected":true,"isDone":false,"state":"DESCONECTADO","isCallback":false,"isDialer":false,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"vonex 4004","recordingState":"active","displayAddress":"7286495585999560029","queueName":"Conseg: Ativo Manual Renovação","ani":"Interno","calledNumber":"7286495585999560029","interactionDurationSeconds":2,"direction":"Inbound","isInternal":false,"startTime":"2024-01-19T20:10:29.532Z"}',
            ReferenceId__c = 'conversationIdTeste'
        );
        insert log;
    }

    public class MockHttpCallout implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest request){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(200);
            response.setBody('{"results":[{"data":[{"metrics":[{"stats":{"sum":1837,"min":1837,"max":1837,"count":1}}]}]}]}');
            return response;
        }
    }

    @isTest
    public static void updateCallWaitingTimeTest(){
        CallLog__c log = [SELECT Id FROM CallLog__c WHERE ReferenceId__c = 'conversationIdTeste' LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            CallLog.updateCallWaitingTime(new List<String>{log.Id});
        Test.stopTest();

        CallLog__c logWithWaitingTime = [SELECT Id, TempoDeEspera__c FROM CallLog__c 
        WHERE ReferenceId__c = 'conversationIdTeste' LIMIT 1];
        System.assertEquals(2, logWithWaitingTime.TempoDeEspera__c, 'O tempo de espera não está correto');
    }
}