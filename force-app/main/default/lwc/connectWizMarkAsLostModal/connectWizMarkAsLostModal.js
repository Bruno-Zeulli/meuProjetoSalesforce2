import { LightningElement, api, track } from 'lwc';
import createTaskHistory from '@salesforce/apex/ConnectWizController.createTaskHistory'
import updateCaseFromPlacement from '@salesforce/apex/ConnectWizController.updateCaseFromPlacement'

const lostOptions = [
                    'Valores acima da expectativa/orçamento',
                    'Somente pesquisa de preço',
                    'Interesse no futuro',
                    'Excesso de tentativas',
                    'Fechou com o concorrente',
                    'Cotação declinada pela seguradora/operadora',
                    'Renovou com a seguradora/operadora atual',
                    'Sem interesse e outros'
                ]

export default class ConnectWizMarkAsLostModal extends LightningElement {
    @api recordId; //get the recordId for which files will be attached
    @api opportunityId;
    @api userName;
    @api contactOrLeadId;
    @track userSelectedReason;

    lostOptions = lostOptions;
    openModalMarkAsLost = true;

    isLoading = false;
    isRendered = false;
    showDragbox = false;

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleSelectCloseModal(){
        this.sendCloseModalToParent();
        // this.sendClosePopoverToParent();
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
            bubbles: true
        });
            this.dispatchEvent(selectedEvent);
    }

    handleLoading(event){
        this.isLoading = event;
        // console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }

    async connectedCallback(){
        this.handleLoading(true);
        this.sendClosePopoverToParent();
        // console.log(this.parentRecordId);
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


    @api async getMarkAsLostPromiseValues(recordId, opportunityId, userName, contactOrLeadId){
        this.handleLoading(true);
        this.openModalMarkAsLost = true;
        this.recordId = recordId;
        this.opportunityId = opportunityId;
        this.userName = userName;
        this.contactOrLeadId = contactOrLeadId;
        await this.getReasonsList();
        this.handleLoading(false);
    }

    async getReasonsList(){
        try{
            // console.log(lostOptions);
            this.handleLoading(true);
            if(this.openModalMarkAsLost){
                // console.log('lst => ', this.template.querySelector('[data-id="reasonList"]'));
                let lst = this.template.querySelector('[data-id="reasonList"]');

                this.lostOptions.forEach(
                    item => {
                        let option = document.createElement("option");
                        option.setAttribute('value', item);
                        console.log('option => ', item)
                        let optionText = document.createTextNode(item);
                        option.appendChild(optionText);

                        lst.appendChild(option);
                    });

            }

            this.handleLoading(false);
        }catch(error){
            this.handleLoading(false);
            console.log('error =>',error);
        }
    }

    handleSelectedToRegister(){
        this.handleLoading(true);
        if(this.userSelectedReason !== undefined &&
                this.userSelectedReason !== null &&
                this.userSelectedDescription !== undefined &&
                this.userSelectedDescription !== null
            ){
            this.openModalMarkAsLost = false;
            this.updateCaseFromPlacement();
            this.createTaskHistory();
        }
        this.handleLoading(false);
    }

    handleSelectReason(){
        let e = this.template.querySelector('[data-id="reasonList"]');
        this.userSelectedReason = e.value;
        // console.log(`options list: ==> ${e}`);
    }

    handleSelectedDescription(){
        let e = this.template.querySelector('[data-id="descriptionData"]');
        this.userSelectedDescription = e.value;
        // console.log(`dascription: ==> ${this.userSelectedDescription}`);
    }

    async updateCaseFromPlacement(){
        this.handleLoading(true);
        updateCaseFromPlacement({
            caseId: this.recordId,
            status: 'Processo anulado',
            reason: this.userSelectedReason,
        }).then(result =>{
            if(result){
                console.log('result ', result)
            }
            this.openModalMarkAsLost = false;
            // this.handleLoading(false);
            this.openModalSuccess = true;
            // this.handleLoading(true);
            this.onRefresh();
            // this.handleLoading(false);
            // console.log(result);
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`, error);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    async createTaskHistory(){

        createTaskHistory({
            whatId: this.opportunityId,
            whotId: this.contactOrLeadId,
            subject: this.userSelectedReason,// todo verificar lista
            description: this.userSelectedDescription,
            type: 'Oportunidade perdida'// todo add tipos ou tabulação
        }).then(result =>{
            if(result){}
            this.openModalMarkAsLost = false;
            // this.handleLoading(false);
            this.openModalSuccess = true;
            // console.log(result);
            // this.handleLoading(true);
            this.onRefresh();
            // window.location.reload();
            this.handleLoading(false);
        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }
}