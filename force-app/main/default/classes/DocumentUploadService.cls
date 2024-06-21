/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class DocumentUploadService {
    private static final Map<String, Object> MAP_OBJ_ACCOUNT = new Map<String, Object>();
    private static final Map<String, Object> MAP_OBJ_RELATED = new Map<String, Object>();

    @future(callout=true)
    public static void getFileByFileId(String fileId){
        String msgErrorSubject = 'Error ao atualizar o DocumentUpload';
        List<DocumentUpload__c> lstDocUpd = new List<DocumentUpload__c>();

        String whereCondition = ' WHERE Id = \'' + fileId + '\'';
        List<DocumentUpload__c> lstDocumentUpload = DocumentUploadDAO.getInstance().getAllFields(whereCondition);

        for(DocumentUpload__c objDocumentUpload : lstDocumentUpload){
            Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().getFileByFileId(objDocumentUpload.ExternalReferenceId__c);

            System.debug('MAP Return : ' + mapReturnJson);
            if(mapReturnJson.containsKey('Retorno')){
                DocumentTO.DocumentGetResponse documentGetResponse = (DocumentTO.DocumentGetResponse) (JSON.deserialize(
                    (String) mapReturnJson.get('Retorno'),
                    DocumentTO.DocumentGetResponse.class
                ));

                lstDocUpd.add(new DocumentUpload__c(Id = fileId, ExternalUrl__c = documentGetResponse.urlBlob));
            }
        }

        if(!lstDocUpd.isEmpty()){
            Savepoint sp = Database.setSavepoint();

             try{
                Database.SaveResult[] srListFiles = Database.update(lstDocUpd, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstDocUpd);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    @future(callout=true)
    public static void postFile(String objectId){
        Map<String, ContentVersion> mapContentVersion = new Map<String, ContentVersion>();
        List<DocumentUpload__c> lstDocUpd = new List<DocumentUpload__c>();
        List<DocumentUpload__c> lstDocUploadSendAPI = new List<DocumentUpload__c>();
        List<DocumentTO.Pessoa> lstPessoa = new List<DocumentTO.Pessoa>();
        Set<Id> setcontentVersionIds = new Set<Id>();
        String msgErrorSubject = 'Error ao atualizar DocumentUpload após o Post API Docs';
        String whereCondition = ' WHERE IdObjeto__c = \'' + objectId + '\'' + ' AND ExternalReferenceId__c = null AND ContentVersionId__c != null ';

        String path = createPath(objectId);
        System.debug('path ==>' + path);
        lstpessoa.add(createPerson(objectId, path));
        System.debug('lstpessoa ==>' + lstpessoa);

        List<DocumentUpload__c> lstDocumentUpload = DocumentUploadDAO.getInstance().getAllFields(whereCondition);
        for(DocumentUpload__c docUpload : lstDocumentUpload){
            if(docUpload.ContentVersionId__c != null && docUpload.ExternalReferenceId__c == null){
                setcontentVersionIds.add(docUpload.ContentVersionId__c);
                lstDocUploadSendAPI.add(docUpload);
            }
        }

        for(ContentVersion conVersion : [SELECT Id, VersionData, FileExtension, PathOnClient FROM ContentVersion WHERE Id IN :setcontentVersionIds]){
            mapContentVersion.put(conVersion.Id, conVersion);
        }

        Map<String, Map<String, String>> mapMimeTypeAndFileExtensionByContentId = getExtensionFile(setcontentVersionIds);

        System.debug('ENTREIImapContentVersion ==' + mapContentVersion);

        for(DocumentUpload__c docUpload : lstDocUploadSendAPI){
            if(!Test.isRunningTest()){
                      ContentVersion conVersion = mapContentVersion.get(docUpload.ContentVersionId__c);

                        Blob form64 = createBodyBlob(path, lstpessoa, docUpload.DocumentTypeExternalId__c, ConVersion, mapMimeTypeAndFileExtensionByContentId);

                        Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().postFile(form64);

                        System.debug('MAP Return : ' + mapReturnJson);
                        if(mapReturnJson.containsKey('Retorno')){
                            DocumentTO.DocumentPostResponseTO documentResponseTO = (DocumentTO.DocumentPostResponseTO) (JSON.deserialize(
                                (String) mapReturnJson.get('Retorno'),
                                DocumentTO.DocumentPostResponseTO.class
                            ));
                            System.debug('@@@ documentResponseTO : ' + documentResponseTO);

                            lstDocUpd.add(
                                new DocumentUpload__c(
                                    Id = docUpload.Id,
                                    ExternalReferenceId__c = documentResponseTO.idArquivo,
                                    Path__c = path,
                                    Status__c = 'UnderReview',
                                    ExternalUrl__c = documentResponseTO.Pessoa[0].desCaminho,
                                    FileExtension__c = conVersion.FileExtension
                            )
                            );
                        }
            }

        }

        if(!lstDocUpd.isEmpty()){
            Savepoint sp = Database.setSavepoint();

             try{
                Database.SaveResult[] srListFiles = Database.update(lstDocUpd, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstDocUpd);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
     }

     public static Boolean isOpportunityOFCorporate(String recordId){
        String objeto = String.valueOf(Id.valueOf(recordId).getsobjecttype());

        if(objeto == 'Opportunity'){

            String nameCorporateComercial = 'CorporateComercial';
            String nameCorporateLicitacao = 'CorporateLicitacao';
            String nameCorporateMCMV = 'CorporateMCMV';
            String nameCorporateCBIC = 'CorporateCBIC';

            Id oppRecordTypeCorporateComercial = [SELECT Id FROM RecordType WHERE DeveloperName = :nameCorporateComercial AND SobjectType = 'Opportunity' LIMIT 1].Id;
            Id oppRecordTypeCorporateLicitacao = [SELECT Id FROM RecordType WHERE DeveloperName = :nameCorporateLicitacao AND SobjectType = 'Opportunity' LIMIT 1].Id;
            Id oppRecordTypeCorporateMCMV = [SELECT Id FROM RecordType WHERE DeveloperName = :nameCorporateMCMV AND SobjectType = 'Opportunity' LIMIT 1].Id;
            Id oppRecordTypeCorporateCBIC = [SELECT Id FROM RecordType WHERE DeveloperName = :nameCorporateCBIC AND SobjectType = 'Opportunity' LIMIT 1].Id;


            Set<Id> setIdsOpportunities = new Set<Id>();
            setIdsOpportunities.add(Id.valueOf(recordId));

            List<Opportunity> lstOpportunity = OpportunityDAO.getInstance().getOpportunitiesByIds(setIdsOpportunities);

            Opportunity opportunity = lstOpportunity.get(0);

                    if(
                        (opportunity.RecordTypeId == oppRecordTypeCorporateComercial ||
                        opportunity.RecordTypeId == oppRecordTypeCorporateLicitacao ||
                        opportunity.RecordTypeId == oppRecordTypeCorporateMCMV ||
                        opportunity.RecordTypeId == oppRecordTypeCorporateCBIC)
                        && opportunity.ExternalReferenceId__c != null
                    ){
                            return true;
                    }

             return false;

        }else{
            return false;
        }

     }

    public static void postDocumentSave(List<DocumentUpload__c> lstDocumentUpload){
        System.debug('call PostDocumentSave ...');
        List<DocumentTO.DocumentForSave> lstDocumentsAPI = new List<DocumentTO.DocumentForSave>();
        if(lstDocumentUpload.size() > 0){

            for(DocumentUpload__c documentUpload : lstDocumentUpload){
                DocumentTO.DocumentForSave documentAPI = new DocumentTO.DocumentForSave();
                documentAPI.opportunitySfId = documentUpload.IdObjeto__c;
                documentAPI.originalName = documentUpload.Name;
                documentAPI.extension = documentUpload.FileExtension__c;
                documentAPI.url = documentUpload.ExternalUrl__c;
                documentAPI.objectType = '1';
                documentAPI.externalReferenceId = documentUpload.ExternalReferenceId__c;
                documentAPI.documentTypeExternalId = documentUpload.DocumentTypeExternalId__c;
                lstDocumentsAPI.add(documentAPI);
            }
        }

        if(lstDocumentsAPI.size() > 0){
            for(DocumentTO.DocumentForSave documentAPI : lstDocumentsAPI){
                String documentAPIString = JSON.serialize(documentAPI);
                Map<String, Object> results = IntegrationAPIWFlow.getInstance().postDocument(documentAPIString);
                System.debug(results);
            }
        }
    }

    @future(callout=true)
    public static void deleteFileLogic(String fileExternalId, String documentUploadId){
        List<DocumentUpload__c> lstDocUpd = new List<DocumentUpload__c>();
        String msgErrorSubject = 'Error ao atualizar um registro DocumentUpload';
        Boolean isDeleted = IntegrationAPIDocumentos.getInstance().deleteFileLogic(fileExternalId);

        if(isDeleted){
            lstDocUpd.add(new DocumentUpload__c(Id = documentUploadId, IsDeleted__c = true, ContentVersionId__c = null, IdentificadorDocumento__c = null));
        }

        if(!lstDocUpd.isEmpty()){
            Savepoint sp = Database.setSavepoint();
             try{
                Database.SaveResult[] srListFiles = Database.update(lstDocUpd, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstDocUpd);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    @future(callout=true)
    public static void deleteFilePhysical(String fileExternalId, String documentUploadId){
        String msgErrorSubject = 'Error ao deletar um registro DocumentUpload';
        Boolean isDeleted = IntegrationAPIDocumentos.getInstance().deleteFilePhysical(fileExternalId);

        if(isDeleted){
            Savepoint sp = Database.setSavepoint();
             try{
                Database.delete(documentUploadId, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    @future(callout=true)
    public static void getAllTypesFile(){
        String msgErrorSubject = 'Error ao atualizar a lista dos tipos de documentos';
        List<DocumentType__c> lstDocumentTypeInsert = new List<DocumentType__c>();
        Map<String, Object> mapFileType = new Map<String, Object>();
        Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().getAllTypesFile();

        System.debug('@@@@ mapReturnJson :' + mapReturnJson);

        if(mapReturnJson.containsKey('Retorno')){
            for(DocumentTO.DocumentTypeGetResponse fileType : (List<DocumentTO.DocumentTypeGetResponse>)
                (JSON.deserialize((String) mapReturnJson.get('Retorno'),DocumentTO.DocumentTypeGetResponse[].class))){
                mapFileType.put(fileType.idTipoArquivo, fileType);
            }
        }

        for(DocumentType__c docType : [SELECT ExternalReferenceId__c, Name FROM DocumentType__c]){
            mapFileType.remove(docType.ExternalReferenceId__c);
        }
        System.debug('@@@@ Map para insert :' + mapFileType);

        for(String key : mapFileType.keySet()){
            DocumentTO.DocumentTypeGetResponse fileType = (DocumentTO.DocumentTypeGetResponse) mapFileType.get(key);
            lstDocumentTypeInsert.add(new DocumentType__c(ExternalReferenceId__c = fileType.idTipoArquivo, Name = fileType.descricaoTipoArquivo));
        }

        if(!lstDocumentTypeInsert.isEmpty()){
            Savepoint sp = Database.setSavepoint();
             try{
                Database.insert(lstDocumentTypeInsert, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    @future(callout=true)
    public static void getFileTypeIdByFileTypeName(String nameFileType){
        Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().getFileTypeIdByFileTypeName(nameFileType);

        if(mapReturnJson.containsKey('Retorno')){
            DocumentTO.DocumentTypeGetResponse fileType = (DocumentTO.DocumentTypeGetResponse) (JSON.deserialize(
                (String) mapReturnJson.get('Retorno'),
                DocumentTO.DocumentTypeGetResponse.class
            ));
        }
    }

    public static String createPath(String objectId){
        String objectType = String.valueOf(Id.valueOf(objectId).getsobjecttype());
        String path;
        String whereCondition = ' Where Id = \'' + objectId + '\'';

        switch on objectType {
            when 'Account' {
                String profileName = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
                String businnessUnit = getBusinnessUnit(profileName);

                path = businnessUnit != null ? businnessUnit + '/' + objectId : objectId;
            }
            when 'Case' {
                MAP_OBJ_RELATED.putAll(CaseDAO.getInstance().getAllFieldsByWhereCondition(whereCondition));

                Case objCase = (Case) MAP_OBJ_RELATED.get(objectId);
                System.debug('Objeto Case: ' + objCase);

                String accountId = (String) (objCase).get('AccountId');
                System.debug('Get AccountId: ' + accountId);

                String businnessUnit = getBusinnessUnit(Schema.SObjectType.Case.getRecordTypeInfosById().get((String) (objCase).get('RecordTypeId')).getName());

                path = businnessUnit != null ? businnessUnit + '/' + accountId + '/' + objectId : accountId + '/' + objectId;
            }
            when 'Opportunity' {
                MAP_OBJ_RELATED.putAll(OpportunityDAO.getInstance().getAllFieldsByWhereCondition(whereCondition));

                Opportunity objOpportunity = (Opportunity) MAP_OBJ_RELATED.get(objectId);

                String accountId = (String) (objOpportunity).get('AccountId');
                String businnessUnit = getBusinnessUnit(Schema.SObjectType.Opportunity.getRecordTypeInfosById().get((String) (objOpportunity).get('RecordTypeId')).getName());

                path = businnessUnit != null ? businnessUnit + '/' + accountId + '/' + objectId : accountId + '/' + objectId;
            }
            when 'Order' {
                MAP_OBJ_RELATED.putAll(OrderDAO.getInstance().getAllFieldsByWhereCondition(whereCondition));

                Order objOrder = (Order) MAP_OBJ_RELATED.get(objectId);

                String accountId = (String) (objOrder).get('AccountId');
                String businnessUnit = getBusinnessUnit(Schema.SObjectType.Order.getRecordTypeInfosById().get((String) (objOrder).get('RecordTypeId')).getName());

                path = businnessUnit != null ? businnessUnit + '/' + accountId + '/' + objectId : accountId + '/' + objectId;
            }
            when 'Quote' {
                MAP_OBJ_RELATED.putAll(QuoteDAO.getInstance().getAllFieldsByWhereCondition(whereCondition));

                Quote objQuote = (Quote) MAP_OBJ_RELATED.get(objectId);

                String accountId = (String) (objQuote).get('AccountId');
                String businnessUnit = getBusinnessUnit(Schema.SObjectType.Quote.getRecordTypeInfosById().get((String) (objQuote).get('RecordTypeId')).getName());

                path = businnessUnit != null ? businnessUnit + '/' + accountId + '/' + objectId : accountId + '/' + objectId;
            }
            when 'Contract2__c' {
                MAP_OBJ_RELATED.putAll(Contract2DAO.getInstance().getAllFieldsByWhereCondition(whereCondition));

                Contract2__c objContract2 = (Contract2__c) MAP_OBJ_RELATED.get(objectId);

                String accountId = (String) (objContract2).get('AccountId');
                String businnessUnit = (String) (objContract2).get('SalesBusinessUnity__c');

                path = businnessUnit != null ? businnessUnit + '/' + accountId + '/' + objectId : accountId + '/' + objectId;
            }
        }
        System.debug('Caminho montado : ' + path);
        return path;
    }

    public static DocumentTO.Pessoa createPerson(String objectId, String path){
        String objectType = String.valueOf(Id.valueOf(objectId).getsobjecttype());
        String accountId;

        switch on objectType {
            when 'Account' {
                accountId = objectId;
            }
            when 'Case' {
                Case objCase = (Case) MAP_OBJ_RELATED.get(objectId);
                accountId = (String) (objCase).get('AccountId');
            }
            when 'Opportunity' {
                Opportunity objOpportunity = (Opportunity) MAP_OBJ_RELATED.get(objectId);
                accountId = (String) (objOpportunity).get('AccountId');
            }
            when 'Order' {
                Order objOrder = (Order) MAP_OBJ_RELATED.get(objectId);
                accountId = (String) (objOrder).get('AccountId');
            }
            when 'Quote' {
                Quote objQuote = (Quote) MAP_OBJ_RELATED.get(objectId);
                accountId = (String) (objQuote).get('AccountId');
            }
            when 'Contract2__c' {
                Contract2__c objContract2 = (Contract2__c) MAP_OBJ_RELATED.get(objectId);
                accountId = (String) (objContract2).get('Account__c');
            }
        }

        String whereCondition = 'Where Id = \'' + accountId + '\'';
        List<Account> lstObjAccount = AccountDAO.getInstance().getAllFields(whereCondition);

        DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
        pessoa.desCaminho = path;
        pessoa.documento = lstObjAccount[0].IdentificationNumber__c;
        pessoa.tipoPessoa = lstObjAccount[0].IsPersonAccount ? 'PF' : 'PJ';

        return pessoa;
    }

    public static Blob createBodyBlob(
        String desCaminho,
        List<DocumentTO.Pessoa> pessoa,
        String idTipoArquivo,
        ContentVersion conVersion,
        Map<String, Map<String, String>> mapMimeTypeAndFileExtensionByContentId
    ){
        //  Compose the form
        String form64 = '';
        System.debug('mapMimeTypeAndFileExtensionByContentId ==>' + mapMimeTypeAndFileExtensionByContentId);

        Map<String, String> mapMimeTypeAndFileExtension = mapMimeTypeAndFileExtensionByContentId.get(conVersion.Id);

        String fileExtension = mapMimeTypeAndFileExtension.get('FileExtesion');
        String mimeType = mapMimeTypeAndFileExtension.get('MimeType');

        System.debug('fileExtension =' + fileExtension);
        System.debug('mimeType =' + mimeType);

        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameter('IdTipoArquivo', EncodingUtil.urlEncode(idTipoArquivo, 'UTF-8'));
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameter('DesCaminho', desCaminho);
        form64 += HttpFormBuilder.writeBoundary();

        form64 += writeBodyPessoa(pessoa);
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('Arquivo', EncodingUtil.base64Encode(conVersion.VersionData));
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('MimeType', mimeType);
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('FileExtesion', fileExtension);

        form64 += HttpFormBuilder.writeBoundary(HttpFormBuilder.EndingType.CrLf);

        System.debug('@@@ form64' + form64);

        return EncodingUtil.base64Decode(form64);
    }

    public static Map<String, Map<String, String>> getExtensionFile(Set<Id> contentVersionIds){
        List<ContentVerSion> lstContentVersions = [SELECT Id, ContentDocumentId, PathOnClient FROM ContentVerSion WHERE Id IN :contentVersionIds];

        Map<String, Map<String, String>> mapMimeTypeAndFileExtensionByContentId = new Map<String, Map<String, String>>();

        Set<String> setFileExtensions = new Set<String>();

        for(ContentVerSion contentVersion : lstContentVersions){
            String fileExtension = getFileExtensionOfString(contentVersion.PathOnClient);

            setFileExtensions.add(fileExtension.replace('.', ''));
        }

        List<ContentType__c> lstContentTypes = [SELECT Id, Name, Template__c FROM ContentType__c WHERE Name IN :setFileExtensions];

        Map<String, String> mapMimeTypeByFileExtensionName = new Map<String, String>();

        for(ContentType__c contentType : lstContentTypes){
            mapMimeTypeByFileExtensionName.put(contentType.Name, contentType.Template__c);
        }

        for(ContentVerSion contentVersion : lstContentVersions){
            String fileExtension = getFileExtensionOfString(contentVersion.PathOnClient);

            String mimeType = mapMimeTypeByFileExtensionName.get(fileExtension);

            System.debug('fileExtension ==>' + fileExtension);

            Map<String, String> mapMimeTypeAndFileExtension = new Map<String, String>();

            mapMimeTypeAndFileExtension.put('MimeType', mimeType);
            mapMimeTypeAndFileExtension.put('FileExtesion', fileExtension);

            mapMimeTypeAndFileExtensionByContentId.put(contentVersion.Id, mapMimeTypeAndFileExtension);
        }

        return mapMimeTypeAndFileExtensionByContentId;
    }

    public static String getFileExtensionOfString(String texto){
        Integer indiceUltimoPonto = texto.lastIndexOf('.', texto.length());
        String fileExtension = texto.substring(indiceUltimoPonto, texto.length());

        return fileExtension;
    }

    public static String writeBodyPessoa(List<DocumentTO.Pessoa> pessoa){
        String pessoaStr = '';
        pessoaStr += HttpFormBuilder.writeStrBodyParameter('Pessoa[0].documento', String.valueOf(pessoa[0].documento)) + '\r\n';
        pessoaStr += HttpFormBuilder.writeStrBoundary();
        pessoaStr += HttpFormBuilder.writeStrBodyParameter('Pessoa[0].tipoPessoa', String.valueOf(pessoa[0].tipoPessoa)) + '\r\n';
        pessoaStr += HttpFormBuilder.writeStrBoundary();
        pessoaStr += HttpFormBuilder.writeStrBodyParameter('Pessoa[0].desCaminho', String.valueOf(pessoa[0].desCaminho));
        String pessoaCrLf = pessoaStr + '\r\n';
        Blob pessoaCrLfBlob = Blob.valueOf(pessoaCrLf);
        String pessoaCrLf64 = EncodingUtil.base64Encode(pessoaCrLfBlob);
        String content = HttpFormBuilder.safelyPad(pessoaStr, pessoaCrLf64, '\r\n');
        return content;
    }

    @AuraEnabled
    public static void updateStatus(String docUploadJSON){

        System.debug(docUploadJSON);
        Map<String, DocUploadWrapper> docUploadMap = (Map<String, DocUploadWrapper>) json.deserialize(docUploadJSON, Map<String, DocUploadWrapper>.class);

        List<DocumentUpload__c> docUploadList = new List<DocumentUpload__c>();
        for(String docId : docUploadMap.keySet()){
            docUploadList.add(new DocumentUpload__c(
                                    Id = docId, 
                                    Status__c = ((DocUploadWrapper) docUploadMap.get(docId)).status, 
                                    ReasonRefusal__c = ((DocUploadWrapper) docUploadMap.get(docId)).reason));
        }
        update docUploadList; 
    }

    private static String getBusinnessUnit(String refBusinnessUnit){
        if(refBusinnessUnit.Contains('Corporate')){
            return 'CORPORATE';
        }else if(refBusinnessUnit.Contains('BBX')){
            return 'BBX';
        }else if(refBusinnessUnit.Contains('BPO') || refBusinnessUnit.Contains('B2U')){
            return 'BPO';
        }else if(refBusinnessUnit.Contains('Conseg')){
            return 'CONSEG';
        }else if(refBusinnessUnit.Contains('Beneficios')){
            return 'BENEFICIOS';
        }else if(refBusinnessUnit.Contains('Parceiros') || refBusinnessUnit.Contains('Wimo')){
            return 'PARCEIROS';
        }else if(refBusinnessUnit.Contains('Rede') || refBusinnessUnit.Contains('VIP')){
            return 'REDE';
        }else{
            return null;
        }
    }

    public class DocUploadWrapper{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String reason;
    }
}