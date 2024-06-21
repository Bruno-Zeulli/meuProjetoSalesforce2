/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class OpportunityBOTest {
    @testSetup
    static void setup(){
        Opportunity objOpportunity = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpportunity.StageName = 'Cotação';
        insert objOpportunity;
    }

    @isTest
    static void shouldResultUpdateStatus(){
        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id, StageName, Name, OwnerId, OpportunityNumber__c FROM Opportunity];
        OpportunityBO.getInstance().sendNofiticationHasQuotes(lstOpportunity);
        Test.stopTest();

        Opportunity objopp = [SELECT Id, StageName FROM Opportunity WHERE Id = :lstOpportunity[0].Id];
        String expected = 'Construção da proposta';
        String actual = objopp.StageName;
        System.assertEquals(expected, actual, 'StageName not checking with expecteg');
    }
}