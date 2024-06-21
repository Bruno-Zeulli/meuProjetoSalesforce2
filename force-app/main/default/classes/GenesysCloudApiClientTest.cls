/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GenesysCloudApiClientTest {
       @TestSetup
    static void makeData(){
              // Crie uma configuração personalizada para o teste
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'Genesys Cloud Test',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials'
        );
        insert settings;
    }
    // Classe de mock para simular a chamada HTTP
    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Crie uma resposta simulada com um token de acesso
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token": "your_simulated_token"}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Método de teste para o método getAccessToken
    @isTest
    static void testGetAccessToken() {
        ExternalAPI__c settings = ExternalAPI__c.getInstance('Genesys Cloud Test');
        // Configurar o mock HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest(); // Iniciar contexto de teste

        // Chame o método getAccessToken
        GenesysCloudApiClient.saveAccessToken(settings.Name);

        Test.stopTest(); // Finalizar contexto de teste

        String savedAccessToken = [SELECT Id, AccessToken__c FROM ExternalAPI__C WHERE Name = :settings.Name].AccessToken__c;

        System.assertEquals('your_simulated_token', savedAccessToken, 'O token salvado não bate com o esperado');
    }

    // Método de teste para o método callGenesysCloudApi
    @isTest
    static void testCallGenesysCloudApi() {

        // Configurar o mock
        MockHttpResponseGenerator mock = new MockHttpResponseGenerator();
        mock.setStatusCode(200);
        mock.setBody('{"access_token": "your_simulated_token"}');
        Test.setMock(HttpCalloutMock.class, mock);

        // Chame o método callGenesysCloudApi
        Test.startTest();
        GenesysCloudApiClient.callGenesysCloudApi();
        Test.stopTest();

        // Verifique se não houve exceções durante a chamada à API
        System.assertEquals(1, Limits.getDmlStatements(), 'Houve exceções durante a chamada à API');

        // Verifique o resultado da chamada à API (se aplicável)
        // Exemplo: Verifique se os dados retornados estão corretos
        // String apiResponse = GenesysCloudApiClient.getLastApiResponse();
        // System.assertEquals('{"key": "value"}', apiResponse, 'Resposta incorreta da API');
    }
}