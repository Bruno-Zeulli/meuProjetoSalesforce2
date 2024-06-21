/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GenesysGetIdsInvocable {

    @InvocableMethod(label='Genesys Get Ids' description='Returns the participantId and the CommunicationId' category='DispositionPath__c')
    public static List<FlowOutput> getIdsInvocable(List<String> conversationIds){
        String conversationId = conversationIds[0];
        return getIds(conversationId);
    }

    public static List<FlowOutput> getIds(String conversationId){
        ExternalAPI__c settings = new ExternalAPI__c();
        List<FlowOutput> listFlowOutput = new List<FlowOutput>();

        if(String.isBlank(conversationId)){
            return listFlowOutput;
        }

        // Obtenha as configurações personalizadas (Custom Settings)
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('Genesys Cloud Test GetIds');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            // Substitua pela URL da API desejada
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c +'/api/v2/conversations/' + conversationId;

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            // Verificar a resposta da API
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();

                System.debug(response.getBody());

                RetornoBO deserializeResponse = (RetornoBO) JSON.deserialize(responseBody, RetornoBO.class);

                for(Participant participante : deserializeResponse.participants){
                    if(participante.purpose == 'agent'){
                        Boolean isCallsEmpty = participante.calls.isEmpty();
                        if(isCallsEmpty){
                            continue;
                        }
                        listFlowOutput.add(new FlowOutput(
                            participante.calls[0].id,
                            participante.id,
                            participante.userId
                        ));
                        break;
                    }
                }

                System.debug(listFlowOutput);
            } else {
                // A chamada à API falhou, lidar com o erro aqui
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            // A obtenção do token de acesso falhou, lidar com o erro aqui
            System.debug('Falha na obtenção do token de acesso');
        }

        return listFlowOutput;
    }

    public class RetornoBO {
        public String id;
        public List<Participant> participants;
    }

    public class Participant{
        public String id;
        public String purpose;
        public String userId;
        public List<Call> calls;
    }

    public class Call{
        public string id;
    }

    public class FlowOutput{
        @InvocableVariable
        public String communicationId;
        @InvocableVariable
        public String participantId;
        @InvocableVariable
        public String userId;

        public FlowOutput(String communicationId, String participantId, String userId){
            this.communicationId = communicationId;
            this.participantId = participantId;
            this.userId = userId;
        }
    }
}