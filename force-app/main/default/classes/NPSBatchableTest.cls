/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 08-12-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class NPSBatchableTest {
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

        List<CallLog__c> callsWithoutNPS = new List<CallLog__c>();
        for(Integer index = 1; index <= 95; index++){
            CallLog__c call = new CallLog__c();
            call.NPSConsultado__c = false;
            call.ReferenceId__c = 'TESTENPS' + index;
            callsWithoutNPS.add(call);
        }
        insert callsWithoutNPS;
    }

    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"participants":[{"purpose":"agent","attributes":{}},{"purpose":"customer","attributes":{"NPS_Nota1":"1","NPS_Nota2":"0","NPS_Nota3":"3"}},{"purpose":"ivr","name":"caminhoURAExemple","attributes":{}},{"purpose":"acd","attributes":{}}],"securePause":false,"selfUri":"1"},{"purpose":"ivr","name":"Pesquisa de Satisfação Teste","attributes":{}}');
            return res;
        }
    }

    @isTest 
    public static void npsBatchableTest(){
        List<CallLog__c> callsWithoutNPS = [
            SELECT Id, ReferenceId__c, NPSConsultado__c, NPS_Nota1__c, NPS_Nota2__c, NPS_Nota3__c
            FROM CallLog__c 
            WHERE ReferenceId__c LIKE '%TESTENPS%'
            LIMIT 95
        ]; 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
            Database.executeBatch(new NPSBatchable(), 95);
        Test.stopTest();

        List<CallLog__c> callsWithNPS = [
            SELECT Id, ReferenceId__c, NPSConsultado__c, NPS_Nota1__c, NPS_Nota2__c, NPS_Nota3__c
            FROM CallLog__c 
            WHERE ReferenceId__c LIKE '%TESTENPS%' AND NPSConsultado__c = true
            LIMIT 95
        ]; 

        System.assertEquals(95, callsWithoutNPS.size(), 'Não foi consultado NPS de todos os registros');
    }
}