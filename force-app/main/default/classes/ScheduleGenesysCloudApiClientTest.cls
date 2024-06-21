/**
 * @description       : Salva o token que valerá pelo dia inteiro, para evitar realizar diversas requisições sem necessidade
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 27-11-2023
 * @last modified by  : joao@beecloud.com.br
**/
@istest
public class ScheduleGenesysCloudApiClientTest{
    @TestSetup
    static void makeData(){
        ExternalAPI__c settings = new ExternalAPI__c(
            Name = 'GenesysCloudApiClientTest',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            AccessToken__c = ''
        );
        insert settings;
    }

    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"access_token":"123","token_type":"bearer","expires_in":86399}');
            return res;
        }
    }

    @isTest
    public static void ScheduleGenesysCloudApiClientTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            String cronTime = '0 0 0 3 9 ? 2042';
            String jobId = System.schedule('ScheduledGetAccessTokenEveryDay', cronTime, new ScheduleGenesysCloudApiClient());

            CronTrigger scheduledJobInformations = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
            FROM CronTrigger WHERE id = :jobId];

            System.assertEquals(cronTime, scheduledJobInformations.CronExpression, 'A Schedule não foi marcado no horário correto');

            System.assertEquals(0, scheduledJobInformations.TimesTriggered, 'A Schedule não deveria ter sido executada nenhuma vez');

            System.assertEquals('2042-09-03 00:00:00', String.valueOf(scheduledJobInformations.NextFireTime), 'A data do Schedule não é a esperada');
        Test.stopTest();
    }

    @isTest
    public static void executeReplaceAccessTokenTest(){
        ScheduleGenesysCloudApiClient scheduleInstance = new ScheduleGenesysCloudApiClient();

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            scheduleInstance.execute(null);
        Test.stopTest();

        ExternalAPI__c settings = ExternalAPI__c.getInstance('GenesysCloudApiClientTest');

        System.assertEquals('123', settings.AccessToken__c, 'O Token não foi armazenado como esperado');
        System.assertEquals('GenesysCloudApiClientTest', settings.Name, 'A ExternalAPI__C não foi instanciada corretamente');
    }
}