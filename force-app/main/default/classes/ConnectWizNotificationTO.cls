public with sharing class ConnectWizNotificationTO {
    public class Notification {

        @AuraEnabled
        public string caseId{get; set;}

        @AuraEnabled
        public string taskId{get;set;}

        @AuraEnabled
        public string opportunityNumber{get;set;}

        @AuraEnabled
        public string subject{get;set;}

        @AuraEnabled
        public string additionalInformation{get;set;}

    }
}