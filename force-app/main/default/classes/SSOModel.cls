/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-24-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public class SSOModel {
  public SSOModel.Request requisicao { get; set; }
  public SSOModel.Response resposta { get; set; }

  // Adicionado exessão para Warning do PMD
  @SuppressWarnings('PMD.ExcessiveParameterList')
  public SSOModel(String grantType, String clientId, String clientSecret, String scope){
    requisicao = new Request(grantType, clientId, clientSecret, scope);
    resposta = new Response();
  }

  public String writeBody(){
    return 'client_id=' +
      EncodingUtil.urlEncode(requisicao.clientId, 'UTF-8') +
      '&client_secret=' +
      EncodingUtil.urlEncode(requisicao.clientSecret, 'UTF-8') +
      '&scope=' +
      EncodingUtil.urlEncode(requisicao.scope, 'UTF-8') +
      '&grant_type=client_credentials';
  }

  public void responseToObject(String response){
     try{
      this.resposta = (SSOModel.Response) JSON.deserialize(response, SSOModel.Response.class);
    } catch (Exception e){
      System.debug('Retorno inesperado: ' + response);
      System.debug('Exceção: ' + e.getMessage());
    }
  }

  public class Request {
    public String grantType { get; set; }
    public String clientId { get; set; }
    public String clientSecret { get; set; }
    public String scope { get; set; }

    // Adicionado exessão para Warning do PMD
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public Request(String grantType, String clientId, String clientSecret, String scope){
      if(grantType == null || clientId == null || clientSecret == null || scope == null){
        throw new NullPointerException();
      }
      this.grantType = grantType;
      this.clientId = clientId;
      this.clientSecret = clientSecret;
      this.scope = scope;
    }
  }

  public class Response {
    public String access_token { get; set; }
    public String expires_in { get; set; }
    public String token_type { get; set; }
  }
}