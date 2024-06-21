public without sharing class DocumentUploadBO {
    
    private static final DocumentUploadBO INSTANCE = new DocumentUploadBO();

    public static DocumentUploadBO getInstance(){
        return INSTANCE;
    }

    public void createTaskDocPending(List<DocumentUpload__c> lstDocUploadPending){

        List<Task> lstTaskPending = new List<Task>();
        Map<Id, DocumentType__c> mapDocumentType = DocumentTypeDAO.getMapAllDocumentType();
        Set<Id> lUserId = new Set<Id>();
        lUserId.add(UserInfo.getUserId());
        List<User> lUserInfo = UserDAO.getInstance().getListUserBylUserIds(lUserId);

        Id rtTask = getRecordTypeTaskId(lUserInfo[0].BusinessUnit__c);

        if(rtTask != null){
            for(DocumentUpload__c objDocUpload : lstDocUploadPending){
                String docTypeName = mapDocumentType.containsKey(objDocUpload.DocumentType__c) ? mapDocumentType.get(objDocUpload.DocumentType__c).Name : '';
                Task task = new Task(
                    Subject = 'Pendência',
                    OwnerId = lUserInfo[0].Id,
                    Status = 'Open',
                    Priority = 'Normal',
                    Description = 'Documento ' +  docTypeName + ' reprovado',
                    Type = 'Pendência',
                    WhatId = objDocUpload.IdObjeto__c,
                    RecordTypeId = rtTask,
                    BusinessUnit__c = lUserInfo[0].BusinessUnit__c,
                    IsVisibleInSelfService = true
                );
                lstTaskPending.add(task);
            }
        }        

        if(!lstTaskPending.isEmpty()){
            TaskBO.getInstance().insertTaskByList(lstTaskPending);
        }
    }


    private Id getRecordTypeTaskId(String businessUnit){

        Id rtTask = null;

        switch on businessUnit {
            when 'CORPORATIVO'{
               rtTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            }
            when 'CORPORATE'{
               rtTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            }
            when 'Wiz Benefícios'{
               rtTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            }
            when 'Wiz Corporate Partners'{
               rtTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('ConnectatWiz').getRecordTypeId();
            }
        }
        return rtTask;
    }
}