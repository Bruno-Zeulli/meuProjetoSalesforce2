public with sharing class PPWService  extends WebserviceREST {
    /**
    * @description declaração de variaveis */
    private static final PPWService INSTANCE = new PPWService();
    String accessToken;
    String jsonCredentials;
    String strJSON;
    String tokenPPW = '';


    /**
    * @description constroi a instancia da classe PPWService
    * @return instancia da classe PPWService
    */

    public static PPWService getInstance(){
        return INSTANCE;
    }


    public String executeCallout(){
            String tokenPPW =  getAccessToken();
            return tokenPPW;
  }


   private String getAccessToken(){
        method = 'POST';
        URL = ExternalAPI__c.getValues('PPWToken').Endpoint__c + ExternalAPI__c.getValues('PPWToken').ComplementUrl__c;

        String credentials = createBodyFormDataPPW();

        System.debug('jsonCredentials: ' + credentials);


        strJSON = Utils.callout(accessToken, Blob.valueOf(credentials), new Map<string, string>(), method, URL);
        System.debug('Retorno login API PPW : ' + strJSON);

        if(String.isNotEmpty(strJSON)){
            return strJSON;
        }else{
            return null;
        }
    }


    private String createBodyFormDataPPW(){
        String credentials = 'grant_type={0}&username={1}&password={2}&client_id={3}&client_secret={4}';
        credentials = credentials.replace('{0}', ExternalAPI__c.getValues('PPWToken').GrantType__c);
        credentials = credentials.replace('{1}', ExternalAPI__c.getValues('PPWToken').User__c);
        credentials = credentials.replace('{2}', ExternalAPI__c.getValues('PPWToken').Password__c);
        credentials = credentials.replace('{3}', ExternalAPI__c.getValues('PPWToken').ClientID__c);
        credentials = credentials.replace('{4}', ExternalAPI__c.getValues('PPWToken').ClientSecret__c);

        return credentials;
    }

}