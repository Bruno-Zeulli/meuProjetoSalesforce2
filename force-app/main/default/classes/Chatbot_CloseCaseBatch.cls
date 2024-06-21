/**
 * @description       : Fechamento dos casos e retirada dos Beetalk_Contact
 * @author            : pedrotofani@wiz.co
 * @group             :
 * @last modified on  : 10-19-2023
 * @last modified by  : pedrotofani@wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-06-2023      pedrotofani@wiz.co        Initial Version
 **/
public with sharing class Chatbot_CloseCaseBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
		String query = 'SELECT id, beetalk__Status__c, beetalk__IntentName__c, DuringNPS__c, beetalk__Case__r.Status, beetalk__Case__c, MinutesPastOfLastInboundMessage__c, beetalk__LastInboundMessage__r.beetalk__ServerDateTime__c FROM beetalk__Contact__c WHERE DuringNPS__c = false AND (beetalk__IntentName__c = \'\' OR beetalk__IntentName__c = null) AND (beetalk__Case__r.Status != \'Closed\' and beetalk__Case__r.Status != \'Fechado e resolvido\' and beetalk__Case__r.Status != \'Fechado e não resolvido\' ) AND beetalk__Case__c != null AND beetalk__Status__c != \'CLOSED\'';


        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar os registros
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<beetalk__Contact__c> scope){
        executions++;
        List<beetalk__Contact__c> lstBeetalkContact = (List<beetalk__Contact__c>) scope;
        Set<Id> caseIdLst = new Set<Id>();
        List<Case> caseToUpdate = new List<Case>();
        Datetime endDate = Datetime.now();
        Datetime startDate = Datetime.now();
        Timezone tz = Timezone.getTimeZone('GMT-3');
        Long bsHours = 0;

        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Chatbot Encerramento de Caso'];

        for(beetalk__Contact__c con : lstBeetalkContact)
        {
            endDate = endDate.addSeconds(tz.getOffset(endDate) / 1000);

            bsHours = BusinessHours.diff(bh.Id, con.beetalk__LastInboundMessage__r.beetalk__ServerDateTime__c, endDate);

            if(bsHours > 28800000){
                caseIdLst.add(con.beetalk__Case__c);
                con.beetalk__Status__c = 'CLOSED';
                con.beetalk__IntentName__c = '';
                con.DuringNPS__c = false;
                con.beetalk__Case__c = null;
            }
        }

        List<Case> casesBC = [SELECT Id, Status FROM Case WHERE Id IN :caseIdLst];

        for(Case c : casesBC)
        {
            c.Status = 'Closed';
            caseToUpdate.add(c);
        }

        if(!lstBeetalkContact.isEmpty())
        update lstBeetalkContact;

        if(!caseToUpdate.isEmpty())
        update caseToUpdate;
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
        String cronExp0 = '0 0 7-20 * * ?'; // a cada 10 minutos
        String cronExp1 = '0 10 7-20 * * ?'; // a cada 10 minutos
        String cronExp2 = '0 20 7-20 * * ?'; // a cada 10 minutos
        String cronExp3 = '0 30 7-20 * * ?'; // a cada 10 minutos
        String cronExp4 = '0 40 7-20 * * ?'; // a cada 10 minutos
        String cronExp5 = '0 50 7-20 * * ?'; // a cada 10 minutos
        System.schedule('Agendamento chatbot cronExp0 ' + Datetime.now(), cronExp0, new Chatbot_CloseCaseBatch());
        System.schedule('Agendamento chatbot cronExp1 ' + Datetime.now(), cronExp1, new Chatbot_CloseCaseBatch());
        System.schedule('Agendamento chatbot cronExp2 ' + Datetime.now(), cronExp2, new Chatbot_CloseCaseBatch());
        System.schedule('Agendamento chatbot cronExp3 ' + Datetime.now(), cronExp3, new Chatbot_CloseCaseBatch());
        System.schedule('Agendamento chatbot cronExp4 ' + Datetime.now(), cronExp4, new Chatbot_CloseCaseBatch());
        System.schedule('Agendamento chatbot cronExp5 ' + Datetime.now(), cronExp5, new Chatbot_CloseCaseBatch());
    }

    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização
        Chatbot_CloseCaseBatch batch = new Chatbot_CloseCaseBatch();
        Database.executeBatch(batch);
    }
}