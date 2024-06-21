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
public with sharing class PTN_RetentionCampaignLoadImovelScl implements Schedulable {
    /**
     * @description upadate campaing members
     */
    public static void schedule(String cronExp){

        String cronExpDefaut = '0 0 4 1 * ? *'; // Sempre dia 02 de cada mês às 4 horas da manhã

        if(cronExp != null){
            cronExp = cronExpDefaut;
        }
        System.schedule('Agendamento de carga de retenção Imóvel' + Datetime.now(), cronExp, new PTN_RetentionCampaignLoadImovelScl());
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