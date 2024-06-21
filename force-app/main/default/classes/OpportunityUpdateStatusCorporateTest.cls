@isTest
public class OpportunityUpdateStatusCorporateTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';

    @TestSetup
    static void makeData(){
        Account acc = AccountDataFactory.insertPersonAccount();

        Product2 product1 = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista', Renewal_Start_Term__c = 30);
        Product2 product2 = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista', Renewal_Start_Term__c = 80);
        List<Product2> listPrd = new List<Product2>{product1,product2};
        insert listPrd;

        Id pbId = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        List<PricebookEntry> listPBE = new List<PricebookEntry>{pbe1,pbe2};
        insert listPBE;

        Opportunity opp1 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp1.Name = 'OppVigente';
        opp1.AccountId = acc.Id;

        Opportunity opp2 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp2.Name = 'OppExpirando';
        opp2.AccountId = acc.Id;

        Opportunity opp3 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp3.Name = 'OppRenovacaoVigente';
        opp3.AccountId = acc.Id;

        Opportunity opp4 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp4.Name = 'OppRenovacaoExpirando';
        opp4.AccountId = acc.Id;

        List<Opportunity> oppsToInsert1 = new List<Opportunity>{opp1,opp2,opp3,opp4};
        insert oppsToInsert1;

        List<OpportunityLineItem> oppLIToInsert1 = new List<OpportunityLineItem>();
        for(Opportunity opp:oppsToInsert1){
            OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItem();
            oppLi.OpportunityId = opp.Id;
            if(opp.Name == 'OppExpirando' || opp.Name == 'OppRenovacaoExpirando'){
                oppLi.PricebookEntryId = pbe2.Id;
            }else{
                oppLi.PricebookEntryId = pbe1.Id;
            }
            oppLIToInsert1.add(oppLi);
        }
        insert oppLIToInsert1;

        List<Order> listOrderToInsert = new List<Order>();
        for(Opportunity opp:oppsToInsert1){
            if(opp.Portal_Visible__c == false){
                Order ord = OrderDataFactory.createOrderCorporateApolice();
                ord.OpportunityId = opp.Id;
                ord.AccountId = acc.Id;
                ord.PoNumber = opp.Name + '123';
                ord.EndDate = System.Today().addDays(60);
                listOrderToInsert.add(ord);
            }   
        }

        insert listOrderToInsert;

        Opportunity opp5 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp5.Name = 'OppFilhaEmAnalise1';
        opp5.AccountId = acc.Id;
        opp5.ParentOpportunity__c = opp4.Id;
        opp5.Type = 'ReNew';
        opp5.Portal_Visible__c = true;

        Opportunity opp6 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp6.Name = 'OppFilhaEmAnalise2';
        opp6.AccountId = acc.Id;
        opp6.ParentOpportunity__c = opp3.Id;
        opp6.Type = 'ReNew';
        opp6.Portal_Visible__c = true;        
        
        List<Opportunity> oppsToInsert2 = new List<Opportunity>{opp5,opp6};
        insert oppsToInsert2;

        List<OpportunityLineItem> oppLIToInsert2 = new List<OpportunityLineItem>();
        for(Opportunity opp:oppsToInsert2){
            OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItem();
            oppLi.OpportunityId = opp.Id;
            oppLi.PricebookEntryId = pbe1.Id;
            oppLIToInsert2.add(oppLi);
        }
        insert oppLIToInsert2;
    }

    @isTest
    static void testImplementationSchedule(){
        Test.startTest();
        OpportunityUpdateStatusCorporateSchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new OpportunityUpdateStatusCorporateSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testVigente(){
        Opportunity oppVigente = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppVigente' LIMIT 1];
        Opportunity oppRenovacaoVigente = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppRenovacaoVigente' LIMIT 1];
        Assert.areEqual('Vigente',oppVigente.Status_Portal__c);
        Assert.areEqual('Em Renovação - Vigente',oppRenovacaoVigente.Status_Portal__c);
        Test.startTest();
        OpportunityUpdateStatusCorporateBatch batch = new OpportunityUpdateStatusCorporateBatch();
        batch.todayDate = System.Today().addDays(30);
        Database.executeBatch(batch);
        Test.stopTest();
        oppVigente = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppVigente' LIMIT 1];
        oppRenovacaoVigente = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppRenovacaoVigente' LIMIT 1];
        Assert.areEqual('A Expirar',oppVigente.Status_Portal__c);
        Assert.areEqual('Em Renovação - A Expirar',oppRenovacaoVigente.Status_Portal__c);
    }

    @isTest
    static void testExpirando(){
        Opportunity oppExpirando = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppExpirando' LIMIT 1];
        Opportunity oppRenovacaoExpirando = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppRenovacaoExpirando' LIMIT 1];
        Assert.areEqual('A Expirar',oppExpirando.Status_Portal__c);
        Assert.areEqual('Em Renovação - A Expirar',oppRenovacaoExpirando.Status_Portal__c);
        Test.startTest();
        OpportunityUpdateStatusCorporateBatch batch = new OpportunityUpdateStatusCorporateBatch();
        batch.last1Day = System.Today().addDays(60);
        Database.executeBatch(batch);
        Test.stopTest();
        oppExpirando = [SELECT Id, Status_Portal__c,Latest_Order_EndDate__c, Product_Renewal_Start_Date__c FROM Opportunity WHERE Name='OppExpirando' LIMIT 1];
        oppRenovacaoExpirando = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Name='OppRenovacaoExpirando' LIMIT 1];
        Assert.areEqual('Vencida',oppExpirando.Status_Portal__c);
        Assert.areEqual('Em Renovação - Vencida',oppRenovacaoExpirando.Status_Portal__c);
    }
}