public with sharing class GroupDAO {

    public static List<GroupMember> getAssignedGroupMember(Set<Id> setGroupId , Id userId){
        return [SELECT Id, 
        group.DeveloperName,
        UserOrGroupId,
        GroupId 
        FROM GroupMember WHERE groupId IN: setGroupId AND UserOrGroupId =: userId];
    }

}