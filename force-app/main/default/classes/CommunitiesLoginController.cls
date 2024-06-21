/**
 * @description       : An apex page controller that takes the user to the right start page based on credentials or lack thereof
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class CommunitiesLoginController {
  /** @description Code we will invoke on page load.**/
  public CommunitiesLoginController(){
    // TODO
    System.debug('TODO');
  }

  /** @description Code we will invoke on page load.**/
  public PageReference forwardToAuthPage(){
    String startUrl = System.currentPageReference().getParameters().get('startURL');
    String displayType = System.currentPageReference().getParameters().get('display');
    return Network.forwardToAuthPage(startUrl, displayType);
  }
}