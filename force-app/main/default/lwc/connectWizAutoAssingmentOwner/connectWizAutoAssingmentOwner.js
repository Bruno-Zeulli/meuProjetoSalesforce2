import { api, LightningElement, track } from 'lwc';
import updateOwnerCaseFromPlacement from '@salesforce/apex/ConnectWizController.updateOwnerCaseFromPlacement';
import { NavigationMixin } from 'lightning/navigation';
import userCurrentId from '@salesforce/user/Id'

export default class ConnectWizAutoAssingmentOwner extends  NavigationMixin(LightningElement){

    @api recordId;
    @track caseIdSelected;

    showModalToAutoAssignCase;
    caseSelect;

    openModalAutoAssignmentOwner = true;
    isLoading = false;
    isRendered = false;

    handleSelectToAssignForMe(){
        this.userSelectToAssign = userCurrentId;
        if(this.userSelectToAssign !== undefined && this.userSelectToAssign !== null){
            this.handleLoading(true);
            this.updateOwnerCaseFromPlacement();
        }
    }

    handleSelectPrevious(){
        this.sendCloseModalToParent();
    }

    @api async getCaseIdToAssign(caseIdSelected, recordId){
        this.caseIdSelected = caseIdSelected;
        this.recordId = recordId;
    }

    async updateOwnerCaseFromPlacement(){
        updateOwnerCaseFromPlacement({
            caseId: this.caseIdSelected.caseId,
            userId: this.userSelectToAssign,
            status: 'Análise de dados da oportunidade'
        }).then(result =>{
            if(result){
                this.openModalAutoAssignmentOwner = false;
                this.handleLoading(false);
                this.handleNavigate();
            } else{
                console.log(`UPD Owner fail`);
            }
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    sendCloseModalToParent(){
        const selectedEvent = new CustomEvent("sendclosemodalautotoparent", {
            detail: false
        });
            this.dispatchEvent(selectedEvent);
    }

    handleNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Acompanhamento__c'
            },
            state: {
                c__caseId : this.caseIdSelected.caseId
             }
        });
    }

    handleLoading(event){
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }
}