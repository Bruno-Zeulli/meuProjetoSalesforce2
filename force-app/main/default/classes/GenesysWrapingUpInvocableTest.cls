/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GenesysWrapingUpInvocableTest {
    @TestSetup
    static void setup(){
        DispositionPath__c tabulacao = new DispositionPath__c();
        tabulacao.Name = 'Tabulacao Teste';

        insert tabulacao;

        // Crie uma configuração personalizada para o teste
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'Genesys Cloud Test make Wraping',
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
    public static void makeWrapingUpCallTest(){
        DispositionPath__c tabulacao = [SELECT Id, Name, ExternalId__c FROM DispositionPath__c WHERE Name = 'Tabulacao Teste'];

        GenesysWrapingUpInvocable.FlowInput blankInput = new GenesysWrapingUpInvocable.FlowInput();
        GenesysWrapingUpInvocable.FlowInput flowInput = new GenesysWrapingUpInvocable.FlowInput();
        flowInput.conversationId = 'conversationId';
        flowInput.participantId = 'participantId';
        flowInput.communicationId = 'communicationId';
        flowInput.description = 'description';
        flowInput.queueName = 'CONSEG: TESTE';
        flowInput.durationSeconds = '120';
        flowInput.filteredTabulation = tabulacao.Id;

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            // Standart Test
            GenesysWrapingUpInvocable.makeWrapingUpCallInvocable(new List<GenesysWrapingUpInvocable.FlowInput>{flowInput});

            // Empty Parameters
            GenesysWrapingUpInvocable.makeWrapingUpCallInvocable(new List<GenesysWrapingUpInvocable.FlowInput>{blankInput});
        Test.stopTest();
    }
}