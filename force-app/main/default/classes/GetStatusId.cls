/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-27-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GetStatusId {
    
    @AuraEnabled
    public static String getStatusId(String status){
        ExternalAPI__c settings = new ExternalAPI__c();

        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GetStatusTest');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        if(status == 'Atendimento'){
            return settings.UserStatusAvailable__c;
        }else if(status == 'Onqueue'){
            return settings.UserStatusOnQueue__c;
        }

        return '';
    }

    @AuraEnabled
    public static Boolean checkUserStatus(String userId){
        ExternalAPI__c settings = new ExternalAPI__c();
        Boolean canReplaceAgentStatus = false;

        List<String> invalidUserStatus = new List<String>{
            'Meal', 'Break', 'Away', 'Available', 
            'Idle' , 'Meeting', 'Offline', 'Training'
        };

        if(String.isBlank(userId)){
            return canReplaceAgentStatus = false;
        }

        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GetStatusTest');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if (accessToken != null) {
            String apiUrl = 'https://api.'+ settings.ComplementUrl__c +'/api/v2/users/' + userId + '/presences/purecloud';

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug(response.getBody());

            if (response.getStatusCode() == 200) {
                UserStatus user = (UserStatus) JSON.deserialize(response.getBody(), UserStatus.class);

                if(invalidUserStatus.contains(user.presenceDefinition.systemPresence)){
                    return canReplaceAgentStatus = false;
                }
            } else {
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Falha na obtenção do token de acesso');
        }

        return canReplaceAgentStatus = true;
    }

    public class UserStatus {
        public PresenceDefinition presenceDefinition;
    }

    public class PresenceDefinition {
        public String id;
        public String systemPresence;
        public String selfUri;
    }
}