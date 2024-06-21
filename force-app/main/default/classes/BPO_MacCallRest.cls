/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

public class BPO_MacCallRest extends WebserviceREST {
  public static final String ENDPOINT_CADASTRAR_COMUNICADO = '/mac/cadastrarcomunicado';
  public static final String ENDPOINT_CADASTRAR_TASK = '/mac/acolhida';

  public Map<String, Object> postMACRest(String serializedParameter){
    String token;
    Map<String, Object> results = new Map<String, Object>();
    URL = ExternalAPI__c.getValues('MAC').Endpoint__c + '/Login';
    method = 'POST';
    LoginCredentials credentials = new LoginCredentials();
    credentials.USUARIO = ExternalAPI__c.getValues('MAC').User__c;
    credentials.SENHA = ExternalAPI__c.getValues('MAC').Password__c;

    String jsonCredentials = JSON.serialize(credentials);
    System.debug('jsonCredentials: ' + jsonCredentials);
    String strJSON = Callout(token, jsonCredentials);
    System.debug('Retorno login gateway habitacional: ' + strJSON);
    if(String.isNotEmpty(strJSON)){
      retornoLogin login = (retornoLogin) JSON.deserialize(strJSON, retornoLogin.class);

      if(login.sucesso){
        token = login.Token;
        results = new Map<String, Object>();
        method = 'POST';
        URL = ExternalAPI__c.getValues('MAC').Endpoint__c + ENDPOINT_CADASTRAR_COMUNICADO;
        strJSON = Callout(token, serializedParameter);
        System.debug('Retorno json MAC: ' + strJSON);

        results.put('WSResponseStatusCode', StatusCode);
        validationStatusLogin(results, strJSON);
      }else{
        results.put('Status', 'Failed');
        results.put('ErrorMessage', 'Falha no login do gateway.');
      }
    }else{
      results.put('Status', 'Failed');
      results.put('ErrorMessage', 'Falha no login do gateway.');
    }
    return results;
  }

  public Map<String, Object> postTaskMACRest(String serializedParameter){
    String token;
    Map<String, Object> results = new Map<String, Object>();
    URL = ExternalAPI__c.getValues('MAC').Endpoint__c + '/Login';
    method = 'POST';
    LoginCredentials credentials = new LoginCredentials();
    credentials.USUARIO = ExternalAPI__c.getValues('MAC').User__c;
    credentials.SENHA = ExternalAPI__c.getValues('MAC').Password__c;

    String jsonCredentials = JSON.serialize(credentials);
    System.debug('jsonCredentials: ' + jsonCredentials);
    String strJSON = Callout(token, jsonCredentials);
    System.debug('Retorno login gateway habitacional: ' + strJSON);
    if(String.isNotEmpty(strJSON)){
      retornoLogin login = (retornoLogin) JSON.deserialize(strJSON, retornoLogin.class);

      if(login.sucesso){
        token = login.Token;
        results = new Map<String, Object>();
        method = 'POST';
        URL = ExternalAPI__c.getValues('MAC').Endpoint__c + ENDPOINT_CADASTRAR_TASK;
        strJSON = Callout(token, serializedParameter);
        System.debug('Retorno json MAC: ' + strJSON);

        results.put('WSResponseStatusCode', StatusCode);
        validationStatusLogin(results, strJSON);
      }else{
        results.put('Status', 'Failed');
        results.put('ErrorMessage', 'Falha no login do gateway.');
      }
    }else{
      results.put('Status', 'Failed');
      results.put('ErrorMessage', 'Falha no login do gateway.');
    }
    return results;
  }

  private Map<String, Object> validationStatusLogin(Map<String, Object> results, String strJSON){
    if(Error){
      results.put('Status', 'Failed');
      results.put('ErrorMessage', ErrorMessage);
      System.debug('Callout error: ' + ErrorMessage);
    }else if(StatusCode == 201 || StatusCode == 200){
      results.put('Retorno', strJSON);
      results.put('Status', 'Success');
    }else{
      results.put('Status', 'Failed');
      results.put('ErrorMessage', strJSON);
    }
    return results;
  }

  public class LoginCredentials {
    public String usuario { get; set; }
    public String senha { get; set; }
  }

  public class RetornoLogin {
    public Boolean sucesso { get; set; }
    public String token { get; set; }
  }
}