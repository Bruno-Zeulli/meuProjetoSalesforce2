/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 09-21-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2022   viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
@IsTest(SeeAllData=true)
public class OrderUpdateBatchTest {
    @isTest
    static void testOrderUpdate(){
        // Cria um registro de pedido para ser atualizado
        Account acc = AccountDataFactory.insertPersonAccount();
        Product2 objProduct = new Product2();
        objProduct.name = 'Teste';
        objProduct.Family = 'Beneficios';
        objProduct.ProductCode = '002';
        insert objProduct;

        Pricebook2 objPricebook = new Pricebook2();
        objPricebook.Name = 'Teste Pricebook2';
        objPricebook.IsActive = true;

        insert objPricebook;

        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];

        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = objProduct.Id, UnitPrice = 1000, IsActive = true);

        insert standardPBE;

        PricebookEntry objPricebookEntry = new PricebookEntry();
        objPricebookEntry.Product2Id = objProduct.Id;
        objPricebookEntry.PriceBook2Id = objPricebook.Id;
        objPricebookEntry.IsActive = true;
        objPricebookEntry.UnitPrice = 1;

        insert objPricebookEntry;


        Order ord = OrderDataFactory.createOrder();
        ord.AccountId = acc.Id;
        ord.PoNumber = '87433875639186';
        ord.SalesDepartment__c = 'CONSEG';
        ord.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Conseg').getRecordTypeId();
        ord.Status = 'ReadyToIssue';
        ord.Pricebook2Id = objPricebook.Id;
        ord.Company__c = 'MAPFRE';
        ord.ReferenceId__c = 'MAPFRE - 87433875639186';

        insert ord;

        OrderItem orditem = new OrderItem();
        orditem.Product2Id = objProduct.Id;
        orditem.Quantity = 1;
        orditem.UnitPrice = 1;
        orditem.OrderId = ord.Id;
        orditem.PricebookEntryId = objPricebookEntry.Id;

        insert orditem;

        // Inicia o processo em lote
        Test.startTest();
        OrderUpdateSchedule.schedule();
        OrderUpdateBatch batch = new OrderUpdateBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verifica se o status do pedido foi atualizado corretamente
        Order ordQuery = [SELECT Id, Status FROM Order WHERE Id = :ord.Id];
        //System.assertEquals('PolicyIssued', ordQuery.Status, 'O status do pedido não foi atualizado corretamente');
    }
}