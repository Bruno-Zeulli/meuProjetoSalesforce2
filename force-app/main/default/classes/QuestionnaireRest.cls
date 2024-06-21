@RestResource(urlMapping='/v1/Questionnaire/*')
global with sharing class QuestionnaireRest {

    @HttpPost
    global static void createQuestionnaire(){
        RestRequest req = RestContext.request;
        QuestionnaireRestTO.Questionnaire formData;
        try{
            formData = (QuestionnaireRestTO.Questionnaire) JSON.deserializeStrict(req.requestBody.toString(), QuestionnaireRestTO.Questionnaire.Class);
        } catch (Exception ex){
            setError('Malformed/Invalid body', ex.getMessage(), 400);
            return ;
        }

        Questionnaire_Definition__c formDef = QuestionnaireDefinitionDAO.getInstance().getQuestionnaireDefByName(formData.formDefName);
        if (formDef == null){
            setError('Form definition does not exist', '', 404);
            return ;
        }

        Questionnaire__c form = new Questionnaire__c();
        form.Questionnaire_Definition__c = formDef.Id;
        form.Name = formData.formDefName;
        form.Opportunity__c = formData.opportunityId;

        form = QuestionnaireBO.getInstance().insertQuestionnaire(form);
        if (form.Id == null){
            setError('Error on questionnaire insert', '', 500);
            return ;
        }

        updateQuestions(formData.answers, form.Id);
        upsertPlaces(formData.tables.riskyPlaces, form.Id);

        RestResponse res = RestContext.response;
        res.statusCode = 201;
        res.responseBody = Blob.valueOf(form.Id);
    }

    @HttpPut
    global static void updateQuestionnaire(){
        RestRequest req = RestContext.request;
        String questionnaireId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        QuestionnaireRestTO.QuestionnaireUpdate formData;
        try{
            formData = (QuestionnaireRestTO.QuestionnaireUpdate) JSON.deserializeStrict(req.requestBody.toString(), QuestionnaireRestTO.QuestionnaireUpdate.Class);
        } catch (Exception ex){
            setError('Malformed/Invalid body', ex.getMessage(), 400);
            return ;
        }

        updateQuestions(formData.answers, questionnaireId);
        upsertPlaces(formData.tables.riskyPlaces, questionnaireId);

        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(questionnaireId);
    }

    private static void updateQuestions(List<QuestionnaireRestTO.Answer> answers, String questionnaireId) {
        List<Questionnaire_Answer__c> updatedAnswers = new List<Questionnaire_Answer__c>();
        for (QuestionnaireRestTO.Answer formAnswer : answers){
            Questionnaire_Answer__c answer = new Questionnaire_Answer__c();
            answer.Answer__c = formAnswer.answer;
            answer.Comment__c = formAnswer.comment;
            answer.Unique_Code__c = questionnaireId + formAnswer.code;
            updatedAnswers.add(answer);
        }
        QuestionnaireAnswerBO.getInstance().updateByUniqueCode(updatedAnswers);
    }

    private static void upsertPlaces(List<QuestionnaireRestTo.RiskyPlace> places, String questionnaireId) {
        Questionnaire__c questionnaire = QuestionnaireDAO.getInstance().getQuestionnaireById(questionnaireId);

        List<Asset> placesList = new List<Asset>();
        List<Insured_Location__c> createdPlaces = InsuredLocationDAO.getInstance().getInsuredLocationByQuestionnaireIds(new Set<String>{questionnaireId});
        Map<Id, Insured_Location__c> createdPlaceMap = new Map<Id, Insured_Location__c>();
        for (Insured_Location__c place : createdPlaces){
            createdPlaceMap.put(place.Asset__c, place);
        }
        for (QuestionnaireRestTO.RiskyPlace formPlace: places) {
            Asset place = new Asset();
            place.AssetIdentifierCode__c = formPlace.placeCode;
            place.Activity__c = formPlace.activity;
            // place.Address = formPlace.address;
            place.Name = formPlace.name;
            place.AccountId = questionnaire.Opportunity__r.AccountId;
            placesList.add(place);
        }
        upsert placesList AssetIdentifierCode__c;

        List<Insured_Location__c> placesToInsert = new List<Insured_Location__c>();
        List<Insured_Location__c> placesToDelete = new List<Insured_Location__c>();
        Map<Id, Asset> assetMap = new Map<Id, Asset>(placesList);
        for (Asset a : placesList){
            if (createdPlaceMap.get(a.id) == null){
                Insured_Location__c newPlace = new Insured_Location__c();
                newPlace.Asset__c = a.Id;
                newPlace.Questionnaire__c = questionnaireId;
                placesToInsert.add(newPlace);
            }
        }
        insert placesToInsert;

        for (Insured_Location__c place : createdPlaceMap.values()){
            if (assetMap.get(place.Asset__c) == null){
                Insured_Location__c newPlace = new Insured_Location__c(Id = place.Id);
                placesToDelete.add(newPlace);
            }
        }
        delete placesToDelete;

    }

    private static void setError(String errorTitle, String errorDetails, Integer statusCode){
        RestResponse res = RestContext.response;
        QuestionnaireRestTO.Error e = new QuestionnaireRestTO.Error();
        e.title = errorTitle;
        e.details = errorDetails;
        res.statusCode = statusCode;
        res.headers.put('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(e));
    }

    
}