@isTest
public class CallLogGetCampaignMemberHelperTest {
    @TestSetup
    static void makeData(){
        DispositionPath__c dispP = new DispositionPath__c(
        	Name = 'CallLogGetCampaignMemberHelper',
            Reason__c = 'CallLogGetCampaignMemberHelper'
        );
        insert dispP;
        
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
            Message__c = '{"id":"e45b938b-4a3d-493e-9bfc-0c3d8f799228","connectedTime":"2024-01-16T14:51:54.828Z","endTime":"2024-01-16T14:56:45.492Z","phone":"tel:+5561985003975","name":"Customer","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":true,"isDialer":true,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Cliente","recordingState":"none","displayAddress":"","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5561985003975","interactionDurationSeconds":291,"totalAcdDurationSeconds":6,"disposition":"VENDA REALIZADA - RAFAEL","dispositionDurationSeconds":3,"direction":"Outbound","isInternal":false,"startTime":"2024-01-16T14:51:49.282Z","isDialerPreview":true,"dialerContactId":"4be2abae5737bf5cc26c9d2d6e760f8c","dialerContactListId":"eb0fcf62-64ed-470f-9017-87be20b164d6","dialerCampaignId":"56d5e140-90ed-4979-9ede-da769be577f9","callbackNumbers":["+5561985003975","+5561985003975"]}',
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
        DispositionPath__c disp = [SELECT Id FROM DispositionPath__c WHERE Name = 'CallLogGetCampaignMemberHelper' LIMIT 1];
		
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
        	CallLogGetCampaignMemberHelper.FlowInput aux = new CallLogGetCampaignMemberHelper.FlowInput();
        	aux.callLogId = log.Id;
             CallLogGetCampaignMemberHelper.getReferenceIdByCallLog(new List<CallLogGetCampaignMemberHelper.FlowInput>{aux});
        Test.stopTest();

        CallLog__c cLog = [SELECT Id, TempoDeEspera__c FROM CallLog__c 
        WHERE ReferenceId__c = 'conversationIdTeste' LIMIT 1];
        System.assertNotEquals(null, cLog, 'O callLog deve existir');
    }
}