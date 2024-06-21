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
public with sharing class QuoteDAO {

    /**
    * @description declaração de variaveis */
    private static final QuoteDAO INSTANCE = new QuoteDAO();
    private static final Map<String, Object> MAP_OBJ_QUOTE = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe QuoteDAO
    * @return instancia da classe QuoteDAO
    */
    public static QuoteDAO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca todos os campos do objeto Quote
    * @param whereCondition
    * @return mapa Object com key string
    */
    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Quote objQuote : getAllFields(whereCondition)){
            MAP_OBJ_QUOTE.put(objQuote.Id, objQuote);
		}
		return MAP_OBJ_QUOTE;
	}

    /**
    * @description busca todos os campos do objeto Quote
    * @param whereCondition
    * @return mapa Object com key string
    */
    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Quote> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Quote').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM Quote ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    public List<Quote> getQuoteByOpportunityId(Set<Id> lOpportunityIds){

        return [SELECT  Id,
                        Company__c,
                        Description,
                        OpportunityId,
                        PrizeAmount__c,
                        QuoteReceiptDate__c,
                        QuoteRequestDate__c,
                        RecordTypeId,
                        InsuredAmount__c,
                        AdditionalInsuredAmount__c,
                        AdditionalInsuredAmount2__c,
                        Pricebook2.Name,
                        Status
                FROM    Quote
                WHERE   OpportunityId IN :lOpportunityIds];
    }

    public static Quote getQuoteById(Id quoteId){
        return [SELECT  Id,
                        Company__c,
                        Description,
                        OpportunityId,
                        PrizeAmount__c,
                        QuoteReceiptDate__c,
                        QuoteRequestDate__c,
                        RecordTypeId,
                        InsuredAmount__c,
                        AdditionalInsuredAmount__c,
                        AdditionalInsuredAmount2__c,
                        Pricebook2.Name,
                        Status
                FROM    Quote
                WHERE   Id = :quoteId LIMIT 1];
    }

    public static List<Quote> getQuoteByOppId(Id oppId){
        return [SELECT  Id,
                        Company__c,
                        Description,
                        OpportunityId,
                        PrizeAmount__c,
                        QuoteReceiptDate__c,
                        QuoteRequestDate__c,
                        RecordTypeId,
                        InsuredAmount__c,
                        AdditionalInsuredAmount__c,
                        AdditionalInsuredAmount2__c,
                        Pricebook2.Name,
                        Status
                FROM    Quote
                WHERE   OpportunityId = :oppId LIMIT 1];
    }

    public static List<Quote> getQuotesByOppId(Id oppId){
        return [SELECT  Id,
                        Company__c,
                        Description,
                        OpportunityId,
                        PrizeAmount__c,
                        QuoteReceiptDate__c,
                        QuoteRequestDate__c,
                        RecordTypeId,
                        InsuredAmount__c,
                        AdditionalInsuredAmount__c,
                        AdditionalInsuredAmount2__c,
                        Pricebook2.Name,
                        Status
                FROM    Quote
                WHERE   OpportunityId = :oppId];
    }

    public List<Quote> getPortalQuotesByOppIdAndRecTypeId(String oppId, String recTypeId){
        return [
            SELECT 
                Id,
                Name,
                Opportunity.InsuredAmount__c,
                QuoteRequestDate__c,
                QuoteReceiptDate__c,
                Company__c,
                PrizeAmount__c,
                InsuredAmount__c,
                Description,
                OpportunityId,
                RecordTypeId,
                AdditionalInsuredAmount__c,
                AdditionalInsuredAmount2__c,
                Pricebook2.Name,
                Status,
                (
                    SELECT 
                        Id,
                        PrizeNetValue__c,
                        IOFPrizeValue__c,
                        CommissionPercent__c,
                        AgencyPercentage__c,
                        UnitPrice,
                        Product2.name,
                        QuoteId
                    FROM QuoteLineItems
                    LIMIT 1
                )
            FROM Quote
            WHERE OpportunityId = :oppId AND RecordTypeId = :recTypeId
        ];
    }

    
}