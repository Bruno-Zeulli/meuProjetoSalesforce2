/**
 * @description       : Atualiza detalhe de contato
 * @author            : Samuel Sirkis
 * @group             :
 * @last modified on  : 08-04-2022
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   08-04-2022   Samuel Sirkis   Initial Version
 **/
public with sharing class ContactDetailUpdateBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os deteales de contato  atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, Name, Source__c FROM contactDetail__c WHERE Source__c != null AND Source__c != \'Parceiros\' AND RecordType.Name != \'Parceiros\'';

        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar o contact detail
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        /** @description upadate contact details */
        executions++;
        List<ContactDetail__c> lstContactDetails = (List<ContactDetail__c>) scope;
        for(ContactDetail__c ctd : lstContactDetails){
            String source = ctd.Source__c;
            ctd.Source__c = source;
        }
        update lstContactDetails;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINISHING PROCESS ---------->');
    }
}