/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             : Wiz Solucoes
 * @last modified on  : 07-25-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   07-25-2022   marcelomartins@wizsolucoes.com.br     Initial Version
 **/
@isTest
public with sharing class IntegrationAPIDiretrixTest {
   @testSetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
    }

   
    @isTest
    public static void callIntegrationAPIDiretrixSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDiretrix());
        Test.startTest();
        
        Map<String, Object> results = IntegrationAPIDiretrix.getInstance().getCompanyByIndentificationNumber('test');
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }
}