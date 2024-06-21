/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GetStatusIdTest {
    @TestSetup
    static void makeData(){
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'GetStatusTest',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            UserStatusAvailable__c = 'availableId',
            UserStatusOnQueue__c = 'onQueueId',
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
            if(req.getEndpoint() == 'https://api.sae1.pure.cloud/api/v2/users/userWithStatusMeal/presences/purecloud'){
                res.setBody('{"source":"PURECLOUD", "presenceDefinition":{"id":"mealId","systemPresence":"Meal","selfUri":"selfUri"}}');
            }else if(req.getEndpoint() == 'https://api.sae1.pure.cloud/api/v2/users/userWithoutStatusMeal/presences/purecloud'){
                res.setBody('{"source":"PURECLOUD", "presenceDefinition":{"id":"BusyId","systemPresence":"Busy","selfUri":"selfUri"}}');
            }
            return res;
        }
    }

    @isTest static void getStatusIdTest(){
        Test.startTest();
            String availableId = GetStatusId.getStatusId('Atendimento');
            System.assertEquals('availableId', availableId, 'O status não corresponde com o Id do status Atendimento esperado');

            String onQueueId = GetStatusId.getStatusId('Onqueue');
            System.assertEquals('onQueueId', onQueueId, 'O status não corresponde com o Id do status Onqueue esperado');

            String voidId = GetStatusId.getStatusId('');
            System.assertEquals('', voidId, 'O status deveria ser vazio');
        Test.stopTest();
    }

    @isTest static void checkUserStatusTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            Boolean userWithMealStatus = GetStatusId.checkUserStatus('userWithStatusMeal');
            System.assertEquals(false, userWithMealStatus);

            Boolean userWithoutStatusMeal = GetStatusId.checkUserStatus('userWithoutStatusMeal');
            System.assertEquals(true, userWithoutStatusMeal);

            Boolean blankInput = GetStatusId.checkUserStatus('');
            System.assertEquals(false, blankInput);
        Test.stopTest();
    }
}