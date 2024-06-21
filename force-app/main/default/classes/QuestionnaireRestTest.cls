@IsTest
private class QuestionnaireRestTest {
    @IsTest
    static void createRestQuestionnaireShouldCreateQuestionnaire(){
        
        Questionnaire_Definition__c def = QuestionnaireDefinitionDataFactory.insertQuestionnaireDefinition();
        List<Questionnaire_Question__c> questions = QuestionnaireQuestionDataFactory.insertQuestionnaireQuestions(3, def.Id);
        Account acc = AccountDataFactory.insertBusinessAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        opp.AccountId = acc.Id;
        insert opp;

        QuestionnaireRestTO.Answer answer1 = new QuestionnaireRestTO.Answer();
        answer1.code = 'P1';
        answer1.answer = 'test';
        answer1.comment = 'comm';
        QuestionnaireRestTO.Answer answer2 = new QuestionnaireRestTO.Answer();
        answer2.code = 'P1';
        answer2.answer = 'test';
        answer2.comment = 'comm';
        QuestionnaireRestTO.Answer answer3 = new QuestionnaireRestTO.Answer();
        answer3.code = 'P1';
        answer3.answer = 'test';
        answer3.comment = 'comm';

        QuestionnaireRestTO.RiskyPlace place = new QuestionnaireRestTo.RiskyPlace();
        place.name = 'place1';
        place.placeCode = '123456';
        place.address = 'test';
        place.activity = 'activity';
        place.id = null;

        QuestionnaireRestTO.Tables tables = new QuestionnaireRestTO.Tables();
        tables.riskyPlaces = new List<QuestionnaireRestTO.RiskyPlace>{place};

        QuestionnaireRestTO.Questionnaire quest = new QuestionnaireRestTO.Questionnaire();
        quest.opportunityId = opp.Id;
        quest.formDefName = def.Name;
        quest.answers = new List<QuestionnaireRestTO.Answer>{answer1, answer2, answer3};
        quest.tables = tables;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(quest));
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireRest.createQuestionnaire();
        Test.stopTest();
        
        List<Questionnaire__c> questList = [SELECT Id FROM Questionnaire__c];
        Assert.areEqual(1, questList.size(), 'The questionnaire was not created as expected');
    }

    @IsTest
    static void updateRestQuestionnaireShouldUpdateQuestionnaire(){
        Questionnaire__c questionnaire = QuestionnaireDataFactory.insertQuestionnaire();
        Opportunity questOpp = [SELECT AccountId FROM Opportunity WHERE Id = :questionnaire.Opportunity__c];
        Asset objAsset = new Asset(
            Name = 'Teste',
            AssetIdentifierCode__c = '1234567',
            AccountId = questOpp.AccountId
        );
        insert objAsset;
        InsuredLocationDataFactory.insertInsuredLocation(objAsset.Id, questionnaire.Id);

        Account acc = AccountDataFactory.insertBusinessAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        opp.AccountId = acc.Id;
        insert opp;

        QuestionnaireRestTO.Answer answer1 = new QuestionnaireRestTO.Answer();
        answer1.code = 'P1';
        answer1.answer = 'test';
        answer1.comment = 'comm';
        QuestionnaireRestTO.Answer answer2 = new QuestionnaireRestTO.Answer();
        answer2.code = 'P1';
        answer2.answer = 'test';
        answer2.comment = 'comm';
        QuestionnaireRestTO.Answer answer3 = new QuestionnaireRestTO.Answer();
        answer3.code = 'P1';
        answer3.answer = 'test';
        answer3.comment = 'comm';

        QuestionnaireRestTO.RiskyPlace place = new QuestionnaireRestTo.RiskyPlace();
        place.name = 'place1';
        place.placeCode = '123456';
        place.address = 'test';
        place.activity = 'activity';

        QuestionnaireRestTO.Tables tables = new QuestionnaireRestTO.Tables();
        tables.riskyPlaces = new List<QuestionnaireRestTO.RiskyPlace>{place};

        QuestionnaireRestTO.QuestionnaireUpdate quest = new QuestionnaireRestTO.QuestionnaireUpdate();
        quest.answers = new List<QuestionnaireRestTO.Answer>{answer1, answer2, answer3};
        quest.tables = tables;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire/'+questionnaire.Id; //Request URL
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(JSON.serialize(quest));
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireRest.updateQuestionnaire();
        Test.stopTest();
        
        List<Questionnaire__c> questList = [SELECT Id FROM Questionnaire__c];
        Assert.areEqual(1, questList.size(), 'The questionnaire was not created as expected');
    }

    @IsTest
    static void createOrUpdateRestQuestionnaireWithMalformedBodyShouldReturnError(){
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        insert opp;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/Questionnaire'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"invalid": "true"}');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        QuestionnaireRest.createQuestionnaire();
        Assert.areEqual(400, res.statusCode, 'The status code is not as expected');

        QuestionnaireRest.updateQuestionnaire();
        Assert.areEqual(400, res.statusCode, 'The status code is not as expected');

        QuestionnaireRestTO.Questionnaire quest = new QuestionnaireRestTO.Questionnaire();
        quest.formDefName = 'really invalid name';
        req.requestBody = Blob.valueOf(JSON.serialize(quest));
        QuestionnaireRest.createQuestionnaire();
        Assert.areEqual(404, res.statusCode, 'The status code is not as expected');

        Questionnaire_Definition__c def = QuestionnaireDefinitionDataFactory.insertQuestionnaireDefinition();
        quest.formDefName = def.Name;
        quest.opportunityId = opp.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(quest));
        QuestionnaireRest.createQuestionnaire();
        Assert.areEqual(500, res.statusCode, 'The status code is not as expected');
        Test.stopTest();
    }
}