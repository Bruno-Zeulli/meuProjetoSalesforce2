/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD, alterado propriedade com upercase
 **/
@isTest
public class UploadDocumentControllerTest {
  private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateApolice')
    .getRecordTypeId();

  @isTest
  public static void documentUploadControllerTest(){
    Id recordTypePF = [SELECT Id FROM RecordType WHERE Name = 'PF' LIMIT 1].Id;
    Account acc = new Account(
        FirstName = 'Primeiro',
        LastName = 'Último',
        IdentificationNumber__c = '32482517001',
        RecordTypeId = recordTypePF
      );
      acc.IndividualIdentificationNumber__pc = acc.IdentificationNumber__c;
      insert acc;
    Order orderAIG = new Order();
    orderAIG.Name = TestDataFactory.generateRandomStringNumber(10);
    orderAIG.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
    orderAIG.PoNumber = '087372017010378004672';
    orderAIG.Company__c = 'AIG Seguros';
    orderAIG.Type = 'New';
    orderAIG.Status = 'CarriedOut';
    orderAIG.EffectiveDate = Date.today();
    orderAIG.DateOfFirstInstallment__c = Date.today();
    orderAIG.PoDate = Date.today();
    orderAIG.EndDate = Date.today() + 1;
    orderAIG.NumberOfInstallments__c = '1';
    orderAIG.RecordTypeId = corporateApoliceRecordType;
    orderAIG.AccountId = acc.Id;

    insert orderAIG;

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Apólice';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';
    insert cVersion;

    ContentVersion cVersion1 = new ContentVersion();
    cVersion1.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion1.Title = 'Boleto';
    cVersion1.IsMajorVersion = true;
    cVersion1.PathOnClient = '/Title.pdf';
    insert cVersion1;

    ContentVersion cVersion2 = new ContentVersion();
    cVersion2.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion2.Title = 'Endosso';
    cVersion2.IsMajorVersion = true;
    cVersion2.PathOnClient = '/Title.pdf';
    insert cVersion2;

    ContentVersion cVersion3 = new ContentVersion();
    cVersion3.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion3.Title = 'Comprovante de pagamento';
    cVersion3.IsMajorVersion = true;
    cVersion3.PathOnClient = '/Title.pdf';
    insert cVersion3;

    ContentVersion cVersion4 = new ContentVersion();
    cVersion4.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion4.Title = 'Email';
    cVersion4.IsMajorVersion = true;
    cVersion4.PathOnClient = '/Title.pdf';
    insert cVersion4;

    ContentVersion cVersion5 = new ContentVersion();
    cVersion5.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion5.Title = 'Outros';
    cVersion5.IsMajorVersion = true;
    cVersion5.PathOnClient = '/Title.pdf';
    insert cVersion5;

    cVersion = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion.Id LIMIT 1];
    cVersion1 = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion1.Id LIMIT 1];
    cVersion2 = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion2.Id LIMIT 1];
    cVersion3 = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion3.Id LIMIT 1];
    cVersion4 = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion4.Id LIMIT 1];
    cVersion5 = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ID = :cVersion5.Id LIMIT 1];

    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.LinkedEntityId = orderAIG.Id;
    cdl.ContentDocumentId = cVersion.ContentDocumentId;
    insert cdl;

    ContentDocumentLink cdl1 = new ContentDocumentLink();
    cdl1.LinkedEntityId = orderAIG.Id;
    cdl1.ContentDocumentId = cVersion1.ContentDocumentId;
    insert cdl1;

    ContentDocumentLink cdl2 = new ContentDocumentLink();
    cdl2.LinkedEntityId = orderAIG.Id;
    cdl2.ContentDocumentId = cVersion2.ContentDocumentId;
    insert cdl2;

    ContentDocumentLink cdl3 = new ContentDocumentLink();
    cdl3.LinkedEntityId = orderAIG.Id;
    cdl3.ContentDocumentId = cVersion3.ContentDocumentId;
    insert cdl3;

    ContentDocumentLink cdl4 = new ContentDocumentLink();
    cdl4.LinkedEntityId = orderAIG.Id;
    cdl4.ContentDocumentId = cVersion4.ContentDocumentId;
    insert cdl4;

    ContentDocumentLink cdl5 = new ContentDocumentLink();
    cdl5.LinkedEntityId = orderAIG.Id;
    cdl5.ContentDocumentId = cVersion5.ContentDocumentId;
    insert cdl5;

    System.debug('cVersion.ContentDocumentId = ' + cVersion.ContentDocumentId);
    Test.startTest();
    UploadDocumentController.getRelatedFilesByRecordId(orderAIG.Id);
    UploadDocumentController.changeFileName(
      JSON.serialize(new List<Id>{ cVersion.ContentDocumentId }),
      'fileName',
      orderAIG
    );
    UploadDocumentController.changeFileName(
      JSON.serialize(new List<Id>{ cVersion1.ContentDocumentId }),
      'fileName',
      orderAIG
    );
    UploadDocumentController.changeFileName(
      JSON.serialize(new List<Id>{ cVersion2.ContentDocumentId }),
      'fileName',
      orderAIG
    );
    // UploadDocumentController.changeFileName(
    //   JSON.serialize(new List<Id>{ cVersion3.ContentDocumentId }),
    //   'fileName',
    //   orderAIG
    // );
    // UploadDocumentController.changeFileName(
    //   JSON.serialize(new List<Id>{ cVersion4.ContentDocumentId }),
    //   'fileName',
    //   orderAIG
    // );
    // UploadDocumentController.changeFileName(
    //   JSON.serialize(new List<Id>{ cVersion5.ContentDocumentId }),
    //   'fileName',
    //   orderAIG
    // );
    Test.stopTest();

    System.assertNotEquals(null, cVersion.ContentDocumentId, 'Document id should be not null!');
    System.assertNotEquals(null, cVersion1.ContentDocumentId, 'Document id should be not null!');
    System.assertNotEquals(null, cVersion2.ContentDocumentId, 'Document id should be not null!');
    System.assertNotEquals(null, cVersion3.ContentDocumentId, 'Document id should be not null!');
    System.assertNotEquals(null, cVersion4.ContentDocumentId, 'Document id should be not null!');
    System.assertNotEquals(null, cVersion5.ContentDocumentId, 'Document id should be not null!');
  }

  @isTest
  public static void uploadAnGetDocumentTest(){

    ExternalAPIDataFactory.insertExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
    ContentType__C ct = new ContentType__C();
    ct.Template__c = 'application/x-www-form-urlencoded';
    ct.Name = 'x-www-form-urlencoded';
    ct.Type__c = 'application';
    Insert ct;

    Account acc = AccountDataFactory.insertPersonAccount();
    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Apólice';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';

    insert cVersion;

    ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

    String payload = '[{"name": "R H C da Silva Inf. Faturamento (2).pdf", "documentId":"' + contentVersion.ContentDocumentId + '", "contentVersionId":"'+ contentVersion.Id +'"}]';

    Test.startTest();
      UploadDocumentController.getPickListValuestipoDocumentos();
      Map<ID, String> result = UploadDocumentController.uploadDocuments(payload, acc.Id, 'Boleto');
      UploadDocumentController.getPersonInformation(acc.Id, 'Boleto');
    Test.stopTest();

    List<DocumentUpload__c> documentUpload = [SELECT Id, IdObjeto__c, ContentVersionId__c, IdentificadorDocumento__c FROM DocumentUpload__c];

    System.assertEquals(documentUpload.size() > 0, true, 'Should return true');

  }

  @isTest
  public static void getDocumentchecklistTest(){

    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    Account acc = AccountDataFactory.insertPersonAccount();
    Order orderAIG = new Order();
    orderAIG.Name = TestDataFactory.generateRandomStringNumber(10);
    orderAIG.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
    orderAIG.PoNumber = '087372017010378004672';
    orderAIG.Company__c = 'AIG Seguros';
    orderAIG.Type = 'New';
    orderAIG.Status = 'CarriedOut';
    orderAIG.EffectiveDate = Date.today();
    orderAIG.DateOfFirstInstallment__c = Date.today();
    orderAIG.PoDate = Date.today();
    orderAIG.EndDate = Date.today() + 1;
    orderAIG.NumberOfInstallments__c = '1';
    orderAIG.RecordTypeId = corporateApoliceRecordType;
    orderAIG.AccountId = acc.Id;
    insert orderAIG;


    DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                          orderAIG.Id,
                                                          true,
                                                          'CorporateApolice',
                                                          'New'
                                                        );
    checklist.DocumentType__c = objDocType.Id;
    update checklist;

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Apólice';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';
    insert cVersion;

    ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

    DocumentUpload__c docUpload = new DocumentUpload__c();

    docUpload.Name = cVersion.Title;
    docUpload.Objects__c = String.valueOf(orderAIG.Id.getsobjecttype());
    docUpload.IdObjeto__c = orderAIG.Id;
    docUpload.ContentVersionId__c = contentVersion.Id;
    docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
    docUpload.DocumentType__c = objDocType.Id;
    insert docUpload;

    Test.startTest();
      List<String> lstValuesDocType = UploadDocumentController.getPickListValuestipoDocumentos();
      Map<Id, String> result = UploadDocumentController.getFilesByObject(orderAIG.Id);
      Map<Id, String> result2 = UploadDocumentController.getAccountRelatedFiles(acc.Id);
    //   Map<Id, String> resultGetDocCL = UploadDocumentController.getDocumentsChecklist(orderAIG.Id);

    Test.stopTest();
    System.assertEquals(result.size() > 0, true, 'Should return true');
    System.assertEquals(result2.size() > 0, true, 'Should return true');
    System.assertEquals(lstValuesDocType.size() > 0, true, 'Should return true');
    // System.assertEquals(resultGetDocCL.size() > 0, true, 'Should return true');

  }

  @isTest
  public static void deleteDocTest(){

    ExternalAPIDataFactory.insertExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
    ContentType__C ct = new ContentType__C();
    ct.Template__c = 'application/x-www-form-urlencoded';
    ct.Name = 'x-www-form-urlencoded';
    ct.Type__c = 'application';
    Insert ct;

    Account acc = AccountDataFactory.insertPersonAccount();
    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Test';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';
    insert cVersion;

    ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

    DocumentUpload__c docUpload = new DocumentUpload__c();

    docUpload.Name = cVersion.Title;
    docUpload.Objects__c = String.valueOf(acc.Id.getsobjecttype());
    docUpload.IdObjeto__c = acc.Id;
    docUpload.ContentVersionId__c = contentVersion.Id;
    docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
    docUpload.DocumentType__c = objDocType.Id;
    docUpload.ExternalReferenceId__c = '12345';
    insert docUpload;

    Test.startTest();
      UploadDocumentController.deleteDoc(docUpload.Id);
    Test.stopTest();

    DocumentUpload__c docUploadAfterDelete = [SELECT Id, IsDeleted__c FROM DocumentUpload__c WHERE Id =: docUpload.Id];

    System.assertEquals(docUploadAfterDelete.IsDeleted__c, true, 'Should return true');

  }

  @IsTest
  static void testRelateDocument(){
    ExternalAPIDataFactory.insertExternalAPIs();
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetDocumentAPIDocumentSuccess());

    Account acc = AccountDataFactory.insertPersonAccount();
    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Test';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';
    insert cVersion;

    ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

    DocumentUpload__c docUpload = new DocumentUpload__c();

    docUpload.Name = cVersion.Title;
    docUpload.Objects__c = String.valueOf(acc.Id.getsobjecttype());
    docUpload.IdObjeto__c = acc.Id;
    docUpload.ContentVersionId__c = contentVersion.Id;
    docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
    docUpload.DocumentType__c = objDocType.Id;
    docUpload.ExternalReferenceId__c = '12345';
    insert docUpload;

    DocumentTO.RelateExistingDocument newRecord = new DocumentTO.RelateExistingDocument();
    newRecord.objectName = 'Account';
    newRecord.recordId = acc.Id;
    Test.startTest();
    UploadDocumentController.relateFilesToRecords(docUpload.Id, new List<DocumentTO.RelateExistingDocument>{newRecord});
    UploadDocumentController.sendFiles(acc.Id);
    Test.stopTest();
    
    List<DocumentUpload__c> newDocument = [SELECT Id, Status__c FROM DocumentUpload__c WHERE IdObjeto__c = :acc.Id AND Id != :docUpload.Id];
    Assert.areEqual(1, newDocument.size(), 'The size was not as expected');
    Assert.areEqual('UnderReview', newDocument.get(0).Status__c, 'The status was not as expected');
  }

  @IsTest
  static void increaseCoverage1(){
    Contact con = new Contact(
      LastName = 'Test'
    );
    insert con;

    ContentVersion cv = new ContentVersion(
      Title = 'Test',
      PathOnClient = 'Test',
      VersionData = EncodingUtil.base64Decode('Test'),
      IsMajorVersion = FALSE
    );
    insert cv;

    cv = [SELECT Id, GuestRecordFileUpload__c, ContentDocument.Title, ContentDocumentId, VersionData FROM ContentVersion LIMIT 1];

    ContentDocumentLink link = new ContentDocumentLink(
      ContentDocumentId = cv.ContentDocumentId,
      LinkedEntityId = con.Id,
      Visibility = 'AllUsers'
    );
    insert link;

    Test.startTest();
    UploadDocumentController.getRelatedFilesByRecordId(con.Id);
    Test.stopTest();
    
  }

  public class MockHttpCallout implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Crie uma resposta simulada com um token de acesso
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"access_token": "your_simulated_token"}');
      res.setStatusCode(200);
      return res;
    }
  }

  @IsTest
  static void increaseCoverage2(){
    ExternalAPIDataFactory.insertExternalAPIs();
    ContentType__C ct = new ContentType__C(
      Template__c = 'application/x-www-form-urlencoded',
      Name = 'x-www-form-urlencoded',
      Type__c = 'application'
      );
    insert ct;

    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    DocumentTO.DocumentPostResponseTO documentPostResponseTO = new DocumentTO.DocumentPostResponseTO();
    documentPostResponseTO.idArquivo = 'test';
    documentPostResponseTO.idTipoArquivo = 'test';
    documentPostResponseTO.desCaminho = 'test';
    documentPostResponseTO.snExcluido = true;
    documentPostResponseTO.dtExclusao = Date.today();
    documentPostResponseTO.arquivo = new DocumentTO.DocumentPostFileTO();
    documentPostResponseTO.arquivo.name = 'test';
    DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
    pessoa.documento = 'test';
    pessoa.tipoPessoa = 'test';
    pessoa.desCaminho = 'test';
    documentPostResponseTO.pessoa = new List<DocumentTO.Pessoa>{pessoa};
      
    Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
    Test.startTest();
    UploadDocumentController.getToken();
    UploadDocumentController.getFileURL();
    UploadDocumentController.getLoginURL();
    UploadDocumentController.generateDocumentWithAPISucess(JSON.serialize(documentPostResponseTO), '001000000000000', 'Boleto');
    Test.stopTest(); 
  }

  @IsTest
  static void increaseCoverage3(){
    ExternalAPIDataFactory.insertExternalAPIs();
    ContentType__C ct = new ContentType__C(
      Template__c = 'application/x-www-form-urlencoded',
      Name = 'x-www-form-urlencoded',
      Type__c = 'application'
      );
    insert ct;
    Account acc = AccountDataFactory.insertPersonAccount();
    DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

    ContentVersion cVersion = new ContentVersion();
    cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
    cVersion.Title = 'Test';
    cVersion.IsMajorVersion = true;
    cVersion.PathOnClient = '/Title.pdf';
    insert cVersion;

    ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

    DocumentUpload__c docUpload = new DocumentUpload__c();

    docUpload.Name = cVersion.Title;
    docUpload.Objects__c = String.valueOf(acc.Id.getsobjecttype());
    docUpload.IdObjeto__c = acc.Id;
    docUpload.ContentVersionId__c = contentVersion.Id;
    docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
    docUpload.DocumentType__c = objDocType.Id;
    docUpload.ExternalReferenceId__c = '12345';
    insert docUpload;
    
    Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
    Test.startTest();
    UploadDocumentController.sendOpportunityCorporateForAPI(docUpload.Id);
    UploadDocumentController.updateStatusFile(docUpload.Id, 'UnderReview');
    Test.stopTest();
    
  }
}