public with sharing class CaseMilestoneBO {
    
    public static void updateCaseMilestones(List<CaseMilestone> lstCaseMilestoneToUpdate){
        if(!lstCaseMilestoneToUpdate.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srListCaseMilestoneUpdate = Database.update(lstCaseMilestoneToUpdate, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }
}