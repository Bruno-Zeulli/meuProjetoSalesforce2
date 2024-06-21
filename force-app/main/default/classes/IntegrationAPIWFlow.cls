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
public with sharing class IntegrationAPIWFlow extends WebserviceREST{
    private static final IntegrationAPIWFlow INSTANCE = new IntegrationAPIWFlow();
    public static final String ENDPOINT_API_VERSION = '/api/v1';
    public static final String ENDPOINT_OPPORTUNITY_SALES = '/opportunities/sales';
    public static final String ENDPOINT_OPPORTUNITY = '/opportunities';
    public static final String ENDPOINT_OPPORTUNITY_UPDATE_WFLOW = '/opportunity-database?opportunityId=';
    public static final String ENDPOINT_QUOTES_APPROVAL = '/api/quotes/approve-quote-item';
    public static final String ENDPOINT_QUOTE_UPDATE_WFLOW = '/api/quotes/quote-sf';


    String accessToken;
    String jsonCredentials;
    String strJSON;

    public static IntegrationAPIWFlow getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> postOpportunitySales(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');        
        
        method = 'POST'; 
        URL = ExternalAPI__c.getValues('APIWFlow').Endpoint__c 
            + ENDPOINT_API_VERSION 
            + ENDPOINT_OPPORTUNITY_SALES;               
        strJSON = Callout(accessToken, serializedParameter, '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> postOpportunityEndorsement(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');                
        
        method = 'POST'; 
        URL = ExternalAPI__c.getValues('APIWFlow').Endpoint__c 
            + ENDPOINT_API_VERSION 
            + ENDPOINT_OPPORTUNITY;               
        strJSON = Callout(accessToken, serializedParameter,  '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> opportunityUpdateInWFlow(String opportunityId){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');       
        
        method = 'GET'; 
        URL = ExternalAPI__c.getValues('APIWFlow').Endpoint__c 
            + ENDPOINT_API_VERSION 
            + ENDPOINT_OPPORTUNITY_SALES
            + ENDPOINT_OPPORTUNITY_UPDATE_WFLOW
            + opportunityId;               
        strJSON = Callout(accessToken, '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> postQuoteUpdateInWFlow(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');     
        
        method = 'POST'; 
        URL = ExternalAPI__c.getValues('APIWFlow').Endpoint__c 
            + ENDPOINT_QUOTE_UPDATE_WFLOW;               
        strJSON = Callout(accessToken, serializedParameter,  '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> postDocument(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');       
        
        method = 'POST'; 
        URL = ExternalAPI__c.getValues('SaveDocumentByOpportunity').Endpoint__c + ExternalAPI__c.getValues('SaveDocumentByOpportunity').ComplementUrl__c;               
        strJSON = Callout(accessToken, serializedParameter,  '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

    public Map<String, Object> putQuoteApproval(String serializedParameter){
        Map<String, Object> results = new Map<String, Object>();
        accessToken = GetAccessTokenUtil.getInstance().getToken('APIWFlow', 'SSO');    
        
        method = 'PUT'; 
        URL = ExternalAPI__c.getValues('APIWFlow').Endpoint__c 
            + ENDPOINT_QUOTES_APPROVAL;               
        strJSON = Callout(accessToken, serializedParameter,  '', '');
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);
        return results;
    }

}