/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 12-22-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   12-22-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class CaseDataFactory {
    public static Case createCase(){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
        Case caseVariable = new Case(Subject = 'Teste', Status = 'Open', RecordTypeId = recordType, ExternalReferenceId__c = '');
        return caseVariable;
    }

    public static Case insertCase(){
        Case caseVariable = createCase();
        insert caseVariable;
        return caseVariable;
    }

    public static Case insertComunicadoSinistro(Id accountId, Id personContactId, Id contactDetailId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();

        Case c = new Case(
            Subject = 'Comunicado de Sinistro',
            Description = 'Descrição da ocorrência',
            Origin = 'BPO - Concierge',
            Type = 'BPO - MIP - Imóvel construído',
            Status = 'BPO - Não Tratado',
            Reason = 'BPO - Incêndio, Raio e Explosão',
            Priority = 'Medium',
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            RecordTypeId = recordType,
            ExternalReferenceId__c = (accountId + ' | ' + personContactId + ' | ' + recordType)
        );

        insert c;
        return c;
    }

    public static Case insertComunicadoSinistroNaoSincronizado(Id accountId, Id personContactId, Id contactDetailId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
        Case c = new Case(
            Subject = 'Comunicado de Sinistro ',
            Description = 'Descrição da ocorrência',
            Origin = 'BPO - Concierge',
            Type = 'BPO - MIP - Imóvel construído',
            Status = 'BPO - Comunicado Aberto',
            Reason = 'BPO - Incêndio, Raio e Explosão',
            Priority = 'Medium',
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            RecordTypeId = recordType
        );

        insert c;
        return c;
    }

    public static Case insertSinistro(Id accountId, Id idComunicado, Id personContactId, Id contactDetailId, Id contractId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroHabitacional').getRecordTypeId();

        Case c = new Case(
            Subject = 'Sinistro',
            Description = 'Descrição da ocorrência',
            Origin = 'BPO - Concierge',
            Type = 'BPO - DFI - Imóvel construído',
            Status = 'BPO - Comunicado Aberto',
            Reason = 'BPO - Incêndio, Raio e Explosão',
            Priority = 'High',
            ParentId = idComunicado,
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            Contract2__c = contractId,
            RecordTypeId = recordType,
            //Concierge_IncidentWorkflowStatus__c = 'Em análise',
            RequestDate__c = Date.today(),
            ExternalReferenceId__c = (accountId + ' | ' + contractId)
        );

        insert c;
        return c;
    }

    public static Case insertSinistroHabWithoutExternalId(Id accountId, Id idComunicado, Id personContactId, Id contactDetailId, Id contractId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroHabitacional').getRecordTypeId();

        Case c = new Case(
            Subject = 'Sinistro',
            Description = 'Descrição da ocorrência',
            Origin = 'BPO - Concierge',
            Type = 'BPO - DFI - Imóvel construído',
            Status = 'BPO - Comunicado Aberto',
            Reason = 'BPO - Incêndio, Raio e Explosão',
            Priority = 'High',
            ParentId = idComunicado,
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            Contract2__c = contractId,
            RecordTypeId = recordType,
            //Concierge_IncidentWorkflowStatus__c = 'Em análise',
            RequestDate__c = Date.today()
            // ExternalReferenceId__c = (accountId + ' | ' + contractId)
        );

        insert c;
        return c;
    }

    public static Case insertSinistroPrestamista(Id accountId, Id idComunicado, Id personContactId, Id contactDetailId, Id contractId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroPrestamista').getRecordTypeId();
        Case c = new Case(
            Subject = 'Sinistro',
            Description = 'Sinistro por Morte Natural',
            Origin = 'BPO - Concierge',
            Type = 'BPO - MIP - Morte natural',
            Status = 'BPO - Comunicado Aberto',
            Priority = 'High',
            ParentId = idComunicado,
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            Contract2__c = contractId,
            RecordTypeId = recordType,
            ExternalReferenceId__c = (accountId + ' | ' +  contractId)
        );

        insert c;
        return c;
    }

    public static Case insertSinistroRCPM(Id accountId, Id personContactId, Id contactDetailId, Id contractId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPORcpm').getRecordTypeId();
        Case c = new Case(
            Subject = 'Sinistro',
            Description = 'Sinistro Desmoronamento',
            Origin = 'BPO - RCPM',
            Type = 'BPO - RCPM - Desmoronamento',
            Status = 'BPO - Comunicado Aberto',
            Priority = 'High',
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            Contract2__c = contractId,
            RecordTypeId = recordType,
            ExternalReferenceId__c = (accountId +
            ' | ' +
            contractId)
        );

        insert c;
        return c;
    }

    public static Case insertSinistroAgro(Id accountId, Id personContactId, Id contactDetailId, Id contractId){
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOAgro').getRecordTypeId();
        Case c = new Case(
            Subject = 'Sinistro',
            Description = 'Sinistro de Agro',
            Origin = 'BPO - App',
            Type = 'BPO - Agro',
            Status = 'BPO - Comunicado Aberto',
            Priority = 'High',
            AccountId = accountId,
            ContactId = personContactId,
            ContactDetail__c = contactDetailId,
            Contract2__c = contractId,
            RecordTypeId = recordType,
            ExternalReferenceId__c = (accountId + ' | ' + contractId)
        );

        insert c;
        return c;
    }

    public static Case createCaseCorporateComercial(Id accountId, Id opportunityId){
        Case c = new Case(
            Subject = 'Teste Case Benfícios',
            Description = 'Teste Case Benfícios',
            Origin = 'Web',
            Type = 'Cotação',
            Status = 'Novo Pedido',
            Priority = 'High',
            AccountId = accountId,
            Opportunity__c = opportunityId,
            Contract2__c = null,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId()
        );

        insert c;
        return c;
    }
}