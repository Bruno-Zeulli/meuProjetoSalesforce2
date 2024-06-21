/**
 * @description       :
 * @author            : Bruno Pereira
 * @email             : brunosousa.mirante@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   01-03-2022   Bruno Pereira                        Initial Version
 * 1.1   02-11-2022   marcelomartins@wizsolucoes.com.br    Refactore and insert send products to data extension mkt clould
 **/
public without sharing class GetAccessTokenUtil extends WebserviceREST {
    private static final GetAccessTokenUtil INSTANCE = new GetAccessTokenUtil();

    public static GetAccessTokenUtil getInstance(){
        return INSTANCE;
    }
    String accessToken;
    String jsonCredentials;
    String strJSON;

    public String getToken(String apiName, String ssoName){
        String token;
        if(!Test.isRunningTest()){
            if(Cache.org.contains(apiName)){
                token = (String) Cache.org.get(apiName);
            }else{
                GetAccessTokenTO.ResponseToken responseGetToken = (GetAccessTokenTO.ResponseToken) JSON.deserialize(getAccessToken(apiName, ssoName), GetAccessTokenTO.ResponseToken.class);

                if(responseGetToken != null){
                    Cache.Org.put(apiName, responseGetToken.access_token, responseGetToken.expires_in);
                    token = responseGetToken.access_token;
                }
            }
        }
        if(Test.isRunningTest()){
            String responseGetToken = getAccessToken(apiName, ssoName);
        }

        return token;
    }

    private String getAccessToken(String apiName, String ssoName){
        String credentials;
        String contentType;
        method = 'POST';
        URL = ExternalAPI__c.getValues(ssoName).Endpoint__c;

        switch on apiName {

            when 'MarketingCloudAuth' {

                GetAccessTokenTO.loginCredentialsMktCloud credentialsMktC = new GetAccessTokenTO.loginCredentialsMktCloud();
                credentialsMktC.grant_type = ExternalAPI__c.getValues(apiName).GrantType__c;
                credentialsMktC.client_id = ExternalAPI__c.getValues(apiName).ClientID__c;
                credentialsMktC.client_secret = ExternalAPI__c.getValues(apiName).ClientSecret__c;
                credentialsMktC.account_id = ExternalAPI__c.getValues(apiName).AccountId__c;

                credentials = JSON.serialize(credentialsMktC);
            }

            when else{

                contentType = ContentType__C.getValues('x-www-form-urlencoded').Template__c;

                credentials = 'grant_type={0}&client_id={1}&client_secret={2}&scope={3}';
                credentials = credentials.replace('{0}', ExternalAPI__c.getValues(apiName).GrantType__c);
                credentials = credentials.replace('{1}', ExternalAPI__c.getValues(apiName).ClientID__c);
                credentials = credentials.replace('{2}', ExternalAPI__c.getValues(apiName).ClientSecret__c);
                credentials = credentials.replace('{3}', ExternalAPI__c.getValues(apiName).Scope__c);
            }
        }

        System.debug('Credentials: ' + credentials);

        strJSON = Callout(accessToken, credentials, contentType, '');
        System.debug('Retorno login na API: ' + strJSON);

        if(String.isNotEmpty(strJSON)){
            if(StatusCode == 200){
                return strJSON;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
}