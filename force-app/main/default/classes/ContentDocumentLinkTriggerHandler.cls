public class ContentDocumentLinkTriggerHandler {

    static final Id RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoMovimentaoPremio').getRecordTypeId();
    static final Id RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoNeutro').getRecordTypeId();
    static final Id RECORDTYPE_ENDOSSO_WGARANTIA = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Endosso_WGarantia').getRecordTypeId();

    public List<ContentDocumentLink> oldRecordsList = null;
    public List<ContentDocumentLink> newRecordsList = null;
    public Map<Id, ContentDocumentLink> oldRecordsMap = null;
    public Map<Id, ContentDocumentLink> newRecordsMap = null;

    public void onAfterInsert(){
        updateVisibility();  
        linkToParentOrderOnAfterInsert();
    }

    public void onAfterUpdate(){
    }

    public void onBeforeInsert(){
    }

    public void updateVisibility(){

        Set<Id> cdlIdSet = new Set<Id>();
        List<ContentDocumentLink> cdlToUpdate = new List<ContentDocumentLink>();

        for (ContentDocumentLink newDocument : newRecordsList) {
            cdlIdSet.add(newDocument.Id);
        }

        List<ContentDocumentLink> cdlLst = [SELECT Id, Visibility, LinkedEntity.Type FROM ContentDocumentLink WHERE Id IN : cdlIdSet];

        for (ContentDocumentLink newDocument : cdlLst){
            if(newDocument.LinkedEntity.Type == 'Order'){
                newDocument.Visibility = 'AllUsers';        
            }
            cdlToUpdate.add(newDocument);
        }

        update cdlToUpdate;
    }

    public void linkToParentOrderOnAfterInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            Set<Id> cdlIdSet = new Set<Id>();

            List<Id> listRecordTypeIds = getListRecordTypeIdsEndosso();

            for(ContentDocumentLink newDocument : newRecordsList) {
                if(String.valueOf(newDocument.LinkedEntityId).startsWith('801')){
                    cdlIdSet.add(newDocument.LinkedEntityId);
                }
            }

            Map<Id,Order> mapChildToParent = new Map<Id,Order>([SELECT Id, ParentId__c FROM Order WHERE ParentId__c!=NULL AND Id IN :cdlIdSet AND RecordTypeId IN :listRecordTypeIds]);
            List<ContentDocumentLink> listToInsert = new List<ContentDocumentLink>();

            for(ContentDocumentLink newDocument : newRecordsList) {
                if(mapChildToParent.containsKey(newDocument.LinkedEntityId)){
                    ContentDocumentLink cdlToAdd = new ContentDocumentLink();
                    cdlToAdd.LinkedEntityId = mapChildToParent.get(newDocument.LinkedEntityId).ParentId__c;
                    cdlToAdd.ContentDocumentId = newDocument.ContentDocumentId;
                    listToInsert.add(cdlToAdd);
                }
            }

            if(!listToInsert.isEmpty()){
                insert listToInsert;
            }
        }
    }

    private List<Id> getListRecordTypeIdsEndosso(){
        List<Id> listToReturn = new List<Id>();
        listToReturn.add(RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO);
        listToReturn.add(RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO);
        listToReturn.add(RECORDTYPE_ENDOSSO_WGARANTIA);
        return listToReturn;
    }
}