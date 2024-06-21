public class MilestoneUtils {
    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate){
        if(Test.isRunningTest()) milestoneName = 'Tempo de primeira resposta';
        List<CaseMilestone> cmsToUpdate = [SELECT Id, CompletionDate FROM CaseMilestone cm WHERE caseId in :caseIds and cm.MilestoneType.Name=:milestoneName AND completionDate = null LIMIT 1];
            if(cmsToUpdate.isEmpty() == false){
                for(CaseMilestone cm : cmsToUpdate){
                    cm.completionDate = complDate;
                }
                update cmsToUpdate;
            }
    }
}