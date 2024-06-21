/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GetUserIdTest {
    @TestSetup
    static void makeData(){
        // Crie uma configuração personalizada para o teste
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'GenesysCloudGetUserId',
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
            res.setStatusCode(200);
            res.setBody('{"id":"conversationId","participants":[{"userId":"userId","id":"participantId","purpose":"agent","calls":[{"id": "communicationId"}]}]}');
            return res;
        }
    }

    @isTest
    public static void getIdsInvocableTest(){
        String conversationId = 'conversationId';

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            // Teste da execução default
            String userId = GetUserId.getUserId(conversationId);
            System.assertEquals('userId', userId);

            // Testar enviar sem nenhum parametro
            String blankOutput = GetUserId.getUserId('');
            System.assertEquals('', blankOutput);
        Test.stopTest();
    }
}