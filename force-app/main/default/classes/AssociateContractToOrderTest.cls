/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author                Modification
 * 1.0   06-08-2021     Marcelo Martins         Initial Version
 **/
@isTest
public with sharing class AssociateContractToOrderTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';
    // public static String CRON_EXP2 = '0 0 13 3 9 ? 2022';
    public static String expected;
    public static String actual;

    @testSetup
    static void setup(){
        Id pricebookId = Test.getStandardPricebookId();

        Id recordTypeContract = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId();

        Id recordTypeOrder = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();

        Id recordTypeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();

        Account customer = AccountDataFactory.insertPersonAccount();
        Product2 product = ProductDataFactory.insertProductAuto();

        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = product.Id, IsActive = true, UnitPrice = 1);
        insert pbEntry;

        Opportunity opp = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp
        );
        Opportunity opp1 = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp
        );
        Opportunity opp2 = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp
        );
        Opportunity opp3 = new Opportunity(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = recordTypeOpp
        );
        insert opp;
        insert opp1;
        insert opp2;
        insert opp3;

        Quote quote = new Quote(
            OpportunityId = opp.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'CAIXA Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote1 = new Quote(
            OpportunityId = opp1.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'CAIXA Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote2 = new Quote(
            OpportunityId = opp2.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'CAIXA Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote3 = new Quote(
            OpportunityId = opp3.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'CAIXA Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        insert quote;
        insert quote1;
        insert quote2;
        insert quote3;

        Order order = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote.QuotationNumber__c,
            PoNumber = '00000085956654750384',
            Company__c = ' CAIXA Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );
        Order order1 = new order(
            Pricebook2Id = pricebookId,
            QuoteId = quote1.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            QuotationNumber__c = quote1.QuotationNumber__c,
            PoNumber = '00007183438297530284',
            Company__c = 'CAIXA Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );

        Order order2 = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote2.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote2.QuotationNumber__c,
            PoNumber = '00000000012345678910',
            Company__c = 'CAIXA Seguradora',
            EndorsementNumber__c = '2',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );
        Order order3 = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote3.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote3.QuotationNumber__c,
            PoNumber = '00000000012345678912',
            Company__c = 'CAIXA Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );

        insert order;
        insert order1;
        insert order2;
        insert order3;

        OrderItem ordItem = new OrderItem(PricebookEntryId = pbEntry.Id, OrderId = order.Id, Product2Id = product.Id, Quantity = 1.00, UnitPrice = 1);
        OrderItem ordItem1 = new OrderItem(PricebookEntryId = pbEntry.Id, OrderId = order1.Id, Product2Id = product.Id, Quantity = 1.00, UnitPrice = 1);
        OrderItem ordItem2 = new OrderItem(PricebookEntryId = pbEntry.Id, OrderId = order2.Id, Product2Id = product.Id, Quantity = 1.00, UnitPrice = 1);
        OrderItem ordItem3 = new OrderItem(PricebookEntryId = pbEntry.Id, OrderId = order3.Id, Product2Id = product.Id, QuantityOfItems__c = 1.00, Quantity = 1.00, UnitPrice = 1);
        insert ordItem;
        insert ordItem1;
        insert ordItem2;
        insert ordItem3;

        Contract2__c contract = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'CAIXA Seguradora',
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
        Contract2__c contract1 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'CAIXA Seguradora',
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
            BidStatus__c = 'Cancelada',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        Contract2__c contract2 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'CAIXA Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '2',
            CertificateNumber__c = '2',
            BidNumber__c = '00000000012345678910',
            ProductCode__c = product.ProductCode,
            ProductName__c = product.Name,
            EndorsementNumber__c = '2',
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        Contract2__c contract3 = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'CAIXA Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '4',
            CertificateNumber__c = '4',
            BidNumber__c = '00000000012345678912',
            ProductCode__c = product.ProductCode,
            ProductName__c = product.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Cancelada',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );

        insert contract;
        insert contract1;
        insert contract2;
        insert contract3;
    }

    @isTest
    static void testImplementationSchedule(){
        Test.startTest();
        AssociateContractToOrderSchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new AssociateContractToOrderSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testImplementationBatch(){
        Test.startTest();
        AssociateContractToOrderBatch batch = new AssociateContractToOrderBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Order odr = [SELECT Status, Contract2__c, ReferenceId__c FROM Order WHERE PoNumber = '00000085956654750384'];
        System.debug('Valor do odr ====== ' + odr);
        Contract2__c ctt = [SELECT Id, ExternalReferenceId__c, EndorsementNumber__c FROM Contract2__c WHERE BidNumber__c = '00000085956654750384'];
        System.debug('Valor do CTT ====== ' + ctt);
        expected = 'Confirmed';
        actual = odr.Status;
        System.assertEquals(expected, actual, 'Status odr must be equals Confirmed');
        System.assertEquals(ctt.Id, odr.Contract2__c, 'Contract not associate to Order odr');

        Order odr1 = [SELECT Status, Contract2__c FROM Order WHERE PoNumber = '00007183438297530284'];
        expected = 'CarriedOut';
        actual = odr1.Status;
        System.assertEquals(expected, actual, 'Status odr1 must be equals CarriedOut');
        System.assertEquals(null, odr1.Contract2__c, 'Field Contract__c must be null');

        Order odr2 = [SELECT Status, Contract2__c FROM Order WHERE PoNumber = '00000000012345678910'];
        Contract2__c ctt2 = [SELECT Id FROM Contract2__c WHERE BidNumber__c = '00000000012345678910'];
        expected = 'Confirmed';
        actual = odr2.Status;
        System.assertEquals(expected, actual, 'Status odr2 must be equals Confirmed');
        System.assertEquals(ctt2.Id, odr2.Contract2__c, 'Contract not associate to Order odr2');

        Order odr3 = [SELECT Status, Contract2__c FROM Order WHERE PoNumber = '00000000012345678912'];
        Contract2__c ctt3 = [SELECT Id FROM Contract2__c WHERE BidNumber__c = '00000000012345678912'];
        /*     expected = 'Cancelled';
    actual = odr3.Status;
    System.assertEquals(expected, actual, 'Status odr3 must be equals Cancelled'); */
        System.assertEquals(ctt3.Id, odr3.Contract2__c, 'Contract not associate to Order odr3');
    }

    @isTest
    static void batchShouldEnterException(){
        Id recordTypeContract = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId();

        Id recordTypeOrder = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();

        Account customer = AccountDataFactory.insertPersonAccount();
        Order order = new Order(
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            PoNumber = '00000000012345678913',
            Company__c = 'CAIXA Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            RecordTypeId = recordTypeOrder
        );

        Contract2__c contract = new Contract2__c(
            Name = 'Auto',
            Account__c = customer.Id,
            Company__c = 'CAIXA Seguradora',
            StartDate__c = System.today().addYears(-1),
            EndDate__c = System.today().addDays(-3),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '4',
            CertificateNumber__c = '4',
            BidNumber__c = '00000000012345678913',
            Status__c = 'Ativo',
            ProductFamily__c = 'Auto',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = true,
            IsRenewed__c = true,
            RecordTypeId = recordTypeContract
        );
        insert order;
        insert contract;

        Test.startTest();
        AssociateContractToOrderBatch batch = new AssociateContractToOrderBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Order odr = [SELECT Status, Contract2__c FROM Order WHERE PoNumber = '00000000012345678913'];
        expected = 'CarriedOut';
        actual = odr.Status;
        System.assertEquals(expected, actual, 'Status odr1 must be equals CarriedOut');
        System.assertEquals(null, odr.Contract2__c, 'Field Contract__c must be null');
    }
}