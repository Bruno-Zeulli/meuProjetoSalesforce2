/**
 * @description       : Classe responsável por executar querys no objeto OpportunityLineItem
 * @author            : isaac.terceiros@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 26-11-2022
 * @last modified by  : isaac.terceiros@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   22-02-2021   isaac.terceiros@wizsolucoes.com.br  Initial Version
  */

public with sharing class OpportunityLineItemDAO {

    public static OpportunityLineItem getOpportunityLineItensByOpportunityId (Id opportunityId){
        return [SELECT Id,PricebookEntryId,Product2Id,Product2.Name FROM OpportunityLineItem WHERE OpportunityId =: opportunityId LIMIT 1];
    }

    public static List<OpportunityLineItem> getOppLineItemByListOpportunityId(Set<Id> lOpportunityIds){

        return [    SELECT  Id,
                            OpportunityId,
                            Product2Id,
                            Product2.Name,
                            Product2.Family,
                            Product2.QuoteReturnSLA__c
                    FROM    OpportunityLineItem
                    WHERE   OpportunityId IN :lOpportunityIds];
    }
}