public with sharing class UserBO {

    private static final UserBO INSTANCE = new UserBO();

    public static UserBO getInstance(){
        return INSTANCE;
    }

    // public static Set<Id> getUserAndGroupIds(List<String> lTypeGroup){

    //     Set<Id> setGroupIds = new Set<Id>();
    //     Set<Id> lstUsersAndGroupsIds = new Set<Id>();

    //     for(GroupMember objGroupMember : UserDAO.getInstance().getListGroupMemberByUserInfo(lTypeGroup)){
    //         setGroupIds.add(objGroupMember.GroupId);
    //         lstUsersAndGroupsIds.add(objGroupMember.GroupId);
    //         lstUsersAndGroupsIds.add(objGroupMember.UserOrGroupId);
    //     }

    //     for(User objUser : UserDAO.getInstance().getListUserByGroupId(setGroupIds, lTypeGroup)){
    //         lstUsersAndGroupsIds.add(objUser.Id);
    //     }

    //     return lstUsersAndGroupsIds;
    // }


    public Map<Id, String> getMapUserNameOrGroupNameByIdsAndQueues(List<String> lTypeGroup){

        Set<Id> setGroupIds = new Set<Id>();
        Map<Id, String> mapUserNameOrGroupNameByIds = new Map<Id, String>();

        for(GroupMember objGroupMember : UserDAO.getInstance().getListGroupMemberByUserInfo(lTypeGroup)){
            setGroupIds.add(objGroupMember.GroupId);
            mapUserNameOrGroupNameByIds.put(objGroupMember.GroupId, objGroupMember.Group.Name);
        }

        for(User objUser : UserDAO.getInstance().getListUserByGroupId(setGroupIds, lTypeGroup)){
            System.debug('objUser.UserNickName__c =>' + objUser.UserNickName__c);
            mapUserNameOrGroupNameByIds.put(objUser.Id, objUser.UserNickName__c);
        }

        return mapUserNameOrGroupNameByIds;
    }

    @TestVisible
    public List<String> callGetUserOrGroupNames(){
        return getUserOrGroupNames();
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getUserOrGroupNames(){
        Map<String, Set<String>> mapUserOrGroup = getMapUserOrGroup();
        List<String> lUserOrGroupName = new List<String>();

        for(String userName : mapUserOrGroup.get('Name')){
            lUserOrGroupName.add(userName);
        }

        return lUserOrGroupName;
    }

    @TestVisible
    public String callGetUserOrGroupIds(){
        return getUserOrGroupIds();
    }
    @AuraEnabled
    public static String getUserOrGroupIds(){
        Map<String, Set<String>> mapUserOrGroup = getMapUserOrGroup();

        return JSON.serialize(mapUserOrGroup.get('Id'));
    }

    private static Map<String, Set<String>> getMapUserOrGroup(){
        Set<String> lUserIdOrGroupId = new Set<String>();
        Set<Id> lUserId = new Set<Id>();
        Set<String> lUserOrGroupName = new Set<String>();
        Map<String, Set<String>> mapUserOrGroup = new Map<String, Set<String>>();
        String profileRef;

        Id userId = UserInfo.getUserId();
        User objUserCurrent = [SELECT Profile.Name FROM User WHERE Id = :userId LIMIT 1];

        if( objUserCurrent.Profile.Name.contains('Administrador') &&
            objUserCurrent.Profile.Name.contains('Developer') &&
            objUserCurrent.Profile.Name.contains('Integrador'))
        {
            profileRef = objUserCurrent.Profile.Name;
        }else{

            String prefixProfile = objUserCurrent.Profile.Name.substringBefore(' ');
            profileRef = prefixProfile + ' - Tickets';
        }

        for(GroupMember objGroupMember : [ SELECT   Id,
                                                    UserOrGroupId,
                                                    GroupId,
                                                    Group.Name
                                            FROM    GroupMember
                                            WHERE   UserOrGroupId IN (  SELECT  Id
                                                                        FROM    USER
                                                                        WHERE   Profile.Name = :profileRef
                                                                        OR     Id = :userId)
                                            AND Group.Type = 'Queue']
        ){
            lUserIdOrGroupId.add(String.valueOf(objGroupMember.GroupId));
            lUserOrGroupName.add(objGroupMember.Group.Name);
            lUserIdOrGroupId.add(String.valueOf(objGroupMember.UserOrGroupId));
            lUserId.add(objGroupMember.UserOrGroupId);
        }

        lUserId.add(userId);

        for(User objUser : [ SELECT Id, Name, CommunityNickname FROM User WHERE Id IN:lUserId]){
            lUserOrGroupName.add(objUser.Name);
        }

        lUserIdOrGroupId.add(userId);
        mapUserOrGroup.put('Name', lUserOrGroupName);
        mapUserOrGroup.put('Id', lUserIdOrGroupId);

        return mapUserOrGroup;
    }

}