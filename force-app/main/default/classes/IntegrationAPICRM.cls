/**
 * @description       :  Coporate Order Process
 * @author            : lucasmoro.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 12-03-2021
 * @last modified by  : lucasmoro.mirante@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                 Modification
 * 1.0   12-03-2021   lucasmoro.mirante@wizsolucoes.com.br   Initial Version
 * 1.1   24-06-2021   samuelsirkis@hotmail.com               Sustentation Version
 **/
public with sharing class IntegrationAPICRM {
  /**
   * @descripition
   * @param orderId
   */

  @future(callout=true)
  public static void integrationCorpAPICRM(String orderId){
    // Delaração das variaveis
    String accessToken;
    Boolean processadoSucesso = false;

    AutenticaAPICRM__mdt apiCRM = [
      SELECT ClientId__c, ClientSecret__c, EndPointAPI__c, EndPointToken__c, GrantType__c, Scope__c
      FROM AutenticaAPICRM__mdt
    ];

    String bodyToken = 'grant_type={0}&client_id={1}&client_secret={2}&Scope={3}';
    bodyToken = bodyToken.replace('{0}', apiCRM.GrantType__c);
    bodyToken = bodyToken.replace('{1}', apiCRM.ClientId__c);
    bodyToken = bodyToken.replace('{2}', apiCRM.ClientSecret__c);
    bodyToken = bodyToken.replace('{3}', apiCRM.Scope__c);

    HttpRequest request = new HttpRequest();
    HttpResponse response = new HttpResponse();
    Http http = new Http();

     try{
      System.debug('## URL TOKEN ' + apiCRM.EndPointToken__c);
      request.setMethod('POST');
      request.setEndpoint(apiCRM.EndPointToken__c);
      request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      request.setHeader('Content-Length', bodyToken);
      request.setHeader('Accept', 'application/x-www-form-urlencoded');
      request.setBody(bodyToken);

      System.debug('### BODY TOKEN ' + request.getBody());

      if(!Test.isRunningTest()){
        response = http.send(request);
      }else{
        response = new HTTPResponse();
        response.setBody(Label.ResponseAPITest);
      }

      System.debug('### RESPONSE ' + response.getBody());
      RespostaTokenTO responseTo = (RespostaTokenTO) JSON.deserialize(response.getBody(), RespostaTokenTO.class);
      String tokenIntegracao = responseTo.access_token;
      // System.debug('### TOKEN ' + tokenIntegracao);

      request = new HttpRequest();
      request.setMethod('GET');
      System.debug('## URL INSERT ' + apiCRM.EndPointAPI__c);
      request.setEndPoint(ApiCRM.EndPointAPI__c + '=' + orderId);
      request.setHeader('Authorization', 'Bearer ' + tokenIntegracao);

      if(!Test.isRunningTest()){
        response = http.send(request);
      }else{
        response = new HTTPResponse();
        response.setStatusCode(200);
      }

      // check for status OK
      if(response.getStatusCode() == 200){
        processadoSucesso = true;
      }else{
        processadoSucesso = false;
      }
    } catch (Exception ex){
      String mensagemExcecao =
        'CLASSE = IntegrationAPICRM' +
        ', LINHA = ' +
        ex.getLineNumber() +
        ', TYPE = ' +
        ex.getTypeName() +
        ', MESSAGE = ' +
        ex.getMessage();
    }
    if(!processadoSucesso){
      System.debug('Erro de processamento na integração OCR');
    }else{
      System.debug('Integração OCR feita com sucesso');
    }

    if(response.getStatusCode() == 200 || response.getStatusCode() == 201 || response.getStatusCode() == 202){
      JSONParser parser = JSON.createParser(response.getBody());
      while (parser.nextToken() != null){
        if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')){
          parser.nextToken();
          accessToken = parser.getText();
          // System.debug('### RESPONSE TOKEN ' + accessToken);
        }
      }
    }else{
      System.debug(LoggingLevel.ERROR + 'BODY: ' + response.getBody());
      System.debug(LoggingLevel.ERROR + 'STATUS:' + response.getStatus());
      System.debug(LoggingLevel.ERROR + 'STATUS_CODE:' + response.getStatusCode());
      String strErrMessage = String.format(
        'Response Status Code : {0} Response Status: {1} Response Status Body: {2}',
        new List<String>{ String.valueOf(response.getStatusCode()), response.getStatus(), response.getBody() }
      );
      // envia mensagem de erro para o teams
      SendEmail se = new SendEmail();
      se.toAddresses.add('f03a793d.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms');
      se.subject = 'Erro de processamento na integração OCR';
      se.body = strErrMessage;
      se.send();
    }
  }

  private class RespostaTokenTO {
    public final String access_token { get; set; }
    public final String instance_url { get; set; }
    public final String id { get; set; }
    public final String token_type { get; set; }
    public final String issued_at { get; set; }
    public final String signature { get; set; }
  }
}