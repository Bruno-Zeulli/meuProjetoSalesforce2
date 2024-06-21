/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             : Wiz Solucoes
 * @last modified on  : 07-25-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   07-25-2022   marcelomartins@wizsolucoes.com.br     Initial Version
 **/
public with sharing class IntegrationAPIDiretrix extends WebserviceREST {
    private static final IntegrationAPIDiretrix INSTANCE = new IntegrationAPIDiretrix();
    String strJSON;

    public static IntegrationAPIDiretrix getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> getCompanyByIndentificationNumber(String identificationNumber){
        Map<String, Object> results = new Map<String, Object>();

        ExternalAPI__c apiDiretrix;
        apiDiretrix = ExternalAPI__c.getValues('Diretrix');
        
        DiretrixTO.DiretrixBodyModel modelBody = new DiretrixTO.DiretrixBodyModel(
            apiDiretrix.User__c,
            apiDiretrix.Password__c,
            apiDiretrix.AccountId__c,
            identificationNumber,
            apiDiretrix.ClientID__c
        );  
        
        String body = JSON.serialize(modelBody);

        method = 'POST'; 
        URL = apiDiretrix.Endpoint__c;
        
        strJSON = Callout(null, body, null, null);
        results.put('WSResponseStatusCode', StatusCode);
        validationStatus(results, strJSON);        
        return results;
    }
}