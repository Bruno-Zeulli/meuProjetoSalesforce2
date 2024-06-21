global class CloseTicketBatch implements Database.Batchable<sObject> {
    List<Case> cases;

    global Database.QueryLocator start(Database.BatchableContext bc){
        String referenciaComumTickets = 'TKT';

        Datetime umDiaAntes = (Datetime.now() - 1);
        Datetime meiaHoraAntes = (Datetime.now() - (1 / 48));
        // AND LastModifiedDate <= :meiaHoraAntes
        return Database.getQueryLocator([
                SELECT Id, ContactId, Status, EmResolucao_Tkt__c, DataResolucao_Tkt__c
                FROM Case
                WHERE RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName LIKE :('%' + referenciaComumTickets + '%')) AND EmResolucao_Tkt__c = TRUE AND LastModifiedDate <= :umDiaAntes
            ]);
    }
    global void execute(Database.BatchableContext bc, List<Case> scope){
        List<Id> caseIdsLst = new List<Id>();
        Map<Id, CaseMilestone> milestoneReaberturaMap = new Map<Id, CaseMilestone>();
        Map<Id, CaseMilestone> milestoneResolucaoMap = new Map<Id, CaseMilestone>();

        for(Case iCase : scope){
            caseIdsLst.add(iCase.Id);
        }

        List<CaseMilestone> cmsToUpdateReabertura = [SELECT Id, CompletionDate, CaseId FROM CaseMilestone cm WHERE CaseId IN :caseIdsLst AND cm.MilestoneType.Name = 'Reabertura' AND completionDate = null];
        List<CaseMilestone> cmsToUpdateResolucao = [SELECT Id, CompletionDate, CaseId FROM CaseMilestone cm WHERE CaseId IN :caseIdsLst AND cm.MilestoneType.Name = 'Resolução' AND completionDate = null];

        for(CaseMilestone iCaseMilestone : cmsToUpdateReabertura){
            milestoneReaberturaMap.put(iCaseMilestone.CaseId, iCaseMilestone);
        }

        for(CaseMilestone iCaseMilestone : cmsToUpdateResolucao){
            milestoneResolucaoMap.put(iCaseMilestone.CaseId, iCaseMilestone);
        }

        for(Case iCase : scope){
            if(milestoneReaberturaMap.get(iCase.Id) != null) milestoneReaberturaMap.get(iCase.Id).CompletionDate = System.now();
            if(milestoneResolucaoMap.get(iCase.Id) != null) milestoneResolucaoMap.get(iCase.Id).CompletionDate = iCase.DataResolucao_Tkt__c;
        }

        if(milestoneReaberturaMap != null){
            update milestoneReaberturaMap.values();
        }
        if(milestoneResolucaoMap != null){
            update milestoneResolucaoMap.values();
        }

        //Alterar status para fechado
        for(Case caso : scope){
            caso.EmResolucao_Tkt__c = false;
        }

        update scope;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Tickets Alterados com sucesso!');
    }
}