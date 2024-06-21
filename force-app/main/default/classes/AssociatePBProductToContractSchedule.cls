/**
 * @description       : Agenda quando deve ser executado a rotina que atualiza o campos Pricebook2Id e Product2Id do contrato
 * @author            : brunosousa.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 20-12-2021
 * @last modified by  : Bruno Pereira
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   06-08-2021     Bruno Pereira       Initial Version
 **/
public with sharing class AssociatePBProductToContractSchedule implements Schedulable{
    /**@description declaração da variável que recebe respectivamente o segundo, minuto, hora, dia do mes, mês, dia da semana e ano que será executado a rotina
    * caso dúvida consulte https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
    */
    private static final String CRON_EXP = '0 0 10 * * ? *'; // Todos os dias às 10 horas da manhã
    
    /**
    * @description método responsável por agendar a rotina
    */
    public static void schedule(){
        System.schedule(    
            'Agendamento para atualização e vinculação dos campos Pricebook2Id e Product2Id dos contratos ' + Datetime.now(),
            CRON_EXP,
            new AssociatePBProductToContractSchedule()
        );
    }
    
    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        AssociatePricebookProductToContractBatch batch = new AssociatePricebookProductToContractBatch();
        Database.executeBatch(batch);
    }
}