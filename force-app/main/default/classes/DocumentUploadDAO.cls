public with sharing class DocumentUploadDAO {

    private static final DocumentUploadDAO INSTANCE = new DocumentUploadDAO();
    private static final Map<String, Object> MAP_OBJ_DOCUMENT_UPLOAD = new Map<String, Object>();

    public static DocumentUploadDAO getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(DocumentUpload__c objDocumentUpload : getAllFields(whereCondition)){
            MAP_OBJ_DOCUMENT_UPLOAD.put(objDocumentUpload.Id, objDocumentUpload);
		}
		return MAP_OBJ_DOCUMENT_UPLOAD;
	}

    public List<DocumentUpload__c> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('DocumentUpload__c').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM DocumentUpload__c ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    public List<DocumentUpload__c> getDocumentUploadBySObjectId(String recordId){

        return [SELECT Id,Name,DocumentType__c,DocumentType__r.Name,IdObjeto__c,DocumentTypeExternalId__c
                FROM DocumentUpload__c WHERE IdObjeto__c = :recordId];
    }

    @AuraEnabled(cacheable=true)
    public static List<DocumentUpload__c> getDocumentUploadComponentBySObjectId(String recordId){
        return [SELECT Id,Name,Status__c,ExternalUrl__c,IdentificadorDocumento__c,ReasonRefusal__c,DocumentType__c,DocumentTypeExternalId__c
                FROM DocumentUpload__c WHERE IdObjeto__c = :recordId];
    }

    public List<DocumentUpload__c> getDocumentUploadByListSObjectId(List<String> lstObjectIds){

        return [SELECT Id,Name,Objects__c,IdentificadorDocumento__c,Obrigatorio__c,ContentVersionId__c,IdObjeto__c,Status__c,Path__c,ExternalUrl__c,IsDeleted__c,ExternalReferenceId__c,DocumentType__c,DocumentTypeExternalId__c,FileExtension__c
                FROM DocumentUpload__c
                WHERE IdObjeto__c IN :lstObjectIds];
    }
}