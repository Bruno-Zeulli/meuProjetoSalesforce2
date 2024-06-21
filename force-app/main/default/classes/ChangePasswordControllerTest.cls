/**
 * @description       : An apex page controller that exposes the change password functionality
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@IsTest
public with sharing class ChangePasswordControllerTest {
  @IsTest // (SeeAllData=true)
  public static void testChangePasswordController(){
    // Instantiate a new controller with all parameters in the page
    ChangePasswordController controller = new ChangePasswordController();
    controller.oldPassword = '123456';
    controller.newPassword = 'qwerty1';
    controller.verifyNewPassword = 'qwerty1';

    System.assertEquals(controller.changePassword(), null, 'Test');
  }
}