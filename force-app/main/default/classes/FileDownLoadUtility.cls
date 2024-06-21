public without sharing class FileDownLoadUtility {

    public static final String URL_BLIP = 'https://blipmediastore.blob.core.windows.net';
    public static final String ENDPOINT_ARQUIVOS = '/arquivos';

    public static blob fetchFileFromExternalUrl(String extFileUrl, String contentType){
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        extFileUrl = extFileUrl.replace(' ', '%20');
        //Set the end point URL
        req.setEndpoint(extFileUrl);
        req.setMethod('GET');
        req.setHeader('Content-Type', contentType);
        req.setCompressed(true);
        req.setTimeout(60000);
        //Now Send HTTP Request
        HttpResponse res  = h.send(req);
        system.debug('Response from Server: ' + res.getBody());
        //getBodyAsBlob method was will convert the response into Blob
        blob retFile = res.getBodyAsBlob();
        return retFile;
    }

    public static Id createAttachment(blob fileContent, String recordId, String fileType){
        //for pdf files content type should be pdf
        //for jpeg file content type should be image/jpeg
        Attachment attach = new Attachment();
        attach.ParentId = recordId;
        attach.Name = 'FileFromExtenalSource.pdf';
        attach.Body = fileContent;
        attach.contentType = fileType;
        insert attach;
        return attach.id;
    }

    public static Map<string, ContentType__c> mapeiaExtensionTypes(Set<String> setFileExtension){
        System.debug('filesExtension ===>'+ setFileExtension);

        List<ContentType__c> lstContentTypes = [SELECT Id,Name, Template__c FROM ContentType__c WHERE Name IN :setFileExtension];
        System.debug('lstContentTypes ===>'+ lstContentTypes);
        Map<string, ContentType__c> mapContentTypes = new Map<string, ContentType__c>();

        for( ContentType__c contentType : lstContentTypes ){
            mapContentTypes.put(contentType.Name, contentType);
        }

        System.debug('mapContentTypes ===>' + mapContentTypes);

        return mapContentTypes;
    }


    @future(callout=true)
    public static void alterarURLTemporariaBlip(String idObjeto){

        List<DocumentUpload__c> lstDocuments = [SELECT Id, Name, ExternalUrl__c, Owner.Name, ownerId,IdObjeto__c, FileExtension__c FROM DocumentUpload__c WHERE IdObjeto__c  = :idObjeto];

        String objectType = String.valueOf(Id.valueOf(idObjeto).getsobjecttype());

        if(objectType == 'Opportunity'){

            List<DocumentUpload__c> lstDocumentsUploadLinkBlip = new List<DocumentUpload__c>();

            for(DocumentUpload__c documentUpload : lstDocuments){
                if(documentUpload.ExternalUrl__c.contains(URL_BLIP)){
                    lstDocumentsUploadLinkBlip.add(documentUpload);
                }
            }

            if(lstDocumentsUploadLinkBlip.size() > 0){

                String nomeArquivo = lstDocumentsUploadLinkBlip.get(0).Name;

                System.debug('nomeArquivo ===>'+nomeArquivo);
                String fileExtension = lstDocumentsUploadLinkBlip.get(0).FileExtension__c  != null ? lstDocumentsUploadLinkBlip.get(0).FileExtension__c  : 'pdf';

                System.debug('fileExtension ===>'+fileExtension);

                Set<String> setFileExtension = new Set<String>();
                setFileExtension.add(fileExtension);
                Map<string, ContentType__c> mapContentTypes = FileDownLoadUtility.mapeiaExtensionTypes(setFileExtension);

                ContentType__c contentType = mapContentTypes.get(fileExtension);

                System.debug('contentType ===>'+contentType);

                blob fileBlob = FileDownLoadUtility.fetchFileFromExternalUrl(lstDocumentsUploadLinkBlip.get(0).ExternalUrl__c, contentType.Template__c);

                Opportunity oportunidade = [SELECT Id, Name, accountId, Account.Name, Account.IdentificationNumber__c, Account.RecordType.Name FROM Opportunity WHERE Id = :idObjeto];
                String path = DocumentUploadService.createPath(idObjeto);

                DocumentTO.Pessoa pessoa = FileDownLoadUtility.createPerson(path, oportunidade.Account.IdentificationNumber__c, oportunidade.Account.RecordType.Name);

                List<DocumentTO.Pessoa> lstPessoa = new List<DocumentTO.Pessoa>();
                lstPessoa.add(pessoa);

                Blob form64 = FileDownLoadUtility.montarFormRequisicao(fileBlob, contentType, lstPessoa, path);

                System.debug('form64 ==.'+form64);

                Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().postFile(form64);
                System.debug('MAP Return : ' + mapReturnJson);

                atualizarDocumentosUpload(mapReturnJson, lstDocumentsUploadLinkBlip, fileBlob);

            }
        }
    }

    public static void atualizarDocumentosUpload(Map<String, Object> mapReturnJson, List<DocumentUpload__c> lstDocuments, blob fileBlob){
        String msgErrorSubject = 'Error ao atualizar DocumentUpload após o Post API Docs';
        List<DocumentUpload__c> lstDocUpd = new List<DocumentUpload__c>();

        if(mapReturnJson.containsKey('Retorno')){

            DocumentTO.DocumentPostResponseTO documentResponseTO = (DocumentTO.DocumentPostResponseTO) (
                    JSON.deserialize(
                        (String) mapReturnJson.get('Retorno'),
                        DocumentTO.DocumentPostResponseTO.class
                    )
                );
            System.debug('@@@ documentResponseTO : ' + documentResponseTO);

            lstDocUpd.add(new DocumentUpload__c (
                Id = lstDocuments.get(0).Id,
                ExternalUrl__c = documentResponseTO.Pessoa[0].desCaminho
            ));

            if(!lstDocUpd.isEmpty()){

                Savepoint sp = Database.setSavepoint();

                try{
                    Database.SaveResult[] srListFiles = Database.update(lstDocUpd, false);
                    ErrorLogService.getInstance().saveResult(srListFiles ,msgErrorSubject, lstDocUpd);
                } catch (Exception e){
                    System.Debug(e);
                    Database.rollback(sp);
                }
            }else{
                String nomeArquivo = lstDocuments.get(0).Name;

                ContentVersion contentVersion = new ContentVersion(
                    Title = nomeArquivo,
                    PathOnClient = nomeArquivo,
                    VersionData = fileBlob,
                    origin = 'H'
                );

                insert contentVersion;
            }
        }
    }


    public static Blob montarFormRequisicao(blob retFile, ContentType__c contentType, List<DocumentTO.Pessoa> lstPessoa, String path){
        DocumentType__c  documentType = [SELECT Id, Name, ExternalReferenceId__c FROM DocumentType__c WHERE Name = 'Material Digital' LIMIT 1];
        String form64 = '';

        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameter('IdTipoArquivo', EncodingUtil.urlEncode( documentType.ExternalReferenceId__c , 'UTF-8'));
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameter('DesCaminho', path); // PATH
        form64 += HttpFormBuilder.writeBoundary();

        form64 += DocumentUploadService.writeBodyPessoa(lstPessoa);
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('Arquivo', EncodingUtil.base64Encode(retFile));
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('MimeType', contentType.Template__c);//contentType.Template__c
        form64 += HttpFormBuilder.writeBoundary();
        form64 += HttpFormBuilder.writeBodyParameterFile('FileExtesion', '.' +   contentType.Name);//contentType.Name

        form64 += HttpFormBuilder.writeBoundary(HttpFormBuilder.EndingType.CrLf);

        return EncodingUtil.base64Decode(form64);
    }

    public static DocumentTO.Pessoa createPerson(String path, String identitificador, String tipoPessoa){
        DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
        pessoa.desCaminho = path;
        pessoa.documento = identitificador;
        pessoa.tipoPessoa = tipoPessoa;
        return pessoa;
    }

}