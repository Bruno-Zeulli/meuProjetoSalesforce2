@isTest
public class CaseMilestoneBOTest 
{
	@isTest
    public static void updateCaseMilestones()
    {
        List<CaseMilestone> lstCaseMilestoneToUpdate = new List<CaseMilestone>();
        CaseMilestone cm = new CaseMilestone();
        
        lstCaseMilestoneToUpdate.add(cm);
        
        CaseMilestoneBO.updateCaseMilestones(lstCaseMilestoneToUpdate);
    }
}