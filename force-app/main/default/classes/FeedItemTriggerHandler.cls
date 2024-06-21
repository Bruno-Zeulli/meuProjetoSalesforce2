/**
 * @description       :
 * @author            : Bruno Pereira (Mirante)
 * @group             :
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   24-01-2022   Bruno Pereira (Mirante)              Initial Version
 * 1.1   09-06-2022   Rafael Henrique             Update call API Document
 **/
public without sharing class FeedItemTriggerHandler {
    private boolean isExecuting = false;
    public List<FeedItem> oldRecordsList = null;
    public List<FeedItem> newRecordsList = null;
    public Map<Id, FeedItem> oldRecordsMap = null;
    public Map<Id, FeedItem> newRecordsMap = null;

    private String CONTENT_POST_TYPE = 'ContentPost';

    public FeedItemTriggerHandler(Boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert(){
        System.debug('Trigger After Insert FeedItem');
        if(!System.isBatch() && !System.isFuture()){
            sendFilesOfFeedItem(JSON.serialize(this.newRecordsList));        
        }      
    }

    public void onBeforeUpdate(){
        System.debug('Trigger Before Update FeedItem');
        updateVisibilityFeedItem();
        
    }

    public void onBeforeInsert(){
        System.debug('Trigger Before Insert FeedItem');
        updateVisibilityFeedItem();
    }

    public static string PARCEIROS_PROFILE = [SELECT Id FROM Profile WHERE Name = 'Integrador - PARCEIROS'].Id;

    private void updateVisibilityFeedItem()
    {
        System.debug('CHAMOU O METODO');
        System.debug('LISTA DE FEED ITEM: '+newRecordsList);

        for(FeedItem fi : newRecordsList)
        {
            System.debug('FEED ITEM TYPE: '+fi.Type);
            if(fi.Type == 'TextPost' || fi.Type == 'ContentPost' || fi.Type == 'MilestoneEvent' || fi.Type == 'EmailMessageEvent' || fi.Type == 'ChangeStatusPost')
            {
                System.debug('FEED ITEM VISIBILITY ANTES: '+fi.Visibility);
                fi.Visibility = 'AllUsers';
                System.debug('FEED ITEM VISIBILITY DEPOIS: '+fi.Visibility);
            }
        }
    }

    public static void updateStatusParceiros(List<FeedItem> triggerNew){
        List<Case> updates = new List<Case>();
        Set<Id> caseSet = new Set<Id>();
        Map<Id, String> caseMap = new Map<Id, String>();
        Map<Id, String> caseStatusValue = new Map<Id, String>();

        Id profileId;
        if(!Test.isRunningTest()){
            profileId = UserInfo.getProfileId();
        }else{
            profileId = PARCEIROS_PROFILE;
        }
        for(FeedItem feedItemToIteration : triggerNew){
            caseSet.add(feedItemToIteration.ParentId);
        }

        List<Case> lCaseToVerify = [SELECT Id, OwnerId, Status FROM Case WHERE Id = :caseSet];

        for(Case iLstCase : lCaseToVerify){
            caseMap.put(iLstCase.Id, iLstCase.OwnerId);
            caseStatusValue.put(iLstCase.Id, iLstCase.Status);
        }

        for(FeedItem iFeedItem : triggerNew){
            if(iFeedItem.ParentId.getSObjectType() == Case.SObjectType &&
                    profileId == PARCEIROS_PROFILE && (
                        caseStatusValue.get(iFeedItem.ParentId) == 'Em atendimento' ||
                        caseStatusValue.get(iFeedItem.ParentId) == 'Aguardando solicitante' ||
                        caseStatusValue.get(iFeedItem.ParentId) == 'Aguardando atendimento externo' ||
                        caseStatusValue.get(iFeedItem.ParentId) == 'Reaberto pelo solicitante'
                    )
                ){

                updates.add(new Case(Id = iFeedItem.ParentId, Status = 'Alterado pelo solicitante', DataAtualizacaoFeedItem__c = Date.Today()));
            }
            else if(iFeedItem.ParentId.getSObjectType() == Case.SObjectType && UserInfo.getUserId() == caseMap.get(iFeedItem.ParentId) && iFeedItem.Type == 'ContentPost' && iFeedItem.IsRichText == true){
                updates.add(new Case(Id = iFeedItem.ParentId, Status = 'Aguardando solicitante', DataAtualizacaoFeedItem__c = Date.Today()));
            }else if(iFeedItem.ParentId.getSObjectType() == Case.SObjectType && UserInfo.getUserId() == caseMap.get(iFeedItem.ParentId) && iFeedItem.IsRichText == true && iFeedItem.RelatedRecordId == null){
                updates.add(new Case(Id = iFeedItem.ParentId, Status = 'Aguardando solicitante', DataAtualizacaoFeedItem__c = Date.Today()));
            }
        }
        update updates;
    }



    @future(callout=true)
    public static void sendFilesOfFeedItem(String newRecordsListStr){
        Set<Id> setFeedItemsId = new Set<Id>();
        List<FeedItem> newRecordsList = (List<FeedItem>) JSON.deserialize(newRecordsListStr, List<FeedItem>.class);

        for(FeedItem item : newRecordsList){
            setFeedItemsId.add(item.Id);
        }

        List<FeedAttachment> filesOfFeed = [SELECT Id, FeedEntityId, RecordId FROM FeedAttachment WHERE FeedEntityId IN :setFeedItemsId];
        System.debug('filesOfFeed ==>' + filesOfFeed);

        if(filesOfFeed.size() > 0){



            List<DocumentUpload__c> lstDocUpload = new List<DocumentUpload__c>();
            DocumentType__c tipoDocumento = [SELECT Id, ExternalReferenceId__c FROM DocumentType__c WHERE Name = 'Material Digital' LIMIT 1];

              Map<Id, List<Id>> mapFilesIdByFeedItem = mapFilesByFeedItemID(filesOfFeed);


            String initContentDocument = '069';
            Set<Id> setDocumentsIds = new Set<Id>();
            Set<Id> setContentVersionIds = new Set<Id>();


            System.debug('mapFilesIdByFeedItem ==>'+mapFilesIdByFeedItem);
            for(FeedItem item : newRecordsList){
                List<Id> documentsId = mapFilesIdByFeedItem.get(item.Id);

                if(documentsId != null){
                    System.debug(documentsId);
                       for(Id documentId: documentsId){
                            DocumentUpload__c docUpload = createDocumentUpload(item, tipoDocumento);


                            if(String.valueOf(documentId).contains(initContentDocument)){
                                docUpload.IdentificadorDocumento__c = documentId;
                                setDocumentsIds.add(documentId);
                            }else{
                                docUpload.ContentVersionId__c = documentId;
                                setContentVersionIds.add(documentId);
                            }

                            lstDocUpload.add(docUpload);
                        }
                }

            }

            if(lstDocUpload.size() > 0){
                 Map<String, Map<Id, ContentVersion>> mapContentVersions = mapContentVersionsWithParameter(setDocumentsIds, setContentVersionIds);

                Map<Id, ContentVersion> mapContentVersionIdByContentDocument = mapContentVersions.get('mapContentVersionIdByContentDocument');
                Map<Id, ContentVersion> mapContentVersionIdById = mapContentVersions.get('mapContentVersionIdById');

                List<DocumentUpload__c> lstDocUploadFinish = new List<DocumentUpload__c>();

                for(DocumentUpload__c docUpload : lstDocUpload){
                    ContentVersion content = null;

                    if(docUpload.IdentificadorDocumento__c != null){
                        content = mapContentVersionIdByContentDocument.get(docUpload.IdentificadorDocumento__c);
                    }else if(docUpload.ContentVersionId__c != null){
                        content = mapContentVersionIdById.get(docUpload.ContentVersionId__c);
                    }

                    if(content != null){
                        docUpload.ContentVersionId__c = content.Id;
                        docUpload.Name = content.Title;
                        lstDocUploadFinish.add(docUpload);
                    }
                }

                System.debug('lstDocUploadFinish=>');
                System.debug(lstDocUploadFinish);

                insert lstDocUploadFinish;
           }
        }
    }

    public static DocumentUpload__c createDocumentUpload(FeedItem feedItem, DocumentType__c tipoDocumento){
          DocumentUpload__c docUpload = new DocumentUpload__c();

                Id idObjeto = feedItem.ParentId;
                docUpload.Objects__c = String.valueOf(idObjeto.getsobjecttype());
                docUpload.IdObjeto__c = idObjeto;
                docUpload.Status__c = 'Pending';

                docUpload.DocumentType__c = tipoDocumento.Id;

           return docUpload;
    }

    public static Map<Id, List<Id>> mapFilesByFeedItemID(List<FeedAttachment> filesOfFeed){
             Map<Id, List<Id>> mapFilesIdByFeedItem = new Map<Id, List<Id>>();

            for(FeedAttachment fileFeed : filesOfFeed){
                List<Id> filesId = new  List<Id>();

                if(mapFilesIdByFeedItem.get(fileFeed.FeedEntityId) != null){
                   filesId = mapFilesIdByFeedItem.get(fileFeed.FeedEntityId);
                    filesId.add(fileFeed.RecordId);
                }else{
                    filesId.add(fileFeed.RecordId);
                }

                mapFilesIdByFeedItem.put(fileFeed.FeedEntityId, filesId);
            }

            return mapFilesIdByFeedItem;
    }

    public static Map<String, Map<Id, ContentVersion>> mapContentVersionsWithParameter(Set<Id> setDocumentsIds, Set<Id> setContentVersionIds){
            List<ContentVersion> listDocsByDocumentIds = [
                    SELECT Id, ContentDocumentId, IsDeleted, Title, FirstPublishLocationId, VersionData
                    FROM ContentVersion
                    WHERE IsDeleted = FALSE AND ContentDocumentId IN :setDocumentsIds
                ];

                List<ContentVersion> listDocsByContentDocumentId = [
                    SELECT Id, ContentDocumentId, IsDeleted, Title, FirstPublishLocationId, VersionData
                    FROM ContentVersion
                    WHERE IsDeleted = FALSE AND Id IN :setContentVersionIds
                ];

                Map<Id, ContentVersion> mapContentVersionIdByContentDocument = new Map<Id, ContentVersion>();
                Map<Id, ContentVersion> mapContentVersionIdById = new Map<Id, ContentVersion>();

                for(ContentVersion conVersion : listDocsByDocumentIds){
                    mapContentVersionIdByContentDocument.put(conVersion.ContentDocumentId, conVersion);
                }

                for(ContentVersion conVersion : listDocsByContentDocumentId){
                    mapContentVersionIdById.put(conVersion.Id, conVersion);
                }

                Map<String, Map<Id, ContentVersion>> mapContentVersions = new Map<String, Map<Id, ContentVersion>>();

                mapContentVersions.put('mapContentVersionIdByContentDocument', mapContentVersionIdByContentDocument);
                mapContentVersions.put('mapContentVersionIdById', mapContentVersionIdById);

                return mapContentVersions;

    }

    //REGRA FINALIZAÇÃO DOS MARCOS
    public static void completeMilestoneTickets(List<FeedItem> triggerNew){
        List<Id> updatePrimeiraResposta = new List<Id>();
        DateTime completionDate = System.now();
        Set<Id> feedItemIdSet = new Set<Id>();
        Set<Id> caseIdSet = new Set<Id>();

        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(FeedItem iFeed : triggerNew){
            feedItemIdSet.add(iFeed.Id);
            caseIdSet.add(iFeed.ParentId);
        }

        List<FeedItem> lstFeedItem = new List<FeedItem>();
        if(!Test.isRunningTest()){
            lstFeedItem = [SELECT Id, InsertedBy.Profile.Name, Type, InsertedById, ParentId, Parent.RecordTypeId FROM FeedItem WHERE Id IN : feedItemIdSet];
        }
    	
        List<Case> caseToCheck = [SELECT Id FROM Case WHERE Id IN : caseIdSet];
        if(!caseToCheck.isEmpty()){
            for(FeedItem iFi : lstFeedItem){
                if(rt_map.get(iFi.Parent.RecordTypeId)?.getDeveloperName().contains('_Tkt') && (iFi.Type == 'TextPost' || iFi.Type == 'EmailMessageEvent' || iFi.Type == 'ContentPost' || iFi.Type == 'LinkPost') && !iFi.InsertedBy.Profile.Name.contains('Admin') && !iFi.InsertedBy.Profile.Name.contains('Integra')){
                    updatePrimeiraResposta.add(iFi.ParentId);
                }
            }
        }
        
        if(updatePrimeiraResposta != null){
            milestoneUtils.completeMilestone(updatePrimeiraResposta, 'Tempo de primeira resposta', completionDate);
        }
    }
}