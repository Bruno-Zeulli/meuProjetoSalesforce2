import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunityByCaseId from '@salesforce/apex/ConnectWizMonitoringController.getOpportunityByCaseId';
import getAccountByOpportunityId from '@salesforce/apex/ConnectWizMonitoringController.getAccountByOpportunityId';

export default class ConnectWizContactAccordionItem extends LightningElement {
    @api caseId;
    opportunityId;
    @track contatos = [];
    isOpen=false;

    async connectedCallback(){
        await this.retrieveOpportunity();
        await this.retrieveContacts();
    }

    async retrieveContacts(){
        console.log('OppID2' + this.opportunityId);
        await getAccountByOpportunityId({opportunityId : this.opportunityId}).then(result => {
            console.log('backend getAcc' + JSON.stringify(result));
            this.contatos =[...result];

        })
        .catch(error =>{
            console.log('Deu errado getAcc' + JSON.stringify(error));
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
        });
    }

    async retrieveOpportunity(){
        await getOpportunityByCaseId({caseId : this.caseId}).then(result => {
            console.log('backend getOpp' + JSON.stringify(result));
            this.opportunityId = result.Id;
            console.log('OppID' + this.opportunityId);
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

    handleContatoInformation(event){
        console.log('contatoId ' + JSON.stringify(event.currentTarget.dataset.id));
        let contatoNum = event.currentTarget.dataset.id;
        for(let contato of this.contatos.values()){
            if(contato.ordem == contatoNum){
                console.log("entrou no if");
                contato.showDetails = !contato.showDetails;
                console.log("contato" + JSON.stringify(contato));
            }
        }
    }
}