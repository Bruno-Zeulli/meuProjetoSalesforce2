/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-04-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public with sharing class OpportunityDAOTest {
    @testSetup
    static void setup(){

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunityCorporateComercial();
        insert objOpportunity;
    }

    @isTest
    static void shouldReturnAllOpportunity(){
        String whereCondition = '';

        Test.startTest();
        List<Opportunity> lstOpportunityActual = OpportunityDAO.getInstance().getAllFields(whereCondition);
        Test.stopTest();
        Integer expected = 1;
        Integer actual = lstOpportunityActual.size();
        System.assertEquals(expected, actual, 'Expected return list with size 1 position');
    }

    @isTest
    static void shouldReturnSpecificOpportunity(){

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id FROM Opportunity];
        String oppId = lstOpportunity[0].Id;
        List<Opportunity> lstOpportunityActual = OpportunityDAO.getInstance().getAllFieldsById(oppId);
        List<Opportunity> lstOpportunityExpected = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        Test.stopTest();

        String expected = lstOpportunityExpected[0].Id;
        String actual = lstOpportunityActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

    @isTest
    static void shouldReturnSpecificOpportunityFromMap(){

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id FROM Opportunity];
        String oppId = lstOpportunity[0].Id;
        String whereCondition = 'WHERE Id = \'' + oppId + '\'';
        Map<String, Object> mapOpportunityActual = OpportunityDAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        Opportunity objOpportunity = (Opportunity) mapOpportunityActual.get(oppId);
        List<Opportunity> lstOpportunityExpected = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        Test.stopTest();

        String expected = lstOpportunityExpected[0].Id;
        String actual = objOpportunity.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

}