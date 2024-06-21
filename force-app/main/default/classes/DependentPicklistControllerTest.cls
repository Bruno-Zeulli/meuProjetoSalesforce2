/**
 * @description       : Componente para picklist dependente em fluxo de tela
 * @author            : samuelsirkis@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 13-02-20201
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-02-20201   Samuel Sirkis   Initial Version
 **/
@isTest
private class DependentPicklistControllerTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new DependentPicklistControllerMock());
    }

    @isTest
    static void testGetRecordTypes(){
        // Instantiate a new controller with all parameters in the page
        String objectName = 'Case';
        List<DependentPicklistController.RecordTypeWrapper> recordTypeList = new List<DependentPicklistController.RecordTypeWrapper>();

        Test.startTest();
        recordTypeList = DependentPicklistController.getRecordTypes(objectName);
        System.assert(recordTypeList.size() >= 2, 'Success => Record type list ');

        // Test a incorret api name
        String incorrectApiName = 'Case&';
        recordTypeList = DependentPicklistController.getRecordTypes(incorrectApiName);
        System.assert(recordTypeList.size() <= 1, 'Fail => invalid record type');
        Test.stopTest();
    }

    @isTest
    static void testGetPicklistValues(){
        RecordType recordTypeId = [SELECT ID FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Parceiros - Welcome Call'];
        string objectApiName = 'Case';
        string fieldApiName = 'CaseReason__c';
        string subFieldApiName = 'SpecificReason__c';

        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('DependentePicklistResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, new DependentPicklistControllerMock());

        // Call method to test

        // Instantiate a new controller with all parameters in the page

        Test.startTest();

        Map<String, List<String>> result = DependentPicklistController.getPicklistValues(objectApiName, recordTypeId.Id, subFieldApiName);

        Map<String, List<String>> result2 = DependentPicklistController.getPicklistValues(objectApiName, recordTypeId.Id, fieldApiName);

        Test.stopTest();

        System.assert(result != null, 'Success');
    }

    @isTest
    static void testGetSessionId(){
        PageReference pageRef = Page.SessionId;
        Test.startTest();
        if(pageRef != null){
            System.debug('pageRef => ' + pageRef);
        }
        Test.stopTest();

        System.assert(pageRef != null, 'Success');
    }
}