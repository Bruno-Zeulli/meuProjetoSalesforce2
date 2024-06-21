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
public class ContractDataFactory {
  // Contrato Habitacional
  public static Contract2__c createContractHab(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('Insurance')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = 'Habitacional',
      Account__c = accountId,
      Company__c = 'CAIXA Seguradora',
      StartDate__c = System.today(),
      EndDate__c = System.today(),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = '873465874',
      CertificateNumber__c = '873465874',
      BidNumber__c = bidNumberGenerator(), //'873465874',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Habitacional',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = false,
      RecordTypeId = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
        .get('Insurance')
        .getRecordTypeId()
    );

    return contract;
  }

  public static Contract2__c insertContractHab(Id accountId, Product2 product){
    Contract2__c contract = createContractHab(accountId, product);
    insert contract;
    return contract;
  }

  // Contrato Prestamista
  public static Contract2__c createContractPres(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('Insurance')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = 'Prestamista',
      Account__c = accountId,
      Company__c = 'CAIXA Seguradora',
      StartDate__c = System.today(),
      EndDate__c = System.today(),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = '1',
      CertificateNumber__c = '1',
      BidNumber__c = bidNumberGenerator(), // '1',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Prestamista',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = false,
      RecordTypeId = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
        .get('Insurance')
        .getRecordTypeId()
    );

    return contract;
  }

  public static Contract2__c insertContractPres(Id accountId, Product2 product){
    Contract2__c contract = createContractPres(accountId, product);
    insert contract;
    return contract;
  }

  // Contrato Auto
  public static Contract2__c createContractAuto(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('Insurance')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = 'Auto',
      Account__c = accountId,
      Company__c = 'CAIXA Seguradora',
      StartDate__c = System.today().addYears(-1),
      EndDate__c = System.today().addDays(-3),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = '1',
      CertificateNumber__c = '1',
      BidNumber__c = bidNumberGenerator(), //'1',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Auto',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = true,
      IsRenewed__c = true,
      RecordTypeId = recordType
    );

    return contract;
  }

  public static Contract2__c insertContractAuto(Id accountId, Product2 product){
    Contract2__c contract = createContractAuto(accountId, product);
    insert contract;
    return contract;
  }

  // Contrato RCPM
  public static Contract2__c createContractRCPM(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('Insurance')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = 'RCPM',
      Account__c = accountId,
      Company__c = 'Argo Seguros',
      StartDate__c = System.today().addYears(-1),
      EndDate__c = System.today().addDays(-3),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = '1',
      CertificateNumber__c = '1',
      BidNumber__c = bidNumberGenerator(), //'1',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Habitacional',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = true,
      IsRenewed__c = true,
      RecordTypeId = recordType
    );

    return contract;
  }

  public static Contract2__c insertContractRCPM(Id accountId, Product2 product){
    Contract2__c contract = createContractRCPM(accountId, product);
    insert contract;
    return contract;
  }

  // Contrato Agro
  public static Contract2__c createContractAgro(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('Insurance')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = 'Agro',
      Account__c = accountId,
      Company__c = 'NEWE',
      StartDate__c = System.today().addYears(-1),
      EndDate__c = System.today().addDays(-3),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = '1',
      CertificateNumber__c = '1',
      BidNumber__c = bidNumberGenerator(), //'1',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Agro',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = true,
      IsRenewed__c = true,
      RecordTypeId = recordType
    );

    return contract;
  }

  public static Contract2__c insertContractAgro(Id accountId, Product2 product){
    Contract2__c contract = createContractAgro(accountId, product);
    insert contract;
    return contract;
  }

  // Contrato Corporate
  public static Contract2__c createContractCorporate(Id accountId, Product2 product){
    Id recordType = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
      .get('SeguroCorporate')
      .getRecordTypeId();

    Contract2__c contract = new Contract2__c(
      Name = TestDataFactory.generateRandomStringChar(15),
      Account__c = accountId,
      Company__c = 'NEWE',
      StartDate__c = System.today().addYears(-1),
      EndDate__c = System.today().addDays(-3),
      InsuredAmount__c = 4500.00,
      ContractNumber__c = TestDataFactory.generateRandomStringNumber(15),
      CertificateNumber__c = TestDataFactory.generateRandomStringChar(15),
      BidNumber__c = bidNumberGenerator(), //'1',
      ProductCode__c = product.ProductCode,
      ProductName__c = product.Name,
      Status__c = 'Ativo',
      ProductFamily__c = 'Patrimonial',
      BidStatus__c = 'Emitida',
      IsAutoRenewal__c = true,
      IsRenewed__c = true,
      RecordTypeId = recordType
    );

    return contract;
  }

  public static Contract2__c insertContractCorporate(Id accountId, Product2 product){
    Contract2__c contract = createContractCorporate(accountId, product);
    insert contract;
    return contract;
  }

  public static String bidNumberGenerator(){
    Integer len = 20;
    Blob blobKey = crypto.generateAesKey(128);
    String key = EncodingUtil.convertToHex(blobKey);
    String randomBidNumber = key.substring(0, len);
    //System.debug('************ '+pwd);
    return randomBidNumber;
  }
}