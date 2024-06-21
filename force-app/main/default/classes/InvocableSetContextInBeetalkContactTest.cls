@isTest
public with sharing class InvocableSetContextInBeetalkContactTest {
    @isTest
   static void setContextWithEmptyField(){
    beetalk__Contact__c bc = new beetalk__Contact__c();
    insert bc;

    List<InvocableSetContextInBeetalkContact.ParamsRequests> requests = new List<InvocableSetContextInBeetalkContact.ParamsRequests>();
    InvocableSetContextInBeetalkContact.ParamsRequests request = new InvocableSetContextInBeetalkContact.ParamsRequests();
    request.beetalkContact = bc;
    request.variableName = 'Name Test';
    request.variableValue = 'Value Test';
    requests.add(request);

    Test.startTest();
    List<InvocableSetContextInBeetalkContact.ParamsResponse> responses = InvocableSetContextInBeetalkContact.setContextVariableInBeetalkContact(requests);
    System.assertEquals('Value Test', responses[0].variableValue);
    Test.stopTest();
   }
   
   @isTest
   static void setContextWithNoEmptyField(){
    beetalk__Contact__c bc = new beetalk__Contact__c();
    bc.ContextVariables__c = '{"customerName":"Test"}';
    insert bc;

    List<InvocableSetContextInBeetalkContact.ParamsRequests> requests = new List<InvocableSetContextInBeetalkContact.ParamsRequests>();
    InvocableSetContextInBeetalkContact.ParamsRequests request = new InvocableSetContextInBeetalkContact.ParamsRequests();
    request.beetalkContact = bc;
    request.variableName = 'Name Test';
    request.variableValue = 'Value Test';
    requests.add(request);

    Test.startTest();
    List<InvocableSetContextInBeetalkContact.ParamsResponse> responses = InvocableSetContextInBeetalkContact.setContextVariableInBeetalkContact(requests);
    System.assertEquals('Value Test', responses[0].variableValue);
    Test.stopTest();
   }
}