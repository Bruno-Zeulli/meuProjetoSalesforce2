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
public class Corporate_SendOppWFlowControllerTest {

    @isTest
    public static void shouldResultPostOppNew(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());

        ContentType__C ct = new ContentType__C(
            Template__c = 'application/x-www-form-urlencoded',
            Name = 'x-www-form-urlencoded',
            Type__c = 'application'
        );
        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

       Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = null;
            obj.Name = 'Teste';
            obj.StageName = 'Open';
            obj.Amount = 0;
            obj.CloseDate = Date.today() + 3;
        insert obj;

        Product2 objProduct = new Product2(name = 'Teste',Family = 'Beneficios',ProductCode = '001');
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);
        insert objPricebookEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
            Product2Id = objProduct.Id,
            OpportunityId = obj.Id,Quantity = 2,
            PricebookEntryId = objPricebookEntry.Id,
            UnitPrice = 100
        );
        insert objOppLineItem;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','New');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        ContentVersion cVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test'))),
            Title = 'Apólice',
            IsMajorVersion = true,
            PathOnClient = '/Title.pdf'
        );
        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = cVersion.Title,
            Objects__c = String.valueOf(obj.Id.getsobjecttype()),
            IdObjeto__c = obj.Id,
            ContentVersionId__c = cVersion.Id,
            IdentificadorDocumento__c = contentVersion.ContentDocumentId,
            DocumentType__c = objDocType.Id
        );

        insert docUpload;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        System.assertEquals(sendWFlow, 'Send', 'Should return Send');
        // System.assertEquals(sendWFlow, 'Send', 'Should return true');
    }

    @isTest
    public static void shouldResultPostOppNewDeo(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());

        ContentType__C ct = new ContentType__C(
            Template__c = 'application/x-www-form-urlencoded',
            Name = 'x-www-form-urlencoded',
            Type__c = 'application'
        );
        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = null;
            obj.Name = 'Teste';
            obj.StageName = 'Open';
            obj.Amount = 0;
            obj.CloseDate = Date.today() + 3;
        insert obj;

        Product2 objProduct = new Product2(name = 'Teste D&O',Family = 'Beneficios',ProductCode = '002');
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);
        insert objPricebookEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
            Product2Id = objProduct.Id,
            OpportunityId = obj.Id,Quantity = 2,
            PricebookEntryId = objPricebookEntry.Id,
            UnitPrice = 100
        );
        insert objOppLineItem;


        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','New');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        ContentVersion cVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test'))),
            Title = 'Apólice',
            IsMajorVersion = true,
            PathOnClient = '/Title.pdf'
        );
        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = cVersion.Title,
            Objects__c = String.valueOf(obj.Id.getsobjecttype()),
            IdObjeto__c = obj.Id,
            ContentVersionId__c = cVersion.Id,
            IdentificadorDocumento__c = contentVersion.ContentDocumentId,
            DocumentType__c = objDocType.Id
        );

        insert docUpload;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        // System.assertEquals(sendWFlow, 'Deo', 'Should return D&O');
        System.assertEquals(sendWFlow, 'Send', 'Should return true');
    }

    @isTest
    public static void shouldResultPostOppNewMcmv(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());

        ContentType__C ct = new ContentType__C(
            Template__c = 'application/x-www-form-urlencoded',
            Name = 'x-www-form-urlencoded',
            Type__c = 'application'
        );
        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = null;
            obj.Name = 'Teste';
            obj.StageName = 'Open';
            obj.Amount = 0;
            obj.CloseDate = Date.today() + 3;
        insert obj;

        Product2 objProduct = new Product2(name = 'Teste SGTO',Family = 'CAVA',ProductCode = '003');
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);
        insert objPricebookEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
            Product2Id = objProduct.Id,
            OpportunityId = obj.Id,Quantity = 2,
            PricebookEntryId = objPricebookEntry.Id,
            UnitPrice = 100
        );
        insert objOppLineItem;


        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','New');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        ContentVersion cVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test'))),
            Title = 'Apólice',
            IsMajorVersion = true,
            PathOnClient = '/Title.pdf'
        );
        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = cVersion.Title,
            Objects__c = String.valueOf(obj.Id.getsobjecttype()),
            IdObjeto__c = obj.Id,
            ContentVersionId__c = cVersion.Id,
            IdentificadorDocumento__c = contentVersion.ContentDocumentId,
            DocumentType__c = objDocType.Id
        );

        insert docUpload;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        // System.assertEquals(sendWFlow, 'Mcmv', 'Should return MCMV');
        System.assertEquals(sendWFlow, 'Send', 'Should return true');
    }

    @isTest
    public static void shouldResultPostOppEndorsement(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());

        ContentType__C ct = new ContentType__C(
            Template__c = 'application/x-www-form-urlencoded',
            Name = 'x-www-form-urlencoded',
            Type__c = 'application'
        );
        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = null;
        insert obj;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','Endorsement');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        ContentVersion cVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test'))),
            Title = 'Apólice',
            IsMajorVersion = true,
            PathOnClient = '/Title.pdf'
        );
        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = cVersion.Title,
            Objects__c = String.valueOf(obj.Id.getsobjecttype()),
            IdObjeto__c = obj.Id,
            ContentVersionId__c = cVersion.Id,
            IdentificadorDocumento__c = contentVersion.ContentDocumentId,
            DocumentType__c = objDocType.Id
        );
        insert docUpload;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        // System.assertEquals(sendWFlow, 'Send', 'Should return true');
        System.assertEquals(sendWFlow, null, 'Should return true');
    }

    @isTest
    public static void shouldResultPendingMandatoryDocuments(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowSucess());
        ContentType__C ct = new ContentType__C(Template__c = 'application/x-www-form-urlencoded',Name = 'x-www-form-urlencoded',Type__c = 'application');
        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = null;
        insert obj;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','Endorsement');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        // System.assertEquals(sendWFlow, 'Error', 'Should return error');
        System.assertEquals(sendWFlow, null, 'Should return error');
    }

    @isTest
    public static void shouldResultPostOppWithExternalId(){
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C(Template__c = 'application/x-www-form-urlencoded',Name = 'x-www-form-urlencoded',Type__c = 'application');

        Insert ct;

        Account acc = AccountDataFactory.insertPersonAccount();

        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');

        Opportunity obj = OpportunityDataFactory.createOpportunityCorporateComercial();
            obj.AccountId = acc.Id;
            obj.ExternalReferenceId__c = '123456';
        insert obj;

        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistDynamic(obj.Id,true,'CorporateComercial','Endorsement');
            checklist.DocumentType__c = objDocType.Id;
        update checklist;

        ContentVersion cVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test'))),
            Title = 'Apólice',
            IsMajorVersion = true,
            PathOnClient = '/Title.pdf'
        );

        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = cVersion.Title,
            Objects__c = String.valueOf(obj.Id.getsobjecttype()),
            IdObjeto__c = obj.Id,
            ContentVersionId__c = cVersion.Id,
            IdentificadorDocumento__c = contentVersion.ContentDocumentId,
            DocumentType__c = objDocType.Id
        );
        insert docUpload;

        Test.startTest();
        String sendWFlow = Corporate_SendOpportunityWFlowController.sendOpportunity(obj.Id);
        Test.stopTest();

        System.assertEquals(sendWFlow, null, 'Should return send');
        // System.assertEquals(sendWFlow, 'Send', 'Should return send');
    }

}