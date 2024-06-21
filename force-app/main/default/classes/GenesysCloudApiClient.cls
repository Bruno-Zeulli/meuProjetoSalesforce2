/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GenesysCloudApiClient {
    @future(callout=true)
    public static void saveAccessToken(String settingsName){
        ExternalAPI__c settings = ExternalAPI__c.getInstance(settingsName);
        settings.AccessToken__c = getAccessToken(settings);
        update settings;
    }

   // Método para obter o token de acesso
    public static String getAccessToken(ExternalAPI__c settings) {
        if (settings != null) {
            String clientId = settings.ClientID__c;
            String clientSecret = settings.ClientSecret__c;
            String endpoint = settings.Endpoint__c;
            String grantType = settings.GrantType__c;

            // Configurar o ambiente
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret)));
            request.setBody('grant_type=' + grantType);

            // Fazer a solicitação HTTP para obter o token de acesso
            HttpResponse response = http.send(request);

            // Verificar se a solicitação foi bem-sucedida
            if (response.getStatusCode() == 200) {
                Map<String, Object> authData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String accessToken = (String) authData.get('access_token');
                return accessToken;
            } else {
                // A solicitação falhou, lidar com o erro aqui
                return null;
            }
        } else {
            // As configurações personalizadas não foram encontradas, lidar com o erro aqui
            return null;
        }
    }

    // Método para fazer uma chamada à API Genesys Cloud autenticada
    public static void callGenesysCloudApi() {
        ExternalAPI__c settings = new ExternalAPI__c();
        // Obtenha as configurações personalizadas (Custom Settings)
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('Genesys Cloud Test');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = getAccessToken(settings);
        if (accessToken != null) {
            // Substitua pela URL da API desejada
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c +'/api/v2/organizations/me';

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            // Verificar a resposta da API
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('Resposta da API: ' + responseBody);
            } else {
                // A chamada à API falhou, lidar com o erro aqui
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            // A obtenção do token de acesso falhou, lidar com o erro aqui
            System.debug('Falha na obtenção do token de acesso');
        }
    }
}