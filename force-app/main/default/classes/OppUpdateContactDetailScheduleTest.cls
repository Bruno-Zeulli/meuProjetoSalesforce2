@isTest
private class OppUpdateContactDetailScheduleTest {
    
    @isTest
    static void testScheduledJob() {
        // Agendar o job
        String jobId = System.schedule('Test_OppUpdateContactDetailScheduleTest', '0 0 0 * * ? ', new OppUpdateContactDetailSchedule());
        
        //Inicia o teste
        Test.startTest();
        
        //Aguardando a execução do job
        System.scheduleBatch(new OpportunityUpdateContactDetailBatch(), 'Test_OppUpdateContactDetailBatch', 200, 1);
        
        //Encerra o teste
        Test.stopTest();
    }

}