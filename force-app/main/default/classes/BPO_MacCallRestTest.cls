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
public class BPO_MacCallRestTest {
    @testSetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
    }

    @isTest
    public static void callSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACSuccess());
        Test.startTest();
        BPO_MacCallRest ws = new BPO_MacCallRest();
        Map<String, Object> results = ws.PostMACRest('Teste');
        Test.stopTest();
        system.assertEquals(201, results.get('WSResponseStatusCode'), 'Check, the status code cannot be other than 201 "Failed call');
    }

    @isTest
    static void callFailAuth(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACAuthFailure());
        Test.startTest();
        BPO_MacCallRest ws = new BPO_MacCallRest();
        Map<String, Object> results = ws.PostMACRest('');
        Test.stopTest();
        system.assertNotEquals(201, results.get('WSResponseStatusCode'), 'Check, status code cannot equal to 201 "Authorized call"');
    }

    @isTest
    public static void callFail(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACSuccess());
        BPO_MacCallRest ws = new BPO_MacCallRest();
        Map<String, Object> results = ws.PostMACRest('Teste');
        system.assertNotEquals(201, results.get('WSResponseStatusCode'), 'Check, status code cannot equal to 201 "Successfull call"');
    }

    @isTest
    public static void callUnauthorized(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.UnauthorizedEndpointResponse());
        BPO_MacCallRest ws = new BPO_MacCallRest();
        Map<String, Object> results = ws.PostMACRest('Teste');
        system.assertNotEquals(201, results.get('WSResponseStatusCode'), 'Check, status code cannot equal to 201 "Authorized call"');
    }

    @isTest
    public static void callSuccessTASK(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACSuccess());
        Test.startTest();
        BPO_MacCallRest ws = new BPO_MacCallRest();
        Map<String, Object> results = ws.PostTaskMACRest('Teste');
        Test.stopTest();
        system.assertEquals(201, results.get('WSResponseStatusCode'), 'Check, the status code cannot be other than 201 "Failed call"');
    }
}