/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public class GenesysScheduleCallInvocable {

    @InvocableMethod(label = 'Schedule Call' description = 'Realiza reagendamento da chamada na genesys')
    public static void scheduleCallInvocable(List<FlowInputTO> data){
        FlowInputTO schedule = data[0];

        try {
            scheduleCall(schedule);
        } catch (Exception e){
            System.debug('Erro ao agendar chamada: ' + e);
        }

        return;
    }

    public static void scheduleCall(FlowInputTO scheduleData){
        // Datetime.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        ExternalAPI__c settings = new ExternalAPI__c();

        // Checando se existe algum dado faltando
        if(scheduleData == null){
            return;
        }

        // Obtenha as configurações personalizadas (Custom Settings)
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('Genesys Cloud Test ScheduleCall');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            Map<String,Object> requestBody = new Map<String,Object>();
            requestBody.put('callbackNumbers', new List<String>{scheduleData.callbackNumbers});
            requestBody.put('validateCallbackNumbers', false);
            requestBody.put('routingData', new Map<String,Object>{
                'preferredAgentIds' => new List<String>{scheduleData.participantId},
                'queueId' => scheduleData.queueId
            });
            requestBody.put('callbackScheduledTime', scheduleData.callbackScheduledTime.addHours(3).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
            requestBody.put('callbackUserName', scheduleData.callerIdName);
            requestBody.put('data', new Map<String,String>{
                'notes' => scheduleData.notes
            });
            requestBody.put('countryCode', '55');
            System.debug(JSON.serialize(requestBody));

            // Substitua pela URL da API desejada
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c + '/api/v2/conversations/callbacks';

            System.debug(apiUrl);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setBody(JSON.serialize(requestBody));
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            // Verificar a resposta da API
            if (response.getStatusCode() == 202) {

                System.debug('Chamada agendada com sucesso: ' + response.getStatusCode());

            } else {
                // A chamada à API falhou, lidar com o erro aqui
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            // A obtenção do token de acesso falhou, lidar com o erro aqui
            System.debug('Falha na obtenção do token de acesso');
        }

        return;
    }

    public class FlowInputTO {
        @InvocableVariable
        public String participantId;
        @InvocableVariable
        public String conversationId;
        @InvocableVariable
        public String callbackNumbers;
        @InvocableVariable
        public String queueId;
        @InvocableVariable
        public Datetime callbackScheduledTime;
        @InvocableVariable
        public String callerIdName;
        @InvocableVariable
        public String notes;
    }
}