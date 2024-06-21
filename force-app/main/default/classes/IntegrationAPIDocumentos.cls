/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class IntegrationAPIDocumentos extends WebserviceREST{
    private static final IntegrationAPIDocumentos INSTANCE = new IntegrationAPIDocumentos();
    public static final String ENDPOINT_API_VERSION = '/api/v1';
    public static final String ENDPOINT_ARQUIVOS = '/arquivos';
    public static final String ENDPOINT_ARQUIVOS_DOCUMENTO = '/arquivos/documento';
    public static final String ENDPOINT_TIPOS_ARQUIVOS = '/arquivo-tipos';
    public static final String ENDPOINT_FISICO = '/fisico/';
    public static final String ENDPOINT_LOGICO = '/logico/';

    String accessToken;
    String jsonCredentials;
    String strJSON;

    public static IntegrationAPIDocumentos getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> getFileByFileId(String externalFileId){
        Map<String, Object> results = new Map<String, Object>();

        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'GET';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + '/'
            + externalFileId;

        strJSON = Callout(accessToken, null, null, null);

        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);

        return results;
    }

    public Map<String, Object> getListFilesByIdentificatorUniqueAccount(String identificatorUniqueAccount){
        Map<String, Object> results = new Map<String, Object>();

        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'GET';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + '/'
            + identificatorUniqueAccount;

        strJSON = Callout(accessToken, null, null, null);

        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> postFile(Blob form64){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'POST';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + '/base64';
        strJSON = Callout(accessToken, form64);
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Boolean deleteFileLogic(String fileExternalId){

        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'DELETE';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + ENDPOINT_LOGICO
            + fileExternalId;

        strJSON = Callout(accessToken, null, null, null);

        if(StatusCode == 204){
            return true;
        }
        return false;
    }

     public Boolean deleteFilePhysical(String fileExternalId){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'DELETE';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + ENDPOINT_FISICO
            + fileExternalId;

        strJSON = Callout(accessToken, null, null, null);
        if(StatusCode == 204){
            return true;
        }
        return false;
    }

    public Map<String, Object> getAllTypesFile(){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'GET';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_TIPOS_ARQUIVOS;

        strJSON = Callout(accessToken, null, null, null);
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> getFileTypeIdByFileTypeName(String fileTypeName){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'GET';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + '/?nome='
            + fileTypeName;

        strJSON = Callout(accessToken, null, null, null);
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> getAllFilesByPath(String path, String identificatorUniqueAccount){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');

        method = 'POST';
        URL = ExternalAPI__c.getValues('APIDocumentos').Endpoint__c
            + ENDPOINT_API_VERSION
            + ENDPOINT_ARQUIVOS
            + '/?documento='
            + identificatorUniqueAccount
            + '/'
            + path;
        strJSON = Callout(accessToken, null, null, null);

        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    private string callout(String token, Blob reqBody){
        return callout(token, reqBody, getStdHeader(token, reqBody));
    }

    private Map<string, string> getStdHeader(String token, Blob reqBody){
        Map<string, string> headers = new Map<string, string>();
        if(method == 'POST'){
            headers.put('Content-Type', HttpFormBuilder.GetContentType());
            headers.put('Content-Length', string.valueOf(reqBody.size()));
            headers.put('Accept', 'application/json');
        }
        if(token != null && token != ''){
            headers.put('Authorization', 'Bearer ' + token);
        }
            System.debug('***** Valores headers: ' + headers + ' *****');
        return headers;
    }

    private string callout(string token, Blob reqBody, Map<string, string> headers){
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

    @SuppressWarnings('PMD.VariableNamingConventions')
    private class RespostaTokenTO {
        public String access_token { get; set; }
        public Integer expires_in { get; set; }
        public String token_type { get; set; }
        public String scope { get; set; }
    }
}