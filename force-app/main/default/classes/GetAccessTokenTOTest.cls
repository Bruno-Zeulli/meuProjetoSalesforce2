/**
 * @description       :
 * @author            : andresilva@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   11-25-2021   andresilva@wizsolucoes.com.br         Initial Version
 * 1.1   11-25-2021   marcelomartins@wizsolucoes.com.br     refectore
 **/
@isTest
public class GetAccessTokenTOTest {
   
    @isTest 
    static void instantiateResponseToken(){
        GetAccessTokenTO.ResponseToken responseToken = new GetAccessTokenTO.ResponseToken();
        responseToken.access_token = '123456';
        responseToken.expires_in = 360;
        responseToken.scope = 'test';
        responseToken.token_type = 'test';

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest 
    static void instantiateLoginCredentialsMktCloud(){
        GetAccessTokenTO.loginCredentialsMktCloud loginCredentialsMktCloud = new GetAccessTokenTO.LoginCredentialsMktCloud();
        loginCredentialsMktCloud.account_id = '123456';
        loginCredentialsMktCloud.client_id = '123456';
        loginCredentialsMktCloud.client_secret = 'test';
        loginCredentialsMktCloud.account_id = 'test';

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }

}