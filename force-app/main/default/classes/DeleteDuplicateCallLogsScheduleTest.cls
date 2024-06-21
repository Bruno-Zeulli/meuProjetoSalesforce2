@isTest
public class DeleteDuplicateCallLogsScheduleTest {
	@isTest
    public static void executeTest(){
        
        String cronTime = '0 57 * * * ? *';
        //Inicia o teste
        Test.startTest();
        
        // Agendar o job
        String jobId = System.schedule('Delete Duplicate CallLogs by ReferenceId Test', cronTime, new DeleteDuplicateCallLogsSchedule());
        	
        //Encerra o teste
        Test.stopTest();
        
        CronTrigger scheduledJobInformations = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        Assert.areEqual(cronTime, scheduledJobInformations.CronExpression, 'A Schedule não foi marcado no horário correto');
    }
}