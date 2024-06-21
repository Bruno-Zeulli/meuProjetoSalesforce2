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
 public with sharing class DiretrixServiceTest {
    @testsetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
    }

    @isTest
    static void shouldResultGetCompanyData(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDiretrix());

        Test.startTest();
        DiretrixTO.DiretrixResponseFindByIndentificationNumber resultDiretrix = DiretrixService.getInstance().findCompanyByIndentificationNumber('60746948041307');
        Test.stopTest();
        Boolean expectedStatus = true;
        Boolean actualStatus = resultDiretrix.sucesso;
        String expected = '14539125000107';
        String actual = resultDiretrix.consulta.dadosGerais[0].CNPJ;

        System.assertEquals(expectedStatus, expectedStatus, 'result sucesso should true');
        System.assertEquals(expected, actual, 'Indentification Number not check');
    }
    
}