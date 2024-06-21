@RestResource(urlMapping='/v1/ConnectWizListing/*')
global with sharing class ConnectWizListingWebService { 
    
    @HttpPost
    global static void getListingByAccs(){
        
        RestRequest req = RestContext.request;
        ConnectWizListingTO.ReqBody body;
        String endURL = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        try {
            body = (ConnectWizListingTO.ReqBody) JSON.deserializeStrict(req.requestBody.toString(),ConnectWizListingTO.ReqBody.Class);
        } catch (Exception ex) {
            setError('Malformed/Invalid body. Ex: {"accIds":["001Xx000014xxxxXXX","001Xx000023xxxxXXX"]}', ex.getMessage(), 400);
            return;
        }

        if(endURL == 'policies'){
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            Map<String,ConnectWizListingTO.PolicyResponse> resp = ConnectWizListingBO.getInstance().getPoliciesByAccs(body.accIds);
            res.responseBody = Blob.valueOf(JSON.serialize(resp));
        }else if(endURL == 'quotes'){
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            Map<String,ConnectWizListingTO.QuoteResponse> resp = ConnectWizListingBO.getInstance().getQuotesByAccs(body.accIds);
            res.responseBody = Blob.valueOf(JSON.serialize(resp));
        }else{
            setError('Malformed/Invalid URI', 'URI must end with \'policies\' or \'quotes\'', 400);
        }
    }

    private static void setError(String errorTitle, String errorDetails, Integer statusCode){
        RestResponse res = RestContext.response;
        ConnectWizListingTO.Error e = new ConnectWizListingTO.Error();
        e.title = errorTitle;
        e.details = errorDetails;
        res.statusCode = statusCode;
        res.headers.put('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(e));
    }
}