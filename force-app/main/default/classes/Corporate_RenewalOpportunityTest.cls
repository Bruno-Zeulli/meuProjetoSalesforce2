@isTest
public class Corporate_RenewalOpportunityTest {
    static String cronEXP = '0 0 5 3 9 ? 2030';

    @testSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Administrador'];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';

        String alternativeOwnerName = RenewCorporateConstants__mdt.getInstance('AlternativeOwner').Value__c;
        String alternativeRecipientName = RenewCorporateConstants__mdt.getInstance('AlternativeRecipient').Value__c;
        User alternativeOwner;
        
        List<User> alternativeRecipient = [SELECT Email FROM User WHERE Name = :alternativeRecipientName AND IsActive = true LIMIT 1];
        List<User> alternativeOwnerList = [SELECT Id FROM User WHERE Name = :alternativeOwnerName AND IsActive = true LIMIT 1];
        if(alternativeOwnerList.isEmpty()){
            alternativeOwner = new User(Alias = 'standt', Email='owner@testorg.com', EmailEncodingKey='UTF-8', LastName=alternativeOwnerName, LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='a'+uniqueUserName);
            insert alternativeOwner;
        }else{
            alternativeOwner = alternativeOwnerList.get(0);
        }

        if(alternativeRecipient.isEmpty()){
            User userRecipient = new User(Alias = 'standt', Email='recipient@testorg.com', EmailEncodingKey='UTF-8', LastName=alternativeRecipientName, LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='b'+uniqueUserName);
            insert userRecipient;
        }
        
        User user1 = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='c'+uniqueUserName, ManagerId = alternativeOwner.Id);
        insert user1;
        System.runAs(user1){
            Account acc = AccountDataFactory.createPersonAccount();
            acc.IsBroker__c = true;
            insert acc;
    
            Product2 product1 = new Product2(ProductCode = '3-118-211', Name = 'Patrimonial - Equipamentos', Family = 'Patrimonial', Renewal_Start_Term__c = 30, IsActive=true);
            insert product1;
    
            Product2 product2 = new Product2(ProductCode = '3-118-212', Name = 'Patrimonial - Riscos Diversos', Family = 'Patrimonial', Renewal_Start_Term__c = 30, IsActive=true);
            insert product2;
    
            Id pbId = Test.getStandardPricebookId();
            PricebookEntry pbe1 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
            PricebookEntry pbe2 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
            insert new List<PriceBookEntry>{pbe1,pbe2};
    
            Opportunity opp1 = OpportunityDataFactory.createOpportunityCorporateComercial();
            opp1.Name = 'Opp1';
            opp1.AccountId = acc.Id;
    
            Opportunity opp2 = OpportunityDataFactory.createOpportunityCorporateComercial();
            opp2.Name = 'opp2';
            opp2.AccountId = acc.Id;
            insert new List<Opportunity>{opp1,opp2};
    
            Order ord1 = OrderDataFactory.createOrderCorporateApolice();
            ord1.OpportunityId = opp1.Id;
            ord1.AccountId = acc.Id;
            ord1.PoNumber = opp1.Name + '123';
            ord1.EndDate = System.Today().addDays(30);
            ord1.Pricebook2Id = pbId;
    
            Order ord2 = OrderDataFactory.createOrderCorporateApolice();
            ord2.OpportunityId = opp2.Id;
            ord2.AccountId = acc.Id;
            ord2.PoNumber = opp2.Name + '987';
            ord2.EndDate = System.Today().addDays(30);
            ord2.Pricebook2Id = pbId;
            insert new List<Order>{ord1,ord2};
    
            OrderItem ordItem1 = new OrderItem(PricebookEntryId = pbe1.Id, OrderId = ord1.Id, Quantity = 1.00, UnitPrice = 1, CommissionValue__c = 5);
            OrderItem ordItem2 = new OrderItem(PricebookEntryId = pbe2.Id, OrderId = ord2.Id, Quantity = 1.00, UnitPrice = 1, CommissionValue__c = 5);
            insert new List<OrderItem>{ordItem1,ordItem2};
    
            Id idCom = Schema.SObjectType.CommissionsAndTransfers__c.getRecordTypeInfosByDeveloperName().get('Commission').getRecordTypeId();
            CommissionsAndTransfers__c com1 = new CommissionsAndTransfers__c(Broker__c = acc.Id, CommissionPercent__c = 50,Commission__c = ord1.Id,RecordTypeId = idCom);
            CommissionsAndTransfers__c com2 = new CommissionsAndTransfers__c(Broker__c = acc.Id, CommissionPercent__c = 50,Commission__c = ord1.Id,RecordTypeId = idCom);
            CommissionsAndTransfers__c com3 = new CommissionsAndTransfers__c(Broker__c = acc.Id, CommissionPercent__c = 100,Commission__c = ord2.Id,RecordTypeId = idCom);
            insert new List<CommissionsAndTransfers__c>{com1,com2,com3};
        }
    }

    @isTest
    static void testSchedule(){
        Test.startTest();
        Corporate_RenewalOpportunitySchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new Corporate_RenewalOpportunitySchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        Assert.areEqual(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        Assert.areEqual('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testBatchSuccess(){
        String alternativeRecipientName = RenewCorporateConstants__mdt.getInstance('AlternativeRecipient').Value__c;        
        
        User alternativeRecipient = [SELECT Email FROM User WHERE Name = :alternativeRecipientName AND IsActive = true LIMIT 1];
        alternativeRecipient.IsActive = false;
        update alternativeRecipient;

        Test.startTest();
        Database.executeBatch(new Corporate_RenewalOpportunityBatch());
        Test.stopTest();

        List<OpportunityLineItem> oppRenew = [SELECT Id, Product2.Name FROM OpportunityLineItem WHERE Opportunity.Type = 'Renew'];
        Assert.areEqual(2,oppRenew.size());
    }

    @isTest
    static void testBatchInactiveProduct(){

        Product2 prd = [SELECT Id FROM Product2 WHERE Name = 'Patrimonial - Equipamentos'];
        prd.IsActive = false;
        update prd;
        
        Test.startTest();
        Database.executeBatch(new Corporate_RenewalOpportunityBatch());
        Test.stopTest();

        List<OpportunityLineItem> oppRenew = [SELECT Id, Product2.Name FROM OpportunityLineItem WHERE Opportunity.Type = 'Renew'];
        Assert.areEqual(1,oppRenew.size());
    }

    @isTest
    static void testBatchInactiveOwner(){
        
        User user1 = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com'];
        user1.IsActive = false;
        update user1;
        
        Test.startTest();
        Database.executeBatch(new Corporate_RenewalOpportunityBatch());
        Test.stopTest();
    }
}