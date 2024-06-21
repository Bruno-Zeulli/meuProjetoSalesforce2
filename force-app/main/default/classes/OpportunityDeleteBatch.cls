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
public with sharing class OpportunityDeleteBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os pedidos para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        Date dateQuery = Date.today().addDays(-30);
        
        if(Test.isRunningTest()){
            String query = 'SELECT Id, StageName FROM Opportunity WHERE RecordType.Name = \'Conseg\' AND Type = \'MechanicalWarranty\' AND CreatedDate < :dateQuery AND StageName = \'Aberto\'';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, StageName FROM Opportunity WHERE RecordType.Name = \'Conseg\' AND Type = \'MechanicalWarranty\' AND CreatedDate < :dateQuery AND LastModifiedDate < :dateQuery AND StageName = \'Aberto\'';
            return Database.getQueryLocator(query);
        }
    }

    /**
     * @description executa o batch para atualizar o status do pedido
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Opportunity> scope){
        
        List<Opportunity> lstOpportunityDelete = new List<Opportunity>();
        List<Opportunity> lstOpportunity = (List<Opportunity>) scope;
        
        for(Opportunity objOpp : lstOpportunity){
            lstOpportunityDelete.add(objOpp);
            executions ++;
        }
        delete lstOpportunityDelete;
    }
    
    public void finish(Database.BatchableContext bC){
        System.debug('<---------- FINISHING PROCESS ---------->');
        System.debug('executions: ' + executions);
    }
}