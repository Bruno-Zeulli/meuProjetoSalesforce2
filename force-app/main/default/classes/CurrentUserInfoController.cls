/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
* 1.2   03-02-2021   samuelsirkis@wizsolucões.com.br      PMD fix erro de retonor nulo
**/
public without sharing class CurrentUserInfoController {
    /**
    * @description => retonar usuário atual
    * @return user
    */
    @AuraEnabled
    public static user fetchUser(){
        User u = [
        SELECT id, Name, ProfileId, Profile.Name
        FROM User
        WHERE id = :userInfo.getUserId()
        WITH SECURITY_ENFORCED
        ];

        return u;
    }
}