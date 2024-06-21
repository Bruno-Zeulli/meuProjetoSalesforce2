@isTest
public class CallLogMessageJSON2ApexTest {
	@isTest
    public static void test()
    {
        String jsonInput = '{"id":"07447c91-f815-4756-84cb-539faad433be","connectedTime":"2023-11-21T01:25:39.837Z","endTime":"2023-11-21T01:26:05.779Z","phone":"tel:+5561996578345","name":"Mobile Number, Brazil","isConnected":false,"isDisconnected":true,"isDone":false,"state":"DESCONECTADO","isCallback":false,"isDialer":false,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Mobile Number, Brazil","recordingState":"active","displayAddress":"+5561996578345","queueName":"Conseg: Ativo Manual Renovação","ani":"Interno","calledNumber":"+5561996578345","interactionDurationSeconds":26,"direction":"Outbound","isInternal":false,"startTime":"2023-11-21T01:25:28.944Z"}';
        CallLogMessageJSON2Apex obj = (CallLogMessageJSON2Apex) JSON.deserialize(jsonInput, CallLogMessageJSON2Apex.class);
        
        obj.ani = '';
        obj.calledNumber = '';
        obj.connectedTime = '';
        obj.dialerCampaignId = '';
        obj.dialerContactId = '';
        obj.direction = '';
        obj.displayAddress = '';
        obj.dispositionDurationSeconds = 1;
        obj.endTime = '';
        obj.interactionDurationSeconds = 2;
        obj.isCallback = true;
        obj.isChat = false;
        obj.isConnected = true;
        obj.isDialer = true;
        obj.isDialerPreview = true;
        obj.name = '';
        obj.phone = '';
        obj.state = '';
        obj.id = '';
        obj.totalAcdDurationSeconds = 3;
        obj.remoteName = '';
        obj.queueName = '3';
        obj.startTime = '3';
        obj.isMessage = true;
        obj.isVoicemail = true;
        obj.isEmail = true;
        obj.isInternal = true;
        obj.isDisconnected = true;
        obj.isDone = true;
        
        System.assertNotEquals(obj, null, 'O objeto deve ser diferente de nulo');
    }
}