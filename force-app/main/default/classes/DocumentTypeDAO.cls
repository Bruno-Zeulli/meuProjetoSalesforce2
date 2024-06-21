/**
 * @description       : 
 * @author            : samuelsirkis@wiz.co
 * @group             : 
 * @last modified on  : 09-22-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
public without sharing class DocumentTypeDAO {
    public static Map<Id, DocumentType__c> getMapAllDocumentType(){
        Map<Id, DocumentType__c> mapDocumentTypeById = new Map<Id, DocumentType__c>();
        for(DocumentType__c objDocumentType  : [SELECT Id,OwnerId,IsDeleted,Name,ExternalReferenceId__c FROM DocumentType__c]){
            mapDocumentTypeById.put(objDocumentType.Id, objDocumentType);
        }
        return mapDocumentTypeById;
    }
}