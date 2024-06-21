/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-22-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-22-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class DocumentChecklistDataFactory {

    public static DocumentChecklist__c createDocumentChecklist(Id recordId){
        String objType = String.valueOf(Id.valueOf(recordId).getsobjecttype());

        DocumentChecklist__c docChecklist = new DocumentChecklist__c(
            IsActive__c = true,
            Object__c = 'Opportunity',
            DocumentRequirement__c = true,
            ObjectRecordType__c = 'CorporateComercial',
            ObjectTypeValue__c  = 'new'
        );
        
        return docChecklist;
    }

    public static DocumentChecklist__c createDocumentChecklistBeneficios(Id recordId){
        String objType = String.valueOf(Id.valueOf(recordId).getsobjecttype());

        DocumentChecklist__c docChecklist = new DocumentChecklist__c(
            IsActive__c = true,
            Object__c = 'Opportunity',
            DocumentRequirement__c = true,
            ObjectRecordType__c = 'CorporateBeneficios',
            ObjectTypeValue__c  = 'new'
        );
        
        return docChecklist;
    }

    public static DocumentChecklist__c insertDocumentChecklist(Id recordId){
        DocumentChecklist__c docChecklist = createDocumentChecklist(recordId);
        insert docChecklist;
        return docChecklist;
    }

    public static DocumentChecklist__c insertDocumentChecklistBeneficios(Id recordId){
        DocumentChecklist__c docChecklist = createDocumentChecklistBeneficios(recordId);
        insert docChecklist;
        return docChecklist;
    }

    public static DocumentChecklist__c createDocumentChecklistDynamic(Id recordId, Boolean required, String recordType, String type){
        String objType = String.valueOf(Id.valueOf(recordId).getsobjecttype());

        DocumentChecklist__c docChecklist = new DocumentChecklist__c(
            IsActive__c = true,
            Object__c = objType,
            DocumentRequirement__c = required,
            ObjectRecordType__c = recordType
        );

        if(type!=''){
            docChecklist.ObjectTypeValue__c  = type;
        }
        
        return docChecklist;
    }

    public static DocumentChecklist__c insertDocumentChecklistDynamic(Id recordId, Boolean required, String recordType, String type){
        DocumentChecklist__c docChecklist = createDocumentChecklistDynamic(recordId, required, recordType, type);
        insert docChecklist;
        return docChecklist;
    }
}