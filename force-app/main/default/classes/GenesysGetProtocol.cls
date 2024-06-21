public with sharing class GenesysGetProtocol {
    @AuraEnabled
    public static String getProtocol(String recordId){
        String retorno;
        try {
            retorno = [SELECT Id, Name FROM CallLog__c WHERE Id = :recordId].Name;
        } catch (Exception e){
            System.debug('Erro: ' + e);
        }

        return retorno;
    }
}