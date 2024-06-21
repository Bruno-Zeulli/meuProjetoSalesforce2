/**
 * @description       : Agenda as classes AbandonedCalls e NPS, para que seja armazenado esses dados
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 27-11-2023
 * @last modified by  : joao@beecloud.com.br
**/
@istest
public class ScheduleJobsFromGenesysTest{
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
            if(req.getEndpoint() == 'https://api.sae1.pure.cloud/api/v2/analytics/conversations/details/query'){
                res.setBody('{"conversations":[{"conversationId":"conversationId","divisionIds":["b2975b50-90e0-49a5-a974-f3b18692f0fc"],"participants":[{"purpose":"customer","participantName":"Mobile Number, Brazil","sessions":[{"ani":"tel:+fakeNumber","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:04:16.884Z","segmentEnd":"2023-11-27T13:04:16.991Z"},{"conference":false,"disconnectType":"endpoint","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:04:16.991Z","segmentEnd":"2023-11-27T13:05:45.937Z","segmentType":"interact"}]}]},{"purpose":"ivr","participantName":"Concept CGDR Vs1","sessions":[{"ani":"tel:+5561985003975","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:04:16.899Z","segmentEnd":"2023-11-27T13:04:16.937Z"},{"conference":false,"disconnectType":"transfer","segmentStart":"2023-11-27T13:04:16.937Z","segmentEnd":"2023-11-27T13:05:10.935Z","segmentType":"ivr"}]}]},{"purpose":"acd","participantName":"queueTest","sessions":[{"ani":"tel:+5561985003975","direction":"inbound","segments":[{"segmentType":"delay","segmentStart":"2023-11-27T13:05:10.948Z","segmentEnd":"2023-11-27T13:05:10.968Z"},{"conference":false,"disconnectType":"peer","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:05:10.968Z","segmentEnd":"2023-11-27T13:05:45.964Z","segmentType":"interact"}]}]}]},{"conversationId":"conversationId2","divisionIds":["a2975b50-90e0-49a5-a974-f3b18692f0fc"],"participants":[{"purpose":"customer","participantName":"Another Customer","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:00:00.000Z","segmentEnd":"2023-11-27T13:01:00.000Z"},{"conference":false,"disconnectType":"endpoint","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:01:00.000Z","segmentEnd":"2023-11-27T13:02:00.000Z","segmentType":"interact"}]}]},{"purpose":"ivr","participantName":"Another IVR","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:02:00.000Z","segmentEnd":"2023-11-27T13:03:00.000Z"},{"conference":false,"disconnectType":"transfer","segmentStart":"2023-11-27T13:03:00.000Z","segmentEnd":"2023-11-27T13:04:00.000Z","segmentType":"ivr"}]}]},{"purpose":"acd","participantName":"Another ACD","sessions":[{"ani":"tel:+987654321","direction":"inbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:04:00.000Z","segmentEnd":"2023-11-27T13:05:00.000Z"},{"conference":false,"disconnectType":"peer","queueId":"74ed1c55-b7ac-4ebc-bb87-89b982ea44ab","segmentStart":"2023-11-27T13:05:00.000Z","segmentEnd":"2023-11-27T13:06:00.000Z","segmentType":"interact"}]}]},{"purpose":"agent","participantName":"Another Agent","sessions":[{"ani":"tel:+987654321","direction":"outbound","segments":[{"segmentType":"system","segmentStart":"2023-11-27T13:06:00.000Z","segmentEnd":"2023-11-27T13:07:00.000Z"}]}]}]}],"totalHits":2}');
            }else{
                // res.setBody('{"participants":[{"purpose":"agent","attributes":{}},{"purpose":"customer","attributes":{"NPS_Nota1":"1","NPS_Nota2":"0","NPS_Nota3":"3"}},{"purpose":"ivr","attributes":{}},{"purpose":"acd","attributes":{}}],"securePause":false,"selfUri":"1"}');
                res.setBody('{"participants":[{"purpose":"agent","attributes":{}},{"purpose":"customer","attributes":{"NPS_Nota1":"1","NPS_Nota2":"0","NPS_Nota3":"3"}},{"purpose":"ivr","name":"caminhoURAExemple","attributes":{}},{"purpose":"acd","attributes":{}}],"securePause":false,"selfUri":"1"},{"purpose":"ivr","name":"Pesquisa de Satisfação Teste","attributes":{}}');
            }
            return res;
        }
    }
 
    @isTest
    public static void executeScheduleJobsFromGenesysTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            String cronTime = '0 0 0 3 9 ? 2042';
            String jobId = System.schedule('GenesysScheduleJobsTest', cronTime, new ScheduleJobsFromGenesys());
        Test.stopTest();

        CronTrigger scheduledJobInformations = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        Assert.areEqual(cronTime, scheduledJobInformations.CronExpression, 'A Schedule não foi marcado no horário correto');

        Assert.areEqual(0, scheduledJobInformations.TimesTriggered, 'A Schedule não deveria ter sido executada nenhuma vez');

        Assert.areEqual('2042-09-03 00:00:00', String.valueOf(scheduledJobInformations.NextFireTime), 'A data do Schedule não é a esperada');
        }
}