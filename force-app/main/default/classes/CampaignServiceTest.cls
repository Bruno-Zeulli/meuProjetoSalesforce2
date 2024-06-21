@isTest
public class CampaignServiceTest {
     @TestSetup
    static void makeData(){
        CallLog__c cl = new CallLog__c();
        cl.Message__c = '{"id":"fc848988-a7d5-44aa-a4bf-6ad2b071a929","connectedTime":"2024-01-25T19:36:10.359Z","endTime":"2024-01-25T19:36:16.470Z","phone":"tel:+5585988309552","name":"Mobile Number, Brazil","isConnected":false,"isDisconnected":true,"isDone":false,"state":"DESCONECTADO","isCallback":false,"isDialer":false,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Mobile Number, Brazil","recordingState":"none","displayAddress":"+5585988309552","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5585988309552","interactionDurationSeconds":6,"direction":"Outbound","isInternal":false,"startTime":"2024-01-25T19:36:01.970Z"}';
		cl.DivisionId__c = 'test_callLog';
        insert cl;
    }

	@isTest
    public static void getTimeCampaignTest()
    {
        CallLog__c cl = [SELECT Id FROM CallLog__c WHERE DivisionId__c = 'test_callLog'];
        CampaignService.getTimeCampaign((String)cl.Id);
    }
}