/**
 * @description       : An apex page controller that takes the user to the right start page based on credentials or lack thereof
 * @author            : samuelsirkis@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 25-03-2021
 * @last modified by  : samuelsirkis@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   25-03-2021   samuelsirkis@wizsolucoes.com.br      Initial Version
 **/
public with sharing class CommunitiesLandingController {
  /** @description Code we will invoke on page load. **/
  public PageReference forwardToStartPage(){
    return Network.communitiesLanding();
  }
}