/**
 * @description       : Distribuição das oportunidades com regra de distribuição com cálculo
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 09-27-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-06-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public with sharing class Chatbot_CustomerInQueueBatch implements Schedulable, Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os registros para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        Datetime now = Datetime.now();
        Datetime nowSubstract = now.addMinutes(-60);
        String query = 'select beetalk__Status__c, beetalk__IntentName__c, DuringNPS__c from beetalk__Contact__c where (beetalk__IntentName__c <> null or DuringNPS__c = true) and LastModifiedDate < : nowSubstract';

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
        for(beetalk__Contact__c con : lstBeetalkContact){
            con.beetalk__Status__c = 'CLOSED';
            con.beetalk__IntentName__c = '';
            con.DuringNPS__c = false;
        }
        update lstBeetalkContact;
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
     * @description agenda o batch para execução a cada 10 minutos
     */
    public static void schedule(){
        String cronExp0 = '0 0 7-20 * * ?'; // a cada 10 minutos
        String cronExp1 = '0 10 7-20 * * ?'; // a cada 10 minutos
        String cronExp2 = '0 20 7-20 * * ?'; // a cada 10 minutos
        String cronExp3 = '0 30 7-20 * * ?'; // a cada 10 minutos
        String cronExp4 = '0 40 7-20 * * ?'; // a cada 10 minutos
        String cronExp5 = '0 50 7-20 * * ?'; // a cada 10 minutos
        System.schedule('Agendamento chatbot cronExp0 ' + Datetime.now(), cronExp0, new Chatbot_CustomerInQueueBatch());
        System.schedule('Agendamento chatbot cronExp1 ' + Datetime.now(), cronExp1, new Chatbot_CustomerInQueueBatch());
        System.schedule('Agendamento chatbot cronExp2 ' + Datetime.now(), cronExp2, new Chatbot_CustomerInQueueBatch());
        System.schedule('Agendamento chatbot cronExp3 ' + Datetime.now(), cronExp3, new Chatbot_CustomerInQueueBatch());
        System.schedule('Agendamento chatbot cronExp4 ' + Datetime.now(), cronExp4, new Chatbot_CustomerInQueueBatch());
        System.schedule('Agendamento chatbot cronExp5 ' + Datetime.now(), cronExp5, new Chatbot_CustomerInQueueBatch());
    }

    /**
     * @description executa o batch através do agendador
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        // chamada do batch para atualização
        Chatbot_CustomerInQueueBatch batch = new Chatbot_CustomerInQueueBatch();
        Database.executeBatch(batch);
    }
}