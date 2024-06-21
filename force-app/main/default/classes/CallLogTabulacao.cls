public with sharing class CallLogTabulacao {

    public CallLogTabulacao()
    {}

   @InvocableMethod(
       label='IsPreview Verification' 
       category='CallLog__c'
   )
   public static void isPreviewVerification(List<FlowInput> flowInputies){
        System.debug('Put request');
        FlowInput input = flowInputies[0];
        CallLog__c call = [SELECT Id, Message__c FROM CallLog__c WHERE Id = :input.callLogId];

        CallLogMessageJson2Apex callObject;
        if(call != null && !String.isBlank(call.Message__c)){
            callObject = (CallLogMessageJson2Apex)JSON.deserialize(call.Message__c, CallLogMessageJSON2Apex.class);
            if(callObject.isDialerPreview != null && callObject.isDialerPreview)
            {
                System.enqueueJob(new GenesysInsertTabulacao(callObject, input.filteredTabulation));
            }
        }

        
   }
   
    public class FlowInput{
        @InvocableVariable
        public String callLogId;
        @InvocableVariable
        public String filteredTabulation;
    }
}