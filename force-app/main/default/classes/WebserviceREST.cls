/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

public virtual class WebserviceREST {
    public string method { get; set; }
    public string url { get; set; }
    public integer statusCode { get; set; }
    public string requestBody { get; set; }
    public string responseBody { get; set; }
    public boolean error { get; set; }
    public string errorMessage { get; set; }

    public virtual string callout(string token, string reqBody){
        return callout(token, reqBody, getStdHeader(token, reqBody));
    }

    public virtual Map<string, string> getStdHeader(string token, string reqBody){
        Map<string, string> headers = new Map<string, string>();
        headers.put('WizClientId', ExternalAPI__c.getValues('Corporativo').ClientSecret__c);
        if(method == 'POST'){
            headers.put('Content-Type', 'application/json');
            headers.put('Content-Length', String.valueOf(Blob.valueOf(reqBody != null ? reqBody : '').size()));
        }
        if(method == 'GET'){
            headers.put('Accept', 'application/json');
        }

        if(token != null && token != ''){
            headers.put('Authorization', 'Bearer ' + token);
        }
        System.debug('***** Valores headers: ' + headers + ' *****');
        return headers;
    }

    public virtual string callout(String token, String reqBody, String contentType, String boundary){
        return callout(token, reqBody, getStdHeader(token, reqBody, contentType, boundary));
    }

    public virtual Map<string, string> getStdHeader(String token, String reqBody, String contentType, String boundary){
        Map<string, string> headers = new Map<string, string>();
        if(method == 'POST' && contentType == 'application/x-www-form-urlencoded'){
            headers.put('Content-Type', contentType);
            headers.put('Content-Length', reqBody);
            headers.put('Accept', contentType);
        }else if(method == 'POST' && contentType == 'multipart/form-data'){
            headers.put('Content-Type', HttpFormBuilder.GetContentType());
            headers.put('Content-Length', String.valueOf(Blob.valueOf(reqBody != null ? reqBody : '').size()));
            headers.put('Accept', 'application/json');
        }else if(method == 'POST'){
            headers.put('Content-Type', 'application/json');
            headers.put('Content-Length', String.valueOf(Blob.valueOf(reqBody != null ? reqBody : '').size()));
        }else if(method == 'PUT'){
            headers.put('Content-Type', 'application/json');
            headers.put('Content-Length', String.valueOf(Blob.valueOf(reqBody != null ? reqBody : '').size()));
        }
            else if(method == 'GET' || method == 'DELETE'){
            headers.put('Accept', 'application/json');
        }

        if(token != null && token != ''){
            headers.put('Authorization', 'Bearer ' + token);
        }
        System.debug('***** Valores headers: ' + headers + ' *****');
        return headers;
    }

    public virtual string callout(string token, string reqBody, Map<string, string> headers){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod(method);
        req.setEndpoint(url);
        req.setTimeout(120000);

        for(string h : headers.keySet()){
            req.setHeader(h, headers.get(h));
        }

        if(reqBody != null && reqBody != ''){
            this.requestBody = reqBody;
            req.setBody(requestBody);
            System.debug('***** Valores request: ' + requestBody + ' *****');
        }
        System.debug('***** Valores request: ' + req + ' *****');

        HTTPResponse resp = null;
         try{
            resp = http.send(req);
            error = false;
            system.debug('resp.getBody(): ' + resp.getBody());
        } catch (System.CalloutException e){
            error = true;
            errorMessage = e.getMessage();
            system.debug('errorMessage: ' + errorMessage);
        }

        this.statusCode = resp != null ? resp.getstatusCode() : 0;

        if(this.statusCode == 0){
            this.responseBody = '';
        }else{
             try{
                this.responseBody = resp.getBody();
            } catch (Exception e){
                error = true;
                errorMessage = e.getMessage();
            }
        }
        return this.responseBody.remove('\\').removeEndIgnoreCase('"').removeStartIgnoreCase('"');
    }

    public virtual Map<String, Object> validationStatus(Map<String, Object> results, String strJSON){
        if(Error){
            results.put('Status', 'Failed');
            results.put('ErrorMessage', ErrorMessage);
            System.debug('Callout error: ' + ErrorMessage);
        }else if(StatusCode == 201 || StatusCode == 200 || statusCode == 202){
            results.put('Retorno', strJSON);
            results.put('Status', 'Success');
        }else{
            results.put('Status', 'Failed');
            results.put('ErrorMessage', strJSON);
        }
        return results;
    }
}