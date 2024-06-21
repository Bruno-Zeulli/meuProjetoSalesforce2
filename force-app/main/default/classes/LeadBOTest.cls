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
public with sharing class LeadBOTest {
    
    @TestSetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
    }

    @isTest
    static void shouldUptLeadWithDiretrixData(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDiretrix());
        Set<Id> setLeadId = new Set<Id>();
        Lead objLeadCompany = getLeadCompany();
        insert objLeadCompany;
        setLeadId.add(objLeadCompany.Id);

        Test.startTest();
        LeadBO.updateLeadDataThroughDiretrix(setLeadId);
        Test.stopTest();

        List<Lead> lstLead = [SELECT Id, Company, AnnualRevenue  FROM Lead WHERE Id IN :setLeadId LIMIT 1];
        String expectedName = 'DIRETRIX.ON INTELIGENCIA DA INFORMACAO LTDA';
        String actualName = lstLead[0].Company;
        Decimal expectedAnnualRevenue = 160000.00;
        Decimal actualAnnualRevenue = lstLead[0].AnnualRevenue;

        System.assertEquals(expectedName, actualName, 'Name company not updated');
        System.assertEquals(expectedAnnualRevenue, actualAnnualRevenue, 'AnnualRevenue not updated');

    }

    static Lead getLeadCompany(){

        Lead objLead = new Lead();        
        objLead.Company = 'Teste';
        objLead.IdentificationNumber__c = '14539125000107';
        objLead.LeadSource = 'Wiz';
        objLead.LastName = 'Teste';
        objLead.email = 'test@test.com';

        return objLead;
    }
    
}