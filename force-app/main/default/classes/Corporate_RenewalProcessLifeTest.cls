/**
 * @description       : Agenda quando deve ser executado a rotina que criar as oportunidades de renovação
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 29-12-2022
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   29-12-2022     Marcelo Martins     Initial Version
 **/
@isTest
public without sharing class Corporate_RenewalProcessLifeTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';
    public static String expected;
    public static String actual;

    @testSetup
    static void setup(){
        Id pricebookId = Test.getStandardPricebookId();

        Id recordTypeOrder = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateApolice').getRecordTypeId();

        Id recordTypeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CorporateComercial').getRecordTypeId();

        Account customer = AccountDataFactory.insertPersonAccount();
        Product2 product = ProductDataFactory.insertProduct();

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
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote1 = new Quote(
            OpportunityId = opp1.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote2 = new Quote(
            OpportunityId = opp2.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Accepted'
        );
        Quote quote3 = new Quote(
            OpportunityId = opp3.Id,
            QuotationNumber__c = TestDataFactory.generateRandomStringNumber(6),
            Company__c = 'Caixa Seguradora',
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
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            EndDate = Date.today().addDays(90),
            SalesDepartment__c = 'Wiz Benefícios',
            RecordTypeId = recordTypeOrder
        );
        Order order1 = new order(
            Pricebook2Id = pricebookId,
            QuoteId = quote1.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            QuotationNumber__c = quote1.QuotationNumber__c,
            PoNumber = '00007183438297530284',
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            EndDate = Date.today().addDays(90),
            SalesDepartment__c = 'Wiz Benefícios',
            RecordTypeId = recordTypeOrder
        );

        Order order2 = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote2.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote2.QuotationNumber__c,
            PoNumber = '00000000012345678910',
            Company__c = 'Caixa Seguradora',
            EndorsementNumber__c = '2',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            EndDate = Date.today().addDays(90),
            SalesDepartment__c = 'Wiz Benefícios',
            RecordTypeId = recordTypeOrder
        );
        Order order3 = new Order(
            Pricebook2Id = pricebookId,
            QuoteId = quote3.Id,
            AccountId = customer.Id,
            Name = TestDataFactory.generateRandomStringNumber(10),
            QuotationNumber__c = quote3.QuotationNumber__c,
            PoNumber = '00000000012345678912',
            Company__c = 'Caixa Seguradora',
            Type = 'New',
            Status = 'CarriedOut',
            EffectiveDate = Date.today(),
            EndDate = Date.today().addDays(90),
            SalesDepartment__c = 'Wiz Benefícios',
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

    }

    @isTest
    static void testImplementationSchedule(){
        Test.startTest();
        Corporate_RenewalProcessLifeSchedule.schedule(cronEXP);
        String jobId = System.schedule('ScheduledApexTest',cronEXP , new Corporate_RenewalProcessLifeSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testImplementationBatch(){
        Test.startTest();
        Corporate_RenewalProcessLifeBatch batch = new Corporate_RenewalProcessLifeBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        // todo ajustar test
        List<Opportunity> lOpp = [SELECT Id FROM Opportunity WHERE Type = 'Renew'];
        // System.assert(lOpp.size() > 0, 'Deve haver oportunidades de renovação para benefícios');

        // List<Case> lCase = [SELECT Id  FROM Case WHERE Opportunity__c =:lOpp[0].Id ];
        // System.assert(lCase.size() > 0, 'Deve haver casos de renovação para benefícios');
    }

}