import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDocumentUpload from '@salesforce/apex/UploadDocumentController.getFilesByObject';
import getOpportunityByCaseId from '@salesforce/apex/ConnectWizMonitoringController.getOpportunityByCaseId';

const exceptionDocument = [
    'Estudo de Mercado'
];
export default class ConnectWizDocumentsAccordionItem extends LightningElement {
    @api caseId;
    opportunityId;
    recordId;
    @track lFiles=[];
    showViewFiles = true;
    showFullView = true;
    showButtonDisapproveFile = true;
    showButtonViewFile = true;
    showButtonApproveFile = true;
    isComplete = false;
    hasDisapproved = false;
    isOpen=false;
    isRendered = false;
    showNotFoundChecklistRequired = false;
    showNotFoundChecklistOptional = false;

    connectedCallback(){
        this.retrieveOpportunity();
    }

    async retrieveOpportunity(){
        await getOpportunityByCaseId({caseId : this.caseId}).then(result => {
            console.log('backend getOpp' + JSON.stringify(result));
            this.opportunityId = result.Id;
            this.recordId = this.opportunityId;
            console.log('OppID' + this.opportunityId);

            this.getDocumentUpload();
        })
        .catch(error =>{
            console.log('Deu errado getOpp' + JSON.stringify(error));
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
        });
    }

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    async getDocumentUpload(){
        getDocumentUpload({
            recordId : this.recordId
        })
        .then(result => {
            try{
                this.handleTagStatus(Object.keys(result).map((item) => JSON.parse(result[item])));
            }catch(error){
                console.log('error =>',error);
            }
        })
        .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
            });
    }

    async getFiles(event){
       this.lFiles=event.detail;

       this.handleTagStatus(JSON.parse(JSON.stringify((this.lFiles))));

    }

    async handleTagStatus(lFiles){

         lFiles =  lFiles.filter(item => {
            return !item.type.includes(exceptionDocument);
        });

        let lFilesAccepted = lFiles.filter(item => {
            return item.status.includes('Accepted');
        });

        let lFilesRefused = lFiles.filter(item => {
            return item.status.includes('Refused');
        });

        if(lFilesRefused.length > 0 ){
            this.isComplete = false;
            this.hasDisapproved = true;
        } else if(lFilesAccepted.length == lFiles.length && lFilesAccepted.length > 0){
            this.isComplete = true;
            this.hasDisapproved = false;
        } else{
            this.isComplete = false;
            this.hasDisapproved = false;
        }

        console.log('this.isComplete =>', this.isComplete);
        console.log('this.hasDisapproved =>', this.hasDisapproved);
        console.log('this.hasNewFiles =>', this.hasNewFiles);

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
        // console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
    }
}