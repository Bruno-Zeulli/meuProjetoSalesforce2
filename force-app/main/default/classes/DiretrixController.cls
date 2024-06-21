/**
 * @description       : Classe controle do componente Diretrix. 
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 07-24-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   07-24-2022   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public without sharing class DiretrixController {

    /**
    * @description recebe a chamada do componente controle e direciona a variável identificationNumber 
    * para o service que realizará a chama para a API Diretrix. 
    * @param identificationNumber recebe uma string com o valor do CNPJ.
    * @return retorna uma string com o objeto do retorno da chamada API Diretrix em Json. 
    */
    @AuraEnabled
    public static string findCompanyByIndentificationNumber(String identificationNumber){
         try{
            return JSON.serialize(DiretrixService.getInstance().findCompanyByIndentificationNumber(identificationNumber));     
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Lead getIdentificationNumber(String recordId){
         return [SELECT Id, IdentificationNumber__c FROM Lead WHERE Id =:recordId LIMIT 1];
    }
}