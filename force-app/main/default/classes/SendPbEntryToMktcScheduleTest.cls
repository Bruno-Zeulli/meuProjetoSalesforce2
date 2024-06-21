/**
 * @description       : Agendamento para atualização dos produtos enviado para o marketingcloud
 * @author            : Marcelo Martins
 * @email             : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2022   marcelomartins@wizsolucoes.com.br    Initial Version
 **/

@isTest
public class SendPbEntryToMktcScheduleTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';
    public static String expected;
    public static String actual;

    @isTest
    static void testImplementationSchedule(){
        Test.startTest();
        SendPricebookEntryToMktcSchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new SendPricebookEntryToMktcSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

}