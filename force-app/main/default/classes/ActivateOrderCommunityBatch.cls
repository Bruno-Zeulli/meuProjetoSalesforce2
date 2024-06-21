/**
 * @description       :
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 20-06-2023
 * @last modified by  : samuelsirkis@.wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-06-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public with sharing class ActivateOrderCommunityBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, Status FROM Order WHERE Status = \'Pronto para Confirmar\'';

        return Database.getQueryLocator(query);
    }
    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Order> scope){
        executions++;
        List<Order> ordersUpdate = new List<Order>();
        for(Order o : scope){
            if(o.Status == 'Pronto para Confirmar'){
                o.Status = 'Confirmed';
                ordersUpdate.add(o);
            }
        }
        system.debug(ordersUpdate);
        Database.SaveResult [] updateResult = Database.update(ordersUpdate,false);
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
        System.schedule('Agendamento ativar order community ' + Datetime.now(), cronExp, new ActivateOrderCommunityBatch());
    }
    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização.
        ActivateOrderCommunityBatch batch = new ActivateOrderCommunityBatch();
        Database.executeBatch(batch);
    }
}