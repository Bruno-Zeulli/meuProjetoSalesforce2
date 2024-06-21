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
public class Contract2DAOTest {
    @testSetup
    static void setup(){

        Account objAccount  = AccountDataFactory.insertPersonAccount();

        Product2 objProductHab = ProductDataFactory.insertProductHab();
        Product2 objProductPrest = ProductDataFactory.insertProductPres();

        Contract2__c objContract = ContractDataFactory.insertContractHab(objAccount.Id, objProductHab);
        Contract2__c objContract2 = ContractDataFactory.insertContractPres(objAccount.Id, objProductPrest);
       
    }

    @isTest
    static void shouldReturnAllContract(){
        String whereCondition = '';

        Test.startTest();
        List<Contract2__c> lstContractActual = Contract2DAO.getInstance().getAllFields(whereCondition);
        List<Contract2__c> lstContractExpected = [SELECT Id FROM Contract2__c];
        Test.stopTest();
        
        
        Integer expected = lstContractExpected.size();
        Integer actual = lstContractActual.size();
        System.assertEquals(expected, actual, 'Expected return list with size 3 position');
    }

    @isTest
    static void shouldReturnSpecificContract(){
        String contractNumber = '873465874';
        String whereCondition = 'WHERE ContractNumber__c = \'' + contractNumber + '\'';

        Test.startTest();
        List<Contract2__c> lstContractActual = Contract2DAO.getInstance().getAllFields(whereCondition);
        List<Contract2__c> lstContractExpected = [SELECT Id FROM Contract2__c WHERE ContractNumber__c = :contractNumber];
        Test.stopTest();

        String expected = lstContractExpected[0].Id;
        String actual = lstContractActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

    @isTest
    static void shouldReturnSpecificContractFromMap(){
        String contractNumber = '1';
        String whereCondition = 'WHERE ContractNumber__c = \'' + contractNumber + '\'';

        Test.startTest();
        Map<String, Object> mapContractActual = Contract2DAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        List<Contract2__c> lstContractExpected = [SELECT Id FROM Contract2__c WHERE ContractNumber__c = :contractNumber];
        Test.stopTest();

        String expected = lstContractExpected[0].Id;
        Contract2__c objContractActual = (Contract2__c) mapContractActual.get(lstContractExpected[0].Id);
        String actual = objContractActual.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }
}