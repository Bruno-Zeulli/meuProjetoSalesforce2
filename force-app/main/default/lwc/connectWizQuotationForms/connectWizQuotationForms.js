import { api, LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuotationFormsByOppId from '@salesforce/apex/ConnectWizQuotationFormsController.getQuotationFormsByOppId';
import { NavigationMixin } from 'lightning/navigation';

export default class ConnectWizQuotationForms extends NavigationMixin(LightningElement){
    @api opportunityId;
    @api caseId;
    @track lQuotationForms;
    hasPending = false;
    @track formId;

    connectedCallback(){
        this.getQuotationFormsByOppId();
    }

    async getQuotationFormsByOppId(){
        getQuotationFormsByOppId({opportunityId : this.opportunityId})
            .then(result => {
                console.log('backend retrieve' + JSON.stringify(result));
                this.lQuotationForms = JSON.parse(result);
                this.handleRefresh();
            })
            .catch(error =>{
                console.log('Deu errado retrieve' + JSON.stringify(error));
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

    async handleOpenQuotationForm(event){

        this.formId = event.currentTarget.dataset.name;
        /* let e = this.template.querySelector('.btn-view-data');
        this.formId = e.value; */
        console.log('this.formId', this.formId);
        await this.handleNavigate();
    }


    async handleNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'QuotationForm__c'
            },
            state: {
                c__formId : this.formId,
                c__caseId: this.caseId
             }
        });
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