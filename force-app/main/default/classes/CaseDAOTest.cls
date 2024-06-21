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
@istest
public class CaseDAOTest {
    @testSetup
    static void setup(){
        Case objCase = CaseDataFactory.insertComunicadoSinistro(null, null, null);       
    }

    @isTest
    static void shouldReturnAllCase(){
        String whereCondition = '';

        Test.startTest();
        List<Case> lstCaseActual = CaseDAO.getInstance().getAllFields(whereCondition);
        List<Case> lstCaseExpected = [SELECT Id FROM Case];
        Test.stopTest();

        Integer expected = lstCaseExpected.size();
        Integer actual = lstCaseActual.size();
        System.assertEquals(expected, actual, 'Expected return size list with 1 position');
    }

    @isTest
    static void shouldReturnSpecificCaseFromMap(){

        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
            .get('BPOComunicadoDeSinistro')
            .getRecordTypeId();
        String whereCondition = 'WHERE RecordTypeId  = \'' + recordTypeId + '\'';
        Map<String, Object> mapCaseActual = CaseDAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        List<Case> lstCaseExpected = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];
        String expected = lstCaseExpected[0].Id;
        Test.stopTest();

        Case objCaseActual = (Case) mapCaseActual.get(lstCaseExpected[0].Id);
        String actual = objCaseActual.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }        
}