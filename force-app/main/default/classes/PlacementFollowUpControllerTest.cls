@isTest
public class PlacementFollowUpControllerTest {

    @isTest
    static void testCustomExceptionData() {
        
        PlacementFollowUpController.CustomExceptionData customException = new PlacementFollowUpController.CustomExceptionData('MESSAGE');
    }

    @isTest
    static void testGetOpportunityById() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        Opportunity resultOpp = PlacementFollowUpController.getOpportunityById(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetOpportunityLineItemByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<OpportunityLineItem> resultOppLineItem = PlacementFollowUpController.getOpportunityLineItemByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetContactByAccId() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Test.startTest();
        List<Contact> contacts = PlacementFollowUpController.getContactByAccId(testAcc.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetQuestionaryByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<Questionnaire__c> questionary = PlacementFollowUpController.getQuestionaryByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetCaseByOpportunityId() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Case testCase = new Case(Status = 'Novo pedido', AccountId = testAcc.Id, Opportunity__c = testOpp.Id);
        insert testCase;

        Test.startTest();
        List<Case> cse = PlacementFollowUpController.getCaseByOpportunityId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetQuotesByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<Quote> quote = PlacementFollowUpController.getQuotesByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetCoinsuranceProposalsByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<Quote> quote = PlacementFollowUpController.getCoinsuranceProposalsByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetQuoteById() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testQt = new Quote(Name = 'Test Quote', Status = 'Presented', OpportunityId = testOpp.Id);
        insert testQt;

        Test.startTest();
        Quote quote = PlacementFollowUpController.getQuoteById(testQt.Id);
        Test.stopTest();
    }

    @isTest
    static void testDeleteQuoteById() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testQt = new Quote(Name = 'Test Quote', Status = 'Presented', OpportunityId = testOpp.Id);
        insert testQt;

        Test.startTest();
        Id deletedId = PlacementFollowUpController.deleteQuoteById(testQt.Id);
        Test.stopTest();
    }

    @isTest
    static void testDeleteQuoteById_Exception() {
        Id invalidQuoteId = 'a0Q00000000XXXXXXX'; 
    
        Exception actualException;
        try {
            Test.startTest();
            PlacementFollowUpController.deleteQuoteById(invalidQuoteId);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected');
    }
    

    @isTest
    static void testUpdateQuotes() {
        List<Quote> quotes = new List<Quote>();

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testQt = new Quote(Name = 'Test Quote', Status = 'Presented', OpportunityId = testOpp.Id);
        insert testQt;

        testQt.Name = 'Test Quote 2';

        quotes.add(testQt);

        Test.startTest();
        PlacementFollowUpController.updateQuotes(quotes);
        Test.stopTest();
    }
    

    @isTest
    static void testUpdateQuotes_Exception() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;
    
        Quote testQuote = new Quote(Name = 'Test Quote', OpportunityId = testOpp.Id);
        insert testQuote;
    
        testQuote.Name = ''; 
    
        List<Quote> quotesToUpdate = new List<Quote>{testQuote};
    
        Exception actualException;
        try {
            Test.startTest();
            PlacementFollowUpController.updateQuotes(quotesToUpdate);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
    
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }
    

    @isTest
    static void testGetApprovedProposalByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testQuote = new Quote(Name = 'Quote Test', OpportunityId = testOpp.Id, Status = 'Accepted');
        insert testQuote;

        Test.startTest();
        Quote quote = PlacementFollowUpController.getApprovedProposalByOppId(testOpp.Id);
        Test.stopTest();
    }


    @isTest
    static void testCreateQuoteIntegralizations() {
        List<QuoteIntegralization__c> integralizations = new List<QuoteIntegralization__c>();

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testPartialQuote = new Quote(Name = 'Partial Quote', OpportunityId = testOpp.Id);
        insert testPartialQuote;

        Quote testIntegralQuote = new Quote(Name = 'Integral Quote', OpportunityId = testOpp.Id);
        insert testIntegralQuote;

        QuoteIntegralization__c testIntegralization = new QuoteIntegralization__c(IntegralQuote__c = testIntegralQuote.Id, PartialQuote__c = testPartialQuote.Id);
        
        integralizations.add(testIntegralization);

        Test.startTest();
        List<QuoteIntegralization__c> quoteIntegralizations = PlacementFollowUpController.createQuoteIntegralizations(integralizations);
        Test.stopTest();
    }

