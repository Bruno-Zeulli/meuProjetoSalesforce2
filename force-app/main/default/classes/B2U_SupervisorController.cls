/**
* @description       :
* @author            : Windson Santos
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
**/

public with sharing class B2U_SupervisorController {
    @AuraEnabled(cacheable=true)
    public static List<TaskReturnModel> getTasksList(){
        List<TaskReturnModel> modelList = new List<TaskReturnModel>();
        String businessOperation = getCurrentUserBusinessOperation();
        if(businessOperation != null){
            Set<Id> agentRolesSet = getAgentRoles(businessOperation);

            List<Task> taskList;
            taskList = selectTaskList(taskList, agentRolesSet);
            sweeperTaskList(taskList, modelList);
        }
        return modelList;
    }

    private static List<Task> selectTaskList(List<Task> taskList, Set<Id> agentRolesSet){
        String leadCampaignsStr = System.Label.B2ULeadCampaigns;
        List<String> leadCampaigns = leadCampaignsStr.split('\n');

        if(isManager(agentRolesSet)){
            taskList = [
                SELECT
                    Id,
                    Subject,Owner.Name,Owner.UserRoleId,WhatId,WhoId,What.Name,Who.Name,Five9__Five9Campaign__c,CallDisposition,
                    Category__c,Subcategory__c,Reason__c,SpecificReason__c,Disposition__r.Disposition__c,CallType,Status,Createddate
                FROM
                    Task
                WHERE
                    (CreatedDate = TODAY AND Owner.UserRoleId IN :agentRolesSet
                    AND (Category__c = NULL OR (WhoId = NULL AND Category__c = '5. Transferência')
                    OR (WhatId = NULL AND Subcategory__c IN ('1.6 Venda', '1.38 Visita agendada'))
                    OR (WhatId = NULL AND CallType = 'Outbound' AND (NOT Five9__Five9Campaign__c IN :leadCampaigns))
                    OR (What.Type != 'Contract2__c' AND Subcategory__c = '1.39 Retenção na Renovação Automática')))
                    OR (CreatedDate = YESTERDAY AND Owner.UserRoleId IN :agentRolesSet AND Status != 'Completed')
                    ORDER BY CreatedDate DESC
            ];
        }else{
            taskList = [
                SELECT
                    Id,Subject,Owner.Name,WhatId,WhoId,What.Name,Who.Name,Five9__Five9Campaign__c,CallDisposition,
                    Category__c,Subcategory__c,Reason__c,SpecificReason__c,Disposition__r.Disposition__c,CallType,Status
                FROM
                    Task
                WHERE
                    (CreatedDate = TODAY AND OwnerId = :UserInfo.getUserId()
                    AND (Category__c = NULL OR (WhoId = NULL
                    AND Category__c = '5. Transferência') OR (WhatId = NULL
                    AND Subcategory__c IN ('1.6 Venda', '1.38 Visita agendada'))
                    OR (WhatId = NULL AND CallType = 'Outbound'
                    AND (NOT Five9__Five9Campaign__c IN :leadCampaigns))
                    OR (What.Type != 'Contract2__c' AND Subcategory__c = '1.39 Retenção na Renovação Automática')))
                    OR (CreatedDate = YESTERDAY AND OwnerId = :UserInfo.getUserId()
                    AND Status != 'Completed') ORDER BY CreatedDate DESC
            ];
        }
        return taskList;
    }

    private static void sweeperTaskList(List<Task> taskList, List<TaskReturnModel> modelList){
        for(Task t : taskList){
            String taskURL = '/lightning/r/Task/' + t.Id + '/view';
            String whatURL = String.isNotBlank(t.WhatId) ? '/' + t.WhatId : '';
            String disposition = t.Disposition__r.Disposition__c;
            String reason = generateIncorrectDispositionReason(t);
            TaskReturnModel trm = new TaskReturnModel(t.Id,t.Subject,taskURL,t.Owner.Name,disposition,t.Who.Name,t.What.Name,whatURL,t.Five9__Five9Campaign__c,reason);
            modelList.add(trm);
        }
    }

    private static String getCurrentUserBusinessOperation(){
        String businessOperation;
        Id userRoleId = UserInfo.getUserRoleId();
        if(userRoleId != null){
            UserRole ur = [SELECT Name FROM UserRole WHERE Id = :userRoleId WITH SECURITY_ENFORCED];
            if(ur.Name.contains('B2U - ')){
                if(ur.Name.contains('CAIXA')){
                    businessOperation = 'CAIXA';
                }else if(ur.Name.contains('Conseg')){
                    businessOperation = 'Conseg';
                }
            }
        }
        return businessOperation;
    }

    private static Boolean isManager(Set<Id> agentRolesSet){
        return (!agentRolesSet.contains(UserInfo.getUserRoleId()));
    }

    private static Set<Id> getAgentRoles(String businessOperation){
        Set<String> agentRolesName = new Set<String>();
        agentRolesName.add('B2U - Operador de Vendas ' + businessOperation);
        agentRolesName.add('B2U - Assistente Comercial ' + businessOperation);
        Set<Id> agentRolesId = new Map<Id, UserRole>([SELECT Id FROM UserRole WHERE Name IN :agentRolesName]).keySet();
        return agentRolesId;
    }

    public static String generateIncorrectDispositionReason(Task t){
        Integer reasonQuantity = 0;
        String reason = '';

        if(t.Category__c == null){
            reasonQuantity++;
            reason += reasonQuantity + ' - Não tabulada';
        }

        reason = taskNotContainWhatId(t, reason, reasonQuantity);
        reason = taskNotContainWhoId(t, reason, reasonQuantity);
        reason = taskWithRetention(t, reason, reasonQuantity);
        reason = taskNotCompletedWithTransfer(t, reason, reasonQuantity);

        return reason;
    }

    private static String taskNotContainWhatId(Task t, String reason, Integer reasonQuantity){
        String leadCampaignsStr = System.Label.B2ULeadCampaigns;
        List<String> leadCampaigns = leadCampaignsStr.split('\n');

        if(t.WhatId == null){
            if(t.Subcategory__c == '1.6 Venda' || t.Subcategory__c == '1.38 Visita agendada'){
                reasonQuantity++;
                reasonIsNotBlack(reason);
                reason += reasonQuantity + ' - Relativo a não preenchido em venda';
            }else if(t.CallType == 'Outbound' && !leadCampaigns.contains(t.Five9__Five9Campaign__c)){
                reasonQuantity++;
                reasonIsNotBlack(reason);
                reason += reasonQuantity + ' - Relativo a não preenchido em ativo';
            }else if(t.CallType == 'Inbound' && t.Category__c == '1. Atendimento Realizado'){
                reasonQuantity++;
                reasonIsNotBlack(reason);
                reason += reasonQuantity + ' - Relativo a não preenchimento do número do contrato';
            }
        }
        return reason;
    }

    private static String taskNotContainWhoId(Task t, String reason, Integer reasonQuantity){
        if(t.whoId == null){
            if(t.Category__c == '5. Transferência'){
                reasonQuantity++;
                reasonIsNotBlack(reason);
                return reason += reasonQuantity + ' - Relativo a não preenchido de Contato';
            }
        }
        return reason;
    }

    private static String taskWithRetention(Task t, String reason, Integer reasonQuantity){
        if(t.Subcategory__c == '1.39 Retenção na Renovação Automática'){
            reasonQuantity++;
            reasonIsNotBlack(reason);
            return reason += reasonQuantity + ' - Contrato não preenchido em retenção';
        }
        return reason;
    }

    private static String taskNotCompletedWithTransfer(Task t, String reason, Integer reasonQuantity){
        if(t.Status != 'Completed'){
            if(t.Category__c == '5. Transferência'){
                if(reasonQuantity == 0){
                    reasonQuantity++;
                    reasonIsNotBlack(reason);
                    reason += reasonQuantity + ' - Relativo a não finalizada';
                }
            }
        }
        return reason;
    }

    private static String reasonIsNotBlack(String reason){
        if(String.isNotBlank(reason)){
            reason += '\n';
        }
        return reason;
    }

    @AuraEnabled(cacheable=true)
    public static List<RankingReturnModel> getRanking(){
        List<RankingReturnModel> modelList = new List<RankingReturnModel>();
        String businessOperation = getCurrentUserBusinessOperation();

        if(businessOperation != null){
            Set<Id> agentRolesSet = getAgentRoles(businessOperation);

            List<AggregateResult> ranking;
            ranking = selectRanking(ranking, agentRolesSet);
            sweeperRanking(ranking, modelList);
        }
        return modelList;
    }

    private static List<AggregateResult> selectRanking(List<AggregateResult> ranking, Set<Id> agentRolesSet){
        String leadCampaignsStr = System.Label.B2ULeadCampaigns;
        List<String> leadCampaigns = leadCampaignsStr.split('\n');

        if(isManager(agentRolesSet)){
            ranking = [
            SELECT COUNT(Id) quantity, Owner.Name owner
            FROM Task
            WHERE
            (CreatedDate = TODAY
            AND Owner.UserRoleId IN :agentRolesSet
            AND (Category__c = NULL
            OR (WhoId = NULL
            AND Category__c = '5. Transferência')
            OR (WhatId = NULL
            AND Subcategory__c IN ('1.6 Venda', '1.38 Visita agendada'))
            OR (WhatId = NULL
            AND CallType = 'Outbound'
            AND (NOT Five9__Five9Campaign__c IN :leadCampaigns))
            OR (What.Type != 'Contract2__c'
            AND Subcategory__c = '1.39 Retenção na Renovação Automática')))
            OR (CreatedDate = YESTERDAY
            AND Owner.UserRoleId IN :agentRolesSet
            AND Status != 'Completed')
            GROUP BY Owner.Name
            ];
        }else{
            ranking = [
            SELECT COUNT(Id) quantity, Owner.Name owner
            FROM Task
            WHERE
            (CreatedDate = TODAY
            AND OwnerId = :UserInfo.getUserId()
            AND (Category__c = NULL
            OR (WhoId = NULL
            AND Category__c = '5. Transferência')
            OR (WhatId = NULL
            AND Subcategory__c IN ('1.6 Venda', '1.38 Visita agendada'))
            OR (WhatId = NULL
            AND CallType = 'Outbound'
            AND (NOT Five9__Five9Campaign__c IN :leadCampaigns))
            OR (What.Type != 'Contract2__c'
            AND Subcategory__c = '1.39 Retenção na Renovação Automática')))
            OR (CreatedDate = YESTERDAY
            AND OwnerId = :UserInfo.getUserId()
            AND Status != 'Completed')
            GROUP BY Owner.Name
            ];
        }
        return ranking;
    }

    private static void sweeperRanking(List<AggregateResult> ranking, List<RankingReturnModel> modelList){
        for(AggregateResult ar : ranking){
            Integer quantity = Integer.valueOf(ar.get('quantity'));
            String owner = String.valueOf(ar.get('owner'));
            RankingReturnModel rrm = new RankingReturnModel(quantity, owner);
            modelList.add(rrm);
        }
    }

    @AuraEnabled
    public static Boolean hasAccess(Id taskId){
        if(!isSupposedToHaveAccess()){
            return false;
        }
         try{
            String businessOperation = getCurrentUserBusinessOperation();
            if(businessOperation != null){
                Set<Id> agentRolesSet = getAgentRoles(businessOperation);
                if(isManager(agentRolesSet)){
                    return true;
                }else{
                    Task t = [SELECT Id FROM Task WHERE Id = :taskId AND OwnerId = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
                }
            }
        } catch (Exception e){
            return false;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean isSupposedToHaveAccess(){
        String supervisorRoles = System.Label.B2USupervisorRoles;
        if(String.isBlank(supervisorRoles)){
            return false;
        }
        Id currentUserRoleId = UserInfo.getUserRoleId();
        UserRole currentUserRole = [SELECT Name FROM UserRole WHERE Id = :currentUserRoleId WITH SECURITY_ENFORCED];
        if(!supervisorRoles.contains(currentUserRole.Name)){
            return false;
        }
        return true;
    }

    private class TaskReturnModel {
        @AuraEnabled
        public Id id { get; set; }
        @AuraEnabled
        public String subject { get; set; }
        @AuraEnabled
        public String url { get; set; }
        @AuraEnabled
        public String owner { get; set; }
        @AuraEnabled
        public String disposition { get; set; }
        @AuraEnabled
        public String whatName { get; set; }
        @AuraEnabled
        public String whoName { get; set; }
        @AuraEnabled
        public String whatURL { get; set; }
        @AuraEnabled
        public String campaign { get; set; }
        @AuraEnabled
        public String reason { get; set; }

        private TaskReturnModel(
        Id id,
        String subject,
        String url,
        String owner,
        String disposition,
        String whoName,
        String whatName,
        String whatURL,
        String campaign,
        String reason
        ){
            this.id = id;
            this.subject = subject;
            this.url = url;
            this.owner = owner;
            this.disposition = disposition;
            this.whatName = whatName;
            this.whatURL = whatURL;
            this.whoName = whoName;
            this.campaign = campaign;
            this.reason = reason;
        }
    }

    private class RankingReturnModel {
        @AuraEnabled
        public Integer quantity { get; set; }
        @AuraEnabled
        public String ownerName { get; set; }

        private RankingReturnModel(Integer quantity, String ownerName){
            this.quantity = quantity;
            this.ownerName = ownerName;
        }
    }
}