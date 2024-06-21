@IsTest
private class ConnectWizListingTest { 

    @testSetup
    static void makeData(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista', Renewal_Start_Term__c = 60);
        insert product;
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;

        Account acc = AccountDataFactory.insertPersonAccount();

        Opportunity opp1 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp1.AccountId = acc.Id;
        opp1.StageName = 'Em Emissão';
        insert opp1;

        OpportunityLineItem oppLi1 = OpportunityLineItemDataFactory.createOpportunityLineItem();
        oppLi1.OpportunityId = opp1.Id;
        oppLi1.PricebookEntryId = pbe.Id;
        insert oppLi1;

        Opportunity opp2 = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp2.AccountId = acc.Id;
        opp2.StageName = 'Em Emissão';
        insert opp2;

        OpportunityLineItem oppLi2 = OpportunityLineItemDataFactory.createOpportunityLineItem();
        oppLi2.OpportunityId = opp2.Id;
        oppLi2.PricebookEntryId = pbe.Id;
        insert oppLi2;

        Order ord = OrderDataFactory.createOrderCorporateApolice();
        ord.AccountId = acc.Id;
        ord.Pricebook2Id = pbId;
        ord.OpportunityId = opp2.Id;
        ord.EndDate = System.Today().addDays(150);
        insert ord;

        OrderItem oi = new OrderItem();
        oi.UnitPrice = 1;
        oi.Product2Id = product.Id;
        oi.Quantity = 1;
        oi.PricebookEntryId = pbe.Id;
        oi.OrderId = ord.Id;
        insert oi;
    }

    @isTest
    static void testWrongBody(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/ConnectWizListing/policies';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('tests');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ConnectWizListingWebService.getListingByAccs();
        Test.stopTest();
        ConnectWizListingTO.Error body = (ConnectWizListingTO.Error) JSON.deserializeStrict(res.responseBody.toString(),ConnectWizListingTO.Error.Class);
        Assert.areEqual(400, res.statusCode, 'The status code is not as expected');
        Assert.areEqual('Malformed/Invalid body. Ex: {"accIds":["001Xx000014xxxxXXX","001Xx000023xxxxXXX"]}', body.title, 'The title of the error is not as expected');
    }

    @isTest
    static void testWrongURI(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/ConnectWizListing/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"accIds":["001Xx000012xxxxXXX","001Xx000023xxxxXXX"]}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ConnectWizListingWebService.getListingByAccs();
        Test.stopTest();
        ConnectWizListingTO.Error body = (ConnectWizListingTO.Error) JSON.deserializeStrict(res.responseBody.toString(),ConnectWizListingTO.Error.Class);
        Assert.areEqual(400, res.statusCode, 'The status code is not as expected');
        Assert.areEqual('Malformed/Invalid URI', body.title, 'The title of the error is not as expected');
    }

    @isTest
    static void testSuccessPolicies(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/ConnectWizListing/policies';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"accIds":["' + acc.Id + '"]}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ConnectWizListingWebService.getListingByAccs();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode, 'The status code is not as expected');
    }

    @isTest
    static void testSuccessQuotes(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/ConnectWizListing/quotes';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"accIds":["' + acc.Id + '"]}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ConnectWizListingWebService.getListingByAccs();
        Test.stopTest();
        Assert.areEqual(200, res.statusCode, 'The status code is not as expected');
    }
}