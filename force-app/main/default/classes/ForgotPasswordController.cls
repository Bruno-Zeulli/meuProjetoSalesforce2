/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username { get; set; }

    public ForgotPasswordController(){
        System.debug(LoggingLevel.FINEST, 'On Forgot Password Controller');
    }

    public PageReference forgotPassword(){
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);

        if(success){
        return pr;
        }
        return null;
    }
}