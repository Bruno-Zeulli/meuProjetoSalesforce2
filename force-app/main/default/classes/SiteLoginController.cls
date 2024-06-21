/**
 * An apex page controller that exposes the site login functionality
 */
public with sharing class SiteLoginController {
  public String username { get; set; }
  public String password { get; set; }

  public PageReference login(){
    String startUrl = System.currentPageReference().getParameters().get('startURL');
    return Site.login(username, password, startUrl);
  }

  public SiteLoginController(){
    System.debug(LoggingLevel.FINEST, 'On Site Login Controller');
  }
}