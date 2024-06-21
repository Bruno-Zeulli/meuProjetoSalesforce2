/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-20-2022
 * @last modified by  : viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2022   viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
public with sharing class OpportunityUpdateOwnerBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os pedidos para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, Estrategia5__c, OwnerId FROM Opportunity WHERE Type = \'MechanicalWarranty\' AND Estrategia5__c != null AND Owner.UserType = \'Standard\' AND (StageName = \'Fechado e ganho\' OR StageName = \'Fechado e perdido\') AND RecordType.DeveloperName = \'Conseg\'';
        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar o status do pedido
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Opportunity> scope){
        /** @description upadate order */
        executions++;
        List<Opportunity> lstOpportunityUpdate = new List<Opportunity>();
        List<Opportunity> lstOpportunity = (List<Opportunity>) scope;
        for(Opportunity objOpp : lstOpportunity){
                objOpp.OwnerId = objOpp.Estrategia5__c;
                lstOpportunityUpdate.add(objOpp);

        }
        update lstOpportunityUpdate;
    }

    public void finish(Database.BatchableContext bC){
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINISHING PROCESS ---------->');
    }
}