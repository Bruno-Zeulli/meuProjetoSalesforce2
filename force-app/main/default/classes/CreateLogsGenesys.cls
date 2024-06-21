/**
 * @description       : Envia os dados para o Fluxo gerar e atualizar callLogs
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 20-10-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class CreateLogsGenesys {
    @AuraEnabled
    public static Map<String, String> createCallLog(String callLogJSON, String eventName){
        Map<String, String> returnMap = new Map<String, String>();

        try{
            CallLog callLog = (CallLog) JSON.deserialize(callLogJSON, CallLog.class);

            callLog.startTime = callLog.startTime?.replace('Z', '').replace('T', ' ');
            callLog.endTime = callLog.endTime?.replace('Z', '').replace('T', ' ');

            Flow.Interview genesysCreateLogsFlow = Flow.Interview.createInterview('genesysCreateLogsFlow', new map<String, Object>{
                'id' => callLog.id,
                'connectedTime' => callLog.connectedTime,
                'endTime' => String.isBlank(callLog.endTime) ? null : Datetime.valueOfGmt(callLog.endTime),
                'phone' => callLog.phone,
                'name' => callLog.name,
                'isConnected' => callLog.isConnected,
                'isDisconnected' => callLog.isDisconnected,
                'isDone' => callLog.isDone,
                'state' => callLog.state,
                'isCallback' => callLog.isCallback,
                'isDialer' => callLog.isDialer,
                'isChat' => callLog.isChat,
                'isEmail' => callLog.isEmail,
                'isMessage' => callLog.isMessage,
                'isVoicemail' => callLog.isVoicemail,
                'remoteName' => callLog.remoteName,
                'recordingState' => callLog.recordingState,
                'displayAddress' => callLog.displayAddress,
                'ani' => callLog.ani,
                'calledNumber' => callLog.calledNumber,
                'direction' => callLog.direction,
                'isInternal' => callLog.isInternal,
                'startTime' => String.isBlank(callLog.startTime) ? null : Datetime.valueOfGmt(callLog.startTime),
                'interactionDurationSeconds' => callLog.interactionDurationSeconds,
                'queueName' => callLog.queueName,
                'eventName' => eventName,
                'message' => callLogJSON,
                'callbackNumbers' => callLog.callbackNumbers == null || callLog.callbackNumbers.isEmpty() ? null : callLog.callbackNumbers[0]
            });
            genesysCreateLogsFlow.start();

            String createdCallLogId = (String) genesysCreateLogsFlow.getVariableValue('createdCallLogId');

            System.debug(createdCallLogId);

            returnMap.put('callLogId', createdCallLogId);

            System.debug(returnMap);
        }catch (Exception e){
            System.debug('Erro: ' + e);
            System.debug('Erro: ' + e.getStackTraceString());
        }

        return returnMap;
    }

    public class CallLog {
        public String id;
        public String connectedTime;
        public String endTime;
        public String phone;
        public String name;
        public Boolean isConnected;
        public Boolean isDisconnected;
        public Boolean isDone;
        public String state;
        public Boolean isCallback;
        public Boolean isDialer;
        public Boolean isChat;
        public Boolean isEmail;
        public Boolean isMessage;
        public Boolean isVoicemail;
        public String remoteName;
        public String recordingState;
        public String displayAddress;
        public String ani;
        public String calledNumber;
        public String direction;
        public Boolean isInternal;
        public String startTime;
        public Integer interactionDurationSeconds;
        public String queueName;
        public List<String> callbackNumbers;
    }
}