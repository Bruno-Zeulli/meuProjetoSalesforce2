public with sharing class SlaCounterController {

    @AuraEnabled
    public static List<CaseMilestone> getCaseMilestone(String caseId) {
        String etapa;
        Case caseInfo = [SELECT Id, Status FROM Case WHERE Id =: caseId];
        if(caseInfo.Status == 'Resolvido'){
            etapa = 'Reabertura';
        }else if(caseInfo.Status == 'Aguardando atendimento' || caseInfo.Status == 'Em atendimento' || caseInfo.Status == 'Alterado pelo solicitante'){
            etapa = 'Tempo de primeira resposta';
        }else{
            etapa = 'Resolução';
        }
        
        //List<CaseMilestone> cmToSearch = [SELECT Id, TimeRemainingInDays, TimeRemainingInHrs, TimeRemainingInMins, MilestoneType.Name, TargetDate FROM CaseMilestone WHERE CaseId =:caseId AND MilestoneType.Name =: etapa AND IsCompleted = false];
        List<CaseMilestone> cmToSearch = [SELECT Id, TimeRemainingInDays, TimeRemainingInHrs, TimeRemainingInMins, MilestoneType.Name, TargetDate FROM CaseMilestone WHERE CaseId =:caseId AND IsCompleted = false];
        system.debug('@BPPS cmToSearch: '+cmToSearch);
        return cmToSearch;
    }

    @AuraEnabled
    public static List<CaseMilestone> getCompletedCaseMilestone(String caseId) {
        Case caseInfo = [SELECT Id, Status FROM Case WHERE Id =: caseId];        
        List<CaseMilestone> cmToSearch = [SELECT Id, TimeRemainingInDays, TimeRemainingInHrs, TimeRemainingInMins, MilestoneType.Name, TargetDate, IsViolated FROM CaseMilestone WHERE CaseId =:caseId AND IsCompleted = true];
        return cmToSearch;
    }
}