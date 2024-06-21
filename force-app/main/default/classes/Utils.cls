public class Utils {
    public static Database.QueryLocator findSObject(String nomeObjeto, String campos, String whereCondition){
        String query = 'SELECT  ' + campos + ' FROM  ' + nomeObjeto + ' ' + whereCondition;

        return Database.getQueryLocator(query);
    }

    public static String retornarQueryAccountsAnything(){
        return 'SELECT Id, name, (SELECT id FROM Cases), (SELECT id FROM Opportunities), (SELECT Id FROM Contacts), (SELECT id FROM Orders) from account conta where conta.Id NOT IN (SELECT Account__c FROM Contract2__c) AND CreatedDate = LAST_N_DAYS: 60 LIMIT 10000';
    }

    public static String callout(String token, Blob reqBody, Map<string, string> headers, String method, String url){
        String errorMessage = '';
        Boolean error = false;
        Integer statusCode;
        String responseBody;

        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod(method);
        req.setEndpoint(url);
        req.setTimeout(120000);

        for(string h : headers.keySet()){
            req.setHeader(h, headers.get(h));
        }

        if(reqBody != null){
            req.setBodyAsBlob(reqBody);
            System.debug('***** Valores request: ' + reqBody.toString() + ' *****');
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

       statusCode = resp != null ? resp.getstatusCode() : 0;

        if(statusCode == 0){
            responseBody = '';
        }else{
         try{
            responseBody = resp.getBody();
        } catch (Exception e){
            error = true;
            errorMessage = e.getMessage();
        }
        }
        return responseBody.remove('\\').removeEndIgnoreCase('"').removeStartIgnoreCase('"');
    }


}