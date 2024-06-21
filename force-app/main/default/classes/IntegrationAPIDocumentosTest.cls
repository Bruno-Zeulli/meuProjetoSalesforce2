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
public class IntegrationAPIDocumentosTest {
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
    public static void callGetDocSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetDocumentAPIDocumentSuccess());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getFileByFileId('test');
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }
    @isTest
    public static void callGetAllTypeSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetAllTypeSuccess());
        Test.startTest();
        
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getAllTypesFile();
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }
    @isTest
    public static void callGetTypeSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetAllTypeSuccess());
        Test.startTest();
        
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getAllFilesByPath('test', 'test');
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }

    @isTest
    public static void callGetFileTypeNameTypeSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetTypebyNameSuccess());
        Test.startTest();
        
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getFileTypeIdByFileTypeName('test');
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }    

    @isTest
    public static void callGetByIdAccountSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetAllTypeSuccess());
        Test.startTest();
        
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getListFilesByIdentificatorUniqueAccount('test');
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }

    @isTest
    public static void callPostFileSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
        Test.startTest();
        
        Blob body = blob.valueOf('test');
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().postFile(body);
        Test.stopTest();
        system.assertEquals(
            200,
            results.get('WSResponseStatusCode'),
            'Check, the status code cannot be other than 200 "Failed call'
        );
    }

    @isTest
    public static void callDeleteLogicSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
        Test.startTest();
        
        Boolean results = IntegrationAPIDocumentos.getInstance().deleteFileLogic('test');
        Test.stopTest();
        system.assertEquals(
            true,
            results,
            'Check, result not equals true');
    }

     @isTest
    public static void callDeletePhysicalSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
        Test.startTest();
        
        Boolean results = IntegrationAPIDocumentos.getInstance().deleteFilePhysical('test');
        Test.stopTest();
        system.assertEquals(
            true,
            results,
            'Check, result not equals true');
    }

    @isTest
    public static void callFailed(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallAPIDocumentFailed());
        Test.startTest();
        Map<String, Object> results = IntegrationAPIDocumentos.getInstance().getFileByFileId('test');
        Test.stopTest();
        system.assertNotEquals(
            201,
            results.get('WSResponseStatusCode'),
            'Check, status code cannot equal to 201 "Authorized call"'
        );
    }    
}