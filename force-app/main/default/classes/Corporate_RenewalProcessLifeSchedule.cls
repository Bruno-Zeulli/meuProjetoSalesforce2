/**
 * @description       : Agenda quando deve ser executado a rotina que criar as oportunidades de renovação
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 29-12-2022
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   29-12-2022     Marcelo Martins     Initial Version
 **/
public without sharing class Corporate_RenewalProcessLifeSchedule implements Schedulable {
    /**
     * @description
     */
    public static void schedule(String cronExp){

        String cronExpDefaut = '0 10 12 * * ? *'; // todos os dias às 4 horas da manhã

        if(cronExp != null){
            cronExp = cronExpDefaut;
        }
        System.schedule('Agendamento de rotina de renovação vida Corporate Benefícios' + Datetime.now(), cronExp, new Corporate_RenewalProcessLifeSchedule());
    }

    /**
     * @description
     */
    public void execute(SchedulableContext ctx){
        /**
         *@description
         */
        Corporate_RenewalProcessLifeBatch batch = new Corporate_RenewalProcessLifeBatch();
        Database.executeBatch(batch);
    }
}