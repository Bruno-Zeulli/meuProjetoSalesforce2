/**
 * @description       : Responsável por atualizar o o campo PricebookEntryId e Product2__c do objeto Contract2__c
 * @author            : brunosousa.mirante@wizsolucoes.com.br
 * @group             :
 * Modifications Log
 * Ver   Date         Author                                    Modification
 * 1.0   02-12-2021   brunosousa.mirante@wizsolucoes.com.br     Initial Version
 **/
public with sharing class AssociatePricebookProductToContractBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    /**@description variaveis globais da classe */
    public Integer executions = 0;
    public Map<String, Order> mapOrder = new Map<String,Order>();
    public List<Contract2__c> lContractLst = new List<Contract2__c>();
    /**
    * @description Define a query e inicia o processamento em lote 
    * @param bc
    * @return Database.getQueryLocator(q)
    */
    public List<Contract2__c> start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - AssociatePricebookProductToContractBatch ******');

        lContractLst = [SELECT Id, BidNumber__c, BidStatus__c, Company__c, RecordTypeId, EndorsementNumber__c, ProductCode__c, Product2__c, PricebookEntryId__c
                        FROM Contract2__c 
                        WHERE (PricebookEntryId__c = null OR Product2__c = null) AND ProductCode__c != null];

        return lContractLst;
    }
    /**
    * @description Regras de negocios que manipula os registro Order e Contract
    * @param bc
    * @param scope
    */
    public  void execute(Database.BatchableContext bC, List<sObject> scope){
        system.debug('entrou no batch AssociatePricebookProductToContractBatch');
        executions++;
        Map<Contract2__c, String> lContract2Map = new Map<Contract2__c, String>();
        Set<Id> lContract2Set = new Set<Id>();
        Map<String, Id> lProduct2Map = new Map<String, Id>();
        Map<Id, Id> lOrderMap = new Map<Id, Id>();

        Map<Id, Id> lPricebookEntryProductMap = new Map<Id, Id>();
        Map<String, Id> lPricebookEntryPricebookMap = new Map<String, Id>();

        List<Contract2__c> lContractToUpdateLst = new List<Contract2__c>();
        
        for(Contract2__c ctt : lContractLst){
            lContract2Map.put(ctt, ctt.ProductCode__c);
            lContract2Set.add(ctt.Id);
        }
        //Dados MOCK
        //01s1U000008Gj7QQAS - Pricebook2
        //a0f760000008TqBAAU - Contract2
        //lOpportunityMap.put('a0f760000008TqBAAU', '01s1U000008Gj7QQAS');

        for(Order iOrder : [SELECT Id, Contract2__c, Pricebook2Id FROM Order WHERE Contract2__c IN : lContract2Set]){
            lOrderMap.put(iOrder.Contract2__c, iOrder.Pricebook2Id);
        }
        for(Product2 iProduct2 : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN : lContract2Map.values()]){
            lProduct2Map.put(iProduct2.ProductCode, iProduct2.Id);
        }
        //01t2H000004gL5sQAE - Product2Id
        for(PricebookEntry iPricebookEntry : [SELECT Id, Product2Id, Pricebook2Id, ProductCode FROM PricebookEntry WHERE Product2Id IN : lProduct2Map.values() AND Pricebook2Id IN : lOrderMap.values()]){
            lPricebookEntryProductMap.put(iPricebookEntry.Product2Id, iPricebookEntry.Id);
            lPricebookEntryPricebookMap.put(iPricebookEntry.ProductCode, iPricebookEntry.Id);
        }
        //Atualiza a lista de contratos com Product2__c e PricebookEntryId__c
        for(Contract2__c iContract2 : lContract2Map.keySet()){
            iContract2.Product2__c = lProduct2Map.get(iContract2.ProductCode__c);
            if(lPricebookEntryProductMap.get(lProduct2Map.get(iContract2.ProductCode__c)) != null && lPricebookEntryPricebookMap.get(iContract2.ProductCode__c) != null && lPricebookEntryProductMap.get(lProduct2Map.get(iContract2.ProductCode__c)) == lPricebookEntryPricebookMap.get(iContract2.ProductCode__c)){
                iContract2.PricebookEntryId__c = lPricebookEntryProductMap.get(lProduct2Map.get(iContract2.ProductCode__c));
            }
            lContractToUpdateLst.add(iContract2);
        }
        


        System.debug('Contratos Atualizados: ' + lContractToUpdateLst);
        
        update lContractToUpdateLst;

    }

    /**
    * @description Finaliza o processamento em lote
    * @param bc
    */
    public void finish(Database.BatchableContext bc){
        System.debug('***** FINISHING PROCESS - AssociatePricebookProductToContractBatch ******');
        System.debug('Quantidade de execuções totais: ' + executions);
    }

}