public with sharing class CallLogGetCampaignMemberHelper {
    public CallLogGetCampaignMemberHelper() {}

   @InvocableMethod(
       label='Get ReferenceId in CampaignMember by CallLog' 
       category='CallLog__c'
   )
   public static List<FlowOutput> getReferenceIdByCallLog(List<FlowInput> flowInputies){
        FlowInput input = flowInputies[0];
        List<FlowOutput> listFlowOutput = new List<FlowOutput>();
        CallLog__c call = [SELECT Id, Message__c FROM CallLog__c WHERE Id = :input.callLogId];

        CallLogMessageJson2Apex callObject;
        if(call != null && !String.isBlank(call.Message__c)){
            callObject = (CallLogMessageJson2Apex)JSON.deserialize(call.Message__c, CallLogMessageJSON2Apex.class);
            listFlowOutput.add(new FlowOutput(
                            callObject.dialerContactId
                        ));
            return listFlowOutput;
        }
        return null;
   }
   
    public class FlowInput{
        @InvocableVariable
        public String callLogId;
    }
    
    public class FlowOutput{
        @InvocableVariable
        public String referenceId;

        public FlowOutput(String referenceId){
            this.referenceId = referenceId;
        }
    }
}