/**
 * @description       : Responsável por agendar o batch de desativação de usuários inativos.
 * @author            : josiasbarros.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 02-06-2022
 * @last modified by  : josiasbarros.mirante@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-06-2021   josiasbarros.mirante@wizsolucoes.com.br   Initial Version
 **/
public without sharing class DeactivateInactiveUserSchedulable implements Schedulable{
/**@description declaração da variável que recebe respectivamente o segundo, minuto, hora, dia do mes, mês, dia da semana e ano que será executado a rotina
    * caso dúvida consulte https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
    */
    private static final String CRON_EXP = '0 0 22 * * ? *'; // Todos os dias às 22 horas 

    /**
    * @description método responsável por agendar a rotina
    */
    public static void schedule(String CRON_EXP){
        System.schedule(    
            'Agendamento para desativação de usuários inativos ' + Datetime.now(),
            CRON_EXP,
            new DeactivateInactiveUserSchedulable()
        );
    }
    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        DeactivateUsersBatch batch = new DeactivateUsersBatch();
        Database.executeBatch(batch);
    }
}