/**
 * @description       : Agenda quando deve ser executado a rotina que envia ao CTI os CM com task de agendamento de contato não realizada
 * @author            : marcelomartins@wiz.co
 * @group             :
 * @last modified on  : 04-04-2021
 * @last modified by  : Marcelo Martins
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   04-03-2021     Marcelo Martins     Initial Version
 **/
public with sharing class B2U_ResendContactsScheduledToCTISchedule implements Schedulable {
  /**@description declaração da variável que recebe respectivamente o segundo, minuto, hora, dia do mes, mês, dia da semana e ano que será executado a rotina
   * caso dúvida consulte https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
   */
  private static final String CRON_EXP = '0 0 23 * * ? *'; // Todos os dias às 11 horas da noite

  /**
   * @description método responsável por agendar a rotina
   */
  public static void schedule(){
    System.schedule(
      'Agendamento de reenvio dos CM com contatos agendados para o CTI ' + Datetime.now(),
      CRON_EXP,
      new B2U_ResendContactsScheduledToCTISchedule()
    );
  }

  /**
   * @description método responsável por excutar a rotina
   *  @param ctx recebe o contexto do agendamento
   */
  public void execute(SchedulableContext ctx){
    ManipulateTaskBasedCampaignMember.getTaskSchedulingContact();
  }
}