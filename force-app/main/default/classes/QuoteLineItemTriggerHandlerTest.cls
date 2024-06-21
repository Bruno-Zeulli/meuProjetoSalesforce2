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
public class QuoteLineItemTriggerHandlerTest {
  @isTest
  static void testQuoteLineItemTriggerHandler(){
    QuoteLineItem qli;
    qli = testInsert();
    System.assert(qli != null, 'On test Insert');
    qli = testUpdate(qli);
    System.assert(qli != null, 'On test Update');
    qli = testDelete(qli);
    System.assert(qli != null, 'On test Delete');
    qli = testUndelete(qli);
    System.assert(qli != null, 'On test Undelete');
  }

  static QuoteLineItem testInsert(){
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
    insert q;
    QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
    qli.QuoteId = q.Id;
    qli.Product2Id = product.Id;
    qli.PricebookEntryId = pbe.Id;
    insert qli;
    return qli;
  }

  static QuoteLineItem testUpdate(QuoteLineItem qli){
    update qli;
    return qli;
  }

  static QuoteLineItem testDelete(QuoteLineItem qli){
    delete qli;
    return qli;
  }

  static QuoteLineItem testUndelete(QuoteLineItem qli){
    undelete qli;
    return qli;
  }
}