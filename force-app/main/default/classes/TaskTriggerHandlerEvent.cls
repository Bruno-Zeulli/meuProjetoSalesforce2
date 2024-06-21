/**
 * Autor: Samuel da Silva Sirkis
 * Observação: Foi realizado a divisão do método seguinte após analise do PMD.
 */

public with sharing class TaskTriggerHandlerEvent {
    // public static void publishIncorrectDispositionEvent(){
    //     List<Task> newRecordsList;
    //     List<IncorrectDisposition__e> lIncorrectDisposition = new List<IncorrectDisposition__e>();
    //     Set<Id> setOwners = new Set<Id>();
    //     for(Task t : newRecordsList){
    //         setOwners.add(t.CreatedById);
    //     }
    //     2
    //     Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, UserRole.Name FROM User WHERE UserRole.Name LIKE 'B2U - %' AND IsActive = TRUE]);
    //     for(Task t : newRecordsList){
    //         if(mapUsers.containsKey(t.CreatedById)){
    //             if(t.Category__c == null ||(t.WhoId == null &&t.Category__c != '5. Transferência') ||
    //                 ((t.Subcategory__c == '1.6 Venda' || t.Subcategory__c == '1.38 Visita agendada') && t.WhatId == null) ||
    //                 (t.CallType == 'Outbound' && t.WhatId == null)
    //             ){
    //                 IncorrectDisposition__e incDis = new IncorrectDisposition__e(Task__c = t.Id, Reason__c = B2U_SupervisorController.generateIncorrectDispositionReason(t));
    //                 System.debug('incDis: ' + incDis);
    //                 lIncorrectDisposition.add(incDis);
    //             }
    //         }
    //     }
    //     if(!lIncorrectDisposition.isEmpty()){
    //         EventBus.publish(lIncorrectDisposition);
    //     }
    // }
}