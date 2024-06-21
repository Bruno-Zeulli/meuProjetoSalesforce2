public without sharing class QueueAssignmentController {
    @AuraEnabled( cacheable=true )
    public static QueueWrapper fetchQueueAssignments(Id queueId) {
    
        User loggedUser = [SELECT Id, BusinessUnit__c FROM User WHERE Id =:UserInfo.getUserId()];
        
        QueueWrapper objQW = new QueueWrapper();
        List<String> selectedUsers = new List <String>();
        List<QueueOptionWrapper> availableUsers = new List <QueueOptionWrapper>();
        Set<Id> selectedUsersId = new Set <Id>();
        
        for ( GroupMember gp : [ SELECT Id, UserOrGroupId FROM GroupMember WHERE GroupId =:queueId ] ) {
            selectedUsersId.add( gp.UserOrGroupId );
        }
        
        //IsActive não será obrigatório, pois pode haver a invativação de um usuário enquanto ele estiver em uma fila
        //e os responsáveis pela fila deverão poder removê-los
        for ( User u : [ SELECT Id, Name, IsActive FROM User WHERE BusinessUnit__c  =:loggedUser.BusinessUnit__c OR Id IN :selectedUsersId ORDER BY Name] ) {
            QueueOptionWrapper auxWrapper = new QueueOptionWrapper();
            auxWrapper.label = u.IsActive ? u.Name : u.Name + ' - Inativo';
            auxWrapper.value = u.id;
            availableUsers.add( auxWrapper );
        }
        
        for ( User u : [ SELECT Id, Name FROM User WHERE Id IN :selectedUsersId] ) {
            selectedUsers.add( u.id );
        }

        Group gp = [SELECT Id, Name FROM Group WHERE Id=:queueId];
        
        objQW.availableUsers = availableUsers;
        objQW.selectedUsers = selectedUsers;
        objQW.queueName = gp.Name;
        
        return objQW;
    
    }
    
    @AuraEnabled
    public static String addRemoveInQueues( List < String > selectedUsers, String queueId) {
        
        try{

            List<GroupMember> groupMemberToInsertList = new List<GroupMember>();
            List<GroupMember> groupMemberToDeleteList = new List<GroupMember>();
            Map<Id, GroupMember> groupMemberToDeleteMap = new Map<Id, GroupMember>();
            Set<Id> userIdInQueueDB = new Set<Id>();
            List<GroupMember> groupMemberList = [SELECT Id, UserOrGroupId from GroupMember WHERE GroupId =:queueId WITH SECURITY_ENFORCED];
            
            for(GroupMember gm : groupMemberList)
            {
                if(((String)gm.UserOrGroupId).startsWith('005')){
                    userIdInQueueDB.add(gm.UserOrGroupId);
                    groupMemberToDeleteMap.put(gm.UserOrGroupId, gm);
                }
            }
            
            //Se a lista nao possui o id de alguém que ja estava na base, deve excluir esse usuario da fila
            for(Id userId : userIdInQueueDB)
            {
                if(!selectedUsers.contains(userId))
                {
                    groupMemberToDeleteList.add(groupMemberToDeleteMap.get(userId));
                }
            }
            //Incluindo na lista os novos GroupMembers para inserir
            for(Id userId : selectedUsers)
            {
                if(!userIdInQueueDB.contains(userId))
                {
                    groupMemberToInsertList.add(new GroupMember(GroupId = queueId, UserOrGroupId = userId));
                }
            }
            
            if (Schema.sObjectType.GroupMember.isCreateable() && groupMemberToInsertList.size() > 0) {
                insert groupMemberToInsertList;
            }
            
            if (Schema.sObjectType.GroupMember.isDeletable() && groupMemberToDeleteList.size() > 0) {
                delete groupMemberToDeleteList;
            }
            
            return 'Successful';
            
        }catch(Exception e)
        {
            throw new AuraHandledException( e.getMessage() );
        }
        
    }
    
    public class QueueWrapper {

        @AuraEnabled
        public List < QueueOptionWrapper > availableUsers;
        @AuraEnabled
        public List < String > selectedUsers;
        @AuraEnabled
        public String queueName;

    }

    public class QueueOptionWrapper {

        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;

    }

}