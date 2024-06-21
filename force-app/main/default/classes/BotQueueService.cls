public with sharing class BotQueueService {
    
    @AuraEnabled(cacheable=true)
    public static List<Group> getBotQueueByLoggedUser(){
        try {
            
            User loggedUser = [SELECT Id, BusinessUnit__c FROM User WHERE Id =:UserInfo.getUserId()];
            String bu = loggedUser.BusinessUnit__c;
            String likeArg = '%BT-'+bu+'%';
            String notLikeArg = '%Sharing%';
            
            //Todas as filas com nome iniciando com BT e sem Sharing groups
            List<Group> groupList = [SELECT Id, Name, (SELECT Id, UserOrGroupId FROM GroupMembers), CreatedDate FROM Group WHERE Type = 'Regular' AND Name LIKE :likeArg AND (NOT Name LIKE :notLikeArg)];
            
            return groupList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}