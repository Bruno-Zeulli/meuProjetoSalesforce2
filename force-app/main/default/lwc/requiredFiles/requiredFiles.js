import { LightningElement, api, wire, track } from 'lwc';
import getDocumentsChecklist from '@salesforce/apex/UploadDocumentController.getDocumentsChecklist';
import getFilesByObject from '@salesforce/apex/UploadDocumentController.getFilesByObject';
import  { uploadFiles, formatosAceitos, sendData, verifyExceedLimitSizeFiles, sendDocumentForAPI } from 'c/fileUtil';

export default class RequiredFiles extends LightningElement {
    @api
    recordid;

    @track
    loader = false;
    filesChecklistList = [];
    value;
    requireds = [];
    isOnline = true;
    tipoDocumento = '';

    todosItemsChecklist = [];

    connectedCallback(){
        this.getDocumentsChecklist();
    }

    alternarLoader(){
        this.loader = !this.loader;
    }

    async handleUploadFinished(event){
        this.alternarLoader();
        const uploadedFiles = event.detail.files;

        uploadFiles(uploadedFiles, this.recordid, this)
            .then((result) => {
                this.filterChecklist(this.value);
            })
            .catch((error) => {
                throw new Error(error);
            });
    }

    handleChangeFile(event){
        event.preventDefault();
        this.alternarLoader();
        let files = event.target.files;
        this.tipoDocumento = event.target.name;
        sendDocumentForAPI(files, this.recordid, this)
        .then(data => {
            this.ajustarRetornoDocs(data);
            this.alternarLoader();
            this.filterChecklist(this.tipoDocumento);
            return false;
        })
        .catch(error => {
            this.isOnline = false;
            this.alternarLoader();
            return false;
        })
        return false;
    }

    @api filterChecklist(value){
        this.filesChecklistList = this.filesChecklistList.filter((requiredFile) => {
            return requiredFile.documentType != value;
        });
    }

    @api filterChecklistByDelete(termo, lista){
        
        let arquivoEhObrigatorio = this.todosItemsChecklist.find(itemChecklist => itemChecklist.documentType == termo);

        if(arquivoEhObrigatorio){
            console.log('arquivoEhObrigatorio ==>' );
            let listaPossuiArquivoDoTipo = lista.filter(arquivo => arquivo.type == termo);
            console.log('listaPossuiArquivoDoTipo =>',listaPossuiArquivoDoTipo.length == 0);

            if(listaPossuiArquivoDoTipo.length == 0){
                this.filesChecklistList = JSON.parse(JSON.stringify(this.filesChecklistList));

                let checklistPossuiEstaRegra = this.filesChecklistList.filter(checklist => checklist.documentType == arquivoEhObrigatorio.documentType);

                console.log('checklistPossuiEstaRegra ==>', checklistPossuiEstaRegra.length == 0);

                if(checklistPossuiEstaRegra.length == 0){
                    this.filesChecklistList.push(arquivoEhObrigatorio);
                }

                
            }

            
        }
    }

    getValueType(event){
        this.value = event.target.name;
    }
    get acceptedFormats(){
        formatosAceitos();
    }

    ajustarRetornoDocs(data){
        this.disparaEvent(data);
    }

    disparaEvent(data){
        const selectedEvent = new CustomEvent('getdocumentlist', {
            detail: data
        });
        this.dispatchEvent(selectedEvent);
    }

    get showDocuments(){
        return this.filesChecklistList.length > 0;
    }

    @api getDocumentsChecklist(){
        this.alternarLoader();
        getDocumentsChecklist({
            recordId: this.recordid
        })
            .then((data) => {
                this.alternarLoader();
                this.requireds = Object.keys(data).map((item) => JSON.parse(data[item]));
                this.getFilesByObject(data);
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.alternarLoader();
            });
    }

    getFilesByObject(){
        getFilesByObject({
            recordId: this.recordid
        })
            .then((data) => {
                let files = Object.keys(data).map((item) => JSON.parse(data[item]));

                let lstCheckList = [];

                for(let requiredFile of this.requireds){
                    let possuiObrigatorio = false;
                    for(let file of files){
                        if(file.type != undefined && file.type == requiredFile.documentType){
                            possuiObrigatorio = true;
                        }
                    }

                    if(!possuiObrigatorio) lstCheckList.push(requiredFile);
                }

                this.filesChecklistList = [].concat(lstCheckList);
                this.todosItemsChecklist = this.filesChecklistList;
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
            });
    }
}