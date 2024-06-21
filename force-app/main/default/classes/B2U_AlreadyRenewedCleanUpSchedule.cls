/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public with sharing class B2U_AlreadyRenewedCleanUpSchedule implements Schedulable {
  private static final String CRON_EXP = '0 0 8 * * ? *'; // Todos os dias às 8 horas da manhã
  private static final String CRON_EXP2 = '0 0 20 * * ? *'; // Todos os dias às 8 horas da noite

  public static void schedule(){
    System.schedule(
      'Agendamento de limpeza de renovados 1 ' + Datetime.now(),
      CRON_EXP,
      new B2U_AlreadyRenewedCleanUpSchedule()
    );
    System.schedule(
      'Agendamento de limpeza de renovados 2 ' + Datetime.now(),
      CRON_EXP2,
      new B2U_AlreadyRenewedCleanUpSchedule()
    );
  }

  public void execute(SchedulableContext ctx){
    B2U_AlreadyRenewedCleanUpBatch batch = new B2U_AlreadyRenewedCleanUpBatch();
    Database.executeBatch(batch);
  }
}