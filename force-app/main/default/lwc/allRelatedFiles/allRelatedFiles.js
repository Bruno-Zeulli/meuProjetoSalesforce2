import { api, LightningElement, track, wire, } from 'lwc';
import relateFilesToRecords  from '@salesforce/apex/UploadDocumentController.relateFilesToRecords'
import sendFiles  from '@salesforce/apex/UploadDocumentController.sendFiles'
import {NavigationMixin} from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountRelatedFiles from '@salesforce/apex/UploadDocumentController.getAccountRelatedFiles'
import getPickListValuestipoDocumentos from '@salesforce/apex/UploadDocumentController.getPickListValuestipoDocumentos';
import getFileURL from '@salesforce/apex/UploadDocumentController.getFileURL';

export default class AllRelatedFiles extends  NavigationMixin(LightningElement){
    @api
    get fileslist(){
        return this._filesList || [];
    }
    set fileslist(value){
        this._filesList = value;
        this.filteredFilesList = value;
    }
    _filesList = [];
    filteredFilesList = [];
    @api recordid;
    @track Integrado = false;
    @track urlFileLink = '';
    @track loader = false;
    @track value = 'Documento 2';
    link = '';
    relateDocumentModalClass = 'relateDocumentModal';
    options = [{label: 'Todos', value:'all'}];
    selectedValue = 'all';

