/**
 * @description       : Obtem as chamadas abandonadas no endpoint analytcs da genesys e insere como CallLog no salesforce
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 27-11-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class AbandonedCallsTest {
    @TestSetup
    static void makeData(){
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'GenesysCloudScheduleJobsFromGenesys',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            AccessToken__c = '123'
        );
        insert settings;
    }

    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"conversations":[{"participants":[{"sessions":[{"segments":[{"segmentType":"system","segmentStart":"2024-03-22T15:35:18.370Z","segmentEnd":"2024-03-22T15:35:19.351Z"},{"segmentType":"interact","segmentStart":"2024-03-22T15:35:19.351Z","segmentEnd":"2024-03-22T16:22:10.413Z"}],"metrics":[{"value":"1","name":"nConnected","emitDate":"2024-03-22T15:35:19.351Z"},{"value":"2811062","name":"tConnected","emitDate":"2024-03-22T16:22:10.413Z"}],"direction":"inbound","ani":"tel:+5514998261353"}],"purpose":"customer","participantName":"Mobile Number, Brazil"},{"sessions":[{"segments":[{"segmentType":"system","segmentStart":"2024-03-22T15:35:18.390Z","segmentEnd":"2024-03-22T15:35:18.401Z"},{"segmentType":"ivr","segmentStart":"2024-03-22T15:35:18.401Z","segmentEnd":"2024-03-22T15:36:26.431Z"}],"metrics":[{"value":"1","name":"nFlow","emitDate":"2024-03-22T15:35:18.742Z"},{"value":"68030","name":"tIvr","emitDate":"2024-03-22T15:36:26.431Z"},{"value":"67698","name":"tFlow","emitDate":"2024-03-22T15:36:26.440Z"},{"value":"67698","name":"tFlowExit","emitDate":"2024-03-22T15:36:26.440Z"}],"direction":"inbound","ani":"tel:+5514998261353"}],"purpose":"ivr","participantName":"Concept RunOff Televendas Vs1"},{"sessions":[{"segments":[{"segmentType":"delay","segmentStart":"2024-03-22T15:36:26.442Z","segmentEnd":"2024-03-22T15:36:26.494Z"},{"segmentType":"interact","segmentStart":"2024-03-22T15:36:26.494Z","segmentEnd":"2024-03-22T16:22:10.420Z"}],"metrics":[{"value":"1","name":"nOffered","emitDate":"2024-03-22T15:36:26.494Z"},{"value":"2743926","name":"tAbandon","emitDate":"2024-03-22T16:22:10.420Z"},{"value":"2743926","name":"tAcd","emitDate":"2024-03-22T16:22:10.420Z"}],"direction":"inbound","ani":"tel:+5514998261353"}],"purpose":"acd","participantName":"queueTest"}],"divisionIds":["a2975b50-90e0-49a5-a974-f3b18692f0fc"],"conversationId":"conversationId"},{"conversationId":"conversationId2","divisionIds":["a2975b50-90e0-49a5-a974-f3b18692f0fc"],"participants":[{"purpose":"customer","participantName":"Another Customer","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:00:00.000Z","segmentEnd":"2023-11-27T13:01:00.000Z"},{"conference":false,"disconnectType":"endpoint","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:01:00.000Z","segmentEnd":"2023-11-27T13:02:00.000Z","segmentType":"interact"}]}]},{"purpose":"ivr","participantName":"Another IVR","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:02:00.000Z","segmentEnd":"2023-11-27T13:03:00.000Z"},{"conference":false,"disconnectType":"transfer","segmentStart":"2023-11-27T13:03:00.000Z","segmentEnd":"2023-11-27T13:04:00.000Z","segmentType":"ivr"}]}]},{"purpose":"acd","participantName":"Another ACD","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:04:00.000Z","segmentEnd":"2023-11-27T13:05:00.000Z"},{"conference":false,"disconnectType":"peer","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:05:00.000Z","segmentEnd":"2023-11-27T13:06:00.000Z","segmentType":"interact"}]}]},{"purpose":"agent","participantName":"Another Agent","sessions":[{"ani":"tel:+987654321","direction":"outbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:06:00.000Z","segmentEnd":"2023-11-27T13:07:00.000Z"}]}]}]}],"totalHits":2}');
            return res;
        }
    }

    @isTest 
    public static void insertAbandonedCallsTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            AbandonedCalls.insertAbandonedCalls();
        Test.stopTest();

        CallLog__c abandonedCallInserida = [SELECT Id, ReferenceId__c, Queue__c FROM CallLog__c WHERE ReferenceId__c = 'conversationId' LIMIT 1];
        System.assertEquals('conversationId', abandonedCallInserida.ReferenceId__c, 'ConversationId não bate com o recebido na requisição');
        System.assertEquals('queueTest', abandonedCallInserida.Queue__c, 'Fila não bate com o recebido na requisição');
    }
}