/**
 * @description       :
 * @author            : marcelomartins@gwizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@gwizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                    Modification
 * 1.0   11-25-2021   marcelomartins@gwizsolucoes.com.br        Initial Version
 **/
@isTest
public class DocumentTypeDataFactory {    
    
    public static DocumentType__c createDocumentType(String documentTypeName, String externalId){
        DocumentType__c objDocType = new DocumentType__c();
        objDocType.Name = DocumentTypeName;
        objDocType.ExternalReferenceId__c = externalId;
        return objDocType;
    }

    public static DocumentType__c insertDocumentType(String documentTypeName, String externalId){
        DocumentType__c objDocType = createDocumentType(DocumentTypeName, externalId);
        insert objDocType;
        return objDocType;
    }
}