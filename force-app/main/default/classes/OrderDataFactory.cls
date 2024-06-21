/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class OrderDataFactory {
  public static Order createOrder(){
    Order orderVariable = new Order(
      Name = TestDataFactory.generateRandomStringNumber(10),
      QuotationNumber__c = TestDataFactory.generateRandomStringChar(10),
      PoNumber = '85956654750384',
      Company__c = 'Caixa Seguradora',
      Type = 'New',
      Status = 'CarriedOut',
      EffectiveDate = Date.today()
    );
    return orderVariable;
  }

  private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateApolice')
    .getRecordTypeId();

  public static Order createOrderCorporateApolice(){
    Order orderVariable = new Order(
      Name = TestDataFactory.generateRandomStringNumber(10),
      QuotationNumber__c = TestDataFactory.generateRandomStringChar(10),
      PoNumber = '859563960750384',
      Company__c = 'Caixa Seguradora',
      Type = 'New',
      Status = 'CarriedOut',
      EffectiveDate = Date.today(),
      RecordTypeId = corporateApoliceRecordType
    );
    return orderVariable;
  }

  private static Id corporateEndossoNeutroRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateEndossoNeutro')
    .getRecordTypeId();

  public static Order createOrderCorporateEndossoNeutro(){
    Order orderVariable = new Order(
      Name = TestDataFactory.generateRandomStringAlfa(10),
      QuotationNumber__c = TestDataFactory.generateRandomStringChar(10),
      PoNumber = '9557295869239568604',
      Company__c = 'Caixa Seguradora',
      Type = 'New',
      Status = 'CarriedOut',
      EffectiveDate = Date.today(),
      RecordTypeId = corporateEndossoNeutroRecordType
    );
    return orderVariable;
  }

  private static Id corporateEndossoMovimentacaoPremioRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateEndossoMovimentaoPremio')
    .getRecordTypeId();

  public static Order createOrderCorporateEndossoMovimentacaoPremio(){
    Order orderVariable = new Order(
      Name = TestDataFactory.generateRandomStringAlfa(10),
      QuotationNumber__c = TestDataFactory.generateRandomStringChar(10),
      PoNumber = '7183438297530284',
      Company__c = 'Caixa Seguradora',
      Type = 'New',
      Status = 'CarriedOut',
      EffectiveDate = Date.today(),
      RecordTypeId = corporateEndossoMovimentacaoPremioRecordType
    );
    return orderVariable;
  }
}