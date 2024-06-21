/**
 * @description       : Remove membro da campanha pelo agendamento
 * @author            : samuelsirkis@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 13-02-20201
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   13-02-20201   Samuel Sirkis   Initial Version
 **/
public with sharing class PTN_ExpiredCleanUpBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description Busca campaing members
     * @return all campaing member CONSORCIOS BV PARCEIROS
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - ExpiredCleanUpBatch ******');

        Date dateAWeekAgo = System.today().addDays(-30);
        String q =
            'SELECT Id, IntegrationStatus__c FROM CampaignMember ' +
            'WHERE Campaign.RecordType.Name = \'Parceiros - Campaign\' AND Campaign.Type = \'Call Center Ativo\' AND IntegrationStatus__c = \'Enviado\' AND LastModifiedDate <= :dateAWeekAgo ';

        return Database.getQueryLocator(q);
    }

    /**
     * @description executa o batch para atualizar o integration status
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<sObject> scope){
        /**
         * @description upadate campaing members
         */
        executions++;
        List<CampaignMember> lCampaignMembers = (List<CampaignMember>) scope;
        for(CampaignMember cm : lCampaignMembers){
            cm.IntegrationStatus__c = 'Retirado';
        }
        update lCampaignMembers;
    }

    /**
     * @description log debug para informar finalizar a execução
     * @param bC
     */
    public void finish(Database.BatchableContext bC){
        System.debug('***** FINISHING PROCESS - ExpiredCleanUpBatch ******');
        System.debug('Quantidade de execuções totais: ' + executions);
    }
}