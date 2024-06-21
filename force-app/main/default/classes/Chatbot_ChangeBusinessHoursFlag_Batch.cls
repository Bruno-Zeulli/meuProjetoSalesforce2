/**
 * @description       : Muda a flag para forcar update no beetalk contact
 * @author            : pedrotofani@wiz.co
 * @group             :
 * @last modified on  : 15-12-2023
 * @last modified by  : pedrotofani@wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  15-12-2023      pedrotofani@wiz.co        Initial Version
 **/
public with sharing class Chatbot_ChangeBusinessHoursFlag_Batch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
		String query = 'SELECT id, beetalk__Status__c, beetalk__IntentName__c, DuringNPS__c, beetalk__Case__r.Status, beetalk__Case__c, MinutesPastOfLastInboundMessage__c, beetalk__LastInboundMessage__r.beetalk__ServerDateTime__c, beetalk_Business_Hours_Exceeded_Flag__c FROM beetalk__Contact__c WHERE MinutesPastOfLastInboundMessage__c >= 1440 AND DuringNPS__c = false AND (beetalk__IntentName__c = \'\' OR beetalk__IntentName__c = null) AND (beetalk__Case__r.Status != \'Closed\' and beetalk__Case__r.Status != \'Fechado e resolvido\' and beetalk__Case__r.Status != \'Fechado e não resolvido\' ) AND beetalk__Case__c != null AND beetalk__Status__c != \'CLOSED\'  Order by LastModifiedDate ASC  LIMIT 200';


        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<beetalk__Contact__c> scope)
    {
        executions++;
        List<beetalk__Contact__c> lstBeetalkContact = (List<beetalk__Contact__c>) scope;
        List<beetalk__Contact__c> beetalkContactToUpdate = new List<beetalk__Contact__c>();


        for (beetalk__Contact__c bcc : lstBeetalkContact)
        {
            if( bcc.beetalk_Business_Hours_Exceeded_Flag__c == true)
            bcc.beetalk_Business_Hours_Exceeded_Flag__c = false;
            else
             bcc.beetalk_Business_Hours_Exceeded_Flag__c = true;

            beetalkContactToUpdate.add(bcc);
        }

        if(!beetalkContactToUpdate.isEmpty())
        update beetalkContactToUpdate;

    }

    /**
     * @description finaliza o batch para atualizar os registros
     * @param bC
     */
    public void finish(Database.BatchableContext bC){
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<------------- FINISHING PROCESS ------------->');
    }

    /**
     * @description agenda o batch para execução a cada 10 minutos
     */
    public static void schedule(){

    }

    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização
        Chatbot_ChangeBusinessHoursFlag_Batch batch = new Chatbot_ChangeBusinessHoursFlag_Batch();
        Database.executeBatch(batch);
    }
}