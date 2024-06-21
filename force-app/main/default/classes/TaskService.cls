public with sharing class TaskService {
    private static String EXPIRED_DISPOSITION_PATH_EXT_ID = '3de172be-4b8b-488c-80fa-46d79663c0ad';

    @AuraEnabled
    public static void createTabulationExpiredTask(String callLogId){
        DispositionPath__c tabulationExpired = [SELECT Id, Reason__c FROM DispositionPath__c WHERE ExternalId__c =: EXPIRED_DISPOSITION_PATH_EXT_ID];
        
        createTabulationTask(callLogId, tabulationExpired.Reason__c, true);		
    }

    @AuraEnabled
    public static void createTabulationPreviewTask(String callLogId, String dispositionPath){
        createTabulationTask(callLogId, dispositionPath, false);
    }

    private static void createTabulationTask(String callLogId, String dipositionPath, Boolean expiration){
        Task task = new Task();
        
        String whoId;
        String whatId;
        
        CallLog__c callL = [SELECT Id, Queue__c, Address__c, WhoId__c, Message__c FROM CallLog__c WHERE Id=:callLogId];
        Campaign camp = [SELECT Id, CampaignSource__c FROM Campaign WHERE CTIListName__c =: callL.Queue__c];
        
        CallLogMessageJson2Apex callObject;
        if(callL != null && !String.isBlank(callL.Message__c)){
            callObject = (CallLogMessageJson2Apex)JSON.deserialize(callL.Message__c, CallLogMessageJSON2Apex.class);
        }

        List<CampaignMember> campMemberList = new List<CampaignMember>();
        CampaignMember campMember;
        if(callObject.dialerContactId != null){
            campMemberList = [SELECT Id, LeadOrContactId, Contrato__c FROM CampaignMember WHERE ReferenceId__c=:callObject.dialerContactId];
            if(campMemberList.isEmpty())
            {
                throw new AuraHandledException('Não foi encontrado o membro de campanha atrelado ao Id externo');
            }
            campMember = campMemberList[0];
            whoId = campMember.LeadOrContactId;
            whatId = campMember.Contrato__c;
        }

        String phone = String.valueOf(callL.Address__c).substring(Math.max(0, String.valueOf(callL.Address__c).length() - 11));
        if(phone.startsWith('5')){
            phone = phone.replaceFirst('5', '');
        }

        List<ContactDetail__c> contactDetList = [SELECT Id, Contact__c FROM ContactDetail__c
            WHERE (BestPhone__c LIKE :'%'+phone+'%' OR AssistantPhone__c LIKE :'%'+phone+'%' OR
            HomePhone__c LIKE :'%'+phone+'%' OR MobilePhone__c LIKE :'%'+phone+'%' OR OtherPhone__c LIKE :'%'+phone+'%')
            AND Source__c = :camp.CampaignSource__c
            LIMIT 1];
        
        ContactDetail__c contactDet;
        if(!contactDetList.isEmpty())
        {
            contactDet = contactDetList[0];
        }

        String phoneFormatted = callL.Address__c.right(11);
        List<Lead> leadList = [SELECT Id FROM Lead WHERE LeadSource =:camp.CampaignSource__c AND (Phone =: phoneFormatted OR MobilePhone =: phoneFormatted)];
        Lead lead;
        if(!leadList.isEmpty())
        {
            lead = leadList[0];
        }
        
        if(whoId == null){
            if(campMember != null){
                whoId = contactDet.Contact__c;
            }else if(lead != null){
                whoId = lead.Id;
            }
        }

        if(callL.WhoId__c != null){
            whoId = callL.WhoId__c;
        }

        RecordType recType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Telefonema' AND sObjectType = 'Task'];

        task.CTIName__c = 'Genesys';
        task.Call_Log__c = callLogId;
        task.CampaignId__c = camp.Id;
        task.CallDisposition = dipositionPath;
        task.ContactDetail__c = contactDet != null ? contactDet.Id : null;
        task.ContactedPhoneNumber__c = callL.Address__c;
        task.Status = 'Completed';
        task.RecordTypeId = recType.Id;
        task.Subject = 'Chamada ' + System.now().format('yyyy-MM-dd HH:mm:ss','America/Sao_Paulo');

        task.WhatId = whatId;
        task.WhoId = whoId;
		
        insert task;

        if(expiration){
            ExpiredTabulacaoQueueable expQueueable = new ExpiredTabulacaoQueueable(callObject, EXPIRED_DISPOSITION_PATH_EXT_ID);
            System.enqueueJob(expQueueable);
        }
    }
}