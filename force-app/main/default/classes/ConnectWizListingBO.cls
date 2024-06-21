public with sharing class ConnectWizListingBO { 
    /**
     * Singleton implementation
     */
    private static final ConnectWizListingBO INSTANCE = new ConnectWizListingBO();
    
    public static ConnectWizListingBO getInstance() {
        return INSTANCE;
    }

    public Map<String,ConnectWizListingTO.PolicyResponse> getPoliciesByAccs(List<String> accIds){
        
        Map<String,ConnectWizListingTO.PolicyResponse> responseToReturn = new Map<String,ConnectWizListingTO.PolicyResponse>();
        
        List<Opportunity> oppsToFilter = [SELECT Id, 
                                                 Latest_Order_EndDate__c, 
                                                 AccountId, 
                                                 Account.Name,
                                                 Product_Name__c,
                                                 Latest_Order__c,
                                                 Latest_Order__r.PoNumber,
                                                 Latest_Order__r.PoDate,
                                                 Latest_Order__r.Company__c,
                                                 Latest_Order__r.DateOfFirstInstallment__c,
                                                 Status_Portal__c,
                                                 CorretoraApoliceLookup__r.Name,
                                                 Latest_Order__r.Quote.CoinsuranceCompany__c  
                                        FROM Opportunity 
                                        WHERE (NOT Status_Portal__c LIKE 'Indefinido%') AND (NOT Status_Portal__c IN (NULL,'Em Emissão','Em Análise','Endosso Emitido','Endosso Em Emissão')) AND AccountId IN : accIds];
        
        for(Opportunity opp:oppsToFilter){
            
            if(!responseToReturn.keySet().contains(opp.AccountId)){
                responseToReturn.put(opp.AccountId,new ConnectWizListingTO.PolicyResponse(opp.AccountId, opp.Account.Name));
            }
            ConnectWizListingTO.Policy policyToAdd = new ConnectWizListingTO.Policy();
            policyToAdd.oppId = opp.Id;
            policyToAdd.orderId = opp.Latest_Order__c;
            policyToAdd.poN = opp.Latest_Order__r.PoNumber;
            policyToAdd.company = opp.Latest_Order__r.Company__c;
            policyToAdd.product = opp.Product_Name__c;
            policyToAdd.sDate = opp.Latest_Order__r.PoDate;
            policyToAdd.endDate = opp.Latest_Order_EndDate__c;
            policyToAdd.status = opp.Status_Portal__c;
            policyToAdd.broker = opp.CorretoraApoliceLookup__r.Name;
            policyToAdd.coCompany = opp.Latest_Order__r.Quote.CoinsuranceCompany__c;
            policyToAdd.dtFInst = opp.Latest_Order__r.DateOfFirstInstallment__c;

            responseToReturn.get(opp.AccountId).policies.add(policyToAdd);
        }

        return responseToReturn;
    }

    public Map<String,ConnectWizListingTO.QuoteResponse> getQuotesByAccs(List<String> accIds){
        
        Map<String,ConnectWizListingTO.QuoteResponse> responseToReturn = new Map<String,ConnectWizListingTO.QuoteResponse>();
        
        List<Opportunity> oppsFilter = [SELECT Id, 
                                                 OpportunityNumber__c, 
                                                 AccountId, 
                                                 Account.Name,
                                                 Product_Name__c,
                                                 Type,
                                                 ParentOrderId__r.PoNumber,
                                                 StageName,
                                                 CreatedDate,
                                                 Status_Portal__c  
                                        FROM Opportunity 
                                        WHERE Status_Portal__c IN ('Em Emissão','Em Análise','Endosso Em Emissão') AND AccountId IN : accIds];
        
        for(Opportunity opp:oppsFilter){
            
            if(!responseToReturn.keySet().contains(opp.AccountId)){
                responseToReturn.put(opp.AccountId,new ConnectWizListingTO.QuoteResponse(opp.AccountId, opp.Account.Name));
            }
            ConnectWizListingTO.Quote quoteToAdd = new ConnectWizListingTO.Quote();
            quoteToAdd.oppId = opp.Id;
            quoteToAdd.oppNumber = opp.OpportunityNumber__c;
            quoteToAdd.product = opp.Product_Name__c;
            quoteToAdd.sDate = opp.CreatedDate.date();
            quoteToAdd.type = opp.Type;
            quoteToAdd.parentOrder = opp.ParentOrderId__r.PoNumber;
            quoteToAdd.stage = opp.StageName;
            quoteToAdd.status = opp.Status_Portal__c;

            responseToReturn.get(opp.AccountId).quotes.add(quoteToAdd);
        }

        return responseToReturn;
    }
}