/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class DocumentUploadServiceTest {
    @isTest
    public static void shouldResultGetFilesById(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetDocumentAPIDocumentSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Order objOrder = OrderDataFactory.createOrderCorporateApolice();
        objOrder.AccountId = acc.Id;
        insert objOrder;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            objOrder.Id, 
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
        docUpload.Objects__c = String.valueOf(objOrder.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOrder.Id;
        docUpload.ContentVersionId__c = contentVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        docUpload.ExternalReferenceId__c = '12345';
        insert docUpload;

        Test.startTest();
        DocumentUploadService.getFileByFileId(docUpload.Id);
        Test.stopTest();

        DocumentUpload__c objDocUp = [SELECT Id, ExternalUrl__c FROM DocumentUpload__c WHERE Id=:docUpload.Id];
        
        System.assert(objDocUp.ExternalUrl__c != null, 'Must return value in ExternalURL');

    }


    @isTest
    public static void shouldResultPostDoc(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Order objOrder = OrderDataFactory.createOrderCorporateApolice();
        objOrder.AccountId = acc.Id;
        insert objOrder;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            objOrder.Id, 
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
        docUpload.Objects__c = String.valueOf(objOrder.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOrder.Id;
        docUpload.ContentVersionId__c = cVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        insert docUpload;

        Test.startTest();
        DocumentUploadService.postFile(objOrder.Id);
        Test.stopTest();

        DocumentUpload__c objDocUp = [SELECT Id, ExternalUrl__c FROM DocumentUpload__c WHERE Id=:docUpload.Id];
        
        System.assert(objDocUp.ExternalUrl__c == null, true);

    }

    @isTest
    public static void updateStatusTest(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Order objOrder = OrderDataFactory.createOrderCorporateApolice();
        objOrder.AccountId = acc.Id;
        insert objOrder;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            objOrder.Id, 
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
        docUpload.Objects__c = String.valueOf(objOrder.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOrder.Id;
        docUpload.ContentVersionId__c = contentVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        docUpload.ExternalReferenceId__c = '12345';
        insert docUpload;
		
        String myJson = '{"' + docUpload.Id + '":{"status":"Accepted","reason":""}}';
        
        Test.startTest();
        DocumentUploadService.updateStatus(myJson);
        Test.stopTest();

        DocumentUpload__c docUploadAfterDelete = [SELECT Id, Status__c FROM DocumentUpload__c WHERE Id =: docUpload.Id];
    
        System.assertEquals(docUploadAfterDelete.Status__c, 'Accepted', 'Should return Accepted');

    }
    
    @isTest
    public static void shouldResultDeleteFileLogic(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Order objOrder = OrderDataFactory.createOrderCorporateApolice();
        objOrder.AccountId = acc.Id;
        insert objOrder;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            objOrder.Id, 
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
        docUpload.Objects__c = String.valueOf(objOrder.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOrder.Id;
        docUpload.ContentVersionId__c = contentVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        docUpload.ExternalReferenceId__c = '12345';
        insert docUpload;

        Test.startTest();
        DocumentUploadService.deleteFileLogic(docUpload.ExternalReferenceId__c, docUpload.Id);
        Test.stopTest();

        DocumentUpload__c docUploadAfterDelete = [SELECT Id, IsDeleted__c FROM DocumentUpload__c WHERE Id =: docUpload.Id];
    
        System.assertEquals(docUploadAfterDelete.IsDeleted__c, true, 'Should return true');

    }

    @isTest
    public static void shouldResultDeleteFilePhysical(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallDeleteDocSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Order objOrder = OrderDataFactory.createOrderCorporateApolice();
        objOrder.AccountId = acc.Id;
        insert objOrder;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            objOrder.Id, 
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
        docUpload.Objects__c = String.valueOf(objOrder.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOrder.Id;
        docUpload.ContentVersionId__c = contentVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        docUpload.ExternalReferenceId__c = '12345';
        insert docUpload;

        Test.startTest();
        DocumentUploadService.deleteFilePhysical(docUpload.ExternalReferenceId__c, docUpload.Id);
        Test.stopTest();

        List<DocumentUpload__c> lstUploadAfterDelete = [SELECT Id, IsDeleted FROM DocumentUpload__c WHERE Id =: docUpload.Id];
    
        System.assertEquals(lstUploadAfterDelete.size(), 0, 'Should return 0');

    }

    @isTest
    public static void shouldResultGetAllTypesFile(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetAllTypesSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '4');

        Test.startTest();
        DocumentUploadService.getAllTypesFile();
        Test.stopTest();

        List<DocumentType__c> lstDocumentType = [SELECT Id FROM DocumentType__c];
    
        System.assertEquals(lstDocumentType.size(), 2, 'Should return 2');

    }

    @isTest
    public static void shouldResultGeTypesFileByName(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGetTypebyNameSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '4');

        Test.startTest();
        DocumentUploadService.getFileTypeIdByFileTypeName('Boleto');
        Test.stopTest();

        List<DocumentType__c> lstDocumentType = [SELECT Id FROM DocumentType__c];
    
        System.assertEquals(lstDocumentType.size(), 1, 'Should return 1');

    }

    @isTest
    public static void shouldResultPostDocAccount(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        
        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            acc.Id, 
                                                            true, 
                                                            'personAccount', 
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
        docUpload.Objects__c = String.valueOf(acc.Id.getsobjecttype());  
        docUpload.IdObjeto__c = acc.Id;
        docUpload.ContentVersionId__c = cVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        insert docUpload;

        Test.startTest();
        DocumentUploadService.postFile(acc.Id);
        Test.stopTest();

        DocumentUpload__c objDocUp = [SELECT Id, ExternalUrl__c FROM DocumentUpload__c WHERE Id=:docUpload.Id];
        System.debug('value ==>'+objDocUp.ExternalUrl__c);
        
        System.assert(objDocUp.ExternalUrl__c == null, true);

    }

    @isTest
    public static void shouldResultPostDocOpp(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
        obj.AccountId = acc.Id;
        insert obj;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            obj.Id, 
                                                            true, 
                                                            'CorporateComercial', 
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
        docUpload.Objects__c = String.valueOf(obj.Id.getsobjecttype());  
        docUpload.IdObjeto__c = obj.Id;
        docUpload.ContentVersionId__c = cVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        insert docUpload;

        Test.startTest();
        DocumentUploadService.postFile(obj.Id);
        Test.stopTest();

        DocumentUpload__c objDocUp = [SELECT Id, ExternalUrl__c FROM DocumentUpload__c WHERE Id=:docUpload.Id];
        
        System.assert(objDocUp.ExternalUrl__c == null, true);

    }

    @isTest
    public static void shouldResultPostDocCase(){
        
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSendDocumentAPIDocumentSuccess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Case obj = CaseDataFactory.insertCase();
        obj.AccountId = acc.Id;
        update obj;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
                                                            obj.Id, 
                                                            true, 
                                                            'BPOComunicadoDeSinistro', 
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
        docUpload.Objects__c = String.valueOf(obj.Id.getsobjecttype());  
        docUpload.IdObjeto__c = obj.Id;
        docUpload.ContentVersionId__c = cVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        insert docUpload;

        Test.startTest();
        DocumentUploadService.postFile(obj.Id);
        Test.stopTest();

        DocumentUpload__c objDocUp = [SELECT Id, ExternalUrl__c FROM DocumentUpload__c WHERE Id=:docUpload.Id];
        
        System.assert(objDocUp.ExternalUrl__c == null, true);

    }

    
}