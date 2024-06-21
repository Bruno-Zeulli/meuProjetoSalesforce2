@isTest
public class OpportunityCorporateHelperTest {

    @isTest
    static void testGetStatus(){
        
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp.AccountId = acc.Id;
        insert opp;
        
        Assert.areEqual('Indefinido - Sem Produto',OpportunityCorporateHelper.getStatusPortal(opp));
        
        opp.Product_Name__c = 'Vida';
        Assert.areEqual('Indefinido',OpportunityCorporateHelper.getStatusPortal(opp));
        opp.Portal_Visible__c = true;
        Assert.areEqual('Em Análise',OpportunityCorporateHelper.getStatusPortal(opp));
        opp.StageName = 'Em Emissão';
        Assert.areEqual('Em Emissão',OpportunityCorporateHelper.getStatusPortal(opp));
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        ord.OpportunityId = opp.Id;
        ord.AccountId = acc.Id;
        insert ord;
        opp.Latest_Order__c = ord.Id;
        Assert.areEqual('Indefinido - Order sem EndDate',OpportunityCorporateHelper.getStatusPortal(opp));
        opp.Product_Renewal_Start_Term__c = 90;
        opp.Latest_Order_EndDate__c = System.Today() + 300;
        Opportunity oppChild = OpportunityDataFactory.createOpportunityCorporateComercial();
        oppChild.AccountId = acc.Id;
        oppChild.ParentOpportunity__c = opp.Id;
        insert oppChild;
        opp.Latest_Child_Opportunity__c = oppChild.Id;
        update opp;
        Opportunity oppParentInserted = [SELECT Id, Type, Status_Portal__c,StageName,Product_Name__c,Latest_Child_Opportunity__c,Latest_Child_Opportunity_Status_Portal__c,Latest_Order__c,Latest_Order_EndDate__c,Product_Renewal_Start_Term__c,Product_Renewal_Start_Date__c,Portal_Visible__c,Latest_Order_Status__c FROM Opportunity WHERE Id =:opp.Id];
        Assert.areEqual('Vigente',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = 'Em Análise';
        Assert.areEqual('Em Renovação - Vigente',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Order_EndDate__c = System.Today() + 80;
        update oppParentInserted;
        oppParentInserted = [SELECT Id, Type, Status_Portal__c,StageName,Product_Name__c,Latest_Child_Opportunity__c,Latest_Child_Opportunity_Status_Portal__c,Latest_Order__c,Latest_Order_EndDate__c,Product_Renewal_Start_Term__c,Product_Renewal_Start_Date__c,Portal_Visible__c,Latest_Order_Status__c FROM Opportunity WHERE Id =:opp.Id];
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = null;
        Assert.areEqual('A Expirar',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = 'Em Análise';
        Assert.areEqual('Em Renovação - A Expirar',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Order_EndDate__c = System.Today() - 10;
        update oppParentInserted;
        oppParentInserted = [SELECT Id, Type, Status_Portal__c,StageName,Product_Name__c,Latest_Child_Opportunity__c,Latest_Child_Opportunity_Status_Portal__c,Latest_Order__c,Latest_Order_EndDate__c,Product_Renewal_Start_Term__c,Product_Renewal_Start_Date__c,Portal_Visible__c,Latest_Order_Status__c FROM Opportunity WHERE Id =:opp.Id];
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = null;
        Assert.areEqual('Vencida',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = 'Em Análise';
        Assert.areEqual('Em Renovação - Vencida',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = 'Vigente';
        Assert.areEqual('Renovada',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Order_Status__c = 'Cancelled';
        oppParentInserted.Latest_Child_Opportunity_Status_Portal__c = 'Cancelada';
        Assert.areEqual('Cancelada',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.Latest_Order__c = null;
        Assert.areEqual('Indefinido - Pai sem Order',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));
        oppParentInserted.StageName = 'Fechado e Perdido';
        Assert.areEqual('Indefinido - Fechado e Perdido',OpportunityCorporateHelper.getStatusPortal(oppParentInserted));

        Opportunity oppEndosso = OpportunityDataFactory.createOpportunityCorporateComercial();
        oppEndosso.AccountId = acc.Id;
        oppEndosso.ParentOpportunity__c = opp.Id;
        oppEndosso.ParentOrderId__c = ord.Id;
        oppEndosso.Type = 'Endorsement';
        oppEndosso.StageName = 'Em Emissão';
        oppEndosso.Product_Name__c = 'Vida';
        insert oppEndosso;
        Assert.areEqual('Endosso Em Emissão',OpportunityCorporateHelper.getStatusPortal(oppEndosso));

        Order ordEndosso = OrderDataFactory.createOrderCorporateApolice();
        ordEndosso.PoNumber = '88761435634186';
        ordEndosso.OpportunityId = oppEndosso.Id;
        ordEndosso.AccountId = acc.Id;
        insert ordEndosso;

        oppEndosso.Latest_Order__c = oppEndosso.Id;
        Assert.areEqual('Endosso Emitido',OpportunityCorporateHelper.getStatusPortal(oppEndosso));


    }

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
        
        Opportunity oppParentInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id =:opp.Id];
        Assert.areEqual('Indefinido',oppParentInserted.Status_Portal__c);

        Opportunity oppChild = OpportunityDataFactory.createOpportunityCorporateComercial();
        oppChild.AccountId = acc.Id;
        oppChild.ParentOpportunity__c = opp.Id;
        oppChild.Type = 'ReNew';
        insert oppChild;

        oppChild.StageName = 'Em Emissão';
        update oppChild;

        Opportunity oppChildInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id =:oppChild.Id];
        Assert.areEqual('Indefinido - Sem Produto',oppChildInserted.Status_Portal__c);
        
        Account accountInserted = [SELECT Id, Product_Count_JSON__c FROM Account];
        Assert.areEqual(null,accountInserted.Product_Count_JSON__c);

        OpportunityLineItem oppLi2 = OpportunityLineItemDataFactory.createOpportunityLineItem();
        oppLi2.OpportunityId = oppChild.Id;
        oppLi2.PricebookEntryId = pbe.Id;
        insert oppLi2;

        oppChildInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id =:oppChild.Id];
        Assert.areEqual('Em Emissão',oppChildInserted.Status_Portal__c);

        oppParentInserted = [SELECT Id, Status_Portal__c,Latest_Child_Opportunity__c FROM Opportunity WHERE Id =:opp.Id];
        Assert.areEqual(oppChild.Id, oppParentInserted.Latest_Child_Opportunity__c);
        Assert.areEqual('Indefinido - Pai sem Order',oppParentInserted.Status_Portal__c);
        accountInserted = [SELECT Id, Product_Count_JSON__c FROM Account];
        Assert.areNotEqual(null,accountInserted.Product_Count_JSON__c);
    }
}