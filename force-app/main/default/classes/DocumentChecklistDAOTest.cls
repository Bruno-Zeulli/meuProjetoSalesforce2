/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-22-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-22-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class DocumentChecklistDAOTest {
    @testSetup
    static void setup(){

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunityCorporateComercial();
        insert objOpportunity;
        DocumentChecklist__c objDocChecklist = DocumentChecklistDataFactory.insertDocumentChecklist(objOpportunity.Id);

    }

    @isTest
    static void shouldReturnAllDocumentChecklist(){
        String whereCondition = '';

        Test.startTest();
        List<DocumentChecklist__c> lstDocumentChecklistActual = DocumentChecklistDAO.getInstance().getAllFields(whereCondition);
        Test.stopTest();        
        
        Integer expected = 1;
        Integer actual = lstDocumentChecklistActual.size();
        System.assertEquals(expected, actual, 'Expected return list with size 1 position');
    }

    @isTest
    static void shouldReturnSpecificDocumentChecklist(){
        String objectRecordType = 'CorporateComercial';

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id FROM Opportunity];
        String oppId = lstOpportunity[0].Id;
        List<DocumentChecklist__c> lstDocumentChecklistActual = DocumentChecklistDAO.getInstance().getDocumentsChecklistBySObject(oppId);
        List<DocumentChecklist__c> lstDocumentChecklistExpected = [SELECT Id FROM DocumentChecklist__c WHERE ObjectRecordType__c = :objectRecordType];
        Test.stopTest();

        String expected = lstDocumentChecklistExpected[0].Id;
        String actual = lstDocumentChecklistActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

    @isTest
    static void shouldReturnSpecificDocumentChecklistFromMap(){
        String objectRecordType = 'CorporateComercial';
        String whereCondition = 'WHERE ObjectRecordType__c = \'' + objectRecordType + '\'';
        String selecField = 'Id';

        Test.startTest();
        List<DocumentChecklist__c> lstDocumentChecklistActual = DocumentChecklistDAO.getInstance().getDocumentsChecklistByWhereCondition(selecField, whereCondition);
        List<DocumentChecklist__c> lstDocumentChecklistExpected = [SELECT Id FROM DocumentChecklist__c WHERE ObjectRecordType__c = :objectRecordType];
        Test.stopTest();

        String expected = lstDocumentChecklistExpected[0].Id;
        String actual = lstDocumentChecklistActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }
}