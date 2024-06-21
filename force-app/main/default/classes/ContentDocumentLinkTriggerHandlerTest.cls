@isTest
public class ContentDocumentLinkTriggerHandlerTest {
    
    private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
        .get('CorporateApolice')
        .getRecordTypeId();
    
    @testSetup
    static void setup(){
        Account acc = AccountDataFactory.insertPersonAccount();
        
        Order orderAlfa = new Order();
        orderAlfa.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAlfa.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAlfa.PoNumber = '2/93/2205';
        orderAlfa.Company__c = 'Alfa Seguros';
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
    public static void testUpdateVisibility(){
        
        Order orderToCheck = [SELECT Id FROM Order WHERE Company__c = 'Alfa Seguros' LIMIT 1];
        
        Test.startTest();
        
        ContentVersion content = new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = orderToCheck.Id;
        contentlink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: content.id].ContentDocumentId;
        contentlink.ShareType = 'I';
        insert contentlink;
        
        Test.stopTest();
        
        ContentDocumentLink cdlToVerify = [SELECT Id, Visibility FROM ContentDocumentLink WHERE LinkedEntityId =: orderToCheck.Id LIMIT 1];
        Assert.areEqual('AllUsers', cdlToVerify.Visibility);
        
    }

    @isTest
    public static void testLinkToParent(){
        Order parentOrder = [SELECT Id FROM Order WHERE Company__c = 'Alfa Seguros' LIMIT 1];

        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItemCorporate();
        Quote qt = QuoteDataFactory.createQuoteCorporate();
        QuoteLineItem qli = QuoteLineItemDataFactory.createQuoteLineItem();
        Order ord = OrderDataFactory.createOrderCorporateEndossoMovimentacaoPremio();
        ord.AccountId = acc.Id;
        ord.ParentId__c = parentOrder.Id;
        insert ord;

        ContentVersion content = new ContentVersion(); 
        content.Title='Header_Picture2'; 
        content.PathOnClient='/' + content.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = ord.Id;
        contentlink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: content.id].ContentDocumentId;
        insert contentlink;

        List<ContentDocumentLink> conts = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId= :parentOrder.Id];
        Assert.areEqual(1,conts.size());
    }
}