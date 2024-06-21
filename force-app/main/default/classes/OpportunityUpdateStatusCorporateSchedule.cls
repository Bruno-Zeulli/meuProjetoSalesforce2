public with sharing class OpportunityUpdateStatusCorporateSchedule implements Schedulable{
    
    public void execute(SchedulableContext ctx) {
        Id batchId = Database.executeBatch(new OpportunityUpdateStatusCorporateBatch());
    }

    public static void schedule(){
        String isTest = '';
        if(Test.isRunningTest()){
            isTest +=' test';
        }
    
        System.schedule('Atualizar Oportunidades a vencer' + isTest, '0 0 4 * * ?', new OpportunityUpdateStatusCorporateSchedule());
        
    }
}