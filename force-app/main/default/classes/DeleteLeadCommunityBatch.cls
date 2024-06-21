/**
 * @description       :
 * @author            : pedrotofani@.wiz.co
 * @group             :
 * @last modified on  : 30-09-2023
 * @last modified by  : pedrotofani@.wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  30-09-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public with sharing class DeleteLeadCommunityBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, toDelete__c FROM Lead WHERE ToDelete__c = true';

        return Database.getQueryLocator(query);
    }
    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Lead> scope){
        executions++;
        List<Lead> leadToDelete = new List<Lead>();
        leadToDelete = scope;
        
     Database.delete(leadToDelete,false);
    }
    /**
     * @description finaliza o batch para atualizar os registros
     * @param bC
     */
    public void finish(Database.BatchableContext bC){
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINISHING PROCESS ---------->');
    }
    /**
     * @description agenda o batch para execução
     */
    public static void schedule(){
        String cronExp = '0 0 0 * * ?'; // todos os dias as sete e trinta
        System.schedule('Deletar Lead Community ' + Datetime.now(), cronExp, new DeleteLeadCommunityBatch());
    }
    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização.
        DeleteLeadCommunityBatch batch = new DeleteLeadCommunityBatch();
        Database.executeBatch(batch);
    }
}