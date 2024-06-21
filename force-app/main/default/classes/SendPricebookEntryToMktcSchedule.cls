/**
 * @description       : Agendamento para atualização dos produtos enviado para o marketingcloud
 * @author            : Marcelo Martins
 * @email             : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2022   marcelomartins@wizsolucoes.com.br    Initial Version
 **/
public without sharing class SendPricebookEntryToMktcSchedule implements Schedulable {
    
    private static final String CRON_EXP = '0 0 21 ? * SUN'; //Todos os domingos às 21 horas da noite
    
     /**
    * @description método responsável por agendar a rotina
    */
    public static void schedule(){
        System.schedule(    
            'Agendamento para atualização dos produtos enviado para o marketingcloud' + Datetime.now(),
            CRON_EXP,
            new SendPricebookEntryToMktcSchedule()
        );
    }
    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        MarketingCloudHandler.sendProductToMarketingcloud();
    }
}