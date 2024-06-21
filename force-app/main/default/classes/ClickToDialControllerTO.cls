/**
 * @description       :
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 20-09-2023
 * @last modified by  : samuelsirkis@.wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-09-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public without sharing class ClickToDialControllerTO {
    public class ContactToDial {

        @AuraEnabled public string sobjectname {get; set;}
        @AuraEnabled public string objectId {get; set;}
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string mobilephone{get;set;}
        @AuraEnabled public string homephone{get;set;}
        @AuraEnabled public string otherphone{get;set;}
        @AuraEnabled public string assistantphone{get;set;}
        @AuraEnabled public string bestphone{get;set;}
        @AuraEnabled public string email{get;set;}

    }

    public class PhoneFieldInfo {
        @AuraEnabled public String apiName { get; set; }
        @AuraEnabled public String label { get; set; }

        public PhoneFieldInfo(String apiName, String label) {
            this.apiName = apiName;
            this.label = label;
        }
    }
}