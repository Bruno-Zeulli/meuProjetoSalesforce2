import { LightningElement, api, wire, track } from 'lwc';
import getFilesByObject from '@salesforce/apex/UploadDocumentController.getFilesByObject';
import getAccountRelatedFiles from '@salesforce/apex/UploadDocumentController.getAccountRelatedFiles';
import { NavigationMixin } from 'lightning/navigation';
import getPickListValuestipoDocumentos from '@salesforce/apex/UploadDocumentController.getPickListValuestipoDocumentos';
import { showToast } from 'c/util';
import { uploadFiles, formatosAceitos, sendData, verifyExceedLimitSizeFiles, sendDocumentForAPI } from 'c/fileUtil';

export default class UploadFile extends NavigationMixin(LightningElement){
    filesList = [];
    filesRelatedList = [];

    @track
    loader = false;
    options = [];
    isOnline = true;

    @api
    recordId;

    @api accountRelatedDocs = false;

    tipoDocumento = 'Material Digital';

 /*    @wire(getFilesByObject, {
        recordId: '$recordId'
    })
    wiredResult({ data, error }){
        if(data){
            this.ajustarRetornoDocs(data);
        }
        if(error){
            console.log(error);
        }
    } */

    async connectedCallback(){
        this.loader = true;
        await this.getFilesByObject();
        if (this.accountRelatedDocs){
            await this.getAccountRelatedFiles();
        }
        this.getPickListValuestipoDocumentos();
    }

    async getFilesByObject(){
        getFilesByObject({
            recordId : this.recordId
        })
        .then(async result => {
            try{
                this.ajustarRetornoDocs(result);
            }catch(error){
                console.log('error =>',error);
                this.loader = false;
            }
        })
        .catch(error => console.log(error));
        this.loader = false;
    }

    async getAccountRelatedFiles(){
        getAccountRelatedFiles({
            recordId : this.recordId
        })
        .then(async result => {
            try{
                this.ajustarRetornoDocsAccountRelated(result);
            }catch(error){
                console.log('error =>',error);
                this.loader = false;
            }
        })
        .catch(error => console.log(error));
        this.loader = false;
    }

    getPickListValuestipoDocumentos(){
        getPickListValuestipoDocumentos({})
            .then((data) => {
                let arrayDocumentos = [];
                if(data.length > 0){
                    for(let result of data){
                        arrayDocumentos.push({ label: result, value: result });
                    }
                    this.options = arrayDocumentos;
                    this.loader = false;
                }

                this.loader = false;
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                showToast('Erro', 'Ocorreu um erro!', 'error', this);
                this.loader = false;
                throw new Error(error);
            });
    }

    ajustarRetornoDocs(data){
        this.filesList = Object.keys(data).map((item) => JSON.parse(data[item]));
    }

    ajustarRetornoDocsAccountRelated(data){
        this.filesRelatedList = Object.keys(data).map((item) => JSON.parse(data[item]));
        this.filesRelatedList.forEach(e => {
            const objPrefix = e.recordId.substring(0,3).toUpperCase();
            switch (objPrefix) {
                case '006':
                    e.recordType = 'Oportunidade';
                    break;
                case '0Q0':
                    e.recordType = 'Cotação';
                    break;
                case '801':
                    e.recordType = 'Pedido';
                    break;
                case '500':
                    e.recordType = 'Caso';
                    break;
                default:
                    e.recordType = 'Registro';
                    break;
            }
        });
    }

    getDocumentList(event){
        let documento = JSON.parse(JSON.stringify(event.detail));
        this.renderFile(documento);
    }

    alternarLoader(){
        this.loader = !this.loader;
    }

    handleChange(event){
        this.tipoDocumento = event.detail.value;
    }

    get acceptedFormats(){
        formatosAceitos();
    }

    async handleUploadFinishedOffline(event){

        const uploadedFiles = event.detail.files;


        let verifyExceedLimitSizeFilesBool = await verifyExceedLimitSizeFiles(uploadedFiles, this);


        if(!verifyExceedLimitSizeFilesBool){
            uploadFiles(uploadedFiles, this.recordId, this)
                .then((result) => {
                    this.template.querySelector('c-required-files').filterChecklist(this.tipoDocumento);
                })
                .catch((error) => {
                    throw new Error(error);
                });
        }else{
            showToast('Erro', 'Os arquivo(s) não podem exceder o tamanho de 2.5MB offline!', 'error', this);
            this.alternarLoader();
        }
      
    }

    removerObjetoListaDocumentos(documentid){
        this.filesList = this.filesList.filter((item) => item.id != documentid);
    }

    deleteDoc(event){
        let id = JSON.parse(JSON.stringify(event.detail));
        let documento = this.filesList.find((item) => item.id == id);
        this.removerObjetoListaDocumentos(id);
        this.template.querySelector('c-required-files').filterChecklistByDelete(documento.type, this.filesList);
    }

    handleChangeFile(event){
        event.preventDefault();
        this.alternarLoader();
        let files = event.target.files;
        sendDocumentForAPI(files, this.recordId, this)
        .then(async data => {
            try{
                    this.filesList = JSON.parse(JSON.stringify(this.filesList));
                    let arquivo = await this.renderFile(data);
                    this.template.querySelector('c-required-files').filterChecklistByDelete(arquivo.type, this.filesList);
                    
            }catch(error){
                console.log(error)
                showToast('Erro', 'Erro para exibir arquivo, porem foi adicionado.', 'error', this);
            }
            this.alternarLoader();
            return false;
        })
        .catch(error => {
            this.isOnline = false;
            this.alternarLoader();
            return false;
        })
        return false;
    }

    createFile(data){
           let fields = data.fields;
            
           let file = {
            id: data.id,
            type: fields.DocumentType__r.displayValue,
            name: fields.Name.value,
            status: fields.Status__c.value,
            url: fields.ExternalUrl__c.value,
            hasPreview: false,
            dataCriacao: fields.CreatedDate.displayValue,
            isIntegrated: true
        }

        return file;
    }

    async renderFile(data){

        let arquivo = this.createFile(data);
        this.pushFileForList(arquivo);
        return arquivo;

       
    }


    pushFileForList(arquivo){
         this.filesList = JSON.parse(JSON.stringify(this.filesList));
         this.filesList.push(arquivo);
    }
    
}