/**
 * @description       : Classe responsável por executar querys no objeto QuoteLineItem
 * @author            : isaac.terceiros@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 26-11-2022
 * @last modified by  : isaac.terceiros@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   05-12-2022   isaac.terceiros@wizsolucoes.com.br  Initial Version
  */

public with sharing class QuoteLineItemDAO {
    public static List<QuoteLineItem> getQuoteLineItensByQuoteId (Set<Id> setQuoteId){
    return [SELECT 
            Id,
            CommissionPercent__c,
            UnitPrice,
            PrizeNetValue__c,
            IOFPrizeValue__C,
            AgencyPercentage__c,
            Product2.name,
            QuoteId
            FROM QuoteLineItem WHERE QuoteId IN: setQuoteId];
    }

    public static QuoteLineItem getQuoteLineItemByQuoteId (Id quoteId){
    return [SELECT 
            Id,
            CommissionPercent__c,
            UnitPrice,
            PrizeNetValue__c,
            IOFPrizeValue__C,
            AgencyPercentage__c,
            Product2.name,
            QuoteId
            FROM QuoteLineItem WHERE QuoteId =: quoteId LIMIT 1];
    }
}