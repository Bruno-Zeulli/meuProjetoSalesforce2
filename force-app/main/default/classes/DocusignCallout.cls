public with sharing class DocusignCallout {
    private static String DOCUSIG_ACCOUNTID = ExternalAPI__c.getInstance('DocusignWiz').ClientID__c;
    private static String TIPO_CARTA_NOMEACAO = 'Carta de Nomeação';

    public static void saveSignedDocuments(List<Opportunity> oppList){
        Map<String,Opportunity> envelopesIdsToOppId = new Map<String,Opportunity>();
        
        for(Opportunity opp:oppList){
            envelopesIdsToOppId.put(opp.Envelope_Id_CN__c,opp);
        }
        
        HttpResponse responseList = getEnvelopesIdsCompleted(envelopesIdsToOppId);

        if(responseList.getStatusCode() == 200){
            DocumentType__c tipArquivo = [SELECT Id, ExternalReferenceId__c  FROM DocumentType__c WHERE Name  = :TIPO_CARTA_NOMEACAO LIMIT 1];
            
            List<DocumentUpload__c> listDocUploadToInsert = new List<DocumentUpload__c>();

            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseList.getBody());
            List<Object> envelopes = (List<Object>) results.get('envelopes');
            
            for(Object obj:envelopes){
                Map<String, Object> envelope = (Map<String, Object>) obj;
                String envelopeId = (String) envelope.get('envelopeId');

                HttpResponse responseDoc = getEnvelopeDocument(envelopeId);
        
                if(responseDoc.getStatusCode() == 200){
                    ContentVersion contentVersion = new ContentVersion();
                    contentVersion.VersionData = responseDoc.getBodyAsBlob();
                    contentVersion.Id = '068880000000000AAA';

                    Map<String, Object> mapReturnJson = senDocumentBlobPDFCorporate(tipArquivo.ExternalReferenceId__c,envelopesIdsToOppId.get(envelopeId),contentVersion);
                    if(mapReturnJson.get('WSResponseStatusCode') == 201){
                        DocumentTO.DocumentPostResponseTO documentResponseTO = (DocumentTO.DocumentPostResponseTO) (JSON.deserialize((String) mapReturnJson.get('Retorno'),DocumentTO.DocumentPostResponseTO.class));
                        DocumentUpload__c docUploadToAdd = new DocumentUpload__c();
                        docUploadToAdd.Status__c = 'UnderReview'; 
                        docUploadToAdd.ExternalUrl__c = documentResponseTO.Pessoa[0].desCaminho;
                        docUploadToAdd.IdObjeto__c = envelopesIdsToOppId.get(envelopeId).Id;
                        docUploadToAdd.Objects__c = 'Opportunity';
                        docUploadToAdd.DocumentType__c = tipArquivo.Id;
                        docUploadToAdd.Name = 'Carta de Nomeação - '+ System.today().addDays(-1).format();
                        docUploadToAdd.FileExtension__c = 'pdf';
                        listDocUploadToInsert.add(docUploadToAdd);
                    }
                }
            }
            if(!listDocUploadToInsert.isEmpty()){
                insertDocAndUpdateOpp(listDocUploadToInsert);
            }
        }
    }

    @TestVisible
    private static void insertDocAndUpdateOpp(List<DocumentUpload__c> listDocUploadToInsert){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        for(DocumentUpload__c doc:listDocUploadToInsert){
            oppsToUpdate.add(new Opportunity(Id = doc.IdObjeto__c,Envelope_Signed_CN__c = true));
        }
        Savepoint sp = Database.setSavepoint();
        
        insert listDocUploadToInsert;

        try{
            update oppsToUpdate;
        }catch(Exception e){
            Database.rollback(sp);
        }
    }

    private static HttpResponse getEnvelopesIdsCompleted(Map<String,Opportunity> envelopesIdsToOppId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Docusign/restapi/v2.1/accounts/' + DOCUSIG_ACCOUNTID +'/envelopes/status?envelope_ids=request_body&status=completed');
        request.setMethod('PUT');
        Map<String,Set<String>> mapBody = new Map<String,Set<String>>{'envelopeIds'=>envelopesIdsToOppId.keySet()};
        request.setBody(JSON.serialize(mapBody));
        return http.send(request);
    }

    private static HttpResponse getEnvelopeDocument(String envelopeId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Docusign/restapi/v2.1/accounts/' + DOCUSIG_ACCOUNTID + '/envelopes/' + envelopeId + '/documents/combined');
        request.setMethod('GET');
        return http.send(request);
    }

    private static Map<String, Object> senDocumentBlobPDFCorporate(String extIdTipoArquivo, Opportunity opp, ContentVersion contentVersion) {
        String path = 'CORPORATE/' + opp.AccountId + '/' + opp.Id;
        
        List<DocumentTO.Pessoa> lstPessoa = new List<DocumentTO.Pessoa>();
        DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
        pessoa.desCaminho = path;
        pessoa.documento = opp.Account.IdentificationNumber__c;
        pessoa.tipoPessoa = opp.Account.IsPersonAccount ? 'PF' : 'PJ';
        lstPessoa.add(pessoa);

        Map<String, Map<String, String>> mapMimeTypeAndFileExtensionByContentId = new Map<String, Map<String, String>>();
        Map<String, String> mapMimeTypeAndFileExtension = new Map<String, String>();
        mapMimeTypeAndFileExtension.put('MimeType', null);
        mapMimeTypeAndFileExtension.put('FileExtesion', '.pdf');
        mapMimeTypeAndFileExtensionByContentId.put(contentVersion.Id, mapMimeTypeAndFileExtension);

        Blob form64 = DocumentUploadService.createBodyBlob(path, lstpessoa, extIdTipoArquivo, contentVersion, mapMimeTypeAndFileExtensionByContentId);
        Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDocumentos.getInstance().postFile(form64);
        return mapReturnJson;
    }
}