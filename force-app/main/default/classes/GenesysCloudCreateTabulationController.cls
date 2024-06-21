/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GenesysCloudCreateTabulationController {

    public static Map<String, String> createTabulation(String name){
        ExternalAPI__c settings = new ExternalAPI__c();
        Map<String, String> returnMap = new Map<String, String>();

        if(String.isBlank(name)){
            return returnMap;
        }

        // Obtenha as configurações personalizadas (Custom Settings)
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('Genesys Cloud Test Tabulation');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('name', name); 
            // Substitua pela URL da API desejada
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c +'/api/v2/routing/wrapupcodes';

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setBody(JSON.serialize(requestBody));
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            // Verificar a resposta da API
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();

                RetornoBO deserializeResponse = (RetornoBO) JSON.deserialize(responseBody, RetornoBO.class);

                returnMap.put('id', deserializeResponse.id);
                returnMap.put('name', deserializeResponse.name);
                returnMap.put('dateCreated', deserializeResponse.dateCreated);
                returnMap.put('createdBy', deserializeResponse.createdBy);
                returnMap.put('selfUri', deserializeResponse.selfUri);

            } else {
                // A chamada à API falhou, lidar com o erro aqui
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            // A obtenção do token de acesso falhou, lidar com o erro aqui
            System.debug('Falha na obtenção do token de acesso');
        }
        
        return returnMap;
    }

    public class RetornoBO {
        public String id;
        public String name;
        public String dateCreated;
        public String createdBy;
        public String selfUri;
    } 
}