public without sharing class ConnectWizNotificationController {
    @AuraEnabled
    public static List<ConnectWizNotificationTO.Notification> checkIfUserHasTasks(){

        List<ConnectWizNotificationTO.Notification> lstNotificationTO = new List<ConnectWizNotificationTO.Notification>();
        // Map<Task,Case> mapReturn = new Map<Task,Case>();
        id userId = UserInfo.getUserId();
        String userName = UserInfo.getName();
        System.debug(userId + userName);

        Set<Id> setWhatId = new Set<Id>();
        Set<Id> setGroupId = new Set<Id>();

        List<Task> lstTasks = TaskDAO.getAssignedOpenTasks();
        List<Task> lstTasksUnassigned = TaskDAO.getUnassignedOpenTasks();

        for(Task objTask : lstTasks){
            setGroupId.add(objTask.ownerId);
            setWhatId.add(objTask.WhatId);
        }

        for(Task objTask : lstTasksUnassigned){
            setGroupId.add(objTask.ownerId);
            setWhatId.add(objTask.WhatId);
        }
        System.debug('tasks' + JSON.serializePretty(lstTasks));

        List<GroupMember> lstGroupMember = GroupDAO.getAssignedGroupMember(setGroupId,userId);
        List<Task> lstOpenTasks = new List<Task>();
        List<Case> lstCase = [SELECT Id,Opportunity__c,Opportunity__r.OpportunityNumber__c FROM Case WHERE Opportunity__c IN: setWhatId OR Id IN:setWhatId];

        List<Opportunity> lstOpportunities = [SELECT Id,(SELECT Id,Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id IN (SELECT Opportunity__c FROM Case WHERE Id =: lstCase)];

        System.debug('lstCase' + lstCase);
        System.debug('lstOpportunities' + lstOpportunities);
        for(Task objTask : lstTasks){
        ConnectWizNotificationTO.Notification objNotificationTO = new ConnectWizNotificationTO.Notification();
        Datetime notificationDate = objTask.CreatedDate;
        String DateStr = String.valueOf(notificationDate.day()) + '/' + String.valueOf(notificationDate.month()) + '/' + String.valueOf(notificationDate.year());
        String timeStr = String.valueOf(notificationDate.hour()) + ':' + String.valueOf(notificationDate.minute());

        System.debug(DateStr + ' : ' + timeStr);
            if(objTask.ownerId == userId){
                for(Case objCase : lstCase){
                    if(objTask.WhatId == objCase.Opportunity__c || objTask.WhatId == objCase.Id){
                        // mapReturn.put(objTask,objCase);
                        objNotificationTO.caseId = objCase.Id;
                        objNotificationTO.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
                        objNotificationTO.taskId = objTask.Id;
                        for(Opportunity objOpp : lstOpportunities){
                            if(objCase.Opportunity__c == objOpp.Id){
                                objNotificationTO.subject = 'Oportunidade ' + objCase.Opportunity__r.OpportunityNumber__c + ' atribuída à você. - ' + objOpp.OpportunityLineItems[0].Product2.Name;
                                break;
                            }else{
                                objNotificationTO.subject = 'Oportunidade ' + objCase.Opportunity__r.OpportunityNumber__c + ' atribuída à você.';

                            }
                        }
                        objNotificationTO.additionalInformation = DateStr + ' | ' + timeStr;
                        lstNotificationTO.add(objNotificationTO);
                    }
                }
            }else{
                for(GroupMember objGM : lstGroupMember){
                    if(objGM.UserOrGroupId == userId && objGM.groupId == objTask.ownerId){
                        for(Case objCase : lstCase){
                            if(objTask.WhatId == objCase.Opportunity__c || objTask.WhatId == objCase.Id){
                            // mapReturn.put(objTask,objCase);
                            objNotificationTO.caseId = objCase.Id;
                            objNotificationTO.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
                            objNotificationTO.taskId = objTask.Id;
                            for(Opportunity objOpp : lstOpportunities){
                            if(objCase.Opportunity__c == objOpp.Id){
                                objNotificationTO.subject = 'Oportunidade ' + objCase.Opportunity__r.OpportunityNumber__c + ' atribuída à você. - ' + objOpp.OpportunityLineItems[0].Product2.Name;
                                break;
                            }else{
                                objNotificationTO.subject = 'Oportunidade ' + objCase.Opportunity__r.OpportunityNumber__c + ' atribuída à você.';

                            }
                        }
                            objNotificationTO.additionalInformation = DateStr + ' | ' + timeStr;
                            lstNotificationTO.add(objNotificationTO);
                            }
                        }
                    }
                }
            }
        }

        for(Task objUnassignedTask : lstTasksUnassigned){
            if(objUnassignedTask.NotifiedUsers__c == null || !objUnassignedTask.NotifiedUsers__c.contains(userName)){
                ConnectWizNotificationTO.Notification objUnassignedNotificationTO = new ConnectWizNotificationTO.Notification();
                Datetime notificationDate = objUnassignedTask.CreatedDate;
                String DateStr = String.valueOf(notificationDate.day()) + '/' + String.valueOf(notificationDate.month()) + '/' + String.valueOf(notificationDate.year());
                String timeStr = String.valueOf(notificationDate.hour()) + ':' + String.valueOf(notificationDate.minute());

        System.debug(DateStr + ' : ' + timeStr);
            // if(objUnassignedTask.ownerId == userId){
                for(Case objCase : lstCase){
                    if(objUnassignedTask.WhatId == objCase.Opportunity__c || objUnassignedTask.WhatId == objCase.Id){
                        objUnassignedNotificationTO.caseId = objCase.Id;
                        objUnassignedNotificationTO.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
                        objUnassignedNotificationTO.taskId = objUnassignedTask.Id;
                        objUnassignedNotificationTO.subject = 'Nova oportunidade disponível ' + objUnassignedNotificationTO.opportunityNumber;
                        for(Opportunity objOpp : lstOpportunities){
                            if(objCase.Opportunity__c == objOpp.Id){
                                objUnassignedNotificationTO.subject = 'Nova oportunidade disponível ' + objUnassignedNotificationTO.opportunityNumber + ' - ' + objOpp.OpportunityLineItems[0].Product2.Name;
                                break;
                            }else{
                                objUnassignedNotificationTO.subject = 'Nova oportunidade disponível ' + objUnassignedNotificationTO.opportunityNumber;

                            }
                        }
                        objUnassignedNotificationTO.additionalInformation = DateStr + ' | ' + timeStr;
                        lstNotificationTO.add(objUnassignedNotificationTO);
                    }
                }
            // }else{
            //     for(GroupMember objGM : lstGroupMember){
            //         if(objGM.UserOrGroupId == userId && objGM.groupId == objUnassignedTask.ownerId){
            //             for(Case objCase : lstCase){
            //                 if(objUnassignedTask.WhatId == objCase.Opportunity__c || objUnassignedTask.WhatId == objCase.Id){
            //                 objUnassignedNotificationTO.caseId = objCase.Id;
            //                 objUnassignedNotificationTO.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
            //                 objUnassignedNotificationTO.taskId = objUnassignedTask.Id;
            //                 objUnassignedNotificationTO.subject = 'Nova oportunidade disponível ' + objUnassignedNotificationTO.opportunityNumber;
            //                 objUnassignedNotificationTO.additionalInformation = DateStr + ' | ' + timeStr;
            //                 lstNotificationTO.add(objUnassignedNotificationTO);
            //                 }
            //             }
            //         }
            //     }
            //     }
            }
        }

        System.debug('lstNotificationTO' + lstNotificationTO);
        return lstNotificationTO;
    }

    @AuraEnabled
    public static Boolean completeTask(Id taskId){
        Task objTask = [SELECT Id,Status,Subject,NotifiedUsers__c FROM TASK WHERE Id =: taskId];
        Boolean isTaskUpdated = false;
        if(objTask.Subject == 'Nova oportunidade disponível'){
            id userId = UserInfo.getUserId();
            String userName = UserInfo.getName();
            objTask.NotifiedUsers__c = objTask.NotifiedUsers__c == null ? userName :  + objTask.NotifiedUsers__c +','+ userName;
            Database.SaveResult srTask = Database.update(objTask, false);
            if(srTask.isSuccess()){
                System.debug('Successfully inserted Task. Task ID: ' + srTask.getId());
                isTaskUpdated = srTask.isSuccess();
            }else{
                System.debug('Failed to insert Task error message: ' + srTask.getErrors());
                isTaskUpdated = false;
            }
        }else if(objTask.subject == 'Atribuído para técnico'){
            objTask.Status = 'Completed';
            Database.SaveResult srTask = Database.update(objTask, false);
            if(srTask.isSuccess()){
                System.debug('Successfully inserted Task. Task ID: ' + srTask.getId());
                isTaskUpdated = srTask.isSuccess();
            }else{
                System.debug('Failed to insert Task error message: ' + srTask.getErrors());
                isTaskUpdated = false;
            }
        }

        return isTaskUpdated;
    }

    @AuraEnabled
    public static Boolean completeAllTasks(List<ConnectWizNotificationTO.Notification> lstNotificationTO){
        System.debug('lstNotification ' + JSON.serializePretty(lstNotificationTO));
        Set<Id> setTasksToComplete = new Set<Id>();
        for(ConnectWizNotificationTO.Notification objNotificationTO : lstNotificationTO){
            setTasksToComplete.add(objNotificationTO.taskId);
        }

        List<Task> lstTasksToComplete = [SELECT Id,Subject,Status,NotifiedUsers__c FROM Task WHERE ID IN: setTasksToComplete];
        System.debug('lstTaskToComplete' + lstTasksToComplete);

        // List<Task> lstTasksUnassigned = new List<Task>();
        // List<Task> lstTasksAssigned = new List<Task>();
        id userId = UserInfo.getUserId();
        String userName = UserInfo.getName();

        for(Task objTaskToComplete : lstTasksToComplete){
            if(objTaskToComplete.subject == 'Nova oportunidade disponível'){
                // lstTasksUnassigned.add(objTaskToComplete);
                objTaskToComplete.NotifiedUsers__c = objTaskToComplete.NotifiedUsers__c == null ? userName :  + objTaskToComplete.NotifiedUsers__c +','+ userName;
            }else if(objTaskToComplete.subject == 'Atribuído para técnico'){
                // lstTasksAssigned.add(objTaskToComplete);
                objTaskToComplete.Status = 'Completed';
            }
        }

        System.debug('lstTasksToComplete' + JSON.serializePretty(lstTasksToComplete));
        // System.debug('lstTasksAssigned' + JSON.serializePretty(lstTasksAssigned));


        Database.SaveResult[] srList = Database.update(lstTasksToComplete, false);

        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                System.debug('Successfully updated Task. Task ID: ' + sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Task fields that affected this error: ' + err.getFields());
                }
        }
    }
        return true;
    }
}