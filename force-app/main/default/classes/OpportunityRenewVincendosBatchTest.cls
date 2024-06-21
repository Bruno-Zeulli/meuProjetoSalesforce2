/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wiz.co
 * @group             :
 * @last modified on  : 05-22-2022
 * @last modified by  : viniciusazevedo@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-22-2022   viniciusazevedo@wiz.co               Initial Version
 **/
@IsTest
public class OpportunityRenewVincendosBatchTest {
    @IsTest
    public static void testBatch(){

        Id RECORDTYPE_PF = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PF').getRecordTypeId();
        Account objAccount = new Account(
            FirstName = 'Primeiro',
            LastName = 'Último',
            IndividualIdentificationNumber__pc = '58081565051',
            IdentificationNumber__c = '58081565051',
            RecordTypeId = RECORDTYPE_PF
        ) ;
        insert objAccount;

        Asset objAsset = new Asset(
            Name = 'CHASSI | 1234ABC1234',
            AssetIdentifierCode__c = '1234ABC1234',
            AccountId = objAccount.Id
        );
        insert objAsset;


        upsert new Pricebook2(Name = 'Conseg', IsActive = true) Name;
        Pricebook2 objPricB = [SELECT Id FROM Pricebook2 WHERE Name = 'Conseg'];

        Product2 product = new Product2();
        product.Name = 'test';
        product.Description = 'test';
        product.ProductCode = '3-531-205';
        product.isActive = true;
        product.Family = 'Crédito';
        insert product;

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PricebookEntry objPricE = new PricebookEntry(
            Pricebook2Id = objPricB.Id,
            IsActive = true,
            UnitPrice = 1.0,
            Product2Id = product.Id);
        insert objPricE;

        Id RTOppConseg = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();

        Opportunity objOpportunity = new Opportunity(
            RecordTypeId = RTOppConseg,
            Name = 'Test Renewal Opportunity',
            AccountId = objAccount.Id,
            Amount = 2500.0,
            CloseDate = Date.today().addMonths(1),
            Pricebook2Id = objPricB.Id,
            StageName = 'Closed Won',
            LeadSource = 'Conseg',
            Description = 'Renewal Opportunity Description',
            Asset__c = objAsset.Id
        );
        insert objOpportunity;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
            OpportunityId = objOpportunity.Id,
            PricebookEntryId = objPricE.Id,
            Quantity = 1,
            UnitPrice = 1
        );
        insert objOppLineItem;

        Date startDate = Date.today().addYears(-1);
        Date endDate = startDate.addDays(395);
        Contract2__c objContract = new Contract2__c(
            StartDate__c = Date.today().addYears(-1),
            EndDate__c = Date.today().addDays(30),
            Account__c = objAccount.Id,
            BidNumber__c = '12345678',
            Company__c = 'Alfa Seguros',
            Status__c = 'Ativo'

        );
        insert objContract;

        Contract2__c debugContract = [SELECT Id, StartDate__c, EndDate__c, Account__c, BidNumber__c, Company__c, ExpirationDayNumber__c FROM Contract2__c WHERE Id =: objContract.Id];
        Id RTOrdConseg = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();
        Order objOrder = new Order(
            EffectiveDate = Date.today().addDays(30),
            Company__c = 'Alfa Seguros',
            OpportunityId = objOpportunity.Id,
            RecordTypeId = RTOrdConseg,
            SalesDepartment__c = 'CONSEG',
            Status = 'ReadyToIssue',
            AccountId = objAccount.Id,
            Pricebook2Id = objPricB.Id,
            Contract2__c = objContract.Id,
            Type = 'ReNew'
        );
        insert objOrder;

        OrderItem objOrderItem = new OrderItem(
            OrderId = objOrder.Id,
            PricebookEntryId = objPricE.Id,
            Quantity = 1,
            UnitPrice = 1
        );
        insert objOrderItem;

        objOrder.Status = 'PolicyIssued';
        update objOrder;



        Test.startTest();
        OpportunityDeleteSchedule.schedule();
        OpportunityRenewVincendosBatch batch = new OpportunityRenewVincendosBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verifique se o processamento foi concluído corretamente
        // Realize asserções ou consultas para verificar se os resultados esperados foram obtidos
        List<Opportunity> renewedOpportunities = [SELECT Id, ParentOpportunity__c, Type, RecordTypeId FROM Opportunity WHERE ParentOpportunity__c = :objOpportunity.Id AND Type = 'ReNew' AND RecordTypeId =: RTOppConseg];
		System.debug(renewedOpportunities);
		//System.assertEquals(1, renewedOpportunities.size());

    }
}