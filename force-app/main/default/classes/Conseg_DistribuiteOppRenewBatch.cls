/**
 * @description       : Distribuição das oportunidades com regra de distribuição com cálculo
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 20-06-2023
 * @last modified by  : samuelsirkis@.wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-06-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public with sharing class Conseg_DistribuiteOppRenewBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
         String query = 'SELECT Id FROM Opportunity WHERE Owner.CommunityNickname =\'usuariorenovacao\' AND BusinessUnit__c = \'CONSEG\' AND Type = \'ReNew\' '; 

        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Opportunity> scope){
        executions++;
        List<Opportunity> lstOpportunityUpdate = Conseg_OpportunityBO.distributionOpportunityConsegRemote(scope);
        OpportunityBO.getInstance().lstUpdOpportunities(lstOpportunityUpdate);
        // update lstOpportunityUpdate;
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
     * @description agenda o batch para execução diária ao meio-dia
     */
    public static void schedule(){
        String cronExp = '0 30 7 * * ?'; // todos os dias as sete e trinta
        System.schedule('Agendamento distribuir oportunidade de renovação ' + Datetime.now(), cronExp, new Conseg_OpportunityUpdateOwnerBatch());
    }

    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização.
        Conseg_OpportunityUpdateOwnerBatch batch = new Conseg_OpportunityUpdateOwnerBatch();
        Database.executeBatch(batch);
    }
}