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
public class OrderDAOTest {
   @testSetup
    static void setup(){

        Account objAccount = AccountDataFactory.createPersonAccount();
        insert objAccount;  

        Order objOrder = OrderDataFactory.createOrder();
        objOrder.AccountId = objAccount.Id;
        Order objOrder2 = OrderDataFactory.createOrderCorporateApolice();
        objOrder2.AccountId = objAccount.Id;
        insert objOrder;
        insert objOrder2;
    }

    @isTest
    static void shouldReturnAllOrder(){
        String whereCondition = '';

        Test.startTest();
        List<Order> lstOrderActual = OrderDAO.getInstance().getAllFields(whereCondition);
        Test.stopTest();        
        
        Integer expected = 2;
        Integer actual = lstOrderActual.size();
        System.assertEquals(expected, actual, 'Expected return list with size 2 position');
    }

    @isTest
    static void shouldReturnSpecificOrderFromMap(){

        Test.startTest();
        List<Order> lstOrder = [SELECT Id FROM Order];
        String odrId = lstOrder[0].Id;
        String whereCondition = 'WHERE Id = \'' + odrId + '\'';
        Map<String, Object> mapOrderActual = OrderDAO.getInstance().getAllFieldsByWhereCondition(whereCondition);
        Order objOrder = (Order) mapOrderActual.get(odrId);
        List<Order> lstOrderExpected = [SELECT Id FROM Order WHERE Id = :odrId];
        Test.stopTest();

        String expected = lstOrderExpected[0].Id;
        String actual = objOrder.Id;
        System.assertEquals(expected, actual, 'Must return equals Id');
    }
}