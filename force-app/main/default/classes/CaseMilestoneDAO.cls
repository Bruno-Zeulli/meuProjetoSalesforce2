public with sharing class CaseMilestoneDAO {

    public static CaseMilestone getMilestoneByCaseId(Id caseId){
        return [SELECT
                    Id, CaseId, CompletionDate
                FROM
                    CaseMilestone
                WHERE
                    CaseId=:caseId
            ];
    }

    public static List<CaseMilestone> getCaseMilestoneByCaseId(Set<Id> setCaseId){
        return [SELECT
                    Id, IsViolated, caseId
                FROM
                    CaseMilestone
                WHERE
                    caseId IN: setCaseId
            ];
    }
}