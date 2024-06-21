/**
* @description       :
* @author            : brunosousa.mirante@wizsolucoes.com.br
* @group             :
* @last modified on  : 20-12-2021
* @last modified by  : Bruno Pereira
* Modifications Log
* Ver   Date           Author                Modification
* 1.0   20-12-2021     Bruno Pereira         Initial Version
**/
@isTest
public with sharing class AssociatePricebookProductToContractTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';
    // public static String CRON_EXP2 = '0 0 13 3 9 ? 2022';
    public static String expected;
    public static String actual;

    @testSetup
    static void setup(){

        String pricebookId = '01s1U000008Gj7QQAS';

        Id recordTypeContract = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
            .get('Insurance')
            .getRecordTypeId();

        Id recordTypeOrder = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
            .get('Conseg')
            .getRecordTypeId();

        Id recordTypeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
            .get('Conseg')
            .getRecordTypeId();

        Account customer = AccountDataFactory.insertPersonAccount();
        Product2 product = ProductDataFactory.insertProductAuto();

        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            IsActive = true,
            UnitPrice = 1
        );
        insert pbEntry;

        List<Opportunity> iOpportunityList = new List<Opportunity>();

        Opportunity opp = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp,
            Pricebook2Id = '01s1U000008Gj7QQAS'
        );
        iOpportunityList.add(opp);

        Opportunity opp1 = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp,
            Pricebook2Id = '01s1U000008Gj7QQAS'
        );
        iOpportunityList.add(opp1);

        Opportunity opp2 = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp,
            Pricebook2Id = '01s1U000008Gj7QQAS'
        );
        iOpportunityList.add(opp2);

        insert iOpportunityList;

        List<Quote> iQuoteList = new List<Quote>();

        Quote quote = new Quote(
            OpportunityId = opp.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        iQuoteList.add(quote);

        Quote quote1 = new Quote(
            OpportunityId = opp1.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        iQuoteList.add(quote1);

        Quote quote2 = new Quote(
            OpportunityId = opp2.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        iQuoteList.add(quote2);

        insert iQuoteList;

        List<Order> iOrderList = new List<Order>();

        Order order = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote.QuotationNumber__c,
            PoNumber = '00000085956654750384',
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );
        iOrderList.add(order);

        Order order1 = new order(
            Pricebook2Id = pricebookId,
            QuoteId = quote1.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            QuotationNumber__c = quote1.QuotationNumber__c,
            PoNumber = '09557295869239568604',
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );
        iOrderList.add(order1);

        Order order2 = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote2.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote2.QuotationNumber__c,
            PoNumber = '00000000012345678912',
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );
        iOrderList.add(order2);

        insert iOrderList;

        List<OrderItem> iOrderItemList = new List<OrderItem>();

        OrderItem ordItem = new OrderItem(
            PricebookEntryId = pbEntry.Id,
            OrderId = order.Id,
            Product2Id = product.Id,
            Quantity = 1.00,
            UnitPrice = 1
        );
        iOrderItemList.add(ordItem);

        OrderItem ordItem1 = new OrderItem(
            PricebookEntryId = pbEntry.Id,
            OrderId = order1.Id,
            Product2Id = product.Id,
            Quantity = 1.00,
            UnitPrice = 1
        );
        iOrderItemList.add(ordItem1);

        OrderItem ordItem2 = new OrderItem(
            PricebookEntryId = pbEntry.Id,
            OrderId = order2.Id,
            Product2Id = product.Id,
            Quantity = 1.00,
            UnitPrice = 1
        );
        iOrderItemList.add(ordItem2);

        insert iOrderItemList;

        List<Contract2__c> iContract2List = new List<Contract2__c>();
        Contract2__c contract = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'Caixa Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '1',
            CertificateNumber__c = '1',
            BidNumber__c = '00000085956654750384',
            ProductCode__c = product.ProductCode,
            ProductName__c = product.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        iContract2List.add(contract);

        Contract2__c contract1 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'Caixa Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '3',
            CertificateNumber__c = '3',
            BidNumber__c = '09557295869239568604',
            ProductCode__c = product.ProductCode,
            ProductName__c = product.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        iContract2List.add(contract1);

        Contract2__c contract2 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'Caixa Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '2',
            CertificateNumber__c = '2',
            BidNumber__c = '00000000012345678912',
            ProductCode__c = product.ProductCode,
            ProductName__c = product.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        iContract2List.add(contract2);

        insert iContract2List;
    }


    @isTest
    static void testImplementationSchedule(){

        Test.startTest();
        AssociatePBProductToContractSchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new AssociatePBProductToContractSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals(
            '2030-09-03 05:00:00',
            String.valueOf(ct.NextFireTime),
            'NextFireTime of Scheduling other than 2030-09-03 05:00:00'
        );
    }

    @isTest
    static void testImplementationBatchSuccess(){

        Test.startTest();
        AssociateContractToOrderBatch batch = new AssociateContractToOrderBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Contract2__c ctt = [SELECT Id, ExternalReferenceId__c, EndorsementNumber__c, Product2__c, PriceBookEntryId__c FROM Contract2__c WHERE BidNumber__c = '00000085956654750384'];
        Contract2__c ctt2 = [SELECT Id, ExternalReferenceId__c, EndorsementNumber__c, Product2__c, PriceBookEntryId__c FROM Contract2__c WHERE BidNumber__c = '09557295869239568604'];
        Contract2__c ctt3 = [SELECT Id, ExternalReferenceId__c, EndorsementNumber__c, Product2__c, PriceBookEntryId__c FROM Contract2__c WHERE BidNumber__c = '00000000012345678912'];
        System.debug('Valor do CTT ====== ' + ctt);
        System.debug('Valor do CTT2 ====== ' + ctt2);
        System.debug('Valor do CTT3 ====== ' + ctt3);
        System.assertNotEquals(null, ctt.Product2__c, 'Ctt - Product must has a value associate');
        System.assertNotEquals(null, ctt.PriceBookEntryId__c, 'Ctt - PricebookEntry must has a value associate');

        System.assertNotEquals(null, ctt2.Product2__c, 'Ctt2 - Product must has a value associate');
        System.assertNotEquals(null, ctt2.PriceBookEntryId__c, 'Ctt2 - PricebookEntry must has a value associate');

        System.assertNotEquals(null, ctt3.Product2__c, 'Ctt3 - Product must has a value associate');
        System.assertNotEquals(null, ctt3.PriceBookEntryId__c, 'Ctt3 - PricebookEntry must has a value associate');
    }

}