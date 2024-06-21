/**
 * @description       :
 * @author            : marcelomartins@wizsoluceos.com.br
 * @group             :
 * @last modified on  : 10-29-2022
 * @last modified by  : marcelomartins@wizsoluceos.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   10-29-2022   marcelomartins@wizsoluceos.com.br    Initial Version
 **/
public with sharing class PTN_RetentionCampaignLoadingAutoSchedule implements Schedulable {

    /**
     * @description upadate campaing members
     */
    public static void schedule(String cronExp){

        String cronExpDefaut = '0 0 21 4 * ? *'; // Sempre dia 04 de cada mês às 21 horas da noite

        if(cronExp != null){
            cronExp = cronExpDefaut;
        }

        System.schedule('Agendamento de carga de retenção Auto' + Datetime.now(), cronExp, new PTN_RetentionCampaignLoadingAutoSchedule());
    }

    /**
     * @description upadate campaing members
     * @param ctx
     */
    public void execute(SchedulableContext ctx){
        /**
         *@description chamada do batch para inclusão dos Campaign Members
         */
        PTN_RetentionCampaignLoadingBatch batch = new PTN_RetentionCampaignLoadingBatch();
        Database.executeBatch(batch);
    }
}