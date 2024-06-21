@isTest
public class OpportunityLineItemTriggerTest {
    @isTest
    static void testInsertOppLineItem(){
        
        Id pbId = Test.getStandardPricebookId();
        Product2 product = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista', Renewal_Start_Term__c = 60);
        insert product;
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItem();
        
        opp.AccountId = acc.Id;
        insert opp;
        oppLi.OpportunityId = opp.Id;
        oppLi.PricebookEntryId = pbe.Id;
        insert oppLi;

        Assert.isNotNull(oppLi.Id,'On test OpportunityLineItem Insert');
    }   
}