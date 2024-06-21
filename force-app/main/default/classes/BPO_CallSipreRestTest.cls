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
public class BPO_CallSipreRestTest {
    @isTest
    public static void callSuccess(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreSuccess());
        Test.startTest();
        BPO_CallSipreRest ws = new BPO_CallSipreRest();
        Map<String, Object> results = ws.PostSipreRest('Teste');
        Test.stopTest();
        system.assertEquals(201, results.get('WSResponseStatusCode'), 'Check status code not equal to 201 "Failed call"');
    }

    @isTest
    public static void callFailure(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreFailure());
        Test.startTest();
        BPO_CallSipreRest ws = new BPO_CallSipreRest();
        Map<String, Object> results = ws.PostSipreRest('Teste');
        Test.stopTest();
        system.assertNotEquals(201, results.get('WSResponseStatusCode'), 'Check status code equal to 201 "Successfull call"');
    }

    @isTest
    public static void callUnauthorized(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.UnauthorizedEndpointResponse());
        Test.startTest();
        BPO_CallSipreRest ws = new BPO_CallSipreRest();
        Map<String, Object> results = ws.PostSipreRest('Teste');
        Test.stopTest();
        system.assertNotEquals(201, results.get('WSResponseStatusCode'), 'Check status code equal to 201 "Authorized call"');
    }
}