@isTest
public class OpportunityLineItemTriggerHandlerTest {
    @isTest
    static void testUpdateParentOpportunity(){
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

        OpportunityLineItemTriggerHandler handler = new OpportunityLineItemTriggerHandler(true);
        handler.newRecordsList = new List<OpportunityLineItem>{oppLi};

        Test.startTest();
        handler.updateParentOpportunity();
        Test.stopTest();
        List<Opportunity> opps = [SELECT Id,Product_Name__c,Product_Renewal_Start_Term__c FROM Opportunity LIMIT 1];

        Assert.areEqual(opps.get(0).Product_Name__c,product.Name);
        Assert.areEqual(opps.get(0).Product_Renewal_Start_Term__c,product.Renewal_Start_Term__c);
    }   
}