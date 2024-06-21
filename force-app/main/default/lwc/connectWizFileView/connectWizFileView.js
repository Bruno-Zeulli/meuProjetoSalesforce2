import { api, LightningElement, track, wire } from 'lwc';
import getDocumentUpload from '@salesforce/apex/UploadDocumentController.getFilesByObject';
import getFileURL from '@salesforce/apex/UploadDocumentController.getFileURL';
import {NavigationMixin} from 'lightning/navigation';
import deleteFile  from '@salesforce/apex/UploadDocumentController.deleteDoc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateStatusFile from '@salesforce/apex/UploadDocumentController.updateStatusFile';
import updateStageOpportunity from '@salesforce/apex/ConnectWizController.updateStageOpportunity';


export default class ConnectWizFileView extends NavigationMixin(LightningElement){
    @api recordId;
    @api documentTypeName;
    @api showTitle;
    @api showButtonViewFile;
    @api showButtonDeleteFile;
    @api showButtonDisapproveFile;
    @api showButtonApproveFile;
    @api showSimpleView;
    @api showFullView;
    @track urlFileLink='';
    @track filesList=[];
    @track isRendered=false;
    allFiles=[];
    @track isLoading = false;
    @track loader = false;

    showDividingLine = false;

    
    async connectedCallback(){
        this.handleLoading(true);
        console.log('handleControlShowViewFile this.recordId' + this.recordId);
        await this.getDocumentUpload();
        this.getFileURL();
    }

    async getDocumentUpload(){
        this.handleLoading(true);
        getDocumentUpload({
            recordId : this.recordId
        })
        .then(async result => {
            try{
                this.getFiles(result);
                this.handleLoading(false);
            }catch(error){
                console.log('error =>',error);
                this.handleLoading(false);
            }
        })
        .catch(error => console.log(error));
        this.handleLoading(false);
    }

    async downloadFile(event){
        this.handleLoading(true);

         try{
            event.preventDefault();
            let files =  JSON.parse(JSON.stringify(this.filesList));
            let originalURL = event.currentTarget.dataset.name;
            console.log('originalURL ', originalURL);
            let specifiedFile = files.find(file => file.url == originalURL);
            let filename = specifiedFile.name;
            let contentType = specifiedFile.contentType;

            let data = await this.getFileBase64WithName(originalURL, filename);
            if(data.fileContents != null && contentType != null){
                await this.downloadBase64File(contentType, data.fileContents, filename);
            } else{
                await this.saveContent(originalURL, filename);
            }

            this.handleLoading(false);

        } catch (e){
            console.log(e);
            this.handleLoading(false);
        }
    };

