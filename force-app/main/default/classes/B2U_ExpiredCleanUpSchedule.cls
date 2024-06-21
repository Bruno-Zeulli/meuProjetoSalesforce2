/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 11-04-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

public with sharing class B2U_ExpiredCleanUpSchedule implements Schedulable {
    private static final String CRON_EXP = '0 0 10 * * ? *'; // Todos os dias às 10 horas da manhã

    public static void schedule(){
        System.schedule(
        'Agendamento de limpeza por expiração ' + Datetime.now(),
        CRON_EXP,
        new B2U_ExpiredCleanUpSchedule()
        );
    }

    public void execute(SchedulableContext ctx){
        B2U_ExpiredCleanUpBatch batch = new B2U_ExpiredCleanUpBatch();
        Database.executeBatch(batch);
    }
}