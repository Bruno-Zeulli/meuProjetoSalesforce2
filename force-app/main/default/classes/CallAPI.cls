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

public class CallAPI {
  private String fullUrl { get; set; }
  private String method { get; set; }
  private String body { get; set; }
  private String token { get; set; }
  private String contentType { get; set; }

  public CallAPI(String contentType, String fullUrl, String body, String token){
    this.fullUrl = fullUrl;
    this.body = body;
    this.token = token;
    this.contentType = contentType;
  }

  public CallAPI(String fullUrl, String body, String token){
    this.fullUrl = fullUrl;
    this.body = body;
    this.token = token;
    this.contentType = 'application/json;charset=UTF-8';
  }

  public CallAPI(String fullUrl, String body){
    this.body = body;
    this.fullUrl = fullUrl;
    this.contentType = 'application/json;charset=UTF-8';
  }

  public String get(){
    this.method = 'GET';
    return call();
  }

  public String post(){
    this.method = 'POST';
    return call();
  }

  public String put(){
    this.method = 'PUT';
    return call();
  }

  public String del(){
    this.method = 'DELETE';
    return call();
  }

  public String patch(){
    this.method = 'PATCH';
    return call();
  }

  public HttpResponse getHttpResponse(){
    this.method = 'GET';
    return callHttpResponse();
  }

  public HttpResponse postHttpResponse(){
    this.method = 'POST';
    return callHttpResponse();
  }

  public HttpResponse putHttpResponse(){
    this.method = 'PUT';
    return callHttpResponse();
  }

  public HttpResponse delHttpResponse(){
    this.method = 'DELETE';
    return callHttpResponse();
  }

  public HttpResponse patchHttpResponse(){
    this.method = 'PATCH';
    return callHttpResponse();
  }

  private String call(){
    System.debug('CallAPI - ' + method + ' - ' + fullUrl);
    HttpRequest request = new HttpRequest();
    request.setEndpoint(fullUrl);
    request.setMethod(method);
    String authorizationHeader = '';
    if(this.token != null){
      authorizationHeader = this.token;
    }
    request.setHeader('Content-Type', contentType);
    request.setHeader('Authorization', authorizationHeader);
    if(method != 'GET'){
      if(body == null){
        throw new ExpectedBodyException('É esperado um Body para execução desse método HTTP.');
      }
      request.setBody(body);
      System.debug('Body: ' + body);
    }
    System.debug('(1) Request: ' + request);
    String retorno = null;
     try{
      Http http = new Http();
      HTTPResponse res = http.send(request);
      retorno = res.getBody();
      System.debug('Retorno Call:' + retorno);
    } catch (System.CalloutException e){
      System.debug('Callout Exception: Linha ' + e.getLineNumber() + ' - ' + e.getMessage());
    } catch (Exception e){
      System.debug('Exception: Linha ' + e.getLineNumber() + ' - ' + e.getMessage());
    }
    return retorno;
  }

  private HttpResponse callHttpResponse(){
    System.debug('WizAPI - ' + method + ' - ' + fullUrl);
    HttpRequest request = new HttpRequest();
    request.setEndpoint(fullUrl);
    request.setMethod(method);
    String authorizationHeader = '';
    if(token != null){
      authorizationHeader = token;
    }
    request.setHeader('Content-Type', contentType);
    request.setHeader('Authorization', authorizationHeader);
    if(method != 'GET'){
      if(body == null){
        throw new ExpectedBodyException('É esperado um Body para execução desse método HTTP.');
      }
      request.setBody(body);
      System.debug('Body: ' + body);
    }
    HttpResponse retorno = null;
     try{
      Http http = new Http();
      HTTPResponse res = http.send(request);
      retorno = res;
      System.debug('Retorno Call:' + retorno);
    } catch (System.CalloutException e){
      System.debug('Callout Exception: Linha ' + e.getLineNumber() + ' - ' + e.getMessage());
    } catch (Exception e){
      System.debug('Exception: Linha ' + e.getLineNumber() + ' - ' + e.getMessage());
    }
    return retorno;
  }

  public class ExpectedBodyException extends Exception {
  }
}