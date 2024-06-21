import { api, LightningElement } from 'lwc';
import getDocumentsChecklist from '@salesforce/apex/UploadDocumentController.getDocumentsChecklist';
import getDocumentUpload from '@salesforce/apex/UploadDocumentController.getFilesByObject';

const exceptionDocument = [
    'Estudo de Mercado'
];

export default class ConnectWizDocumentChecklist extends LightningElement {
    @api recordId;
    @api showViewFiles;
    @api showFullView;
    @api showButtonDisapproveFile;
    @api showButtonViewFile;
    @api showButtonApproveFile;
    @api showNotFoundChecklistRequired;
    @api showNotFoundChecklistOptional;
    showTitle = true;
    loader = false;
    lDocChecklistRequired=[];
    lDocChecklistOptional=[];
    lTempDocChecklistOptional=[];
    lAllDocChecklist=[];

    isLoading = false;

    connectedCallback(){
        this.alternarLoader();
        this.getDocumentsChecklist();
    }

    alternarLoader(){
        this.isLoading = !this.isLoading;
        console.log('this.isLoading', this.isLoading);
    }

    getDocumentsChecklist(){
        getDocumentsChecklist({
            recordId: this.recordId
        })
            .then( async (data) => {
                this.lAllDocChecklist = Object.keys(data).map((item) => JSON.parse(data[item]));
                let lDocChecklist = this.lAllDocChecklist;
                this.lDocChecklistRequired = lDocChecklist.filter(item => {
                    return item.required.includes('Sim');
                })

                if(this.lDocChecklistRequired.length <= 0){
                    this.showNotFoundChecklistRequired = true;
                } else{
                    this.showNotFoundChecklistRequired = false;
                }

                console.log('lDocChecklistRequired', this.lDocChecklistRequired);

                this.lTempDocChecklistOptional = lDocChecklist.filter(item => {
                    return item.required.includes('Não');
                })
               await this.getDocumentUpload();
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.alternarLoader();
            });
    }

    async getDocumentUpload(){
        getDocumentUpload({
            recordId : this.recordId
        })
        .then(async result => {
            try{
                await this.getFilesType(Object.keys(result).map((item) => JSON.parse(result[item])));
            }catch(error){
                console.log('error =>',error);
                this.alternarLoader();
            }
        })
        .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.alternarLoader();
            });
    }

    async getFilesType(lFiles){

        try{
            let lTempOptionalDocFiles = this.lTempDocChecklistOptional;
            let mapDocType = new Map();
            let lDocChecklist = [];

            this.lAllDocChecklist.forEach(item => {
                lDocChecklist.push(item.documentType);
            });

            lFiles =  lFiles.filter(item => {
                return !item.type.includes(exceptionDocument);
            });

            lFiles.forEach(item => {
                if(!lDocChecklist.includes(item.type)){
                    mapDocType.set(item.type, item.type);
                }
            });

            let lDocTypeToAdd = [...mapDocType.values()];

            lDocTypeToAdd.forEach(item => {
                let objDocUpload = {
                    documentType : item,
                    id : item
                }
                lTempOptionalDocFiles.push(objDocUpload);
            });

            this.lDocChecklistOptional = lTempOptionalDocFiles;

            if(this.lDocChecklistOptional.length <= 0){
                this.showNotFoundChecklistOptional = true;
            } else{
                this.showNotFoundChecklistOptional= false;
            }

            this.alternarLoader();
            this.sendFilesToParent(lFiles);
        }catch(error){
            console.log('error =>',error);
            this.alternarLoader();
        }
    }

    sendFilesToParent(lFiles){
        console.log('Passou aqui', lFiles);
        const selectedEvent = new CustomEvent("getfiles", {
            detail: lFiles
        });
        this.dispatchEvent(selectedEvent);
    }

    changeStatusEvent(event){
        this.connectedCallback();
    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleRefresh(){
        this.onRefresh();
        const selectedEvent = new CustomEvent("refresh");
        console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
    }
}