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
public class AccountDAOTest {
    @testSetup
    static void setup(){

        Account customer = AccountDataFactory.insertPersonAccount();
        String identificationNumberCustomer2 = '96844320116';
        Account customer2 = AccountDataFactory.createPersonAccount(identificationNumberCustomer2);
        if(Schema.sObjectType.Account.isCreateable()){
            insert customer2;
        }
        Account customerBusinessAccount = AccountDataFactory.insertBusinessAccount();
    }

    @isTest
    static void shouldReturnAllAccount(){
        String whereCondition = '';

        Test.startTest();
        List<Account> lstAccountActual = AccountDAO.getInstance().getAllFields(whereCondition);
        List<Account> lstAccountExpected = [SELECT Id FROM Account];
        Test.stopTest();


        Integer expected = lstAccountExpected.size();
        Integer actual = lstAccountActual.size();
        System.assertEquals(expected, actual, 'Expected return list with size 3 position');
    }

    @isTest
    static void shouldReturnSpecificAccount(){
        String identificationNumber = '96844320116';
        String whereCondition = 'WHERE IdentificationNumber__c = \'' + IdentificationNumber + '\'';

        Test.startTest();
        List<Account> lstAccountActual = AccountDAO.getInstance().getAllFields(whereCondition);
        List<Account> lstAccountExpected = [SELECT Id FROM Account WHERE IdentificationNumber__c = :IdentificationNumber];
        Test.stopTest();

        String expected = lstAccountExpected[0].Id;
        String actual = lstAccountActual[0].Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }

    @isTest
    static void shouldReturnSpecificAccountFromMap(){
        String identificationNumber = '96844320116';
        String whereCondition = 'WHERE IdentificationNumber__c = \'' + IdentificationNumber + '\'';

        Test.startTest();
        Map<String, Object> mapAccountActual = AccountDAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        List<Account> lstAccountExpected = [SELECT Id FROM Account WHERE IdentificationNumber__c = :IdentificationNumber];
        Test.stopTest();

        String expected = lstAccountExpected[0].Id;
        Account objAccountActual = (Account) mapAccountActual.get(lstAccountExpected[0].Id);
        String actual = objAccountActual.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }
}