/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GenesysWrapingUpInvocable {
    
    @InvocableMethod(label='Genesys Wraping Up' description='Tabula chamada dentro da Genesys' category='DispositionPath__c')
    public static void makeWrapingUpCallInvocable(List<FlowInput> flowInputies){
        FlowInput input = flowInputies[0];
        makeWrapingUpCall(
            input.conversationId, input.participantId, input.communicationId, 
            input.description, input.queueName, input.durationSeconds, input.filteredTabulation
        );
    }

    public static void makeWrapingUpCall(
        String conversationId, 
        String participantId, 
        String communicationId,
        String description,
        String queueName,
        String durationSeconds,
        String filteredTabulation
    ){
        ExternalAPI__c settings = new ExternalAPI__c();

        // Checando se existe algum dado faltando
        if(
            String.isBlank(conversationId) || String.isBlank(participantId) || 
            String.isBlank(communicationId) || String.isBlank(filteredTabulation)
        ){
            return;
        }

        // Obter os dados necessários para realizar a tabulação na genesys
        DispositionPath__c tabulacaoFiltrada = [SELECT Id, Name, ExternalId__c FROM DispositionPath__c WHERE Id =: filteredTabulation];

        // Obtenha as configurações personalizadas (Custom Settings)
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('Genesys Cloud Test make Wraping');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('code', tabulacaoFiltrada.ExternalId__c); 
            requestBody.put('name', tabulacaoFiltrada.Name);
            requestBody.put('notes', description);
            requestBody.put('tags', new List<String>{queueName});
            requestBody.put('durationSeconds', Integer.valueOf(durationSeconds));
            requestBody.put('endTime', System.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
            System.debug(JSON.serialize(requestBody));

            // Substitua pela URL da API desejada
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c + '/api/v2/conversations/calls/' + conversationId;
            apiUrl = apiUrl + '/participants/' + participantId + '/communications/' + communicationId + '/wrapup';

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
                
                System.debug('Tabulação realizada com sucesso: ' + response.getStatusCode());
                
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

    public class FlowInput{
        @InvocableVariable
        public String conversationId;
        @InvocableVariable
        public String participantId;
        @InvocableVariable
        public String communicationId;
        @InvocableVariable
        public String description;
        @InvocableVariable
        public String queueName;
        @InvocableVariable
        public String durationSeconds;
        @InvocableVariable 
        public String filteredTabulation;
    }
}