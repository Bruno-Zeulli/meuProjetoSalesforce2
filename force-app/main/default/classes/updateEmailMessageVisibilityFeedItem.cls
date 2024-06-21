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
public with sharing class updateEmailMessageVisibilityFeedItem implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, Type, Visibility FROM FeedItem WHERE Visibility = \'InternalUsers\' AND Type = \'EmailMessageEvent\'';

        return Database.getQueryLocator(query);
    }
    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<FeedItem> scope){
        executions++;
        List<FeedItem> feedItemToUpdate = new List<FeedItem>();
        for(FeedItem o : scope){
            if(o.Visibility == 'InternalUsers'){
                o.Visibility = 'AllUsers';
                feedItemToUpdate.add(o);
            }
        }
        system.debug(feedItemToUpdate);
        Database.SaveResult [] updateResult = Database.update(feedItemToUpdate,false);
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
        System.schedule('Agendamento ativar FeedItem ' + Datetime.now(), cronExp, new updateEmailMessageVisibilityFeedItem());
    }
    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização.
        updateEmailMessageVisibilityFeedItem batch = new updateEmailMessageVisibilityFeedItem();
        Database.executeBatch(batch);
    }
}