/**
 * @description       :  An apex page controller that supports self registration of users in communities that allow self registration
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public with sharing class CommunitiesSelfRegControllerTest {
  @IsTest
  public static void testCommunitiesSelfRegController(){
    CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
    controller.firstName = 'FirstName';
    controller.lastName = 'LastName';
    controller.email = 'test@force.com';
    controller.communityNickname = 'test';

    // registerUser will always return null when the page isn't accessed as a guest user
    System.assert(controller.registerUser() == null, 'Expected null');

    controller.password = 'abcd1234';
    controller.confirmPassword = 'abcd123';
    System.assert(controller.registerUser() == null, 'Expected null');
  }
}