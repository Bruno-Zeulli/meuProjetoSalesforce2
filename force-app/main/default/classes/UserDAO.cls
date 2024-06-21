public without sharing class UserDAO {

    public static final UserDAO INSTANCE = new UserDAO();
    private static final Map<Id, User> MAP_USER = new Map<Id, User>();

    public static UserDAO getInstance(){
        return INSTANCE;
    }

    public List<User> getListUserBylUserIds(Set<Id> lUsersIds){

        return [SELECT  Id, 
                        Username, 
                        LastName, 
                        FirstName,  
                        Name, 
                        Email, 
                        UserNickName__c, 
                        BusinessUnit__c
                FROM    User
                WHERE   Id IN:lUsersIds];

    }

    public Map<Id, User> getMapUsersBylUserIds(Set<Id> lUsersIds){

        for(User objUser : getListUserBylUserIds(lUsersIds)){
            MAP_USER.put(objUser.Id, objUser);
		}
		return MAP_USER;

    }
    

    public List<GroupMember> getListGroupMemberByUserInfo(List<String> lTypeGroup){
        return [    SELECT  Id, 
                            UserOrGroupId,
                            GroupId,
                            Group.Name
                    FROM    GroupMember 
                    WHERE   UserOrGroupId = :UserInfo.getUserId()
                    AND     Group.Type IN :lTypeGroup
                    
                ];
    } 

    public List<User> getListUserByGroupId(Set<Id> setGroupIds, List<String> lTypeGroup){
        return [SELECT  Id,
                        Name,
                        UserNickName__c
                FROM    User 
                WHERE   IsActive = true 
                AND     Id IN   ( 
                                    SELECT  UserOrGroupId 
                                    FROM    GroupMember 
                                    WHERE   GroupId IN :setGroupIds
                                    AND     Group.Type IN :lTypeGroup
                                )
            ];
    }

}