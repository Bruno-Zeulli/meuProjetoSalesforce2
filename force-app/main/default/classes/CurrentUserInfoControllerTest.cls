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
 **/
@isTest
public class CurrentUserInfoControllerTest {
  @isTest
  static void testController(){
    User u = UserDataFactory.createUser();

    CurrentUserInfoController.fetchUser();
    System.runAs(u){
      // The following code runs as user 'u'
      System.debug('Current User: ' + UserInfo.getUserName());
      System.debug('Current Profile: ' + UserInfo.getProfileId());
    }
    //System.assert(u.isActive(), 'True or False for User Active');
  }
}