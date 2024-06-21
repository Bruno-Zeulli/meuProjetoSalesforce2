/**
* @description       :
* @author            :italosilva.mirante@wiz.co
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : italosilva.mirante@wiz.co
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-12-2024   italosilva.mirante@wiz.co   Initial Version
**/
@isTest
public class DocumentUploadDAOTest {
    @testSetup
    static void setup(){

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
    }
    
	@isTest
    public static void getDocumentUploadComponentBySObjectIdTest(){
        DocumentUpload__c doc = [SELECT Id FROM DocumentUpload__c WHERE ExternalReferenceId__c = '12345'];
        DocumentUploadDAO.getDocumentUploadComponentBySObjectId(doc.Id);
    }
}