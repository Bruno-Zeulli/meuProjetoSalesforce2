/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GetUserId {

    @AuraEnabled
    public static String getUserId(String conversationId){
        ExternalAPI__c settings = new ExternalAPI__c();

        if(String.isBlank(conversationId)){
            return '';
        }

        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GenesysCloudGetUserId');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c +'/api/v2/conversations/' + conversationId;

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();

                System.debug(response.getBody());

                RetornoBO deserializeResponse = (RetornoBO) JSON.deserialize(responseBody, RetornoBO.class);

                for(Participant participante : deserializeResponse.participants){
                    if(participante.purpose == 'agent'){
                        return participante.userId;
                    }
                }
            } else {
                // A chamada à API falhou, lidar com o erro aqui
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            // A obtenção do token de acesso falhou, lidar com o erro aqui
            System.debug('Falha na obtenção do token de acesso');
        }

        return '';
    }

    public class RetornoBO {
        public String id;
        public List<Participant> participants;
    }

    public class Participant{
        public String purpose;
        public String userId;
    }
}