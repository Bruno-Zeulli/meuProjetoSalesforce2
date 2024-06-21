/**
 * @description       : Agenda quando deve ser executado a rotina que apaga os call logs duplicados por reference id
 * @author            : italosilva.mirante@wiz.co
 * @group             :
 * @last modified on  : 02-08-2024
 * @last modified by  : Italo Ramillys
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   02-08-2024     Italo Ramillys     Initial Version
 **/
public with sharing class DeleteDuplicateCallLogsSchedule implements Schedulable{
    /**@description declaração da variável que recebe respectivamente o segundo, minuto, hora, dia do mes, mês, dia da semana e ano que será executado a rotina
    * caso dúvida consulte https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
    *   
        DeleteDuplicateCallLogsSchedule p = new DeleteDuplicateCallLogsSchedule();
        String CRON_EXP = '0 50 * * * ? *'; // No minuto 50 de cada hora
        System.schedule('Delete CallLogs duplicados por ReferenceId', CRON_EXP, p);
    */
    

    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        new DeleteDuplicateCallLogsService().execute();
    }
}