@isTest
public class GetLatestDocumentsTest {

    @isTest
    static void insertDocumentsAfterUpdate(){

        Account acc = AccountDataFactory.insertBusinessAccount();

        Opportunity oppWithDocument = OpportunityDataFactory.createOpportunityCorporateBeneficios();
        oppWithDocument.AccountId = acc.id;
        insert oppWithDocument;

        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateBeneficios();
        opp.AccountId = acc.id;
        insert opp;

        Product2 prod = ProductDataFactory.insertProductAuto();
        DocumentType__c docType = DocumentTypeDataFactory.insertDocumentType('Teste Type', '0123456');
        DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistBeneficios(oppWithDocument.Id);
        
        checklist.DocumentType__c = docType.id;
        update checklist;

        DocumentUpload__c docUpload = new DocumentUpload__c(
            Name = 'Teste type.txt',
            Objects__c = 'Opportunity',
            DocumentType__c = docType.id,
            ExternalUrl__c = 'https://wizcorphml001.blob.core.windows.net/documentos/b32b4e3661ba.docx',
            IdObjeto__c = oppWithDocument.id,
            IsDeleted__c = false,
            Status__c = 'Accepted'
        );
        insert docUpload;

        // Cria um Pricebook padrão
        ID standardPBID = Test.getStandardPricebookId();

        // Adiciona um preço padrão para o produto no Pricebook padrão
        PricebookEntry standardPBE = new PricebookEntry(
            Pricebook2Id = standardPBID,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPBE;
        
        Pricebook2 pb = new Pricebook2(
          Name = 'Test Pricebook',
          IsActive = true
        );
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(
           Pricebook2Id = pb.Id,
           Product2Id = prod.Id,
           UnitPrice = 100,
           IsActive = true
       );
       insert pbe;

        Test.startTest();
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            TotalPrice = 100
        );
        insert oli;
        Test.stopTest();

        List<DocumentUpload__c> docs = [SELECT id, IdObjeto__c FROM DocumentUpload__c];
        Assert.isTrue(docs.size() > 1, 'A lista precisa conter mais que um documento upado para demonstrar que a trigger funcionou.');
    }
    
}