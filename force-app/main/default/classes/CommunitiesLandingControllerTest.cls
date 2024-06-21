/**
 * @description       :  An apex page controller that takes the user to the right start page based on credentials or lack thereof
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public with sharing class CommunitiesLandingControllerTest {
  @IsTest
  public static void testCommunitiesLandingController(){
    // Instantiate a new controller with all parameters in the page
    CommunitiesLandingController controller = new CommunitiesLandingController();
    PageReference pageRef = controller.forwardToStartPage();
    //PageRef is either null or an empty object in test context
    if(pageRef != null){
      String url = pageRef.getUrl();
      if(url != null){
        System.assertEquals(true, String.isEmpty(url), 'PageRef is either null or an empty object in test context');
        //show up in perforce
      }
    }
  }
}