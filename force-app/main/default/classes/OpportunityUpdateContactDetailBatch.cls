/**
* @description       : Atualiza Oportunidade com Detalhe de Contato
* @author            : matheusmelo@wiz.co
* @last modified on  : 01-15-2024
* @last modified by  : matheusmelo@wiz.co
* Modifications Log
* Ver   Date         Author                          Modification
* 1.0   01-15-2024   matheusmelo@wiz.co              Initial Version
**/
 
public with sharing class OpportunityUpdateContactDetailBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // Contador de execuções
    public Integer executions = 0;
    /**
     * Inicia o processo de lote.
     * @param bC - Contexto do lote.
     * @return QueryLocator com as oportunidades a serem processadas.
     */

    public Database.QueryLocator start(Database.BatchableContext bC) {
        System.debug('<---------- INICIANDO O PROCESSO ---------->');
        // Query para selecionar Oportunidades específicas para atualização
        String query = 'SELECT Id, AccountId, ContactDetail__c, ContactId FROM Opportunity WHERE RecordType.Name= \'Conseg\' and CreatedDate >= 2023-10-01T00:00:00.000-03:00 and ContactDetail__c = null';
        return Database.getQueryLocator(query);
    }
 
    /**
     * Executa o processo de atualização das Oportunidades.
     * @param bC - Contexto do lote.
     * @param scope - Lista das Oportunidades a serem processadas.
     */

    public void execute(Database.BatchableContext bC, List<Opportunity> scope) { 
        System.debug('Batch Execution - Start');
        System.debug('Scope: Size: ' + scope.size());
        // Mapeia os AccountIds das Opportunities no escopo
        Set<Id> accountIds = new Set<Id>();
        // Mapeia os ContactIds associados às Opportunities no escopo
        Set<Id> contactIds = new Set<Id>();
        for(Opportunity opp : scope) {
            accountIds.add(opp.AccountId);
        }
 
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();
        for (Contact contcontract : [SELECT Id, AccountId FROM Contact WHERE AccountId IN:accountIds]){
            accountIdToContact.put(contcontract.AccountId, contcontract);
            contactIds.add(contcontract.Id);
        }
        
        // Consulta os ContactDetails associados aos ContactIds

        Map<Id, ContactDetail__c> contactIdToContactDetails = new Map<Id, ContactDetail__c>();
        for (ContactDetail__c contdetail : [SELECT Id, Contact__c FROM ContactDetail__c WHERE Contact__c IN:contactIds]) {
        contactIdToContactDetails.put(contdetail.Contact__c, contdetail);
        }
        System.debug('Mapa de detalhe de contato: ');
        System.debug(contactIdToContactDetails);
        // Atualiza as Opportunities com os ContactDetails correspondentes
		//O auxiliar é o ContactId
        for(Opportunity opp : scope) {
            System.debug('Entrou no for: ' + opp);
            if (accountIdToContact.get(opp.AccountId)!= null) {
                System.debug('Entrou no if1: ' + accountIdToContact.get(opp.AccountId));
                Id auxiliar = ((contact)accountIdToContact.get(opp.AccountId)).Id;
                if (contactIdToContactDetails.get(auxiliar) != null){
                    System.debug('Entrou no if2: ' + contactIdToContactDetails.get(auxiliar));
                 	opp.ContactDetail__c = ((ContactDetail__c)contactIdToContactDetails.get(auxiliar)).Id;
                }
            }
        }
        for (Opportunity opp : scope){
           System.debug('teste: ' + opp.ContactDetail__c); 
        }
        update scope;
        System.debug('Batch Execution - End');
        executions++;
    }
 
    /**
     * Finaliza o processo de lote, exibindo informações sobre as execuções.
     * @param bC - Contexto do lote.
     */

    public void finish(Database.BatchableContext bC) {
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINALIZANDO O PROCESSO ---------->');
    }
}