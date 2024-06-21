public with sharing class QuoteIntegralizationDAO {
    private static final QuoteIntegralizationDAO INSTANCE = new QuoteIntegralizationDAO();

    /**
    * @description constroi a instancia da classe QuoteIntegralizationDAO
    * @return instancia da classe QuoteIntegralizationDAO
    */
    public static QuoteIntegralizationDAO getInstance(){
        return INSTANCE;
    }

    public List<QuoteIntegralization__c> getCompositionQuotesByProposal(Set<Id> proposalIds){
        return [
            SELECT 
                Id,
                InsuredAmount__c,
                IntegralQuote__c,
                PartialQuote__r.Id,
                PartialQuote__r.Name,
                PartialQuote__r.Opportunity.InsuredAmount__c,
                PartialQuote__r.QuoteRequestDate__c,
                PartialQuote__r.QuoteReceiptDate__c,
                PartialQuote__r.Company__c,
                PartialQuote__r.PrizeAmount__c,
                PartialQuote__r.InsuredAmount__c,
                PartialQuote__r.Description,
                PartialQuote__r.OpportunityId,
                PartialQuote__r.RecordTypeId,
                PartialQuote__r.AdditionalInsuredAmount__c,
                PartialQuote__r.AdditionalInsuredAmount2__c,
                PartialQuote__r.Pricebook2.Name,
                PartialQuote__r.Status
            FROM QuoteIntegralization__c
            WHERE IntegralQuote__c IN :proposalIds
        ];
    }
}