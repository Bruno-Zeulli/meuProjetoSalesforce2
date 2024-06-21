import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
// import { isNarrow, proto, isBase } from './fileUploadUtil';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTaskHistory from '@salesforce/apex/ConnectWizController.createTaskHistory'
import updateCaseFromPlacement from '@salesforce/apex/ConnectWizController.updateCaseFromPlacement'

// import uploadFileInChunks from '@salesforce/apex/FileUploadController.uploadFileInChunks';
// import displayUploadedFiles from '@salesforce/apex/AWSFileUploadController.displayUploadedFiles';
// import userCurrentId from '@salesforce/user/Id'

const recordTypeOptions = ['Comentário','Pendência']

export default class ConnectWizRegisterHistoryModal extends NavigationMixin(LightningElement){
    @api recordId; //get the recordId for which files will be attached
    @api opportunityId;
    @api parentRecordId;
    @api contactOrLeadId;
    @api accountId;
    @track userSelectedType;
    @track userSelectedDescription;
    recordTypeOptions = recordTypeOptions;
    showRegisterHistoryModal;
    openModalRegisterHistory = true;

    isLoading = false;
    isRendered = false;
    showDragbox = false;

    constructor(){
        super();
    }

    sendCloseModalToParent(){
        const selectedEvent = new CustomEvent("sendclosemodaltoparent", {
            detail: false
        });
        this.dispatchEvent(selectedEvent);
    }
    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleSelectCloseModal(){
        this.sendCloseModalToParent();
        this.onRefresh();
        // this.updateRecordView();
    }

    handleLoading(event){
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }

    async connectedCallback(){
        this.handleLoading(true);
        console.log(this.parentRecordId);
        if(this.parentRecordId){
            this.recordId = this.parentRecordId;
        }
    }

    // renderedCallback(){
    //     if(this.eventListenersAdded){
    //         return;
    //     }

    //     this.eventListenersAdded = true;
    //     this.registerEvents();
    // };

    @api async getRegisterHistory(recordId, opportunityId, accountId, contactOrLeadId){
        this.openModalRegisterHistory = true;
        this.recordId = recordId;
        this.opportunityId = opportunityId;
        this.accountId = accountId;
        this.contactOrLeadId = contactOrLeadId;
        await this.getListRecordTypes();
        this.handleLoading(false);
    }

    async getListRecordTypes(){
        try{
            // console.log(recordTypeOptions);
            if(this.openModalRegisterHistory){
                // console.log('lst => ', this.template.querySelector('[data-id="recordList"]'));
                let lst = this.template.querySelector('[data-id="recordList"]');

                this.recordTypeOptions.forEach(
                    item => {
                        let option = document.createElement("option");
                        option.setAttribute('value', item);
                        let optionText = document.createTextNode(item);
                        option.appendChild(optionText);

                        lst.appendChild(option);
                    });

            }

            this.handleLoading(false);
        }catch(error){
            console.log('error =>',error);
            this.handleLoading(false);
        }
    }


    handleSelectToRegister(){
        this.handleLoading(true);
        if(this.userSelectedType !== undefined &&
                this.userSelectedType !== null &&
                this.userSelectedDescription !== undefined &&
                this.userSelectedDescription !== null
            ){
            this.openModalRegisterHistory = false;
            if(this.userSelectedType === 'Pendência'){
                this.updateCaseFromPlacement();
            }
            this.createTaskHistory();
        }
        this.handleLoading(false);
    }

    // updateRecordView(){
    //    setTimeout(() => {
    //     console.log('Dentro do reload')
    //         eval("$A.get('e.force:refreshView').fire();");
    //    }, 1000);
    // }

    handleSelectedType(){
        let e = this.template.querySelector('[data-id="recordList"]');
        this.userSelectedType = e.value;
        // console.log(`options list: ==> ${this.userSelectedType}`);
    }

    handleSelectedDescription(){
        let e = this.template.querySelector('[data-id="descriptionData"]');
        this.userSelectedDescription = e.value;
        // console.log(`dascription: ==> ${this.userSelectedDescription}`);
    }

    async updateCaseFromPlacement(){
        updateCaseFromPlacement({
            caseId: this.recordId,
            status: 'Com pendência',
            reason: this.userSelectedType
        }).then(result =>{
            // if(result){
            //     console.log('recordId => ' , this.recordId)
            //     console.log('result ', result)
            // }
            this.openModalRegisterHistory = false;
            this.handleLoading(false);
            this.openModalSuccess = true;
            // this.updateRecordView();
            // console.log(result);
        }).catch((error) => {
                console.log(`error: => ${error}`, error);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    async createTaskHistory(){
        createTaskHistory({
            whatId: this.opportunityId,
            whoId: this.contactOrLeadId,
            subject: this.userSelectedType,
            description: this.userSelectedDescription,
            type: this.userSelectedType
        }).then(async result =>{
            if(result){}
            // console.log('opp id => ' ,this.opportunityId)
            this.openModalRegisterHistory = false;
            this.handleLoading(false);
            this.openModalSuccess = true;
            this.handleLoading(true);
            this.onRefresh();
            // this.updateRecordView();
            // window.location.reload();
            this.handleLoading(false);
            // console.log(result);
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }
}