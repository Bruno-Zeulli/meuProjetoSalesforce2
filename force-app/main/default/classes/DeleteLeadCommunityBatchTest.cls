/**
 * @description       :
 * @author            : pedrotofani@wiz.co
 * @group             :
 * @last modified on  : 30-09-2023
 * @last modified by  : pedrotofani@wiz.co
**/
@isTest
public class DeleteLeadCommunityBatchTest {
    @isTest
    static void testBatchExecution() {
         Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProduct();
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;

        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Quote qt = QuoteDataFactory.createQuoteCorporate();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        Contract2__c cont = ContractDataFactory.insertContractCorporate(acc.Id, product);

        opp.AccountId = acc.Id;
        opp.toDelete__c = true;
        insert opp;
        oppLi.OpportunityId = opp.Id;
        oppLi.PricebookEntryId = pbe.Id;
        insert oppLi;
        qt.OpportunityId = opp.Id;
        insert qt;
        qli.QuoteId = qt.Id;
        qli.PricebookEntryId = pbe.Id;
        insert qli;
        ord.AccountId = acc.Id;
        ord.Status = 'Pronto para Confirmar';
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.Contract2__c = cont.Id;
        ord.PoNumber = cont.ContractNumber__c;
        insert ord;
        // Crie alguns registros de teste Order com Status 'Pronto para Confirmar'
        // 
        Lead l = new Lead();
        l.FirstName = 'TESTE';
        l.LastName = 'TESTE';
        l.ToDelete__c = true;
        insert l;
        List<Lead> testLead= new List<Lead>();
        testLead.add(l);
        // for (Integer i = 0; i < 5; i++) {
        //     Order o = new Order(Status = 'Pronto para Confirmar');
        //     testOrders.add(o);
        // }
        // insert testOrders;

        // Inicie o batch manualmente
        DeleteLeadCommunityBatch batch = new DeleteLeadCommunityBatch();
        Database.BatchableContext bc;
        batch.start(bc);

        // Execute o batch manualmente
        batch.execute(bc, testLead);

    }
}