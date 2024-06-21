@RestResource(urlMapping='/v1/AccountRelation')
global with sharing class AccountAccountRelationRest {

    public static final Integer MAX_QUERIES = System.Limits.getLimitQueries();
    
    @HttpPost
    global static void getAccountRelation(){
        RestRequest req = RestContext.request;
        Set<String> accountIdList;
        try {
            accountIdList = (Set<String>) JSON.deserialize(req.requestBody.toString(), Set<String>.Class);
        } catch (Exception ex){
            setError('Malformed/Invalid body', ex.getMessage(), 400);
            return ;
        }

        List<String> allRelations = new List<String>(accountIdList);
        allRelations.addAll(getChildAccountIds(accountIdList));

        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.headers.put('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(allRelations));
    }

    // Recursive function to get all the related subordinated accounts
    // To prevent reaching the limits, we check if we can still make queries before making it
    private static Set<String> getChildAccountIds(Set<String> accountIds){
        Set<String> childIds = new Set<String>();
        if (System.Limits.getQueries() >= MAX_QUERIES){
            return childIds;
        }

        List<AccountAccountRelation__c> accountRelationList = [SELECT RelatedAccount__c FROM AccountAccountRelation__c WHERE ParentAccount__c IN :accountIds];
        for (AccountAccountRelation__c accRelation : accountRelationList){
            childIds.add(accRelation.RelatedAccount__c);
        }

        if (!childIds.isEmpty()){
            childIds.addAll(getChildAccountIds(childIds));
        }

        return childIds;
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