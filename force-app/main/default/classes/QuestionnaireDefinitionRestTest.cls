@IsTest
private class QuestionnaireDefinitionRestTest {
    
    @IsTest
    static void testCallWithoutProduct(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire/Definition'; //Request URL
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireDefinitionRest.getDefinition();
        Test.stopTest();
        Assert.areEqual(422, res.statusCode, 'The status code is not as expected');
    }

    @IsTest
    static void testCallWithoutSubProduct(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire/Definition?product=p'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('product', 'p');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireDefinitionRest.getDefinition();
        Test.stopTest();
        Assert.areEqual(422, res.statusCode, 'The status code is not as expected');
    }

    @IsTest
    static void testCallWithEmptyState(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire/Definition?product=p&subproduct=s'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('product', 'p');
        req.addParameter('subproduct', 's');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireDefinitionRest.getDefinition();
        Test.stopTest();
        Assert.areEqual(204, res.statusCode, 'The status code is not as expected');
    }

    @IsTest
    static void getDefinitionShouldSucceed(){
        
        Questionnaire__c quest = QuestionnaireDataFactory.insertQuestionnaire();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire/Definition?product='+quest.Opportunity__c+'&subproduct=null'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('product', quest.Opportunity__c);
        req.addParameter('subproduct', 'null');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireDefinitionRest.getDefinition();
        Test.stopTest();

        Assert.areEqual(200, res.statusCode, 'The status code is not as expected');
        
    }
}