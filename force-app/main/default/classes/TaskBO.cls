/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 26-12-2022
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-12-2022   samuelsirkis@wiz.co                  Initial Version
 **/
public with sharing class TaskBO {
    private static final TaskBO INSTANCE = new TaskBO();

    public static TaskBO getInstance(){
        return INSTANCE;
    }

    public void createTaskHistory(String whatId, String whoId, String subject, String description, String type, String recordtypeId, String businessUnit){
          try{
            Task task = new Task(
                Subject = subject,
                OwnerId = UserInfo.getUserId(),
                Status = 'Open',
                Priority = 'Normal',
                Description = description,
                Type = type,
                WhatId = whatId,
                WhoId = whoId,
                RecordTypeId = recordtypeId,
                BusinessUnit__c = businessUnit,
                IsVisibleInSelfService = true
            );
            insert task;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    public void insertTaskByList(List<Task> lTask){
        Savepoint sp = Database.setSavepoint();
         try{
            Database.SaveResult[] srListTask = Database.insert(lTask, false);
        } catch (Exception e){
            System.Debug(e);
            Database.rollback(sp);
        }
    }
}