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
public class QuoteBOTest {
    
    @testSetup
    static void setup(){

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunityCorporateComercial();
        insert objOpportunity;

        Quote objQuoteAccepted = QuoteDataFactory.createQuoteCorporate();
        objQuoteAccepted.OpportunityId = objOpportunity.Id;
        objQuoteAccepted.QuotationNumber__c = '101010';
        objQuoteAccepted.Status = 'Accepted';
        insert objQuoteAccepted;

        Quote objQuoteDenied = QuoteDataFactory.createQuoteCorporate();
        objQuoteDenied.OpportunityId = objOpportunity.Id;
        insert objQuoteDenied;

    }

    @isTest
    static void shouldResultUpdateStatus(){

        Test.startTest();
        List<Quote> lstQuoteDraft = [SELECT Id FROM Quote WHERE Status = 'Draft' Limit 1]; 
        List<Opportunity> lstOpportunity = [SELECT Id FROM Opportunity Limit 1];
        List<Quote> lstQuote = [SELECT Id FROM Quote WHERE Status = 'Accepted' Limit 1];
        QuoteBO.getInstance().updateRemainingQuotes(lstOpportunity[0].Id, lstQuote[0].Id);          
        Test.stopTest();

        Quote quote = [SELECT Id, status FROM Quote WHERE Id=: lstQuoteDraft[0].Id];
        String expected = 'Denied';
        String actual = quote.Status;
        System.assertEquals(expected, actual, 'Status not checking with expecteg');
    }
}