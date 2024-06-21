/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   12-11-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 *  1.2   02-11-2022   marcelomartins@wizsolucoes.com.br    Refactore and insert send products to data extension mkt clould
 **/
public class CallMktCloudRest extends WebserviceREST {
    private static final CallMktCloudRest INSTANCE = new CallMktCloudRest();
    private static final String ENDPOINT_DATA_EXTENSIONS = '/data/v1/async/dataextensions/key:';
    private static final String ENDPOINT_ROWS = '/rows';

    String accessToken;
    String jsonCredentials;
    String strJSON;

    public static CallMktCloudRest getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> postMktCloudRest(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();        
        String apiName = 'MarketingCloudAuth';
        String ssoName = apiName;
        
        accessToken = GetAccessTokenUtil.getInstance().getToken(apiName, ssoName);

        method = 'POST'; 
        URL = ExternalAPI__c.getValues('MarketingCloud').Endpoint__C;              
        strJSON = Callout(accessToken, serializedParameter, '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> postSendProductsCorporateToMktCloud(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        String apiNameAuth = 'MarketingCloudAuth';
        String ssoName = apiNameAuth;
        ExternalAPI__c externalAPIData = ExternalAPI__c.getValues('MktCloudDataExtentionsProductCorporate');
        
        accessToken = GetAccessTokenUtil.getInstance().getToken(apiNameAuth, ssoName);

        method = 'PUT'; 
        URL = externalAPIData.Endpoint__C
            + ENDPOINT_DATA_EXTENSIONS
            + externalAPIData.EventKey__c
            + ENDPOINT_ROWS;
        
        strJSON = Callout(accessToken, serializedParameter, '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    } 
}