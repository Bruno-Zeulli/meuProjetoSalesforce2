@isTest
public class DocusignCalloutTest {
    public static String cronEXP = '0 0 5 3 9 ? 2030';

    static void makeData(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ExternalAPI__c docusign = new ExternalAPI__c(
            Name = 'DocusignWiz',
            ClientID__c = '987'
        );
        insert docusign;
        
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        Id pbId = Test.getStandardPricebookId();
        Product2 product = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista');
        insert product;
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        opp.AccountId = acc.Id;
        opp.Envelope_Id_CN__c = '123';
        insert opp;

        DocumentType__c docType = new DocumentType__c();
        docType.ExternalReferenceId__c = '1';
        docType.Name = 'Carta de Nomeação';
        insert docType;
    }

    @isTest
    static void testImplementationSchedule(){
        
        Test.startTest();
        DocusignCalloutSchedule.schedule();
        String jobId = System.schedule('ScheduledApexTest', cronEXP, new DocusignCalloutSchedule());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2030');
        System.assertEquals('2030-09-03 05:00:00', String.valueOf(ct.NextFireTime), 'NextFireTime of Scheduling other than 2030-09-03 05:00:00');
    }

    @isTest
    static void testImplementationBatch(){
        makeData();
        HttpCalloutMock mock = new MockWebserviceCallsTest.MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        Id batchId = Database.executeBatch(new DocusignCalloutBatch(),40);
        Test.stopTest();
        
        List<DocumentUpload__c> docs = [SELECT Id FROM DocumentUpload__c];
        Assert.areEqual(1,docs.size(),'Era esperada a inserção do registro');
    }

    @isTest
    static void testImplementationBatchCatch(){
        makeData();
        DocumentType__c docT = [SELECT Id from DocumentType__c limit 1];
        List<DocumentUpload__c> listDoc = new List<DocumentUpload__c>();
        DocumentUpload__c docUploadToAdd = new DocumentUpload__c();
        docUploadToAdd.Status__c = 'UnderReview'; 
        docUploadToAdd.ExternalUrl__c = 'teste';
        docUploadToAdd.Objects__c = 'Opportunity';
        docUploadToAdd.DocumentType__c = docT.Id;
        docUploadToAdd.Name = 'Carta de Nomeação';
        listDoc.add(docUploadToAdd);
        
        Test.startTest();
        DocusignCallout.insertDocAndUpdateOpp(listDoc);
        Test.stopTest();

        List<DocumentUpload__c> docs = [SELECT Id FROM DocumentUpload__c];
        Assert.areEqual(true,docs.isEmpty(),'Não era esperada a inserção do registro');

    }
}