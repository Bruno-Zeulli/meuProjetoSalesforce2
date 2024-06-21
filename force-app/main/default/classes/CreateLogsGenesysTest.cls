/**
 * @description       : Testa envio dos dados para o Fluxo gerar e atualizar callLogs
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-29-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class CreateLogsGenesysTest {
    
    @isTest
    public static void createCallLogTest(){
        String callLogJSON = '{"id":"CallLogConversationIdTeste","endTime":"2023-10-11T16:53:28.689Z","phone":"tel:86713855XXXXXXXXXXX","name":"vonex_2","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":false,"isDialer":false,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"vonex_2","recordingState":"none","displayAddress":"86713855XXXXXXXXXXX","ani":"Internal","calledNumber":"86713855XXXXXXXXXXX","direction":"Outbound","isInternal":false,"startTime":"2023-10-11T16:53:14.109Z"}';
        String referenceIdTest = 'CallLogConversationIdTeste';

        Test.startTest();
            Map<String, String> returnedIds = CreateLogsGenesys.createCallLog(callLogJSON, '');
        
            CallLog__c createdCallLog = [SELECT Id, Type__c, Address__c, Channel__c, EndTime__c, Message__c, Processed__c, ReferenceId__c, StartTime__c
            FROM CallLog__c WHERE ReferenceId__c = :referenceIdTest LIMIT 1]; 

            // Checa se CallLog existe
            System.assertEquals(returnedIds.get('callLogId'), createdCallLog.Id, 'O Fluxo criou o registro de CallLog e os dados batem com os do JSON');

            // Checa se os dados do CallLog criado estão corretos
            System.assertEquals('86713855XXXXXXXXXXX', createdCallLog.Address__c, 'Dado incorreto Address__c');
            System.assertEquals(callLogJSON, createdCallLog.Message__c, 'Dado incorreto Message__c');
            System.assertEquals('CallLogConversationIdTeste', createdCallLog.ReferenceId__c, 'Dado incorreto ReferenceId__c');
            System.assertEquals('Outbound', createdCallLog.Type__c, 'Dado incorreto Type__c');
        Test.stopTest();
    }
}