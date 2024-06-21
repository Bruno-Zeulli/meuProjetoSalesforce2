@isTest
public with sharing class B2U_BuscarApoliceControllerTest {
  private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateApolice')
    .getRecordTypeId();

  @testSetup
  static void setup(){
    Account acc = AccountDataFactory.insertPersonAccount();
    Order orderAlfa = new Order();
    orderAlfa.Name = '10';
    orderAlfa.QuotationNumber__c = '10';
    orderAlfa.PoNumber = '10378004672';
    orderAlfa.Company__c = 'AIG Seguros';
    orderAlfa.Type = 'New';
    orderAlfa.Status = 'CarriedOut';
    orderAlfa.EffectiveDate = Date.today();
    orderAlfa.DateOfFirstInstallment__c = Date.today();
    orderAlfa.PoDate = Date.today();
    orderAlfa.EndDate = Date.today() + 1;
    orderAlfa.NumberOfInstallments__c = '1';
    orderAlfa.RecordTypeId = corporateApoliceRecordType;
    orderAlfa.AccountId = acc.Id;

    insert orderAlfa;
  }

  @isTest
  static void testBuscarApoliceByBookNaoFormatado(){
    Test.startTest();
    List<Order> lstOrder = B2U_BuscarApoliceController.getApolice(
      'BOOKSEMFORMATACAO',
      '087372017010378004672',
      'AIG Seguros'
    );
    System.assertEquals(true, lstOrder.size() > 0);
    Test.stopTest();
  }

  @isTest
  static void testBuscarApoliceByBookFormatado(){
    Test.startTest();
    List<Order> lstOrder = B2U_BuscarApoliceController.getApolice('BOOK', '10378004672', '');
    System.assertEquals(true, lstOrder.size() > 0);
    Test.stopTest();
  }

  @isTest
  static void testGetCompanies(){
    Test.startTest();
    List<String> lstCompanies = B2U_BuscarApoliceController.getCompanies();
    System.assertEquals(true, lstCompanies.size() > 0);
    Test.stopTest();
  }
}