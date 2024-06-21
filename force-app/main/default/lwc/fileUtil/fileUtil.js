import uploadDocuments from '@salesforce/apex/UploadDocumentController.uploadDocuments';
import verifyExceedLimitSize from '@salesforce/apex/UploadDocumentController.verifyExceedLimitSize';
import { showToast } from 'c/util';
import getToken from '@salesforce/apex/UploadDocumentController.getToken';
import getPersonInformation from '@salesforce/apex/UploadDocumentController.getPersonInformation';
import generateDocumentWithAPISucess from '@salesforce/apex/UploadDocumentController.generateDocumentWithAPISucess';
import sendOpportunityCorporateForAPI from '@salesforce/apex/UploadDocumentController.sendOpportunityCorporateForAPI';
import { createRecord } from 'lightning/uiRecordApi';
import DOCUMENT_UPLOAD_OBJECT from '@salesforce/schema/DocumentUpload__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let uploadFiles = (uploadedFiles, recordId, scope) => {
    return new Promise(
        (resolve, reject) => {
        uploadDocuments({
            lstDocumentos : JSON.stringify(uploadedFiles),
            IdObjeto: recordId,
            tipoDocumento: scope.tipoDocumento
        })
            .then((data) => {
                    scope.ajustarRetornoDocs(data);
                    showToast('Sucesso', 'Arquivo(s) inserido(s) com sucesso!', 'success', scope);
                    scope.alternarLoader();
                    resolve(true);
                    return false

            })
            .catch((error) => {
                    console.log(`ERROR: ==> ${error}`)
                    scope.alternarLoader();
                    reject(error);
                    return false;
            });
        }
    )
}

let verifyExceedLimitSizeFiles = (uploadedFiles, scope) => {
      return new Promise(
          (resolve, reject) => {
            verifyExceedLimitSize({
                lstDocumentos : JSON.stringify(uploadedFiles)
            })
            .then((data) => {
                    resolve(data);
                    return false

           })
           .catch((error) => {
                    reject(error);
                    return false;
          });
          }
      )
}


let formatosAceitos = () => {
    return ['.pdf', '.png'];
}

let createFormData = (file, personInformation) => {
     let pessoa = personInformation.pessoa[0];
     let formData  = new FormData();
     formData.append("Arquivo", file);
     formData.append("IdTipoArquivo", parseInt(personInformation.tipoDocumento));
     formData.append("DesCaminho", personInformation.path);
     formData.append("Pessoa[0].documento", pessoa.documento);
     formData.append("Pessoa[0].tipoPessoa",pessoa.tipoPessoa);
     formData.append("Pessoa[0].desCaminho", pessoa);
    console.log('formData ==>'+ formData);
    return formData;
}


let sendDocumentForAPI = (files, recordId, scope) => {
    return new Promise(async (resolve, reject) => {
        try{
            let tokenAPI = await getTokenWFLOW();
            let personInformation = await getInformation(recordId, scope);
            personInformation = JSON.parse(personInformation);
            let urlPOSTDocumentos = personInformation.url;
            scope.isOpportunityOFCorporate = personInformation.isOpportunityOFCorporate;
            let myHeaders = await getHeaders(tokenAPI);

            console.log('personInformation ==>',personInformation);

            if(files.length > 0){
                for(let file of files){
                    console.log('file =>', file);

                    let formData  = createFormData(file, personInformation);

                    calloutAPIDocumentos(urlPOSTDocumentos, myHeaders, formData, recordId, scope)
                    .then((data) => {
                        resolve(data);
                        // updateRenderComponent();
                        return false;
                    })
                    .catch((error) => {
                        errorCallDocuments(scope, error);
                        reject(error);
                        return false;
                    })
                }
            }
        }
        catch (error){
            errorCallDocuments(scope, error);
            reject(error);
            return false;

        }
    });
}

let getHeaders = (token) => {
    var myHeaders = {
        "Authorization": "Bearer "+ token,
        'Accept': '*/*',
        "strict-transport-security": "max-age=31536000; includeSubDomains"
    };
    return myHeaders;
}

