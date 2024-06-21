/**
 * @description       : Agenda execução o batch para todos dos dias as 9 horas
 * @author            : samuelsirkis@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 13-02-20201
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   13-02-20201    Samuel Sirkis       Initial Version
 **/
public with sharing class PTN_ExpiredCleanUpSchedule implements Schedulable {
    private static final String CRON_EXP = '0 0 7 * * ? *'; // Todos os dias às 9 horas da manhã

    /**
     * @description upadate campaing members
     */
    public static void schedule(){
        System.schedule('Agendamento de limpeza por expiração ' + Datetime.now(), CRON_EXP, new PTN_ExpiredCleanUpSchedule());
    }

    /**
     * @description upadate campaing members
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        /**
         *@description chamada do batch para retirada dos Campaign Members
         */
        PTN_ExpiredCleanUpBatch batch = new PTN_ExpiredCleanUpBatch();
        Database.executeBatch(batch);
    }
}