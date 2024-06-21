/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class TaskDataFactory {

    static final id RECORDTYPE_TELEFONEMA = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Telefonema').getRecordTypeId();
    public static Task createCallTask(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityWithRecordType(acc.Id, 'BPOTelevendas');
        User u = UserDataFactory.getAdminUser();

        Task taskVariable = new Task(
            OwnerId = u.Id,
            Subject = 'Chamada - Teste',
            RecordTypeId = RECORDTYPE_TELEFONEMA,
            WhatId = Opp.Id,
            CallDisposition ='1.4.3.6 Já contratou com outro banco',
            CTIName__c = 'Olos'
        );

        return taskVariable;
    }

    public static Task insertCallTask(){
        Task taskVariable = createCallTask();
        insert taskVariable;
        return taskVariable;
    }

    public static Task insertCallTaskWithCase(Id caseId){
        Task taskVariable = createCallTaskWithCase(caseId);
        insert taskVariable;
        return taskVariable;
    }

    public static Task createCallTaskWithCase(Id caseId){
        User u = UserDataFactory.getAdminUser();

        Task taskVariable = new Task(
            Subject = 'Chamada',
            RecordTypeId = RECORDTYPE_TELEFONEMA,
            WhatId = caseId,
            ActivityDate = Date.today(),
            OwnerId =u.Id
        );
        return taskVariable;
    }

    public static Task insertCallTaskWithAccountAndOpp(Id accId, Id oppId){
        Task taskVariable = createCallTaskWithAccountAndOpp(accId, oppId);
        insert taskVariable;
        return taskVariable;
    }

    public static Task createCallTaskWithAccountAndOpp(Id accId, Id oppId){
        User u = UserDataFactory.getAdminUser();
        Task taskVariable = new Task(
            Subject = 'Chamada',
            RecordTypeId = RECORDTYPE_TELEFONEMA,
            WhatId = oppId,
            WhoId = accId,
            ActivityDate = Date.today(),
            CallDisposition = '5.5 Transferência de atendimento para o whatsapp',
            OwnerId = u.Id
        );
        return taskVariable;
    }

    public static Task insertVIPOppTask(Id personContactId, Id oppId){
        Task task = createVIPOppTask(personContactId, oppId);
        insert task;
        return task;
    }

    public static Task createVIPOppTask(Id personContactId, Id oppId){
        User u = [SELECT id FROM User WHERE UserRole.Name LIKE '%VIP - Atendimento%' AND Name LIKE '%joyce%' LIMIT 1];
        Task taskVariable = new Task(
            Subject = 'Chamada',
            RecordTypeId = RECORDTYPE_TELEFONEMA,
            WhatId = oppId,
            WhoId = personContactId,
            ActivityDate = Date.today(),
            CallDisposition = '1.6 Venda',
            OwnerId = u.Id
        );
        return taskVariable;
    }
}