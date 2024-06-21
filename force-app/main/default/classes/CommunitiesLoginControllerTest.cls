/**
 * @description       : An apex page controller that exposes the site login functionality
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public with sharing class CommunitiesLoginControllerTest {
  @IsTest
  public static void testCommunitiesLoginController(){
    CommunitiesLoginController controller = new CommunitiesLoginController();
    System.assertEquals(null, controller.forwardToAuthPage(), 'expected null');
  }
}