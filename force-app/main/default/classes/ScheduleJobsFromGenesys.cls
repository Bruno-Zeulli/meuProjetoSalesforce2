/**
 * @description       : Agenda as classes AbandonedCalls e NPS, para que seja armazenado esses dados
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 27-11-2023
 * @last modified by  : joao@beecloud.com.br
 * ExecuteSchedule    : System.schedule('ScheduledGenesysNPSAndAbandonedCalls', cronTime, new ScheduleJobsFromGenesys());
 * CronTimeHourByHour : String cronTime = '0 0 * * * ?';
**/
global class ScheduleJobsFromGenesys implements Schedulable {
    global void execute(SchedulableContext context){
        AbandonedCalls.insertAbandonedCalls();
        String jobId = Database.executeBatch(new NPSBatchable(), 95);
    }
}