/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-05-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
public with sharing class CaseDAO {

    /**
    * @description declaração de variaveis */
    private static final CaseDAO INSTANCE = new CaseDAO();
    private static final Map<String, Object> MAP_OBJ_CASE = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe CaseDAO
    * @return instancia da classe CaseDAO
    */

    public static CaseDao getInstance(){
        return INSTANCE;
    }

     public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Case objCase : getAllFields(whereCondition)){
            MAP_OBJ_CASE.put(objCase.Id, objCase);
		}
		return MAP_OBJ_CASE;
	}

    /**
    * @description busca todos os campos do objeto case
    * @param whereCondition
    * @return lista de case
    */
    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Case> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Case').getDescribe().fields.getMap();

        String query = 'SELECT ';

       for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
       }

        query = query.substring(0, query.length()-1) + ' FROM Case ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    public List<Case> getCasesByOwnerIds(Set<Id> ownerIds){
       return [SELECT Id,
                    CaseNumber,
                    CaseReason__c,
                    Contact.Id,
                    Contact.Name,
                    Type,
                    NPS__c,
                    Subject,
                    StatusTickets__c,
                    Status,
                    Priority,
                    RecordtypeId,
                    CreatedDate,
                    Owner.Id,
                    Owner.Name,
                    RecordType.Name,
                    RecordType.DeveloperName,
                    Motivo_Tkt__c,
                    Tipo_Tkt__c,
                    Grupo_Tkt__c,
                    Contact_Tkt__c,
                    Contact_Tkt__r.Name,
                    ContactId,
                    LastModifiedDate,
                    Subtipo_Tkt__c,
                    ContactDetail__c,
                    ContactDetail__r.Id,
                    ContactDetail__r.Name,
                    ContactDetail__r.Email__c,
                    Procedente_Tkt__c,
                    Opportunity__r.LeadSource
                FROM Case
                WHERE OwnerId IN :ownerIds AND RecordType.DeveloperName LIKE '%_Tkt' AND  CreatedDate = THIS_YEAR
                ORDER BY LastModifiedDate DESC LIMIT 2000];
    }

    public List<Case> getCasesByOwnerIdAndRecordTypeId(Set<Id> lOwnerIds, Set<Id> lRecordTypeIds){

        return [SELECT  Id,
                        CaseNumber,
                        CaseReason__c,
                        Contact.Id,
                        Contact.Name,
                        Type,
                        NPS__c,
                        Subject,
                        StatusTickets__c,
                        Status,
                        Priority,
                        RecordtypeId,
                        CreatedDate,
                        Owner.Id,
                        Owner.Name,
                        Origin,
                        RecordType.Name,
                        RecordType.DeveloperName,
                        Motivo_Tkt__c,
                        Tipo_Tkt__c,
                        Grupo_Tkt__c,
                        Contact_Tkt__c,
                        Contact_Tkt__r.Name,
                        ContactId,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        Subtipo_Tkt__c,
                        ContactDetail__c,
                        ContactDetail__r.Id,
                        ContactDetail__r.Name,
                        ContactDetail__r.Email__c,
                        Procedente_Tkt__c,
                        Opportunity__c,
                        OpportunityOwner__c,
                        AccountId,
                        Account.Name
                FROM    Case
                WHERE   OwnerId IN :lOwnerIds
                AND     RecordTypeId IN :lRecordTypeIds
                ORDER BY CreatedDate DESC];
    }

    public List<Case> getCasesByRecordTypeId(Set<Id> lRecordTypeIds){

        return [SELECT  Id,
                        CaseNumber,
                        CaseReason__c,
                        Contact.Id,
                        Contact.Name,
                        Type,
                        NPS__c,
                        Subject,
                        StatusTickets__c,
                        Status,
                        Priority,
                        RecordtypeId,
                        CreatedDate,
                        Owner.Id,
                        Owner.Name,
                        Origin,
                        RecordType.Name,
                        RecordType.DeveloperName,
                        Motivo_Tkt__c,
                        Tipo_Tkt__c,
                        Grupo_Tkt__c,
                        Contact_Tkt__c,
                        Contact_Tkt__r.Name,
                        ContactId,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        Subtipo_Tkt__c,
                        ContactDetail__c,
                        ContactDetail__r.Id,
                        ContactDetail__r.Name,
                        ContactDetail__r.Email__c,
                        Procedente_Tkt__c,
                        Opportunity__c,
                        OpportunityOwner__c,
                        AccountId,
                        Account.Name
                FROM    Case
                WHERE   RecordTypeId IN :lRecordTypeIds
                ORDER BY CreatedDate DESC];
    }

    public List<Case> getCasesByOwnerId(Set<Id> lOwnerIds){
        Set<String> setCaseStatus = new Set<String>{
            'Novo pedido',
            'Análise de dados da oportunidade',
            'Com pendência',
            'Aguardando cotação',
            'Aguardando aprovação da cotação',
            'Repique',
            'Aguardando emissão da apólice',
            'Processo anulado',
            'Apólice registrada'
        };


        return [SELECT Id,
                        CaseNumber,
                        CaseReason__c,
                        Contact.Id,
                        Contact.Name,
                        Type,
                        NPS__c,
                        Subject,
                        StatusTickets__c,
                        Status,
                        Priority,
                        RecordtypeId,
                        CreatedDate,
                        OwnerId,
                        Owner.Name,
                        Origin,
                        RecordType.Name,
                        RecordType.DeveloperName,
                        Motivo_Tkt__c,
                        Tipo_Tkt__c,
                        Grupo_Tkt__c,
                        Contact_Tkt__c,
                        Contact_Tkt__r.Name,
                        ContactId,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        Subtipo_Tkt__c,
                        ContactDetail__c,
                        ContactDetail__r.Id,
                        ContactDetail__r.Name,
                        ContactDetail__r.Email__c,
                        Procedente_Tkt__c,
                        Opportunity__c,
                        OpportunityOwner__c,
                        Opportunity__r.OpportunityNumber__c,
                        Opportunity__r.leadSource,
                        AccountId,
                        Account.Name,
                        Account.IdentificationNumber__c
                FROM    Case
                WHERE   OwnerId IN :lOwnerIds and Status IN: setCaseStatus and Opportunity__r.Id != null
                ORDER BY CreatedDate DESC];
    }

    /**
    * @description busca todos os campos do objeto case
    * @param recordTypeId
    * @param opportunityId
    * @return lista de case
    */
    public List<Case> getCasesByOpportunityId(Id opportunityId){

        return [SELECT  Id,
                        CaseNumber,
                        CaseReason__c,
                        Contact.Id,
                        Contact.Name,
                        Type,
                        NPS__c,
                        Subject,
                        StatusTickets__c,
                        Status,
                        Priority,
                        RecordtypeId,
                        CreatedDate,
                        Owner.Id,
                        Owner.Name,
                        Origin,
                        RecordType.Name,
                        RecordType.DeveloperName,
                        Motivo_Tkt__c,
                        Tipo_Tkt__c,
                        Grupo_Tkt__c,
                        Contact_Tkt__c,
                        Contact_Tkt__r.Name,
                        ContactId,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        Subtipo_Tkt__c,
                        ContactDetail__c,
                        ContactDetail__r.Id,
                        ContactDetail__r.Name,
                        ContactDetail__r.Email__c,
                        Procedente_Tkt__c,
                        Opportunity__c,
                        OpportunityOwner__c,
                        AccountId,
                        Account.Name
                FROM    Case
                WHERE   Opportunity__c =: opportunityId
                ORDER BY CreatedDate DESC LIMIT 100];
    }

    public static Case getCaseById(Id caseId){
        return [SELECT  Id,
                        CaseNumber,
                        CaseReason__c,
                        Contact.Id,
                        Contact.Name,
                        Type,
                        NPS__c,
                        Subject,
                        StatusTickets__c,
                        Status,
                        Priority,
                        RecordtypeId,
                        CreatedDate,
                        Owner.Id,
                        Owner.Name,
                        Origin,
                        RecordType.Name,
                        RecordType.DeveloperName,
                        Motivo_Tkt__c,
                        Tipo_Tkt__c,
                        Grupo_Tkt__c,
                        Contact_Tkt__c,
                        Contact_Tkt__r.Name,
                        ContactId,
                        LastModifiedDate,
                        LastModifiedBy.Name,
                        Subtipo_Tkt__c,
                        ContactDetail__c,
                        ContactDetail__r.Id,
                        ContactDetail__r.Name,
                        ContactDetail__r.Email__c,
                        Procedente_Tkt__c,
                        Opportunity__c,
                        OpportunityOwner__c,
                        AccountId,
                        Account.Name
                FROM    Case
                WHERE   Id =: caseId LIMIT 1];
    }
}