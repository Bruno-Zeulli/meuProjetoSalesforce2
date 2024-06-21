public with sharing class CampaignService {
    
    public static Integer MIN_SECONDS = 60;

    @AuraEnabled(cacheable=true)
    public static Integer getTimeCampaign(String callLogId){
        CallLog__c cl = [SELECT Id, Message__c FROM CallLog__c WHERE Id=:callLogId];
        
        if(cl == null){
            return MIN_SECONDS;
        }

        CallLogMessageJSON2Apex msgObj =  (CallLogMessageJson2Apex)JSON.deserialize(cl.Message__c, CallLogMessageJSON2Apex.class);

        List<Campaign> cpgnList = [SELECT Id, TabulationTime__c FROM Campaign WHERE Name =:msgObj.queueName LIMIT 1];
        
        if(cpgnList.size() > 0){
            return (Integer)cpgnList[0].TabulationTime__c;
        }else{
            return MIN_SECONDS;
        }

    }
}