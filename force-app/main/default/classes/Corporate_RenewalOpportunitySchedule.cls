public with sharing class Corporate_RenewalOpportunitySchedule implements Schedulable {
    public void execute(SchedulableContext ctx){
        Database.executeBatch(new Corporate_RenewalOpportunityBatch(),40);
    }

    public static void schedule(){
        String jobName = 'Renovar Oportunidades Corporate (exc. Vida)';
        if(Test.isRunningTest()){
            jobName += ' Test';
        }
        System.schedule(jobName, '0 30 8 * * ?', new Corporate_RenewalOpportunitySchedule());
    }
}