import { api, LightningElement, track, wire, } from 'lwc';
import deleteDoc  from '@salesforce/apex/UploadDocumentController.deleteDoc'
import sendFiles  from '@salesforce/apex/UploadDocumentController.sendFiles'
import {NavigationMixin} from 'lightning/navigation'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFilesByObject from '@salesforce/apex/UploadDocumentController.getFilesByObject'
import getFileURL from '@salesforce/apex/UploadDocumentController.getFileURL';

export default class AllFiles extends  NavigationMixin(LightningElement){
    @api
    fileslist;
    @api recordid;
    @track Integrado = false;
    @track urlFileLink = '';
    @track loader = false;
    @track value = 'Documento 2';
    link = '';

    connectedCallback(){
        this.getFileURL();
    }

    ajustarRetornoDocs(data){
        this.fileslist = [];

        let fileslist = Object.keys(data).map(item => (JSON.parse(data[item])));

        for(let file of fileslist){
            file.isIntegrated = true;
        }
        this.fileslist = fileslist;
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

    deleteDoc(event){
        this.alternarLoader();
        let documentId = event.target.dataset.id;
        deleteDoc({
            documentUploadId: documentId
        })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'Arquivo deletado com sucesso',
                    variant: 'warning'
                })
            );
            this.displayEventDeleteDoc(documentId);
            this.alternarLoader();
        })
        .catch((error) => {
            console.log(`ERROR: ==> ${error}`);
            this.alternarLoader();
        });
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
        getFilesByObject({
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

        displayEventDeleteDoc(documentId){
        const selectedEvent = new CustomEvent("deletedoc", {
            detail: documentId
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
}