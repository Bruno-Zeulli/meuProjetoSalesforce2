public without sharing class GetLatestDocuments {
    
    public static void createDocuments(List<Id> opportunitiesIds){
        
        List<Opportunity> receivedOpportunities = [SELECT id, AccountId, RecordTypeId, (SELECT Product2Id, ProductCode FROM OpportunityLineItems) FROM Opportunity WHERE Id IN :opportunitiesIds];
        List<DocumentChecklist__c> lstDocumentsChecklist = [SELECT Id, IsActive__c, DocumentRequirement__c, DocumentType__r.Name, Object__c, ObjectTypeValue__c, ObjectRecordType__c, ComplementaryParameter__c FROM DocumentChecklist__c WHERE Object__c = 'Opportunity' AND IsActive__c = true];

        
        Set<Id> recordTypesReceivedOpps = new Set<Id>();
        Set<Id> lstIdDocumentTypes = new Set<Id>();
        Set<Id> lstAccountIds = new Set<Id>();
        Map<Id,List<DocumentChecklist__c>> checklists = new Map<Id,List<DocumentChecklist__c>>();
        List<DocumentUpload__c> lstDocumentsToUpdate = new List<DocumentUpload__c>();

        for (Opportunity currentOpportunity : receivedOpportunities) {
            List<DocumentChecklist__c> listDocumentChecklist = new List<DocumentChecklist__c>();
            String productCode;
            for (OpportunityLineItem lineItem : currentOpportunity.OpportunityLineItems) {
                productCode = lineItem.ProductCode;
            }
            for (DocumentChecklist__c doc : lstDocumentsChecklist) {
                String recordTypeDevelopName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get((String)(currentOpportunity.RecordTypeId)).getDeveloperName();
                if (doc.ObjectRecordType__c == recordTypeDevelopName && (doc.ComplementaryParameter__c == productCode || doc.ComplementaryParameter__c == null)) {
                    listDocumentChecklist.add(doc);
                }
            }
            checklists.put(currentOpportunity.Id, listDocumentChecklist);   
            lstAccountIds.add(currentOpportunity.AccountId);
            recordTypesReceivedOpps.add(currentOpportunity.RecordTypeId);
            
        }

        List<Opportunity> opportunitiesList = [SELECT id FROM Opportunity WHERE AccountId IN :lstAccountIds AND RecordTypeId IN :recordTypesReceivedOpps AND AccountId != NULL ORDER BY CreatedDate DESC LIMIT 300];
        Set<Id> lstOpportunitiesIds = new Set<Id>();

        if(!opportunitiesList.isEmpty()){
            for (Opportunity currentOpportunity : opportunitiesList) {
                lstOpportunitiesIds.add(currentOpportunity.id);
            }
        }

        if(!checklists.isEmpty()){
            for (Id keyMap : checklists.keySet()) {
                List<DocumentChecklist__c> lstDocumentChecklist = checklists.get(keyMap);
                for (DocumentChecklist__c currentDocumentChecklist : lstDocumentChecklist) {
                    lstIdDocumentTypes.add(currentDocumentChecklist.DocumentType__c);                  
                }
            }
        }

        
        
        List<DocumentUpload__c > documentUploadList = [
            SELECT id, Name, DocumentType__c, IdObjeto__c, Path__c, Actions__c, DocumentTypeExternalId__c, ExternalReferenceId__c, ExternalUrl__c, Status__c, Obrigatorio__c, IdentificadorDocumento__c, CreatedDate
            FROM DocumentUpload__c 
            WHERE DocumentType__c IN :lstIdDocumentTypes AND IdObjeto__c = :lstOpportunitiesIds 
            ORDER BY DocumentType__c, CreatedDate DESC
        ];

        Map<Id, DocumentUpload__c> mostRecentDocumentUploadRecordMap = new Map<Id, DocumentUpload__c>();

        if(!documentUploadList.isEmpty()){
            
            for(DocumentUpload__c record : documentUploadList) {
                if(!mostRecentDocumentUploadRecordMap.containsKey(record.DocumentType__c)) {
                    mostRecentDocumentUploadRecordMap.put(record.DocumentType__c, record);
                }
            }
        }

        if (!mostRecentDocumentUploadRecordMap.isEmpty()) {
            
            for (Id keyMap : mostRecentDocumentUploadRecordMap.keySet()) {
                for (Opportunity currentOpportunity : receivedOpportunities) {
                    
                    DocumentUpload__c doc = mostRecentDocumentUploadRecordMap.get(keyMap);
                    DocumentUpload__c documentToInsert = new DocumentUpload__c(
                        IdObjeto__c = currentOpportunity.Id,
                        Name = doc.Name,
                        Objects__c = 'Opportunity',
                        DocumentType__c = doc.DocumentType__c,
                        ExternalUrl__c = doc.ExternalUrl__c,
                        Obrigatorio__c = doc.Obrigatorio__c,
                        Status__c = doc.Status__c
                        );
                        
                        lstDocumentsToUpdate.add(documentToInsert);
                }
            }
        }

        insert lstDocumentsToUpdate;
    }

}