import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
// import { CloseActionScreenEvent } from 'lightning/actions';
import getUserOrGroupNames from '@salesforce/apex/ConnectWizController.getUsersInfo';
import updateOwnerCaseFromPlacement from '@salesforce/apex/ConnectWizController.updateOwnerCaseFromPlacement';
import createTaskHistory from '@salesforce/apex/ConnectWizController.createTaskHistory'

export default class ConnectWizReassignOpportunityModal extends NavigationMixin(LightningElement){
    @api recordId;
    @api opportunityId;
    @api userName;
    @api contactOrLeadId;

    @track userIdSelectedToReassign;
    @track userNameSelectedToReassign;
    @track ownerOptions=[];

    userSelectedDescription;
    openModalReassignOportunity = true;
    isLoading = false;
    isRendered = false;
    showDragbox = false;

    constructor(){
        super();
    }

    onRefresh(){
        this.sendCloseModalToParent();
        this.updateRecordView();
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleSelectCloseModal(){
        this.sendCloseModalToParent();
        this.onRefresh();
    }

    sendCloseModalToParent(){
        const selectedEvent = new CustomEvent("sendclosemodaltoparent", {
            detail: false
        });
            this.dispatchEvent(selectedEvent);
    }

    sendClosePopoverToParent(){
        const selectedEvent = new CustomEvent("sendclosepopovertoparent",{
            detail: false
        });
            this.dispatchEvent(selectedEvent);
    }

    handleLoading(event){
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }

    updateRecordView(){
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       }, 1000);
    }

    async connectedCallback(){
        this.handleLoading(true);
    }

    renderedCallback(){};

    @api async getReassignPromiseValues(recordId, opportunityId, userName,contactOrLeadId){
        this.openModalReassignOportunity = true;
        this.recordId = recordId;
        this.opportunityId = opportunityId;
        this.userName = userName;
        this.contactOrLeadId = contactOrLeadId;
        await this.getUserOrGroupNames();
        this.handleLoading(false);
    }

    getUserOrGroupNames(){
        getUserOrGroupNames({})
            .then(async date => {
                this.handleLoading(true);
                try{
                    this.ownerOptions = JSON.parse(date);
                    if(this.openModalReassignOportunity == true){
                        let lOwner =  this.template.querySelector('[data-id="ownerList"]');
                        this.ownerOptions.forEach(
                            key => {
                                let option = document.createElement("option");
                                option.setAttribute('value', key.id);
                                option.setAttribute('label', key.userName);

                                let optionText = document.createTextNode(key.userName);
                                option.appendChild(optionText);
                                lOwner.appendChild(option);
                            });
                    }
                    this.handleLoading(false);
                }catch(error){
                    console.log('error =>',error);
                    this.handleLoading(false);
                }
            })
            .catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                showToast('Erro', 'Ocorreu um erro!', 'error', this);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    handleSelectValueToAssign(){
        let e = this.template.querySelector('[data-id="ownerList"]');
        this.userIdSelectedToReassign = e.value;
        let y = this.template.querySelector('[value="' + e.value +'"]');
        // console.log(y)
        this.userNameSelectedToReassign = y.innerText;
        // console.log(`userIdSelectedToReassign: ==> ${this.userIdSelectedToReassign}`);
        // console.log(`userNameSelectedToReassign: ==> ${this.userNameSelectedToReassign}`);

    }

    handleSelectToReassign(){
        if(this.userIdSelectedToReassign !== undefined && this.userIdSelectedToReassign !== null){
            this.openModalReassignOportunity = false;
            this.handleLoading(true);
            this.updateOwnerCaseFromPlacement();
            this.createTaskHistory();

        }
    }

    handleSelectedDescription(){
        let e = this.template.querySelector('[data-id="descriptionData"]');
        this.userSelectedDescription = e.value;
        // console.log(`dascription: ==> ${this.userSelectedDescription}`);
    }

    async updateOwnerCaseFromPlacement(){
        this.handleLoading(true);
        updateOwnerCaseFromPlacement({
            caseId: this.recordId,
            userId: this.userIdSelectedToReassign,
            status: 'Análise de dados da oportunidade'
        }).then(result =>{
            if(result){
                this.openModalReassignOportunity = false;
                // this.handleLoading(false);
                this.openModalAssignmentSuccess = true;
                const selectedEvent = new CustomEvent('selecteduser', { detail: this.userNameSelectedToReassign });
                this.dispatchEvent(selectedEvent);
                // console.log('Entrou no evento de Reasign' + this.userNameSelectedToReassign);
                // this.handleLoading(true);
                // this.onRefresh();
                // this.handleLoading(false);
            } else{
                console.log(`UPD Owner fail`);
            }
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

     async createTaskHistory(){
        createTaskHistory({
            whatId: this.opportunityId,
            whoId: this.contactOrLeadId,
            subject: 'Reatribuido para técnico/fila',
            description: this.userSelectedDescription,
            type: 'Reatribuido para técnico/fila'
        }).then(result =>{
            if(result){}
                this.handleLoading(true);
                this.openModalReassignOportunity = false;
                // this.handleLoading(false);
                // this.openModalAssignmentSuccess = true;
                // this.updateRecordView();
                this.onRefresh();
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