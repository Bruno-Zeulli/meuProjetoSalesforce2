global class OppUpdateContactDetailSchedule implements Schedulable {
    global void execute(SchedulableContext context){
       
        String jobId = Database.executeBatch(new OpportunityUpdateContactDetailBatch(), 200);
    }
}