    @isTest
    static void testCreateQuoteIntegralizations_Exception() {
        List<QuoteIntegralization__c> integralizations = new List<QuoteIntegralization__c>();

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Id invalidQuoteId = 'a0Q00000000XXXXXXX'; 

        QuoteIntegralization__c testIntegralization = new QuoteIntegralization__c(IntegralQuote__c = invalidQuoteId, PartialQuote__c = invalidQuoteId);
        
        integralizations.add(testIntegralization);

        Exception actualException;
        try {
            Test.startTest();
            List<QuoteIntegralization__c> quoteIntegralizations = PlacementFollowUpController.createQuoteIntegralizations(integralizations);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest
    static void testGetIntegralizationsByProposalId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testIntegralQuote = new Quote(Name = 'Integral Quote', OpportunityId = testOpp.Id);
        insert testIntegralQuote;

        Test.startTest();
        List<QuoteIntegralization__c> quoteIntegralizations = PlacementFollowUpController.getIntegralizationsByProposalId(testIntegralQuote.Id);
        Test.stopTest();
    }

    @isTest
    static void testDeleteIntegralizations() {
        List<QuoteIntegralization__c> quoteIntegralizations = new List<QuoteIntegralization__c>();
        
        QuoteIntegralization__c quoteIntegralization = new QuoteIntegralization__c();
        insert quoteIntegralization;

        quoteIntegralizations.add(quoteIntegralization);

        Test.startTest();
        List<QuoteIntegralization__c> integralizations = PlacementFollowUpController.deleteIntegralizations(quoteIntegralizations);
        Test.stopTest();
    }

    @isTest
    static void testDeleteIntegralizations_Exception() {
        List<QuoteIntegralization__c> quoteIntegralizations = new List<QuoteIntegralization__c>();
        
        QuoteIntegralization__c quoteIntegralization = new QuoteIntegralization__c();

        quoteIntegralizations.add(quoteIntegralization);

        Exception actualException;
        try {
            Test.startTest();
            List<QuoteIntegralization__c> integralizations = PlacementFollowUpController.deleteIntegralizations(quoteIntegralizations);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');

    }


    @isTest
    static void testGetDocumentsFromOppByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<DocumentUpload__c> documents = PlacementFollowUpController.getDocumentsFromOppByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testUpdateDocument() {
        DocumentType__c docType = new DocumentType__c();
        docType.ExternalReferenceId__c = '89';
        insert docType;

        DocumentUpload__c document = new DocumentUpload__c();
        document.DocumentType__c = docType.Id;
        document.Name = 'Doc Test';
        insert document;

        document.Name = 'Doc Test Updt';

        Test.startTest();
        DocumentUpload__c documentUpdt = PlacementFollowUpController.updateDocument(document);
        Test.stopTest();
    }

    @isTest
    static void testUpdateDocument_Exception() {
        DocumentType__c docType = new DocumentType__c();
        docType.ExternalReferenceId__c = '89';
        insert docType;

        DocumentUpload__c document = new DocumentUpload__c();
        document.DocumentType__c = docType.Id;
        document.Name = 'Doc Test';
        insert document;

        document.DocumentType__c = 'a0Q00000000XXXXXXX';

        Exception actualException;
        try {
            Test.startTest();
            DocumentUpload__c documentUpdt = PlacementFollowUpController.updateDocument(document);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }


    @isTest
    static void testGetDocumentsSusep382FromOppByOppId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Test.startTest();
        List<DocumentUpload__c> documents = PlacementFollowUpController.getDocumentsSusep382FromOppByOppId(testOpp.Id);
        Test.stopTest();
    }


    @isTest
    static void testUpdateOpportunity() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        testOpp.StageName = 'Fechado e ganho';

        Test.startTest();
        Opportunity oppUpdt = PlacementFollowUpController.updateOpportunity(testOpp);
        Test.stopTest();
    }

    @isTest
    static void testUpdateOpportunity_Exception() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        testOpp.CloseDate = null;

        Exception actualException;
        try {
            Test.startTest();
            Opportunity oppUpdt = PlacementFollowUpController.updateOpportunity(testOpp);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest
    static void testGetQuoteRecordTypeId() {
        Test.startTest();
        Id recTypeId = PlacementFollowUpController.getQuoteRecordTypeId('Corporate');
        Test.stopTest();
    }

    @isTest
    static void testGetQuoteRecordTypeId_Exception() {
        Exception actualException;
        try {
            Test.startTest();
            Id recTypeId = PlacementFollowUpController.getQuoteRecordTypeId('Teste');
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest
    static void testGetOrderRecordTypeId() {
        Test.startTest();
        Id recTypeId = PlacementFollowUpController.getOrderRecordTypeId('CorporateApolice');
        Test.stopTest();
    }

    @isTest
    static void testGetOrderRecordTypeId_Exception() {
        Exception actualException;
        try {
            Test.startTest();
            Id recTypeId = PlacementFollowUpController.getOrderRecordTypeId('Teste');
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest
    static void testGetCaseRecordTypeId() {
        Test.startTest();
        Id recTypeId = PlacementFollowUpController.getCaseRecordTypeId('CorporateCelulaTecnica');
        Test.stopTest();
    }

    @isTest
    static void testGetCaseRecordTypeId_Exception() {
        Exception actualException;
        try {
            Test.startTest();
            Id recTypeId = PlacementFollowUpController.getCaseRecordTypeId('Teste');
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest
    static void testGetOrderByOppId() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Order testOrder = new Order(Name = 'Test Order', Status = 'CarriedOut', OpportunityId = testOpp.Id, AccountId = testAcc.Id, EffectiveDate = Date.today(), Company__c = 'Akad Seguros');
        insert testOrder;

        Test.startTest();
        Order order = PlacementFollowUpController.getOrderByOppId(testOpp.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetQuoteDocumentsByQuoteId() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Quote testQuote = new Quote(Name = 'Test Quote', Status = 'Draft', OpportunityId = testOpp.Id);
        insert testQuote;

        Test.startTest();
        List<DocumentUpload__c> documents = PlacementFollowUpController.getQuoteDocumentsByQuoteId(testQuote.Id);
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void testGetApoliceBoletosFromOrderByOrderId() {
        DocumentType__c docType =  [SELECT Id, Name FROM DocumentType__c WHERE Name = 'Boleto' LIMIT 1];

        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Order testOrder = new Order(Name = 'Test Order', Status = 'CarriedOut', OpportunityId = testOpp.Id, AccountId = testAcc.Id, EffectiveDate = Date.today(), Company__c = 'Akad Seguros');
        insert testOrder;

        DocumentUpload__c document = new DocumentUpload__c (Name = 'Doc Test', DocumentType__c = docType.Id, ExternalUrl__c = 'URLTEST', IdObjeto__c = testOrder.Id, Objects__c = 'Order');
        insert document;
    
        Test.startTest();
        List<DocumentUpload__c> documents = PlacementFollowUpController.getApoliceBoletosFromOrderByOrderId(testOrder.Id);
        Test.stopTest();
    }

    @isTest
    static void testUpdateCaseAndOppStatus() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Case testCase = new Case(Status = 'Novo pedido', AccountId = testAcc.Id);
        insert testCase;

        testOpp.StageName = 'Fechado e ganho';
        testCase.Status = 'Apólice registrada';

        Test.startTest();
        List<Id> ids = PlacementFollowUpController.updateCaseAndOppStatus(testOpp, testCase);
        Test.stopTest();
    }

    @isTest
    static void testUpdateCaseAndOppStatus_Exception() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Case testCase = new Case(Status = 'Novo pedido', AccountId = testAcc.Id);
        insert testCase;

        testOpp.CloseDate = null;
        testCase.AccountId = 'a0Q00000000XXXXXXX';

        Exception actualException;
        try {
            Test.startTest();
            List<Id> ids = PlacementFollowUpController.updateCaseAndOppStatus(testOpp, testCase);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest(SeeAllData=true)
    static void testCreateQuoteWithLineItems_StatusQuoteSent() {
        Pricebook2 stdPb = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Product2 testProduct2 = new Product2(Name = 'Product Test', IsActive = true, ProductCode = '010101', Family = 'Varejo');
        insert testProduct2;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct2.Id, UnitPrice = 1, Pricebook2Id = stdPb.Id);
        insert testPricebookEntry;

        Quote testQuote = new Quote(Name = 'Test Quote', Status = 'Draft', OpportunityId = testOpp.Id, Integralization__c = false, QuoteRequestDate__c = date.Today());

        List<QuoteLineItem> listItems = new List<QuoteLineItem>();

        QuoteLineItem testLineItem = new QuoteLineItem(Product2Id = testProduct2.Id, PricebookEntryId = testPricebookEntry.Id, UnitPrice = testPricebookEntry.UnitPrice, Quantity = 1);
        listItems.add(testLineItem);

        Exception actualException;
        try {
            Test.startTest();
            Id quoteId = PlacementFollowUpController.createQuoteWithLineItems(testQuote, listItems);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest(SeeAllData=true)
    static void testCreateQuoteWithLineItems_StatusQuoteReceived() {
        Pricebook2 stdPb = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Product2 testProduct2 = new Product2(Name = 'Product Test', IsActive = true, ProductCode = '010101', Family = 'Varejo');
        insert testProduct2;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct2.Id, UnitPrice = 1, Pricebook2Id = stdPb.Id);
        insert testPricebookEntry;

        Quote testQuote = new Quote(Name = 'Test Quote', Status = 'Draft', OpportunityId = testOpp.Id, Integralization__c = false, QuoteRequestDate__c = date.Today(), QuoteReceiptDate__c = date.Today());

        List<QuoteLineItem> listItems = new List<QuoteLineItem>();

        QuoteLineItem testLineItem = new QuoteLineItem(Product2Id = testProduct2.Id, PricebookEntryId = testPricebookEntry.Id, UnitPrice = testPricebookEntry.UnitPrice, Quantity = 1);
        listItems.add(testLineItem);

        Exception actualException;
        try {
            Test.startTest();
            Id quoteId = PlacementFollowUpController.createQuoteWithLineItems(testQuote, listItems);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest(SeeAllData=true)
    static void testUpdateQuote() {
        Pricebook2 stdPb = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Product2 testProduct2 = new Product2(Name = 'Product Test', IsActive = true, ProductCode = '010101', Family = 'Varejo');
        insert testProduct2;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct2.Id, UnitPrice = 1, Pricebook2Id = stdPb.Id);
        insert testPricebookEntry;

        Quote testQuote = new Quote(Name = 'Test Quote', Status = 'Draft', OpportunityId = testOpp.Id, Integralization__c = false, QuoteRequestDate__c = date.Today(), QuoteReceiptDate__c = date.Today());
        insert testQuote;

        List<QuoteLineItem> listItems = new List<QuoteLineItem>();

        QuoteLineItem testLineItem = new QuoteLineItem(Product2Id = testProduct2.Id, PricebookEntryId = testPricebookEntry.Id, UnitPrice = testPricebookEntry.UnitPrice, Quantity = 1);
        listItems.add(testLineItem);

        Test.startTest();
        Id quoteId = PlacementFollowUpController.createQuoteWithLineItems(testQuote, listItems);
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void testUpdateQuote_Exception() {
        Pricebook2 stdPb = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Product2 testProduct2 = new Product2(Name = 'Product Test', IsActive = true, ProductCode = '010101', Family = 'Varejo');
        insert testProduct2;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct2.Id, UnitPrice = 1, Pricebook2Id = stdPb.Id);
        insert testPricebookEntry;

        Quote testQuote = new Quote(Name = 'Test Quote', Status = 'Draft', OpportunityId = testOpp.Id, Integralization__c = false, QuoteRequestDate__c = date.Today(), QuoteReceiptDate__c = date.Today());
        insert testQuote;

        testQuote.OpportunityId = 'a0Q00000000XXXXXXX';

        List<QuoteLineItem> listItems = new List<QuoteLineItem>();

        QuoteLineItem testLineItem = new QuoteLineItem(Product2Id = testProduct2.Id, PricebookEntryId = testPricebookEntry.Id, UnitPrice = testPricebookEntry.UnitPrice, Quantity = 1);
        listItems.add(testLineItem);

        Exception actualException;
        try {
            Test.startTest();
            Id quoteId = PlacementFollowUpController.createQuoteWithLineItems(testQuote, listItems);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }

    @isTest(SeeAllData=true)
    static void testCreateOrderWithLineItems() {
        Pricebook2 stdPb = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;

        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Aberto', CloseDate = Date.today());
        insert testOpp;

        Product2 testProduct2 = new Product2(Name = 'Product Test', IsActive = true, ProductCode = '010101', Family = 'Varejo');
        insert testProduct2;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct2.Id, UnitPrice = 1, Pricebook2Id = stdPb.Id);
        insert testPricebookEntry;

        Order testOrder = new Order(Name = 'Test Order', Status = 'CarriedOut', OpportunityId = testOpp.Id, AccountId = testAcc.Id, EffectiveDate = Date.today(), Company__c = 'Akad Seguros');

        List<OrderItem> listItems = new List<OrderItem>();

        OrderItem testLineItem = new OrderItem(Product2Id = testProduct2.Id, PricebookEntryId = testPricebookEntry.Id, UnitPrice = testPricebookEntry.UnitPrice, Quantity = 1);
        listItems.add(testLineItem);

        Exception actualException;
        try {
            Test.startTest();
            Id orderId = PlacementFollowUpController.createOrderWithLineItems(testOrder, listItems);
            Test.stopTest();
        } catch (AuraHandledException e) {
            actualException = e;
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception type: ' + e);
        }
        System.assertNotEquals(null, actualException, 'An AuraHandledException was expected due to invalid quote name');
    }
}