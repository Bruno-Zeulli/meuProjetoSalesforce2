/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class IntegrationAPIWFlowTest {
    @testSetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
    }

    @isTest
    public static void callopportunityUpdateInWFlowSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().opportunityUpdateInWFlow('test');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }
    @isTest
    public static void callOpportunityUpdateInWFlowFailed(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowFailed());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().opportunityUpdateInWFlow('test');
        Test.stopTest();
        system.assertNotEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, status code cannot equal to 201 "Authorized call"'
        );
    }

    @isTest
    public static void callPostDocumentSuccess(){

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().postDocument('{"opportunitySfId": "0065200000E1oBsAAJ",   "originalName": "ORPORATE/0013B00000hqZJFQA2/0065200000E1oBsAAJ",   "extension": "pdf",   "url": "https://wizcorphml001.blob.core.windows.net/documentos/48113361000170/CORPORATE/pdf",   "objectType": 1,   "externalReferenceId": "31ea2739-1c29-4356-af46-348f788c9c11",   "documentTypeExternalId": "58" }');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }

    @isTest
    public static void callPostOpportunityEndorsementSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().postOpportunityEndorsement('test');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }

    @isTest
    public static void callPostOpportunitySalesSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().postOpportunitySales('test');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }

    @isTest
    public static void callPutQuoteApprovalSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().putQuoteApproval('test');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }

    @isTest
    public static void callPostQuoteUpdateInWFlowSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIWFlow.getInstance().postQuoteUpdateInWFlow('test');
        Test.stopTest();
        system.assertEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 201 "Failed call'
        );
    }
}