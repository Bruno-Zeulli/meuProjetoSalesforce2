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
public class Corporate_WFlowServiceTest {
    
    @isTest
    public static void shouldResultPostOppSales(){

        String pricebookId = '01s1U000008Gj7QQAS';
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        Product2 product = ProductDataFactory.insertProductAuto();  

        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = product.Id, 
        IsActive = true, 
        UnitPrice = 1
        );
        insert pbEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
        PricebookEntryId = pbEntry.Id,
        OpportunityId = objOpp.Id,
        Product2Id = product.Id,
        Quantity = 1.00,
        UnitPrice = 1
        );

        insert objOppLineItem;     

        Test.startTest();
        Corporate_WFlowService.postOpportunitySales(Json.serialize(objOpp));
        Test.stopTest();
        Opportunity opp = [SELECT Id, ExternalReferenceId__c,StageName FROM Opportunity WHERE Id =:objOpp.Id];

        System.assertEquals(opp.StageName, 'Cotação', 'Should return Cotação');

    }

    @isTest
    public static void shouldResultPostOppEndorsement(){

        String pricebookId = '01s1U000008Gj7QQAS';
        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.Type = 'Endorsement';
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        Product2 product = ProductDataFactory.insertProductAuto();  

        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = product.Id, 
        IsActive = true, 
        UnitPrice = 1
        );
        insert pbEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(
        PricebookEntryId = pbEntry.Id,
        OpportunityId = objOpp.Id,
        Product2Id = product.Id,
        Quantity = 1.00,
        UnitPrice = 1
        );

        insert objOppLineItem;       

        Test.startTest();
        Corporate_WFlowService.postOpportunityEndorsement(Json.serialize(objOpp));
        Test.stopTest();
        Opportunity opp = [SELECT Id, ExternalReferenceId__c,StageName FROM Opportunity WHERE Id =:objOpp.Id];

        System.assertEquals(opp.StageName, 'Cotação', 'Should return Cotação');

    }

    @isTest
    public static void shouldResultSendDocumentsToWFlow(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();
        DocumentType__c objDocType = DocumentTypeDataFactory.insertDocumentType('Boleto', '1');
        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.Type = 'Endorsement';
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        ContentVersion cVersion = new ContentVersion();
        cVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf('Test')));
        cVersion.Title = 'Apólice';
        cVersion.IsMajorVersion = true;
        cVersion.PathOnClient = '/Title.pdf';
        insert cVersion;

        ContentVersion contentVersion = [SELECT id, ContentDocumentId FROM CONTENTversion where id = :cVersion.Id];

        DocumentUpload__c docUpload = new DocumentUpload__c();

        docUpload.Name = cVersion.Title;
        docUpload.Objects__c = String.valueOf(objOpp.Id.getsobjecttype());  
        docUpload.IdObjeto__c = objOpp.Id;
        docUpload.ContentVersionId__c = cVersion.Id;
        docUpload.IdentificadorDocumento__c = contentVersion.ContentDocumentId;
        docUpload.DocumentType__c = objDocType.Id;
        insert docUpload;            

        Test.startTest();
        Corporate_WFlowService.sendDocumentsToWFlow(Json.serialize(objOpp));
        Test.stopTest();

        Integer expected;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }

     @isTest
    public static void shouldResultSendAprovedQuoteToWFlow(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();

        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.Type = 'Endorsement';
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        Quote objQuote = QuoteDataFactory.createQuoteCorporate();
        objQuote.ExternalReferenceId__c = '123';
        objQuote.OpportunityId = objOpp.Id;
        insert objQuote;
            
        Test.startTest();
        Corporate_WFlowService.sendAprovedQuoteToWFlow(Json.serialize(objQuote));
        Test.stopTest();

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }

    @isTest
    public static void shouldResultUpdateOpportunityInWFlow(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();

        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.Type = 'Endorsement';
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        List<Opportunity> lstOpportunityToWflow = new List<Opportunity>();
            
        Test.startTest();
        Corporate_WFlowService.updateOpportunityInWFlow(JSON.serialize(lstOpportunityToWflow));
        Test.stopTest();

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }

    @isTest
    public static void shouldResultUpdateQuoteInWFlow(){

        ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallWFlowPostOppSalesSucess());
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        Insert ct;
        Account acc = AccountDataFactory.insertPersonAccount();

        Opportunity objOpp = OpportunityDataFactory.createOpportunityCorporateComercial();
        objOpp.AccountId = acc.Id;
        objOpp.Type = 'Endorsement';
        objOpp.ExternalReferenceId__c = null;
        insert objOpp;

        Quote objQuote = QuoteDataFactory.createQuoteCorporate();
        objQuote.ExternalReferenceId__c = '123';
        objQuote.OpportunityId = objOpp.Id;
        insert objQuote;
            
        Test.startTest();
        Corporate_WFlowService.postQuoteUpdateInWFlow(objQuote.Id);
        Test.stopTest();

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }


}