let calloutAPIDocumentos = (url, myHeaders, formData, recordId, scope) => {
    return new Promise((resolve, reject) => {
        console.log('call api documentos...');
        let requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formData,
            redirect: 'follow'
        };

        try{
            fetch(url, requestOptions)
                .then(response => response.text())
                    .then(result => {
                        createDocument(result, recordId, scope)
                            .then(result => {
                                console.log('scope.isOpportunityOFCorporate ==', scope.isOpportunityOFCorporate);

                                // Caso seja Oportunidade da corporate, salvar o doc na outra API
                                if(scope.isOpportunityOFCorporate){
                                    sendOpportunityCorporate(result);
                                }
                                resolve(result);
                                    return false;
                            })
                            .catch(error => {
                                reject(error);
                                return false;
                        });
                })
                .catch(error => {
                    reject(error);
                    return false;
                });
        }catch (error){
            reject(error);
            return false;
        }
    });
}

let sendOpportunityCorporate = (result) => {
    result = JSON.parse(JSON.stringify(result));
    console.log('result ==>', result.id);

    sendOpportunityCorporateForAPI(
        {documentUploadId: result.id}
    );
}

let calloutAPIOpportunityCorporate = (url, tokenAPI, data) => {
    return new Promise((resolve, reject) => {
        console.log('call api opp saveDB...')
        let myHeaders = getHeaders(tokenAPI);

        let requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: data,
            redirect: 'follow'
        };

        fetch(url, requestOptions)
            .then(response => response.text())
                .then(result => {
                    console.log('inseri aquela budega ==>'+result);
                    resolve(result);
                    return false
            })
            .catch(error => {
                reject(error);
                return false;
            });
    })
}

let getTokenWFLOW = () => {
    return new Promise((resolve, reject) => {
        getToken()
        .then(async (token) => {
            resolve(token)

            return false
        })
        .catch(error => {
            reject(error);
            return false;
        })
    })

}

let getInformation = (recordId, scope) => {
    return new Promise((resolve, reject) => {
        getPersonInformation({
            recordId: recordId,
            tipoArquivo: scope.tipoDocumento
        })
        .then(async (information) => {
            resolve(information)
            return false
        })
        .catch(error =>  reject(error))
    })

}

let createDocument = (retorno, recordId, scope) => {
    return new Promise((resolve, reject) => {
        generateDocumentWithAPISucess(
            {
                retorno: retorno,
                recordId: recordId,
                tipoArquivo: scope.tipoDocumento
            }
        )
        .then(async (information) => {
            let documentUpload = JSON.parse(information);
            delete documentUpload.attributes;

            let fields = {
                        Name : documentUpload.Name,
                        DocumentType__c : documentUpload.DocumentType__c,
                        IdObjeto__c : documentUpload.IdObjeto__c,
                        Objects__c : documentUpload.Objects__c,
                        ExternalUrl__c : documentUpload.ExternalUrl__c,
                        ExternalReferenceId__c : documentUpload.ExternalReferenceId__c,
                        Status__c : 'UnderReview'
            };
            const recordInput = { apiName: DOCUMENT_UPLOAD_OBJECT.objectApiName, fields };
            createRecord(recordInput)
                .then(document => {
                    showToast('Sucesso', 'Arquivo(s) inserido(s) com sucesso!', 'success', scope);
                    resolve(document);
                    //scope.updateRenderComponent();
                    //scope.handleLoading(false);
                    return false;
                })
                .catch(error => {
                    errorCallDocuments(scope, error);
                    reject(error);
                    return false;
                });
        })
        .catch(error => {
            errorCallDocuments(scope, error);
            reject(error);
            return false;
        })
    })
}

let errorCallDocuments = (scope, error) => {
    console.log('error ==>', error);
    showToast('Erro', 'Ocorreu um erro ao inserir o(s) arquivo(s)! Coloque offline por hora.', 'error', scope);
}

const updateRenderComponent = () => {
    setTimeout(() => {
        eval("$A.get('e.force:refreshView').fire();");
    }, 1000);
}

export { formatosAceitos, uploadFiles, verifyExceedLimitSizeFiles,sendDocumentForAPI }