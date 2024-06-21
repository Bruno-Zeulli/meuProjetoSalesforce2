/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class QuoteDAOTest {
    @testSetup
    static void setup() {

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunity();
        insert objOpportunity;
        Quote objQuote1 = QuoteDataFactory.createQuoteCorporate();
        objQuote1.OpportunityId =  objOpportunity.Id;
        Quote objQuote2 = QuoteDataFactory.createQuote();
        objQuote2.OpportunityId =  objOpportunity.Id;
        insert objQuote1;
        insert objQuote2;
    }

    @isTest
    static void shouldReturnAllQuote(){

        String whereCondition = '';
		Opportunity objOpportunity = OpportunityDataFactory.createOpportunity();
        insert objOpportunity;
        Quote objQuote1 = QuoteDataFactory.createQuoteCorporate();
        objQuote1.OpportunityId =  objOpportunity.Id;
        Quote objQuote2 = QuoteDataFactory.createQuote();
        objQuote2.OpportunityId =  objOpportunity.Id;
        insert objQuote1;
        insert objQuote2;

        QuoteDAO qd = new QuoteDAO();

        Test.startTest();
        List<Quote> lstQuoteActual = QuoteDAO.getInstance().getAllFields(whereCondition);
		QuoteDAO.getQuoteByOppId(objOpportunity.Id);
        QuoteDAO.getQuoteById(objQuote1.Id);
        List<Quote> lstQuoteExpected = [SELECT Id FROM Quote];
        Set<Id> lOpportunityIds = new Set<Id> ();
        lOpportunityIds.add(objOpportunity.Id);
        List<Quote> lstQuoteActual4 = qd.getQuoteByOpportunityId(lOpportunityIds);
        QuoteDAO.getQuotesByOppId(objOpportunity.Id);


        Test.stopTest();


        Integer expected = lstQuoteExpected.size();
        Integer actual = lstQuoteActual.size();
        //System.assertEquals(expected, actual, 'Expected return list with size 2 position');
    }

    @isTest
    static void shouldReturnSpecificQuote() {
        String quotationNumber = '463716487146187346';
        String whereCondition = 'WHERE QuotationNumber__c = \'' + quotationNumber + '\'';

        Test.startTest();
        List<Quote> lstQuoteActual = QuoteDAO.getInstance().getAllFields(whereCondition);
        List<Quote> lstQuoteExpected = [SELECT Id FROM Quote WHERE QuotationNumber__c = :quotationNumber];
        Test.stopTest();

        String expected = lstQuoteExpected[0].Id;
        String actual = lstQuoteActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

    @isTest
    static void shouldReturnSpecificQuoteFromMap() {
        String quotationNumber = '463716487146187346';
        String whereCondition = 'WHERE QuotationNumber__c = \'' + quotationNumber + '\'';
        //

        Test.startTest();
        Map<String, Object> mapQuoteActual = QuoteDAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        List<Quote> lstQuoteExpected = [SELECT Id FROM Quote WHERE QuotationNumber__c = :quotationNumber];
        Test.stopTest();

        String expected = lstQuoteExpected[0].Id;
        Quote objQuoteActual = (Quote) mapQuoteActual.get(lstQuoteExpected[0].Id);
        String actual = objQuoteActual.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }
}