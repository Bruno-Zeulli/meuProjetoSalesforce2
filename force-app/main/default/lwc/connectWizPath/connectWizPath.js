import { LightningElement,api,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from "lightning/navigation";

export default class ConnectWizPath extends NavigationMixin(LightningElement){
    @wire(CurrentPageReference)
    pageRef;

    @api isAcompanhamento;
    @api isQuotationData;
    @api caseId;
    

    //Navigate to home page
    navigateToHomePage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    //Navigate to AcompanhantoPage page
    navigateToAcompanhamentoPage(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Acompanhamento__c'
            },    
            state: {
                c__caseId: this.caseId
             }   
        });
    }

}