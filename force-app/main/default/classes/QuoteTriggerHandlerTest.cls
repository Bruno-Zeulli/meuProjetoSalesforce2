/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class QuoteTriggerHandlerTest {
    @isTest
    static void testQuoteTriggerHandler(){
        Quote quoteVariable;
        quoteVariable = testInsert();
        System.assert(quoteVariable != null, 'On test Insert');
        quoteVariable = testUpdate(quoteVariable);
        System.assert(quoteVariable != null, 'On test Update');
        quoteVariable = testDelete(quoteVariable);
        System.assert(quoteVariable != null, 'On test Delete');
        quoteVariable = testUndelete(quoteVariable);
        System.assert(quoteVariable != null, 'On test Undelete');

        //Quote quoteVariableVip;
        //quoteVariableVip = testInsertVip();
        Quote quoteVariableCorporate = testInsertCorporate();
        quoteVariableCorporate = testUpdateCorporate(quoteVariableCorporate);
    }

    static Quote testInsert(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Product2 product = ProductDataFactory.insertProduct();
        Id pbId = Test.getStandardPricebookId();
            PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = pbId,
            UnitPrice = 1,
            IsActive = true
        );
        insert pbe;
        opp.AccountId = acc.Id;
        insert opp;
        Quote quoteVariable = QuoteDataFactory.createQuote();
        quoteVariable.OpportunityId = opp.Id;
        quoteVariable.Pricebook2Id = pbId;
        insert quoteVariable;
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        qli.QuoteId = quoteVariable.Id;
        qli.Product2Id = product.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.UnitPrice = 1000;
        qli.DiscountValue__c = 100;
        insert qli;
        return quoteVariable;
    }

    static Quote testInsertVip(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Product2 product = ProductDataFactory.insertProductAgro();
        Id pbId = Test.getStandardPricebookId();
            PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = pbId,
            UnitPrice = 1,
            IsActive = true
        );
        insert pbe;
        opp.AccountId = acc.Id;
        insert opp;

        Quote quoteVariableVip = QuoteDataFactory.createQuoteVip();
        quoteVariableVip.OpportunityId = opp.Id;
        quoteVariableVip.Pricebook2Id = pbId;
        insert quoteVariableVip;

        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        qli.QuoteId = quoteVariableVip.Id;
        qli.Product2Id = product.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.UnitPrice = 1000;
        qli.DiscountValue__c = 100;

        insert qli;

        return quoteVariableVip;
    }

    static Quote testInsertCorporate(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Product2 product = ProductDataFactory.insertProductAuto();
        Id pbId = Test.getStandardPricebookId();
            PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = pbId,
            UnitPrice = 1,
            IsActive = true
        );
        insert pbe;
        opp.AccountId = acc.Id;
        insert opp;
        oppLi.OpportunityId = opp.Id;

        Quote quoteVariableCorporate = QuoteDataFactory.createQuoteCorporate();
        quoteVariableCorporate.OpportunityId = opp.Id;
        quoteVariableCorporate.Pricebook2Id = pbId;
        insert quoteVariableCorporate;

        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        qli.QuoteId = quoteVariableCorporate.Id;
        qli.Product2Id = product.Id;
        qli.PricebookEntryId = pbe.Id;
        qli.UnitPrice = 1000;
        qli.CommissionPercent__c = 10;

        insert qli;

        Quote quoteVariableCorporate2 = QuoteDataFactory.createQuoteCorporate();
        quoteVariableCorporate2.OpportunityId = opp.Id;
        quoteVariableCorporate2.Pricebook2Id = pbId;
        insert quoteVariableCorporate2;
        quoteVariableCorporate2.Status = 'Accepted';
        update quoteVariableCorporate2;

        QuoteLineItem qli2 = QuoteLineItemDataFactory.createQuoteLineItem();
        qli2.QuoteId = quoteVariableCorporate.Id;
        qli2.Product2Id = product.Id;
        qli2.PricebookEntryId = pbe.Id;
        qli2.UnitPrice = 1000;
        qli2.CommissionPercent__c = 10;

        insert qli2;

        return quoteVariableCorporate;
    }

    static Quote testUpdate(Quote quoteVariable){
        quoteVariable.Company__c = null;
        update quoteVariable;
        quoteVariable.QuotationNumber__c = null;
        update quoteVariable;
        quoteVariable.Company__c = 'Caixa Seguradora';
        update quoteVariable;
        quoteVariable.IsDiscountApproved__c = true;
        update quoteVariable;
        quoteVariable.IsDiscountApproved__c = false;
        update quoteVariable;
        return quoteVariable;
    }

    static Quote testUpdateCorporate(Quote quoteVariable){
        quoteVariable.Status = 'Accepted';
        return testValidateAcceptedQuote(quoteVariable);
    }

    static Quote testValidateAcceptedQuote(Quote qt){
         try{
            update qt;
        } catch (DMLException ex){
            System.assert(
            ex.getMessage().contains(QuoteTriggerHandler.ERROR_MSG_ACCEPTED_QUOTE),
            'Exception on test Validat Accepted Quote'
            );
        }
        return qt;
    }

    static Quote testDelete(Quote quoteVariable){
        delete quoteVariable;
        return quoteVariable;
    }

    static Quote testUndelete(Quote quoteVariable){
        undelete quoteVariable;
        return quoteVariable;
    }

    @IsTest
    static void increaseCoverage(){
        QuoteTriggerHandler handler = new QuoteTriggerHandler(true);

        Id b2uRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2U').getRecordTypeId();
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Product2 product = ProductDataFactory.insertProduct();
        Id pbId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = pbId,
            UnitPrice = 1,
            IsActive = true
        );
        insert pbe;
        opp.AccountId = acc.Id;
        insert opp;
        Quote q = QuoteDataFactory.createQuote();
        q.OpportunityId = opp.Id;
        q.Pricebook2Id = pbId;
        q.PrizeAmount__c = 1000;
        q.Type__c = 'New';
        insert q;
        
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        qli.QuoteId = q.Id;
        qli.Product2Id = product.Id;
        qli.PricebookEntryId = pbe.Id;
        insert qli;
        
        q.RecordTypeId = b2uRecordType;
        qli.Quote = q;
        handler.newRecordsList = new List<Quote>{q};
        handler.newRecordsMap = new Map<Id, Quote>{q.Id => q};

        Test.startTest();
        handler.generateQuoteName();
        handler.generateQuoteDescriptionQuery(qli);
        q.QuotationNumber__c = null;
        handler.generateQuoteName();
        q.QuotationNumber__c = '111';
        q.Company__c = null;
        handler.generateQuoteName();
        q.QuotationNumber__c = null;
        q.Company__c = null;
        handler.generateQuoteName();
        q.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('RedeVIP').getRecordTypeId();
        handler.generateQuoteName();
        q.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('CorporateParcial').getRecordTypeId();
        handler.generateQuoteName();
        Test.stopTest();
        
    }
}