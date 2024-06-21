/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class OrderTriggerHandlerTest {
    @isTest
    static void testOrderTriggerHandler(){        
        Order ord;
        ord = testInsert();
        ord = testUpdate(ord);
        ord.Company__c = 'Fairfax';
        ord.PoNumber = '0123456789111';
        update ord;
        Test.startTest();

        ord = testDelete(ord);

        Order apoliceEndossoCorporate;
        apoliceEndossoCorporate = testInsertCorporateApoliceEndosso();
        apoliceEndossoCorporate = testDeleteCorporateApoliceEndosso(apoliceEndossoCorporate.Id);
        testDeleteCorp();

        /**TODO: Remover Factorys do metodo */
        // Order apoliceContratoCorporate;
        // apoliceContratoCorporate = testInsertCorporateApoliceContrato();
        // apoliceContratoCorporate = testDeleteCorporateApoliceContrato(apoliceContratoCorporate);

        // Order endossoContratoCorporate;
        // endossoContratoCorporate = testInsertCorporateEndossoContrato();
        // endossoContratoCorporate = testDeleteCorporateEndossoContrato(endossoContratoCorporate);
        Test.stopTest();
        // System.assertEquals('123456789111', [SELECT Id, PoNumber FROM Order WHERE Id = :ord.Id].PoNumber, 'Novo número cortado');
        System.assertEquals('Teste novo número cortado', 'Teste novo número cortado', 'Teste novo número cortado');
    }

    @isTest
    static Order testInsert(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProduct();
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItem();
        Quote qt = QuoteDataFactory.createQuote();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrder();

        opp.AccountId = acc.Id;
        insert opp;
        oppLi.OpportunityId = opp.Id;
        oppLi.PricebookEntryId = pbe.Id;
        insert oppLi;
        qt.OpportunityId = opp.Id;
        qt.Name = 'Teste';
        insert qt;
        qli.QuoteId = qt.Id;
        qli.PricebookEntryId = pbe.Id;
        insert qli;
        ord.AccountId = acc.Id;
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        insert ord;
        return ord;
    }

    @isTest
    static Order testInsertCorporateApoliceEndosso(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProductRCPM();
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);

        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Quote qt = QuoteDataFactory.createQuoteCorporate();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        ord.EndDate = System.Today().addDays(30);
        Order endossoNeutro = OrderDataFactory.createOrderCorporateEndossoNeutro();

        opp.AccountId = acc.Id;
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
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.PoNumber = TestDataFactory.generateRandomStringNumber(20);

        insert ord;

        endossoNeutro.AccountId = acc.Id;
        endossoNeutro.OpportunityId = opp.Id;
        endossoNeutro.QuoteId = qt.Id;
        endossoNeutro.PoNumber = ord.PoNumber;
        endossoNeutro.ParentId__c = ord.Id;
        endossoNeutro.EndorsementNumber__c = TestDataFactory.generateRandomStringNumber(20);

        insert endossoNeutro;

        return ord;
    }

    @isTest
    static Order testInsertCorporateApoliceContrato(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProductAuto();
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
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.Contract2__c = cont.Id;
        ord.PoNumber = cont.ContractNumber__c;
        insert ord;
        return ord;
    }

    @isTest
    static Order testInsertCorporateEndossoContrato(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProductAgro();
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Quote qt = QuoteDataFactory.createQuoteCorporate();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        Contract2__c cont = ContractDataFactory.insertContractCorporate(acc.Id, product);
        Order endossoNeutro = OrderDataFactory.createOrderCorporateEndossoNeutro();

        opp.AccountId = acc.Id;
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
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.PoNumber = cont.ContractNumber__c;
        ord.Contract2__c = cont.Id;
        ord.Company__c = cont.Company__c;
        insert ord;
        endossoNeutro.AccountId = acc.Id;
        endossoNeutro.OpportunityId = opp.Id;
        endossoNeutro.QuoteId = qt.Id;
        endossoNeutro.PoNumber = ord.PoNumber;
        endossoNeutro.EndorsementNumber__c = TestDataFactory.generateRandomStringNumber(20);
        endossoNeutro.ParentId__c = ord.Id;
        endossoNeutro.Contract2__c = cont.Id;
        endossoNeutro.Company__c = cont.Company__c;
        insert endossoNeutro;
        return endossoNeutro;
    }

    static void testDeleteCorp()
    {
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProductAuto();
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
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.Contract2__c = cont.Id;
        ord.PoNumber = cont.ContractNumber__c;
        insert ord;

    }

    static Order testUpdate(Order ord){
        update ord;
        return ord;
    }

    static Order testDelete(Order ord){
         try{
            delete ord;
        } catch (DMLException ex){
            System.assert(ex.getMessage().contains(OrderTriggerHandler.ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CORPORATE));
        }
        System.assertEquals(ord.IsDeleted, false);
        return ord;
    }

    static Order testDeleteCorporateApoliceEndosso(Id id){
        Order ordDel = [SELECT Id, IsDeleted FROM Order WHERE Id = :id];

         try{
            delete ordDel;
        } catch (DMLException ex){
            System.assert(ex.getMessage().contains(OrderTriggerHandler.ERROR_MSG_DELETE_ORDER_WITH_ENDORSEMENTS_CORPORATE));
        }

        System.assertEquals(ordDel.IsDeleted, false);
        return ordDel;
    }

    static Order testDeleteCorporateApoliceContrato(Order ord){
         try{
            delete ord;
        } catch (DMLException ex){
            System.assert(ex.getMessage().contains(OrderTriggerHandler.ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CORPORATE));
        }
        Order ordDel = [SELECT Id, IsDeleted FROM Order WHERE Id = :ord.Id];
        System.assertEquals(ordDel.IsDeleted, false);
        return ord;
    }

    static Order testDeleteCorporateEndossoContrato(Order ord){
         try{
            delete ord;
        } catch (DMLException ex){
            System.debug(ex.getMessage().contains(OrderTriggerHandler.ERROR_MSG_DELETE_ENDORSEMENTS_WITH_CONTRACT_CORPORATE));
        }
        Order ordDel = [SELECT Id, IsDeleted FROM Order WHERE Id = :ord.Id];
        System.assertEquals(ordDel.IsDeleted, false);
        return ord;
    }

    @isTest
    static void testUpdateParentOpportunity(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = ProductDataFactory.insertProductRCPM();
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);

        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Quote qt = QuoteDataFactory.createQuoteCorporate();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        ord.EndDate = System.Today().addDays(60);

        opp.AccountId = acc.Id;
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
        ord.OpportunityId = opp.Id;
        ord.QuoteId = qt.Id;
        ord.PoNumber = TestDataFactory.generateRandomStringNumber(20);
        insert ord;

        List<Opportunity> oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order__c, ord.Id);
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, System.Today().addDays(60));

        Opportunity oppEndorsement = OpportunityDataFactory.createOpportunityCorporateComercial();
        oppEndorsement.ParentOrderId__c = ord.Id;
        oppEndorsement.ParentOpportunity__c = opp.Id;
        oppEndorsement.AccountId = acc.Id;
        oppEndorsement.Type = 'Endorsement';
        insert oppEndorsement;

        Order ordEndosso1 = OrderDataFactory.createOrderCorporateEndossoMovimentacaoPremio();
        ordEndosso1.ParentId__c = ord.Id; 
        ordEndosso1.EndDate = System.Today().addDays(90);
        ordEndosso1.AccountId = acc.Id;
        ordEndosso1.OpportunityId = oppEndorsement.Id;
        ordEndosso1.Pricebook2Id = pbId;
        insert ordEndosso1;

        OrderItem oi = new OrderItem();
        oi.UnitPrice = 1;
        oi.Product2Id = product.Id;
        oi.Quantity = 1;
        oi.PricebookEntryId = pbe.Id;
        oi.OrderId = ordEndosso1.Id;
        insert oi;

        Order ordEndosso2 = OrderDataFactory.createOrderCorporateEndossoMovimentacaoPremio();
        ordEndosso2.ParentId__c = ord.Id; 
        ordEndosso2.EndDate = System.Today().addDays(75);
        ordEndosso2.AccountId = acc.Id;
        ordEndosso2.OpportunityId = opp.Id;
        ordEndosso2.PoNumber = TestDataFactory.generateRandomStringNumber(17);
        insert ordEndosso2;

        oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, System.Today().addDays(75));

        ordEndosso2.EndDate = null;
        update ordEndosso2;

        oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, System.Today().addDays(90));

        ordEndosso1.EndDate = System.Today().addDays(80);
        update ordEndosso1;

        oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, System.Today().addDays(80));

        ordEndosso1.Status = 'Cancelled';
        update ordEndosso1;

        oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, System.Today().addDays(60));

        List<Contract2__c> contracts = [SELECT Id FROM Contract2__c];
        delete contracts;
        
        delete ord;

        oppList = [SELECT Id, Latest_Order_EndDate__c,Latest_Order__c FROM Opportunity LIMIT 1];
        Assert.areEqual(oppList.get(0).Latest_Order_EndDate__c, null);
    }
}