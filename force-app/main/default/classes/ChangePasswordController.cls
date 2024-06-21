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
public with sharing class ChangePasswordController {
  /** @description An apex page controller that exposes the change password functionality **/
  public String oldPassword { get; set; }
  public String newPassword { get; set; }
  public String verifyNewPassword { get; set; }

  /** @description An apex page controller that exposes the change password functionality **/
  public PageReference changePassword(){
    return Site.changePassword(newPassword, verifyNewPassword, oldpassword);
  }

  /** @description An apex page controller that exposes the change password functionality **/
  public ChangePasswordController(){
    System.debug(LoggingLevel.FINEST, 'On Change Password Controller');
  }
}