public with sharing class TaskDAO {
    @AuraEnabled(cacheable=true)
    public static List<Task> getAssignedOpenTasks(){
        Id recordTypeCorporateTaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();

        return [SELECT Id,
                    CreatedDate,
                    WhatId,
                    OwnerId,
                    Owner.Name,
                    Subject
                FROM
                    Task
                WHERE (IsClosed = false AND Subject = 'Atribuído para técnico' AND RecordTypeId =: recordTypeCorporateTaskId)];
    }
    @AuraEnabled(cacheable=true)
    public static List<Task> getUnassignedOpenTasks(){
        Id recordTypeCorporateTaskId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();

        return [SELECT Id,
                    CreatedDate,
                    WhatId,
                    OwnerId,
                    Owner.Name,
                    Subject,
                    NotifiedUsers__c
                FROM
                    Task
                WHERE (IsClosed = false AND Subject = 'Nova oportunidade disponível' AND RecordTypeId =: recordTypeCorporateTaskId)];
    }
}