import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserOrGroupNames from '@salesforce/apex/ConnectWizController.getUsersInfo';
import updateOwnerCaseFromPlacement from '@salesforce/apex/ConnectWizController.updateOwnerCaseFromPlacement';
import createTaskHistory from '@salesforce/apex/ConnectWizController.createTaskHistory';
import getCaseInfo from '@salesforce/apex/ConnectWizController.getCaseInfo';
import userCurrentId from '@salesforce/user/Id'
export default class ConnectWizAssignmentOwner extends  NavigationMixin(LightningElement){
    @api recordId; //get the recordId for which files will be attached
    @api opportunityId;
    @api userName;
    @api contactOrLeadId;

    @track ownerOptions=[];
    @track caseIdSelected;
    @track lAllQuotesRequest=[];
    @track userSelectToAssign;
    @track userSelectedDescription;

    showModalToAssignCase;
    caseSelect;

    finishedLoadingData = false;
    openModalAssignmentOwner = true;
    openModalAssignmentSuccess = false;

    isLoading = false;
    isRendered = false;

    data;
    accountName;
    origin;
    opportunityNumber;
    accountId;
    hasForm;

    connectedCallback(){
        this.handleLoading(true);
        this.getUserOrGroupNames();
    }

    getUserOrGroupNames(){
        getUserOrGroupNames({})
            .then(async date => {
                try{
                    this.ownerOptions = JSON.parse(date);
                    if(this.openModalAssignmentOwner == true){
                        let lOwner =  this.template.querySelector('[data-id="ownerList"]');
                        this.ownerOptions.forEach(
                            key => {
                                let option = document.createElement("option");
                                // console.log(' option ==> ', option);
                                option.setAttribute('value', key.id);
                                // console.log(' option ==> ', option);

                                let optionText = document.createTextNode(key.userName);
                                // console.log(' optionText ==> ', optionText);
                                option.appendChild(optionText);
                                // console.log(' option ==> ', option);
                                lOwner.appendChild(option);
                            });
                    }
                    this.handleLoading(false);
                }catch(error){
                    this.handleLoading(false);
                    console.log('error =>',error);
                }
            })
            .catch((error) => {
                console.log(`error: ${error}`);
                showToast('Erro', 'Ocorreu um erro!', 'error', this);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    @api async getCaseIdToAssign(caseIdSelected, lAllQuotesRequest){
        this.caseIdSelected = caseIdSelected;
        this.recordId = this.caseIdSelected.caseId;
        this.lAllQuotesRequest = lAllQuotesRequest;
        await this.filterCasesShowData(this.lAllQuotesRequest);
    }

    @wire(getCaseInfo,{ recordId: '$recordId'})
        wiredRecord({error, data}){

            if(error){
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
                } else if(data){
                    // console.log(data);
                    this.data = JSON.parse(data)
                    // console.log(data)
                    this.accountName = this.data.accountName;
                    this.origin = this.data.caseOrigin;
                    this.opportunityNumber = this.data.opportunityNumber;
                    this.opportunityId = this.data.opportunityId;
                    this.contactOrLeadId = this.data.contactOrLeadId;
                    this.accountId = this.data.accountId;
                    this.hasForm = this.data.hasForm;
                }
            }

    sendCloseModalToParent(){
        const selectedEvent = new CustomEvent("sendclosemodaltoparent", {
            detail: false
        });
        this.dispatchEvent(selectedEvent);
    }

    handleSelectCloseModal(){
        this.sendCloseModalToParent();
    }

    handleSelectToAssign(){
        if(this.userSelectToAssign !== undefined && this.userSelectToAssign !== null){
            this.openModalAssignmentOwner = false;
            this.handleLoading(true);
            this.updateOwnerCaseFromPlacement();
        }
    }

    handleSelectToAssignForMe(){
        this.userSelectToAssign = userCurrentId;
        if(this.userSelectToAssign !== undefined && this.userSelectToAssign !== null){
            this.openModalAssignmentOwner = false;
            this.handleLoading(true);
            this.updateOwnerCaseFromPlacement();
            this.createTaskHistory();

        }
    }

    handleSelectValueToAssign(){
        let e = this.template.querySelector('[data-id="ownerList"]');
        this.userSelectToAssign = e.value;
        //console.log(`userSelectToAssign: ==> ${this.userSelectToAssign}`);
    }

    handleSelectedDescription(){
        let e = this.template.querySelector('[data-id="descriptionData"]');
        this.userSelectedDescription = e.value;
        //console.log(`dascription: ==> ${this.userSelectedDescription}`);
    }

    handleLoading(event){
        this.isLoading = event;
        //console.log(`this.isLoading: ==> ${this.isLoading}`);
    }
    handleRendered(event){
        this.isRendered = event;
    }

    async updateOwnerCaseFromPlacement(){
        updateOwnerCaseFromPlacement({
            caseId: this.caseIdSelected.caseId,
            userId: this.userSelectToAssign,
            status: 'Análise de dados da oportunidade'
        }).then(result =>{
            if(result){
                this.openModalAssignmentOwner = false;
                this.handleLoading(false);
                this.openModalAssignmentSuccess = true;
                this.updateRecordView();
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
            //console.log('opp id => ' ,this.opportunityId)
            this.handleLoading(false);
            //console.log(result);
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    async filterCasesShowData(lAllQuotesRequest){
        let cases = JSON.parse(JSON.stringify(lAllQuotesRequest));
        // console.log(`cases in filterCasesShowData  - ${JSON.stringify(cases)} `);
        cases = cases.filter(item => item.caseId === this.caseIdSelected.caseId);
        // console.log(`cases in filterCasesShowData  - ${JSON.stringify(cases)} `);
        this.caseSelect = cases[0];
        this.handleRendered(true);
        this.handleLoading(false);
    }

    updateRecordView(){
        // console.log('Entrou no updateRecordView');
        setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
        }, 1000);
        // console.log('Saiu no updateRecordView');
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

    navigateToHomePage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

}