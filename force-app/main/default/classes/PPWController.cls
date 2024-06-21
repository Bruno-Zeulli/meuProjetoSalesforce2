public with sharing class PPWController {
    @AuraEnabled(cacheable=true)
    public static String getInformationPPW(){
        Map<String, String> informationPPW = new Map<String, String>();

        String URL = ExternalAPI__c.getValues('BuscarEmpresaParceiro').Endpoint__c + ExternalAPI__c.getValues('BuscarEmpresaParceiro').ComplementUrl__c;
        String token = PPWService.getInstance().executeCallout();

        informationPPW.put('urlGetCompanies', URL);
        informationPPW.put('token', token);

        return JSON.serialize(informationPPW);
    }
}