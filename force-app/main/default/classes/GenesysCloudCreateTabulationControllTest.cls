/**
 * @description       :
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GenesysCloudCreateTabulationControllTest {
    @TestSetup
    static void makeData(){
        // Crie uma configuração personalizada para o teste
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'Genesys Cloud Test Tabulation',
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
            res.setBody('{"id":"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX","name":"beeTest4","dateCreated":"2023-10-16T16:49:18.098Z","createdBy":"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX","selfUri":"/api/v2/routing/wrapupcodes/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"}');
            return res;
        }
    }

    @isTest
    static void createTabulationTest() {
        ExternalAPI__c settings = ExternalAPI__c.getInstance('Genesys Cloud Test Tabulation');
        // Configurar o mock HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest(); // Iniciar contexto de teste

        // Chame o método createTabulation('name')
        Map<String, String> returnMap = GenesysCloudCreateTabulationController.createTabulation('beeTest4');
        Map<String, String> returnBlankMap = GenesysCloudCreateTabulationController.createTabulation('');
        
        // Verifique se o Map não está vazio
        System.assertEquals(false, returnMap.isEmpty(), 'A classe não retornou a tabulação');

        // Verificando todos dados se estão corretos
        System.assertEquals('XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', returnMap.get('id'), 'id retornado bate com esperado');
        System.assertEquals('beeTest4', returnMap.get('name'), 'name retornado bate com esperado');
        System.assertEquals('2023-10-16T16:49:18.098Z', returnMap.get('dateCreated'), 'dateCreated retornado bate com esperado');
        System.assertEquals('XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', returnMap.get('createdBy'), 'createdBy retornado bate com esperado');
        System.assertEquals('/api/v2/routing/wrapupcodes/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', returnMap.get('selfUri'), 'selfUri retornado bate com esperado');

        Test.stopTest(); // Finalizar contexto de teste
    }
}