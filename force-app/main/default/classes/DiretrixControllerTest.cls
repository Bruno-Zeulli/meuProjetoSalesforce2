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
public with sharing class DiretrixControllerTest {

    @testsetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
    }

    @isTest
    static void shouldResultGetComponyData(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDiretrix());

        Test.startTest();
        String resultDiretrix = DiretrixController.findCompanyByIndentificationNumber('60746948041307');
        Test.stopTest();

        System.assert(resultDiretrix != null, 'Test Call Diretrix');
    }
}