/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GenesysScheduleCallInvocableTest {
    @TestSetup
    static void setup(){
        CallLog__c log = new CallLog__c(
            Address__c = '19999554433',
            ReferenceId__c = 'teste-reference-id',
            Queue__c = 'xxxxx'
        );
        insert log;

        Campaign campanha = new Campaign(
            Name = 'campanha teste',
            CTIListName__c = 'xxxxx',
            CampaignSource__c = 'Conseg',
            PureCloud_Campaign_ID__c = 'teste-campaign-id'
        );
        insert campanha;

        // Crie uma configuração personalizada para o teste
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'Genesys Cloud Test ScheduleCall',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            AccessToken__c = '123'
        );
        insert settings;
    }

    // Classe de mock para simular a chamada HTTP
    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Crie uma resposta simulada
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(202);
            req.setBody('{}');
            return res;
        }
    }

    @isTest
    public static void scheduleCallInvocableTest(){
        CallLog__c log = [SELECT Id, Address__c, ReferenceId__c, Queue__c
            FROM CallLog__c WHERE ReferenceId__c = 'teste-reference-id' LIMIT 1];

        Campaign campanha = [SELECT Id, CTIListName__c, CampaignSource__c, PureCloud_Campaign_ID__c
            FROM Campaign WHERE PureCloud_Campaign_ID__c = 'teste-campaign-id' LIMIT 1];

        GenesysScheduleCallInvocable.FlowInputTO inputBlank = new GenesysScheduleCallInvocable.FlowInputTO();
        GenesysScheduleCallInvocable.FlowInputTO input = new GenesysScheduleCallInvocable.FlowInputTO();
        input.callbackNumbers = log.Address__c;
        input.callbackScheduledTime = Datetime.now() + 1;
        input.callerIdName = 'teste agendamento';
        input.conversationId = log.ReferenceId__c;
        input.participantId = 'participantAgentTeste';
        input.queueId = campanha.PureCloud_Campaign_ID__c;

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            GenesysScheduleCallInvocable.scheduleCallInvocable(new List<GenesysScheduleCallInvocable.FlowInputTO>{input});

            // Input em branco
            GenesysScheduleCallInvocable.scheduleCallInvocable(new List<GenesysScheduleCallInvocable.FlowInputTO>{inputBlank});
        Test.stopTest();
    }
}