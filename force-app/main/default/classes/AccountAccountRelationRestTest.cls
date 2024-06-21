@IsTest
private class AccountAccountRelationRestTest {
    @TestSetup
    static void makeData(){
        Account acc1 = AccountDataFactory.createBusinessAccount();
        acc1.Name = 'First Account';
        Account acc2 = AccountDataFactory.createBusinessAccount();
        Account acc3 = AccountDataFactory.createBusinessAccount();
        insert new List<Account>{acc1, acc2, acc3};

        AccountAccountRelation__c rel1 = new AccountAccountRelation__c(ParentAccount__c = acc1.Id, RelatedAccount__c = acc2.Id);
        AccountAccountRelation__c rel2 = new AccountAccountRelation__c(ParentAccount__c = acc2.Id, RelatedAccount__c = acc3.Id);
        insert new List<AccountAccountRelation__c>{rel1, rel2};
    }

    @IsTest
    static void testRelation(){
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'First Account'];
        List<String> requestBody = new List<String>{acc.Id};
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/AccountRelation'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        AccountAccountRelationRest.getAccountRelation();
        Test.stopTest();
        
        List<String> responseBody = (List<String>) JSON.deserialize(res.responseBody.toString(), List<String>.Class);
        Assert.isFalse(responseBody.isEmpty(), 'The response body should not be empty');
    }

    @IsTest
    static void testError(){
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'First Account'];
        List<String> requestBody = new List<String>{acc.Id};
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/AccountRelation'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('test');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        AccountAccountRelationRest.getAccountRelation();
        Test.stopTest();
        Assert.areEqual(400, res.statusCode, 'The status code is not as expected');
    }
}