/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD`
 * 1.2   02-11-2022   marcelomartins@wizsolucoes.com.br    Refactore and insert send products to data extension mkt clould
 **/
@isTest
public class CallMktCloudRestTest {
  @testsetup
  static void setup(){
    ExternalAPIDataFactory.insertExternalAPIs();
  }

  @isTest
  static void callEventSuccess(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
    Test.startTest();
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postMktCloudRest('Teste');
    Test.stopTest();
    System.assertEquals(200, results.get('WSResponseStatusCode'), '');
  }

  @isTest
  static void callEventIncorrectly(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.UnauthorizedEndpointResponse());
    Test.startTest();
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postMktCloudRest('Teste');
    Test.stopTest();
    System.assertNotEquals(200, results.get('WSResponseStatusCode'), '');
  }

  @isTest
  static void callEventFail(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postMktCloudRest('Teste');
    System.assertNotEquals(200, results.get('WSResponseStatusCode'), '');
  }

   @isTest
  static void callDataExtensionSuccess(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
    Test.startTest();
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postSendProductsCorporateToMktCloud('Teste');
    Test.stopTest();
    System.assertEquals(200, results.get('WSResponseStatusCode'), '');
  }

  @isTest
  static void callDataExtensionIncorrectly(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.UnauthorizedEndpointResponse());
    Test.startTest();
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postSendProductsCorporateToMktCloud('Teste');
    Test.stopTest();
    System.assertNotEquals(200, results.get('WSResponseStatusCode'), '');
  }

  @isTest
  static void callDataExtensionFail(){
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
    CallMktCloudRest ws = new CallMktCloudRest();
    Map<String, Object> results = ws.postSendProductsCorporateToMktCloud('Teste');
    System.assertNotEquals(200, results.get('WSResponseStatusCode'), '');
  }
}