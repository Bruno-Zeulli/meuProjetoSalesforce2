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
@isTest
public class CallAPITest {
  @isTest
  static void testGet(){
    List<ExternalAPI__c> apis = ExternalAPIDataFactory.createExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CallAPI call = new CallAPI('application/json;charset=UTF-8', apis[0].Endpoint__c, null, null);
    call.get();
    call.getHttpResponse();
    System.assert(call != null, 'Success');
  }

  @isTest
  static void testPost(){
    List<ExternalAPI__c> apis = ExternalAPIDataFactory.createExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CallAPI call = new CallAPI('application/json;charset=UTF-8', apis[0].Endpoint__c, null, null);
     try{
      call.post();
    } catch (Exception e){
      System.assert(e instanceof CallAPI.ExpectedBodyException, 'Error');
    }
     try{
      call.postHttpResponse();
    } catch (Exception e){
      System.assert(e instanceof CallAPI.ExpectedBodyException, 'Error');
    }
    call = new CallAPI(apis[0].Endpoint__c, '{}', 'Bearer 123');
    call.post();
    call.postHttpResponse();
  }

  static void testPut(){
    List<ExternalAPI__c> apis = ExternalAPIDataFactory.createExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CallAPI call = new CallAPI(apis[0].Endpoint__c, '{}');
    call.put();
    call.putHttpResponse();
  }

  static void testDel(){
    List<ExternalAPI__c> apis = ExternalAPIDataFactory.createExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CallAPI call = new CallAPI(apis[0].Endpoint__c, '{}');
    call.del();
    call.delHttpResponse();
  }

  static void testPatch(){
    List<ExternalAPI__c> apis = ExternalAPIDataFactory.createExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    CallAPI call = new CallAPI(apis[0].Endpoint__c, '{}');
    call.patch();
    call.patchHttpResponse();
  }
}