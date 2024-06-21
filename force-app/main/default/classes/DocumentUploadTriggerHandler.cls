public with sharing class DocumentUploadTriggerHandler {

    private boolean isExecuting = false;
    public List<DocumentUpload__c> oldRecordsList = null;
    public List<DocumentUpload__c> newRecordsList = null;
    public Map<Id,DocumentUpload__c> oldRecordsMap = null;
    public Map<Id,DocumentUpload__c> newRecordsMap = null;


    public DocumentUploadTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }


    public void onAfterInsert(){
        verifyAndChangeURLBlip(JSON.serialize(this.newRecordsList));
    }

    public void onAfterUpdate(){
        createTaskDocRefused();
    }

    public void createTaskDocRefused(){

        Map<Id, DocumentUpload__c> mapDocUploadRefused = new Map<Id, DocumentUpload__c>() ;

        for(DocumentUpload__c objDocUpload : newRecordsList){
            if(objDocUpload.Status__c == 'Refused'){
                mapDocUploadRefused.put(objDocUpload.Id, objDocUpload);
            }
        }

        List<DocumentUpload__c> lstDocUploadRefused = mapDocUploadRefused.values();

        if(!lstDocUploadRefused.isEmpty()){
            DocumentUploadBO.getInstance().createTaskDocPending(lstDocUploadRefused);
        }
    }

    public static void verifyAndChangeURLBlip(String lstUploadDocumentStrings){

        List<DocumentUpload__c> lstDocumentUpload = (List<DocumentUpload__c>) JSON.deserialize(lstUploadDocumentStrings, List<DocumentUpload__c>.class);
        List<DocumentUpload__c> lstDocumentUploadWithUrlBlip = new List<DocumentUpload__c>();
        List<User> lstUsuario = [SELECT Id FROM User WHERE Name = 'Integrador Blip'];

        if(lstUsuario.size() > 0){
            for(DocumentUpload__c documentUpload : lstDocumentUpload){
                if(documentUpload.ownerId == lstUsuario.get(0).Id){
                    lstDocumentUploadWithUrlBlip.add(documentUpload);
                }
            }

            if(lstDocumentUploadWithUrlBlip.size() > 0){
                FileDownLoadUtility.alterarURLTemporariaBlip(lstDocumentUploadWithUrlBlip.get(0).IdObjeto__c);
            }
        }

    }
}