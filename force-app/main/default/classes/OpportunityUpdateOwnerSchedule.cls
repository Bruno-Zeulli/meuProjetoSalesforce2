/**
 * @description       : Agenda execução o batch para todos dos dias as 22 horas
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-20-2022
 * @last modified by  : viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date           Author                                  Modification
 * 1.0   11-20-2022    viniciusazevedo@wizsolucoes.com.br      Initial Version
 **/
public with sharing class OpportunityUpdateOwnerSchedule implements Schedulable {
    /**
     * @description upadate order
     */
    public static void schedule(){
        String cronExp = '0 0 0 * * ?'; // todos os dias à meia noite
        System.schedule('Agendamento Update Opportunity Owner Conseg GM' + Datetime.now(), cronExp, new OpportunityUpdateOwnerSchedule());
    }
    /**
     * @description upadate order
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        /**
         *@description chamada do batch para update status order
         */
        OpportunityUpdateOwnerBatch batch = new OpportunityUpdateOwnerBatch();
        Database.executeBatch(batch);
    }
}