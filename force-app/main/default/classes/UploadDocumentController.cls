/**
 * @description       :
 * @author            : lucasmoro.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 09-12-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   25-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing  class UploadDocumentController {

	@AuraEnabled(cacheable=true)
	public static void changeFileName(String listAttachId, String fileName, Order Orderupd){
		 try{
			Set<Id> attachIds = String.isNotBlank(listAttachId)
				? (Set<Id>) JSON.deserialize(listAttachId, Set<Id>.class)
				: new Set<Id>();
			List<ContentDocument> documents = [SELECT Id, Title, ContentModifiedDate, FileExtension FROM ContentDocument WHERE Id IN :attachIds];

			if(!Test.isRunningTest()){
				for(ContentDocument doc : documents){
				doc.Title = fileName;
				}
			}
			Order ord = [SELECT Id, OrderNumber, EndorsementNumber__c FROM Order WHERE Id = :Orderupd.Id];

			for(ContentDocument doc : documents){
				if(doc.Title == 'Apólice'){
					doc.Title = fileName + '_' + ord.OrderNumber + '.' + doc.FileExtension;
					if(!Test.isRunningTest()){
						IntegrationAPICRM.integrationCorpAPICRM(ord.Id);
					}
				}

				if(doc.Title == 'Boleto'){
					doc.Title = fileName + '_' + ord.OrderNumber + '_' + doc.ContentModifiedDate + '.' + doc.FileExtension;
				}

				if(doc.Title == 'Endosso'){
					doc.Title = fileName + '_' + ord.OrderNumber + '_' + ord.EndorsementNumber__c + '.' + doc.FileExtension;
				}

				if(doc.Title == 'Comprovante de pagamento'){
					doc.Title = fileName + '_' + ord.OrderNumber + '.' + doc.ContentModifiedDate + doc.FileExtension;
				}

				if(doc.Title == 'Email'){
					doc.Title = fileName + '_' + ord.OrderNumber + '.' + doc.ContentModifiedDate + doc.FileExtension;
				}

				if(doc.Title == 'Outros'){
					doc.Title = fileName + '_' + ord.OrderNumber + '.' + doc.ContentModifiedDate + doc.FileExtension;
				}
			}

			if(documents != null){
				update documents;
			}

			if(Orderupd != null){
				update Orderupd;
			}
		} catch (DMLException dmle){
			throw new AuraHandledException(dmle.getMessage());
		}
	}

	@AuraEnabled
	public static Boolean verifyExceedLimitSize(String lstDocumentos){
		List<DocumentTO> documentos = (List<DocumentTO>) JSON.deserialize(lstDocumentos, List<DocumentTO>.class);
		Integer fourMBSize = 2500000;
		Set<Id> setContentVersionIds = new Set<Id>();

		for(DocumentTO documento: documentos){
			if(documento.contentVersionId != null && documento.contentVersionId != ''){
				setContentVersionIds.add(documento.contentVersionId);
			}
		}

		List<ContentVersion> lstContentVersion =  [SELECT Id, ContentSize FROM ContentVersion WHERE Id IN :setContentVersionIds Order By CreatedDate Desc];

		if(lstContentVersion.size() > 0 ){
			Boolean hasFileMore4MB = false;
			for(ContentVersion contentVersion : lstContentVersion){
				if(contentVersion.ContentSize > fourMBSize){
					hasFileMore4MB = true;
				}
			}

			return hasFileMore4MB;
		}

		return false;
	}

	@AuraEnabled
	public static  Map<ID, String> uploadDocuments(String lstDocumentos, Id IdObjeto, String tipoDocumento){
		Map<String, String> mapDocType = new Map<String, String>();

		 try{
			System.debug('lstDocumentos ==>> ' + lstDocumentos);
			List<DocumentTO> documentos = (List<DocumentTO>) JSON.deserialize(lstDocumentos, List<DocumentTO>.class);

			/**
			 * Caso o Objeto seja Order, renomear os arquivos conforme a regra
			 */
			if(String.valueOf(IdObjeto.getsobjecttype()) == 'Order'){
				Set<Id> setDocsIds = new Set<Id>();

				for(DocumentTO doc : documentos){
					setDocsIds.add(doc.documentId);
				}

				Order pedido = new Order();
				pedido.Id = IdObjeto;
				UploadDocumentController.changeFileName(JSON.serialize(setDocsIds), tipoDocumento, pedido);
			}

			List<DocumentType__c> lstDocType = [SELECT Id, Name FROM DocumentType__c];

			for(DocumentType__c objDocType : lstDocType){
				mapDocType.put(objDocType.Name, objDocType.Id);
			}

			System.debug('lstDocumentos ==>'+documentos);
			List<DocumentUpload__c> lstDocumentUpload = new List<DocumentUpload__c>();

			for(DocumentTO doc : documentos){

				DocumentUpload__c docUpload = new DocumentUpload__c();

				docUpload.Name = doc.name;
				docUpload.Objects__c = String.valueOf(IdObjeto.getsobjecttype());
				docUpload.IdObjeto__c = IdObjeto;
				docUpload.ContentVersionId__c = doc.contentVersionId;
				docUpload.IdentificadorDocumento__c = doc.documentId;
				docUpload.DocumentType__c = mapDocType.get(tipoDocumento);

				lstDocumentUpload.add(docUpload);
			}

			insert lstDocumentUpload;

			Map<ID, String> mapDocumentTO = UploadDocumentController.getFilesByObject(IdObjeto);

			return mapDocumentTO;

		} catch (Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled(cacheable=false)
	public static Map<ID, String> getFilesByObject(String recordId){
		return getFilesByObject(new List<Id>{recordId});
	}

	@AuraEnabled(cacheable=false)
	public static Map<ID, String> getFilesByObject(List<Id> recordId){

		Set<String> setDocumentId = new Set<String>();
		Map<Id, DocumentUpload__c> mapDocUpload = new Map<Id, DocumentUpload__c>();
		Map<Id, ContentVersion> mapContentVersion = new Map<Id, ContentVersion>();

		Map<ID, String> mapDocSendCMP = new Map<ID, String>();
		String uri = '/sfc/servlet.shepherd/document/download/';
		Set<String> setFileExtension = new Set<String>();

		List<DocumentUpload__c> lstDocUpload = [SELECT  Id,
														Name,
														ContentVersionId__c,
														IdentificadorDocumento__c,
														DocumentType__r.Name,
														IdObjeto__c,
														Objects__c,
														Status__c,
														ExternalUrl__c,
														CreatedDate ,
														FileExtension__c,
														FileTemplate__c
												FROM    DocumentUpload__c
												WHERE   IdObjeto__c = :recordId
												AND     IsDeleted__c = false
												ORDER BY CreatedDate DESC];

		for(DocumentUpload__c docUpload : lstDocUpload){
			docUpload.FileExtension__c = 	docUpload.FileExtension__c == null ?
											docUpload.Name.Contains('.') ?
											docUpload.Name.substring(docUpload.Name.indexOf('.'), docUpload.Name.length()).replace('.', '').toLowerCase() :
											null :
											docUpload.FileExtension__c;
			mapDocUpload.put(docUpload.IdentificadorDocumento__c, docUpload);
			setDocumentId.add(docUpload.IdentificadorDocumento__c);
			setFileExtension.add(docUpload.FileExtension__c);

		}

		List<ContentVersion> lstContentVersion = [SELECT  Id,
															Title,
															ContentDocumentId
													FROM    ContentVersion
													WHERE   ContentDocumentId IN :setDocumentId
													];

		for(ContentVersion objContentVersion : lstContentVersion){
			mapContentVersion.put(objContentVersion.ContentDocumentId, objContentVersion);
		}

		Map<string, ContentType__c> mapContentTypes = FileDownLoadUtility.mapeiaExtensionTypes(setFileExtension);

		for(DocumentUpload__c objDocUpload : lstDocUpload){

			ContentVersion objContentVersion = new ContentVersion();

			if(objDocUpload.IdentificadorDocumento__c != null){
			objContentVersion = mapContentVersion.get(objDocUpload.IdentificadorDocumento__c);
			}

			DocumentTO.DocumentSendCMP documentSendCMP = new DocumentTO.DocumentSendCMP();
			documentSendCMP.id = objDocUpload.Id;
			documentSendCMP.type = objDocUpload.DocumentType__r.Name;
			documentSendCMP.name = objDocUpload.Name;
			documentSendCMP.status = objDocUpload.Status__c;
			documentSendCMP.contentVersionId = objContentVersion != null ? objContentVersion.ContentDocumentId : null;
			documentSendCMP.url = objDocUpload.ExternalUrl__c != null ? objDocUpload.ExternalUrl__c :
								objContentVersion != null ? uri + objContentVersion.ContentDocumentId : null;
			documentSendCMP.hasPreview = objContentVersion.ContentDocumentId != null ? true : false;
			documentSendCMP.dataCriacao = objDocUpload.CreatedDate;
			documentSendCMP.isIntegrated = objDocUpload.ExternalUrl__c != null && objDocUpload.ExternalUrl__c != '' ? true : false;
			documentSendCMP.extension = objDocUpload.FileExtension__c;
			String templateFile = mapContentTypes.get(objDocUpload.FileExtension__c)!= null && mapContentTypes.get(objDocUpload.FileExtension__c).Template__c != null ? mapContentTypes.get(objDocUpload.FileExtension__c).Template__c : '';
			documentSendCMP.contentType = objDocUpload.FileTemplate__c != null ? objDocUpload.FileTemplate__c : templateFile;
			documentSendCMP.recordId = objDocUpload.IdObjeto__c;


			mapDocSendCMP.put(objDocUpload.Id, JSON.serialize(documentSendCMP));
		}

		return mapDocSendCMP;
	}

	@AuraEnabled(cacheable=false)
	public static Map<ID, String> getAccountRelatedFiles(String recordId){
		List<Account> accList = [SELECT (SELECT Id FROM Opportunities), (SELECT Id FROM Orders), (SELECT Id FROM Cases) FROM Account WHERE Id = :recordId];
		if (accList.isEmpty()){
			return new Map<ID, String>();
		}

		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(accList.get(0).Opportunities);
		Map<Id, Order> orderMap = new Map<Id, Order>(accList.get(0).Orders);
		Map<Id, Case> caseMap = new Map<Id, Case>(accList.get(0).Cases);
		Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id FROM Quote WHERE Opportunity.AccountId = :recordId]);
		List<Id> recordIdList = new List<Id>();
		recordIdList.addAll(oppMap.keySet());
		recordIdList.addAll(quoteMap.keySet());
		recordIdList.addAll(orderMap.keySet());
		recordIdList.addAll(caseMap.keySet());
		if (recordIdList.isEmpty()){
			return new Map<ID, String>();
		}
		return getFilesByObject(recordIdList);
	}

	@AuraEnabled
	public static void relateFilesToRecords(String fileId, List<DocumentTO.RelateExistingDocument> newRecords){
		List<DocumentUpload__c> lstDocUpload = [
			SELECT 
				Id,
				Name,
				ContentVersionId__c,
				IdentificadorDocumento__c,
				DocumentType__c,
				IdObjeto__c,
				Objects__c,
				Status__c,
				ExternalUrl__c,
				CreatedDate ,
				FileExtension__c,
				FileTemplate__c
			FROM DocumentUpload__c
			WHERE Id = :fileId];

		System.debug(lstDocUpload);
		System.debug(newRecords);
		if (!lstDocUpload.isEmpty()){
			List<DocumentUpload__c> newFiles = new List<DocumentUpload__c>();
			for (DocumentTO.RelateExistingDocument wrapper : newRecords){
				DocumentUpload__c doc = lstDocUpload.get(0).clone(false, true);
				doc.IdObjeto__c = wrapper.recordId;
				doc.Objects__c = wrapper.objectName;
				doc.ExternalReferenceId__c = null;
				doc.Status__c = 'UnderReview';
				newFiles.add(doc);
			}
			insert newFiles;
		}
	}

	@AuraEnabled
	public static List<String> getPickListValuestipoDocumentos(){
		List<String> pickListValuesList= new List<String>();

		for(DocumentType__c docType : [SELECT Name FROM DocumentType__c ORDER BY NAME]){
			pickListValuesList.add(docType.Name);
		}

		return pickListValuesList;
	}

	@AuraEnabled
	public static void deleteDoc(String documentUploadId){

		DocumentUpload__c objDocUpload = [SELECT  Id,
												ContentVersionId__c,
												IdentificadorDocumento__c,
												ExternalReferenceId__c
										FROM    DocumentUpload__c
										WHERE   Id = :documentUploadId
										];

		if(objDocUpload.ExternalReferenceId__c != null){
			DocumentUploadService.deleteFileLogic(objDocUpload.ExternalReferenceId__c, objDocUpload.Id);
		}
	}

	@AuraEnabled
	public static Map<ID, String> getDocumentsChecklist(String recordId){

		Map<ID, String> mapDocChecklistSendCMP = new Map<ID, String>();

		for(DocumentChecklist__c objDocChecklist : DocumentChecklistBO.getInstance().getDocumentsChecklist(recordId)){

			DocumentTO.DocumentChecklistSendCMP docChecklistSendCMP = new DocumentTO.DocumentChecklistSendCMP();
			docChecklistSendCMP.id = objDocChecklist.Id;
			docChecklistSendCMP.documentType = objDocChecklist.DocumentType__r.Name;
			docChecklistSendCMP.required = objDocChecklist.DocumentRequirement__c ? 'Sim' : 'Não';
			mapDocChecklistSendCMP.put(objDocChecklist.Id, JSON.serialize(docChecklistSendCMP));
		}

		return mapDocChecklistSendCMP;
	}

	@AuraEnabled
	public static Map<ID, String> getRelatedFilesByRecordId(String recordId){
		// Get record file IDs
		List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
		List<ID> fileIDs = new List<ID>();
		for(ContentDocumentLink docLink : files){
			fileIDs.add(docLink.ContentDocumentId);
		}

		List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title
			FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
		Map<ID, String> mapIdTitle = new Map<ID, String>();
		for(ContentVersion docLink : docs){
			mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
		}
		return mapIdTitle;
	}

	@AuraEnabled
	public static Boolean sendFiles(String recordId){
		List<DocumentUpload__c> docsUpload = [SELECT  Id, ExternalUrl__c  FROM DocumentUpload__c WHERE   IdObjeto__c = :recordId ORDER BY CreatedDate DESC];
		Boolean allIntegrate = true;

		for(DocumentUpload__c docUpload : docsUpload){
			if(docUpload.ExternalUrl__c == null || docUpload.ExternalUrl__c == ''){
				allIntegrate = false;
			}
		}

		if(allIntegrate == true){
			return false;
		}

		if(recordId != null && recordId != ''){
			DocumentUploadService.postFile(recordId);
			return true;
		}

		return false;
	}

	@AuraEnabled
	public static String getToken(){
		String token = GetAccessTokenUtil.getInstance().getToken('APIDocumentos', 'SSO');
		return token;
	}

	@AuraEnabled
	public static String getFileURL(){
		 try{
			String url = ExternalAPI__c.getValues('GetFiles').Endpoint__c + ExternalAPI__c.getValues('GetFiles').ComplementUrl__c;
			return url;
		} catch (Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static String getPersonInformation(String recordId, String tipoArquivo){
		System.debug('recordId' + recordId + ' | tipoArquivo ' + tipoArquivo);
		DocumentTO document = new DocumentTO();
		DocumentType__c documentType = [SELECT Id, ExternalReferenceId__c  FROM DocumentType__c WHERE Name  = :tipoArquivo LIMIT 1];
		Boolean isOpportunityOFCorporate = DocumentUploadService.isOpportunityOFCorporate(recordId);

		List<DocumentTO.Pessoa> lstPessoa = new List<DocumentTO.Pessoa>();

		String path = DocumentUploadService.createPath(recordId);
		lstpessoa.add(DocumentUploadService.createPerson(recordId, path));

		document.path = path;
		document.pessoa = lstPessoa;
		document.url = ExternalAPI__c.getValues('SaveDocument').Endpoint__c + ExternalAPI__c.getValues('SaveDocument').ComplementUrl__c;
		document.tipoDocumento = documentType.ExternalReferenceId__c;
		document.isOpportunityOFCorporate = isOpportunityOFCorporate;

		return JSON.serialize(document);
	}

	@AuraEnabled
	public static String generateDocumentWithAPISucess(String retorno, Id recordId, String tipoArquivo){

		DocumentTO.DocumentPostResponseTO documentResponseTO = (DocumentTO.DocumentPostResponseTO) (
			JSON.deserialize(
				retorno,
				DocumentTO.DocumentPostResponseTO.class
			));

		DocumentType__c documentType = [SELECT 	Id
										FROM 	DocumentType__c
										WHERE 	Name  = :tipoArquivo
										LIMIT 	1];

		DocumentUpload__c documentUpload = new DocumentUpload__c();
		documentUpload.Name = documentResponseTO.arquivo.fileName;
		documentUpload.DocumentType__c = documentType.Id;
		documentUpload.IdObjeto__c = recordId;
		documentUpload.Objects__c = String.valueOf(recordId.getsobjecttype());
		documentUpload.ExternalUrl__c = documentResponseTO.pessoa.get(0).desCaminho;
		documentUpload.ExternalReferenceId__c = documentResponseTO.idArquivo;
		documentUpload.FileTemplate__c = documentResponseTO.arquivo.contentType;

		return JSON.serialize(documentUpload);
	}

	@AuraEnabled
	public static String sendOpportunityCorporateForAPI(String documentUploadId){
		List<DocumentUpload__c> lstDocumentUpload = [SELECT
															Id,
															IdObjeto__c,
															Name,
															FileExtension__c,
															ExternalUrl__c,
															ExternalReferenceId__c,
															DocumentTypeExternalId__c,
															Objects__c
													FROM DocumentUpload__c
													WHERE Id = :documentUploadId];

		DocumentUploadService.postDocumentSave(lstDocumentUpload);

		return JSON.serialize(lstDocumentUpload);
	}

	@AuraEnabled
	public static Boolean updateStatusFile(String documentUploadId, String status){
		 try{
            DocumentUpload__C objdocUpload = new DocumentUpload__C(
                Id = documentUploadId,
                Status__c = status
            );

            Database.SaveResult srUpdDocUpload= Database.update(objdocUpload, false);
            if(srUpdDocUpload.isSuccess()){
                System.debug('Successfully updated status document upload. documentUpload id: ' + srUpdDocUpload.getId());
                return srUpdDocUpload.isSuccess();
            }else{
                System.debug('Failed to update status document upload error message: ' + srUpdDocUpload.getErrors());
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to status document upload error message: ' + e.getMessage());
            return false;
        }
	}

	@AuraEnabled(cacheable=true)
    public static String getLoginURL(){
        String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        User userRecord = [Select Id, AccountId, ContactId FROM User Where Id = :UserInfo.getUserId()];
        if(userRecord.ContactId != null){
            baseUrl = getExperienceURL();
        }
        return baseUrl;
    }

    public static String getExperienceURL(){
        String baseUrl = Network.getLoginUrl(Network.getNetworkId());
        baseURL =  baseURL.replace('/s/login', '');
        baseURL =  baseURL.replace('/s/Login', '');
        baseURL =  baseURL.replace('/login', '');
        baseURL =  baseURL.replace('/Login', '');
        return baseURL;
    }
}