    getPickListValuestipoDocumentos(){
        getPickListValuestipoDocumentos({})
            .then((data) => {
                let arrayDocumentos = [{label: 'Todos', value:'all'}];
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

    handleChange(event){
        const option = event.detail.value;
        console.log(option);
        if (option === 'all'){
            this.filteredFilesList = this.fileslist;
        } else {
            this.filteredFilesList = this.fileslist.filter(e => e.type === option);
        }
    }

    connectedCallback(){
        this.getFileURL();
        this.getPickListValuestipoDocumentos();
    }

    ajustarRetornoDocs(data){
        this.fileslist = [];

        let fileslist = Object.keys(data).map(item => (JSON.parse(data[item])));

        for(let file of fileslist){
            file.isIntegrated = true;
        }
        this.fileslist = fileslist;
        this.fileslist.forEach(e => {
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

    alternarLoader(){
        this.loader = !this.loader;
    }

    get showDocuments(){
        return this.fileslist.length > 0;
    }

    previewHandler(event){
        this[NavigationMixin.Navigate]({
            type:'standard__namedPage',
            attributes:{
                pageName:'filePreview'
            },
            state:{
                selectedRecordId: event.target.dataset.id
            }
        })
    }

    getFileURL(){
        return new Promise((resolve, reject) => {
            getFileURL({})
                .then(async (url) => {
                    this.urlFileLink = url;
                    console.log('this.urlFileLink ==> ', this.urlFileLink);
                    resolve(url);
                    return false
                })
                .catch(error =>  reject(error))
        })
            
    }

    removerObjetoListaDocumentos(value){
        this.fileslist = this.fileslist.filter(item => item.id != value)
    }

    sendFiles(){
        sendFiles({
        recordId: this.recordid
        })
        .then((result) => {

            if(result == true){
                this.Integrado = true;
                this.updateList();
                this.showToast('Envio de arquivos processado...', 'Todos os arquivos foram integrados!','success');
            }else{
                this.showToast('Envio de arquivos processado...', 'Não foram localizados arquivos que necessitam de envio ao repositório de arquivos.', 'warning');
            }

        }).catch(error => console.log(error));

    }

    saveContent(fileContents, fileName){
        const link = document.createElement('a');
        link.download = fileName;
        link.href = fileContents;
        link.click();
    }

    async downloadFile(event){
        this.loader = true;
        
         try{
            event.preventDefault();
            let files = JSON.parse(JSON.stringify(this.fileslist));
            let originalURL = event.currentTarget.dataset.name;
            let specifiedFile = files.find(file => file.url == originalURL);
            let filename = specifiedFile.name;
            let contentType = specifiedFile.contentType;
            let data = await this.getFileBase64WithName(originalURL, filename);
            
            if(data.fileContents != null && contentType != null){
                await this.downloadBase64File(contentType, data.fileContents, filename);
            } else{
                await this.saveContent(originalURL, filename);
            }  

            this.loader = false;
        
        } catch (e){
            console.log(e);
            this.loader = false;
        }
    };

    downloadBase64File(contentType, base64Data, fileName){
        const linkSource = `data:${contentType};base64,${base64Data}`;
        const downloadLink = document.createElement("a");
        downloadLink.href = linkSource;
        downloadLink.download = fileName;
        downloadLink.click();
    }

    async getFileBase64WithName(url, filename){
        return new Promise ((resolve, reject) => {
            console.log('url ==>', this.urlFileLink);
            let _data = {
                "url": url,
                "name": filename
            }
        fetch(this.urlFileLink, {
            method: "POST",
            body: JSON.stringify(_data),
            headers: {"Content-type": "application/json; charset=UTF-8"}
        })
        .then(response =>  response.json()) 
        .then(json => resolve(json));
        })
    }

    updateList(event){
        getAccountRelatedFiles({
            recordId: this.recordid
        })
        .then((data) => {
            this.ajustarRetornoDocs(data);
        })
        .catch(error => console.log(error));
    }

    disparaEvent(){
        const selectedEvent = new CustomEvent("updatelist", {
            detail: ''
        });
        this.dispatchEvent(selectedEvent);
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }

    get relateDocumentModal(){
        return this.template.querySelector('.' + this.relateDocumentModalClass);
    }

    currentFileId = '';
    relateHandler(event){
        this.currentFileId = event.target.dataset.id;
        this.relateDocumentModal.open();
    }

    async handleRelateDocumentSave(event){
        let newRecords = [];
        if(this.accountSelectedRecord){
            newRecords.push({
                recordId: this.accountSelectedRecord.id,
                objectName: 'Account'
            });
        }
        if(this.opportunitySelectedRecord){
            newRecords.push({
                recordId: this.opportunitySelectedRecord.id,
                objectName: 'Opportunity'
            });
        }
        if(this.quoteSelectedRecord){
            newRecords.push({
                recordId: this.quoteSelectedRecord.id,
                objectName: 'Quote'
            });
        }
        if(this.orderSelectedRecord){
            newRecords.push({
                recordId: this.orderSelectedRecord.id,
                objectName: 'Order'
            });
        }
        if (newRecords.length > 0){
            try{
                this.loader = true;
                await relateFilesToRecords({fileId: this.currentFileId, newRecords: newRecords});
                await this.updateList();
                this.loader = false;
            } catch(ex){
                console.log(ex)
            }
        }
        this.closeModal();
    }

    closeModal(){
        this.accountSelectedRecord = null;
        this.opportunitySelectedRecord = null;
        this.quoteSelectedRecord = null;
        this.orderSelectedRecord = null;
        this.relateDocumentModal.close();
    }

    accountSelectedRecord;
    handleValueSelectedOnAccount(event) {
        this.accountSelectedRecord = event.detail;
        console.log(event.detail);
    }
    opportunitySelectedRecord;
    handleValueSelectedOnOpportunity(event) {
        this.opportunitySelectedRecord = event.detail;
        console.log(event.detail);
    }
    quoteSelectedRecord;
    handleValueSelectedOnQuote(event) {
        this.quoteSelectedRecord = event.detail;
        console.log(event.detail);
    }
    orderSelectedRecord;
    handleValueSelectedOnOrder(event) {
        this.orderSelectedRecord = event.detail;
        console.log(event.detail);
    }

    handleNavigation(event){
        console.log(event.target.dataset.id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.id,
                actionName: 'view',
            }
        });
    }
}