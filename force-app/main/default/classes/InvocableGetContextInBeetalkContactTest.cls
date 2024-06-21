@isTest
public with sharing class InvocableGetContextInBeetalkContactTest {
    @isTest
    static void getNonexistentVariableInContext(){
        beetalk__Contact__c bc = new beetalk__Contact__c();
        insert bc;
    
        List<InvocableGetContextInBeetalkContact.ParamsRequests> requests = new List<InvocableGetContextInBeetalkContact.ParamsRequests>();
        InvocableGetContextInBeetalkContact.ParamsRequests request = new InvocableGetContextInBeetalkContact.ParamsRequests();
        request.beetalkContact = bc;
        request.variableName = 'customerName';
        requests.add(request);
    
        Test.startTest();
        List<InvocableGetContextInBeetalkContact.ParamsResponse> responses = InvocableGetContextInBeetalkContact.getContextVariableInBeetalkContact(requests);
        System.assertEquals(false, responses[0].findVariable);
        Test.stopTest();
    }
    @isTest
    static void getExistentVariableInContext(){
        beetalk__Contact__c bc = new beetalk__Contact__c();
        bc.ContextVariables__c = '{"customerName":"Test"}';
        insert bc;
    
        List<InvocableGetContextInBeetalkContact.ParamsRequests> requests = new List<InvocableGetContextInBeetalkContact.ParamsRequests>();
        InvocableGetContextInBeetalkContact.ParamsRequests request = new InvocableGetContextInBeetalkContact.ParamsRequests();
        request.beetalkContact = bc;
        request.variableName = 'customerName';
        requests.add(request);
    
        Test.startTest();
        List<InvocableGetContextInBeetalkContact.ParamsResponse> responses = InvocableGetContextInBeetalkContact.getContextVariableInBeetalkContact(requests);
        System.assertEquals(true, responses[0].findVariable);
        System.assertEquals('Test', responses[0].variableValue);
        Test.stopTest();
    }
    @isTest
    static void getVariableInInvalidContext(){
        beetalk__Contact__c bc = new beetalk__Contact__c();
        bc.ContextVariables__c = 'asdas';
        insert bc;
    
        List<InvocableGetContextInBeetalkContact.ParamsRequests> requests = new List<InvocableGetContextInBeetalkContact.ParamsRequests>();
        InvocableGetContextInBeetalkContact.ParamsRequests request = new InvocableGetContextInBeetalkContact.ParamsRequests();
        request.beetalkContact = bc;
        request.variableName = 'customerName';
        requests.add(request);
    
        Test.startTest();
        List<InvocableGetContextInBeetalkContact.ParamsResponse> responses = InvocableGetContextInBeetalkContact.getContextVariableInBeetalkContact(requests);
        System.assertEquals(false, responses[0].findVariable);
        Test.stopTest();
    }
}