    async deleteFile(event){
        this.handleLoading(true);
        let documentId = event.currentTarget.dataset.id;
        console.log('documentId', documentId);
        deleteFile({
            documentUploadId: documentId
        })
        .then( async () => {
            const selectedEvent = new CustomEvent("handledeletefile", {
            isDeleted: true
        });
        this.dispatchEvent(selectedEvent);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'success',
                    message: 'Arquivo deletado com sucesso',
                    variant: 'success'
                })
            );
            setTimeout(() => {
                this.getDocumentUpload();
            }, 1500);
        })
        .catch((error) => {
            console.log(`ERROR: ==> ${error}`);
            this.handleLoading(false);
        });
        this.handleLoading(false);
    }

    async disapproveFile(event){
        this.handleLoading(true);
        let documentId = event.currentTarget.dataset.id;
        let status = 'Refused';
        let massage = 'Status do arquivo atualizado para reprovado!'
        console.log('documentId', documentId);
        this.updateStatusFile(documentId, status, massage);


        if(this.recordId.startsWith('006')){
            this.updateStageOpportunity();
        }
        this.handleLoading(false);
    }

    async approveFile(event){
        this.handleLoading(true);
        let documentId = event.currentTarget.dataset.id;
        let status = 'Accepted';
        let massage = 'Status do arquivo atualizado para Aprovado!'
        console.log('documentId', documentId);
        this.updateStatusFile(documentId, status, massage);
        this.handleLoading(false);
    }

    async updateStatusFile(documentId, status, massage){
        this.handleLoading(true);
        updateStatusFile({
            documentUploadId: documentId,
            status: status
        })
        .then( async () => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'success',
                    message: massage,
                    variant: 'success'
                })
            );
            setTimeout(() => {
                this.getDocumentUpload();
            }, 1500);

            this.changeStatusEvent();
            this.onRefresh();
            this.handleRefresh();
            this.handleLoading(false);
        })
        .catch((error) => {
            console.log(`ERROR: ==> ${error}`);
            this.handleLoading(false);
        });
        this.handleLoading(false);
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
            }).then(
                response =>  response.json()).then(json => resolve(json));
        })
    }

    saveContent(fileContents, fileName){
        const link = document.createElement('a');
        link.download = fileName;
        link.href = fileContents;
        link.click();
        this.isUpdateFiles=true;
        this.handleLoading(false);
        this.isUpdateFiles=false;
    }

    downloadBase64File(contentType, base64Data, fileName){
        const linkSource = `data:${contentType};base64,${base64Data}`;
        const downloadLink = document.createElement("a");
        downloadLink.href = linkSource;
        downloadLink.download = fileName;
        console.log('downloadLink ', downloadLink);
        downloadLink.click();
        this.isUpdateFiles=true;
        this.handleLoading(false);
        this.isUpdateFiles=false;
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
        });
    }

    handleLoading(event){
        this.isLoading = event;
    }

    getFiles(result){
        this.handleLoading(true);
        let lFiles = Object.keys(result).map((item) => JSON.parse(result[item]));
        this.allFiles = lFiles;

        lFiles = lFiles.filter(item => {
            return item.contentVersionId === null
        });

        lFiles = lFiles.filter(item => {
            return item.type === this.documentTypeName
        });

        if(lFiles.length > 1){
            this.showDividingLine = true;
        }else{
            this.showDividingLine = false;
        }

        lFiles.forEach(item => {
            item.isAccepted = false;
            item.isRefused = false;
            item.isPending = false;
            item.isUnderReview = false;

            if(item.status == 'Accepted'){
                item.isAccepted = true;
                item.renameStatus = 'Documento aprovado';
                this.handleShowButtonsActions();
            }else if(item.status == 'Refused'){
                item.isRefused = true;
                item.renameStatus = 'Documento recusado';
                this.handleShowButtonsActions();
            }else if(item.status == 'Pending'){
                item.isPending = true;
                item.renameStatus = 'Documento pendente';
                this.handleShowButtonsActions();
            }else if(item.status == 'UnderReview'){
                item.isUnderReview = true;
                item.renameStatus =  'Documento em análise';
            }
        });

        this.updateRenderComponent();

        console.log('lFiles.length', lFiles.length);
        this.filesList = lFiles;
        if(lFiles.length === 0){
            setTimeout(() => {
                this.handleShowViewFile(false);
            }, 2000);
        }else{

            this.handleShowViewFile(true);

        }

        this.handleLoading(false);
        console.log('this.filesList', this.filesList);
    }

    updateRenderComponent(){
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       }, 1900);
    }

    handleShowButtonsActions(){
        this.showButtonDisapproveFile = false;
        this.showButtonApproveFile = false;
    }

    handleShowViewFile(value){
        const selectedEvent = new CustomEvent("handleshowviewfile", {
            detail: value
        });
        this.dispatchEvent(selectedEvent);

        const eventV2 = new CustomEvent("finish", {
            detail: {
                hasFiles: value,
                parentId: this.recordId
            }
        });
        this.dispatchEvent(eventV2);
    }

    updateStageOpportunity(){
        updateStageOpportunity({
            recordId : this.recordId,
            stageName : 'Cotação com pendência'
        }).then( async result => {
                if(result){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'success',
                            message: 'Status da oportunidade atualizado para com pendência',
                            variant: 'success'
                        })
                    );
                    this.onRefresh();
                    this.handleRefresh();
                } else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: ' Erro ao atualizar o status da oportunidade',
                            message: 'Houve um erro ao atualizar o status da oportunidade, tente novamente.',
                            variant: 'error',
                        }),
                    );
                }
            })
            .catch(error =>{
                let message = 'Unknown error';
                if(Array.isArray(error.body)){
                    message = error.body.map(e => e.message).join(', ');
                } else if(typeof error.body.message === 'string'){
                    message = error.body.message;
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading data',
                        message,
                        variant: 'error',
                    }),
                );
            });
    }

    changeStatusEvent(){
        let value = false;
        const selectedEvent = new CustomEvent("changestatusfile", {detail: value});
        this.dispatchEvent(selectedEvent);
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