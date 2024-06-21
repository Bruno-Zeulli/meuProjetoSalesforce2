import { api, LightningElement, track } from 'lwc';

export default class ConnectWizQuotationFormItemEdit extends LightningElement {
    @api quotationFormOriginal;
    @track quotationForm;
    isBenefits = true;

    connectedCallback(){
        console.log('this.quotationFormOriginal ', this.quotationFormOriginal);
        this.quotationForm = this.quotationFormOriginal;
    }


}