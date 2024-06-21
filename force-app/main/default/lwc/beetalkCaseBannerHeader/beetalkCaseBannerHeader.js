import { LightningElement, wire, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import getCaseData from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getCaseData';


export default class CaseBannerHeader extends NavigationMixin(LightningElement){


    @api recordId;
    userId = Id;
    recordIdCase;
    wiredrecordIdCase;
    CaseNumber;
    Origin;
    UN__c;
    Product__c;
    Subject;
    Status;
    showModalCreateTask =false;
    showModalChangeOwner = false; // Variável para controlar a exibição do fluxo
    flowApiName; // api name of your flow


    @wire(getCaseData,{recordId: '$recordId'})
        getCaseData(result){
            if(result.data){
                this.CaseNumber = result.data.CaseNumber;
                this.Origin = result.data.Origin;
                this.UN__c = result.data.UN__c;
                this.Product__c = result.data.Product__c;
                this.Subject = result.data.Subject;
                this.Status = result.data.Status;
                this.wiredrecordIdCase = result;
            } else if(result.error){
                console.log(result.error);
            }

        }


    get inputVariables(){
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            },
        ];
    }


    handleFlowCreateTaskStatusChange(event){
        // Manipula o status do fluxo
        console.log(event.detail.status);
        if(event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN'){
            this.showToast('Status', 'Tabulação inserida com sucesso!', 'success', 'dismissable');
            this.showModalCreateTask = false; // Fecha o componente do fluxo
            this.verifyCaseStatus();
        } else if(event.detail.status === 'ERROR'){
            // Ocorreu um erro durante a execução do fluxo
            // Trate o erro adequadamente
        }
    }

    handleFlowChangeOwnerStatusChange(event){
        console.log(event.detail.status);
        if(event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN'){
            this.showToast('Status', 'Propietário alterado com sucesso!', 'success', 'dismissable');
            this.showModalChangeOwner = false; // Fecha o componente do fluxo
            this.verifyCaseOwner();
        } else if(event.detail.status === 'ERROR'){
            // Ocorreu um erro durante a execução do fluxo
            // Trate o erro adequadamente
        }
    }


    closeModal(){
        this.showModalCreateTask = false;
        this.showModalChangeOwner = false;

    }


    verifyCaseStatus(){
        getCaseData({
            recordId : this.recordId
        })
        .then(result => {
            try{
                if(result.Status === 'Closed'){
                    this.navToHomePage();
                }
            }catch(error){
                console.log('error =>',error);
            }
        })
        .catch(error => console.log(error));
    }

    verifyCaseOwner(){
        getCaseData({
            recordId : this.recordId
        })
        .then(result => {
            try{
                if(result.OwnerId != this.userId){
                    this.navToHomePage();
                }
            }catch(error){
                console.log('error =>',error);
            }
        })
        .catch(error => console.log(error));
    }

    navToHomePage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    showToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }


    handleCreateTaskButtonClick(){
        this.showModalCreateTask = true;
        this.flowApiName = 'BeetalkTabulacao';
        this.startFlow(flowApiName);
        this.closeModal();
    }



    handleChangeOwnerButtonClick(){
        this.showModalChangeOwner = true;
        this.flowApiName = 'TransferCasesChatbot';
        this.startFlow(flowApiName);
        this.closeModal();
    }


    startFlow(flowApiName){
        const flow = this.template.querySelector('lightning-flow');
        flow.startFlow(flowApiName).then(() => {
            // Fluxo iniciado com sucesso
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }).catch(error => {
            // Ocorreu um erro ao iniciar o fluxo
            console.error('Erro ao iniciar o fluxo:', error);
        });
    }
}