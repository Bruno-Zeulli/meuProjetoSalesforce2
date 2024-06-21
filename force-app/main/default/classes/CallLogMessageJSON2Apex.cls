public class CallLogMessageJSON2Apex {

	public String id {get;set;} 
	public String connectedTime {get;set;} 
	public String endTime {get;set;} 
	public String phone {get;set;} 
	public String name {get;set;} 
	public Boolean isConnected {get;set;} 
	public Boolean isDisconnected {get;set;} 
	public Boolean isDone {get;set;} 
	public String state {get;set;} 
	public Boolean isCallback {get;set;} 
	public Boolean isDialer {get;set;} 
	public Boolean isChat {get;set;} 
	public Boolean isEmail {get;set;} 
	public Boolean isMessage {get;set;} 
	public Boolean isVoicemail {get;set;} 
	public String remoteName {get;set;} 
	public String recordingState {get;set;} 
	public String displayAddress {get;set;} 
	public String queueName {get;set;} 
	public String ani {get;set;} 
	public String calledNumber {get;set;} 
	public Integer interactionDurationSeconds {get;set;} 
	public Integer totalAcdDurationSeconds {get;set;} 
	public Integer dispositionDurationSeconds {get;set;} 
	public String direction {get;set;} 
	public Boolean isInternal {get;set;} 
	public String startTime {get;set;} 
	public Boolean isDialerPreview {get;set;} 
	public String dialerContactId {get;set;} 
	public String dialerContactListId {get;set;} 
	public String dialerCampaignId {get;set;} 
	public List<String> callbackNumbers {get;set;} 

	
}