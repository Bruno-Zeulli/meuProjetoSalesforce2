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
public with sharing class OpportunityRenewVincendosSchedule implements Schedulable {
    /**
     * @description  criate opp type renew
     */
    public static void schedule(){
        String cronExp = '0 0 7 * * ?'; // todos os dias à 7h da manhã
        System.schedule('Agendamento criação de oportunidades vincendo para renovação ' + Datetime.now(), cronExp, new OpportunityRenewVincendosSchedule());
    }
    /**
     * @description criate opp type renew
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        /**
         *@description chamada do batch para criar opp tipo renovação conseg
         */
        OpportunityRenewVincendosBatch batch = new OpportunityRenewVincendosBatch();
        Database.executeBatch(batch);
    }
}