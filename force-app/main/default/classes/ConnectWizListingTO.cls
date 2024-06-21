public with sharing class ConnectWizListingTO { 
    
    public class Error {
        public String title {get; set;}
        public String details {get; set;}
    }

    public class ReqBody{
        public List<String> accIds {get; set;}
    }
    
    public class PolicyResponse {
        
        public String accId {get; set;}
        public String accName {get; set;}
        public List<Policy> policies {get; set;}
        public PolicyResponse(String accId, String accName){
            this.accId = accId;
            this.accName = accName;
            this.policies = new List<ConnectWizListingTO.Policy>();
        }
    }

    public class Policy{
        public String oppId {get; set;}
        public String orderId {get; set;}
        public String poN {get; set;}
        public String company {get; set;}
        public String product {get; set;}
        public Date sDate {get; set;}
        public Date endDate {get; set;}
        public String status {get; set;}
        public String broker {get; set;}
        public String coCompany {get; set;}
        public Date dtFInst {get; set;}
    }  

    public class QuoteResponse {
        
        public String accId {get; set;}
        public String accName {get; set;}
        public List<Quote> quotes {get; set;}
        public QuoteResponse(String accountId, String accName){
            this.accId = accountId;
            this.accName = accName;
            this.quotes = new List<ConnectWizListingTO.Quote>();
        }
    }

    public class Quote{
        public String oppId {get; set;}
        public String oppNumber {get; set;}
        public String product {get; set;}
        public Date sDate {get; set;}
        public String type {get; set;}
        public String parentOrder {get; set;}
        public String stage {get; set;}
        public String status {get; set;}
    }
}