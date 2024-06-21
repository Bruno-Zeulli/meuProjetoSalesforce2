/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
 @SuppressWarnings('PMD.ApexSOQLInjection')
public with sharing class OpportunityDAO {
    /**
    * @description declaração de variaveis */
    private static final OpportunityDAO INSTANCE = new OpportunityDAO();
    private static final Map<String, Object> MAP_OBJ_OPPORTUNITY = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe OpportunityDAO
    * @return instancia da classe OpportunityDAO
    */
    public static OpportunityDAO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca todos os campos do objeto Opportunity
    * @param whereCondition
    * @return mapa Object com key string
    */
    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Opportunity opp : getAllFields(whereCondition)){
            MAP_OBJ_OPPORTUNITY.put(opp.Id, opp);
		}
		return MAP_OBJ_OPPORTUNITY;
	}

    /**
    * @description busca todos os campos do objeto Opportunity
    * @param whereCondition
    * @return list Opportunity
    */
    public List<Opportunity> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Opportunity').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM Opportunity ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    /**
    * @description busca todos os campos do objeto Opportunity
    * @param objectId
    * @return list Opportunity
    */
    public List<Opportunity> getAllFieldsById(String objectId){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Opportunity').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query += ' Account.Name, (SELECT Id,Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id = \'' +  objectId + '\'' + ' LIMIT 100';

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

     public List<Opportunity> getOpportunitiesByIds(Set<Id> setIdsOpportunities){
        return [
            SELECT
                Id, Name, LeadSource, RecordTypeId, ExternalReferenceId__c,EnterpriseName__c,OpportunityOwner__c,Owner.SalesUnit__c
            FROM
                Opportunity
            WHERE Id IN :setIdsOpportunities
        ];
    }

    public static Opportunity getOpportunitiesByCaseId (Id caseId){
        return [SELECT
                    Id,
                    CloseDate,
                    Description,
                    StageName,
                    Type,
                    ProbabilityOfWinning__c,
                    InsuredAmount__c,
                    IsInsuranceRestriction__c,
                    IsOpportunityNomination__c,
                    DescriptionOfRestriction__c,
                    EnterpriseName__c,
                    OpportunityOwner__c,
                    Owner.SalesUnit__c,
                        (SELECT
                            Id,
                            Product2.Name,
                            UnitPrice,
                            ExpectedCommission__c,
                            QuantityOfItems__c,
                            TotalPrice
                        FROM OpportunityLineItems)
                    FROM Opportunity WHERE Id IN (SELECT Opportunity__c FROM Case WHERE Id =: caseId) LIMIT 1
                ];
    }

    public List<Opportunity> getOpportunityByCaseId(Id caseId){
        return [SELECT
                    Id,
                    CloseDate,
                    Description,
                    StageName,
                    Type,
                    ProbabilityOfWinning__c,
                    InsuredAmount__c,
                    IsInsuranceRestriction__c,
                    IsOpportunityNomination__c,
                    EnterpriseName__c,
                        (SELECT
                            Id,
                            Product2.Name,
                            UnitPrice,
                            ExpectedCommission__c,
                            QuantityOfItems__c
                        FROM OpportunityLineItems)
                FROM
                    Opportunity
                WHERE Id IN (SELECT Opportunity__c FROM Case WHERE Id =: caseId) LIMIT 1];
    }
}