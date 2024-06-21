/**
 * @description       : Agenda quando deve ser executado a rotina que atualiza o pedido e vincula o contrato ao pedido correspondente
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   06-08-2021     Marcelo Martins     Initial Version
 **/
public with sharing class AssociateContractToOrderSchedule implements Schedulable{
    /**@description declaração da variável que recebe respectivamente o segundo, minuto, hora, dia do mes, mês, dia da semana e ano que será executado a rotina
    * caso dúvida consulte https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
    */
    private static final String CRON_EXP = '0 0 09 * * ? *'; // Todos os dias às 09 horas da manhã

    /**
    * @description método responsável por agendar a rotina
    */
    public static void schedule(){
        System.schedule(
            'Agendamento para atualização e vinculação dos contratos aos pedidos ' + Datetime.now(),
            CRON_EXP,
            new AssociateContractToOrderSchedule()
        );
    }

    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        AssociateContractToOrderBatch batch = new AssociateContractToOrderBatch();
        Database.executeBatch(batch);
    }
}