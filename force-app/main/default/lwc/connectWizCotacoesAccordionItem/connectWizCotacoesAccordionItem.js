import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo,getPicklistValues  } from 'lightning/uiObjectInfoApi';
import retrieveQuotes from '@salesforce/apex/ConnectWizMonitoringController.retrieveQuotes';
import QUOTE_OBJECT from '@salesforce/schema/Quote';
import COMPANY_FIELD from '@salesforce/schema/Quote.Company__c';

export default class ConnectWizCotacoesAccordionItem extends LightningElement {
    @api caseId;
    @api opportunityId;
    @api hasForm;

    @track options;
    @track recordTypeId;
    @track qtdRecebidas = 0;
    @track qtdSolicitadas = 0;

    propostaForm = [];
    isEditForm = false;
    isInsertForm = false;
    isOpen=false;
    solicitadas;
    recebidas;

    proposta = "btn-action-quote-active slds-col slds-size_6-of-12";
    cotacao = "btn-action-quote-deactive slds-col slds-size_6-of-12";

    isProposta = true;
    isCotacao = false;
    isFirstSolic = true;
    openForm = false;
    isDuplicate = false;
    isSubmited = false;
    recordTypeCorporateId;

    @wire(getObjectInfo, { objectApiName: QUOTE_OBJECT })
    objectInfo({error, data}){
        if(data){
            var listRT = data.recordTypeInfos;
            this.recordTypeId = Object.keys(listRT).find(rt => listRT[rt].name === 'Corporate');
            // console.log('RT corporate' + this.recordTypeId);
        }
        else if(error){
            window.console.log('error: '+JSON.stringify(error));
        }
    }

    @wire(getPicklistValues, { fieldApiName: COMPANY_FIELD, recordTypeId: "$recordTypeId"})
    companyPicklistValues({error, data}){
        if(data){
            this.options = data.values;
        }
        else if(error){
            window.console.log('error: '+JSON.stringify(error));
        }
    }

    connectedCallback(){
        this.retrieveQuotes();
    }
    async retrieveQuotes(){
        this.handleLoading(true);
        retrieveQuotes({caseId : this.caseId}).then(result => {
            // console.log('backend retrieve' + JSON.stringify(result));
            this.listProposta = [...result];
            for(let item of this.listProposta.values()){
                if(item.isRecebida){
                    this.qtdRecebidas = this.qtdRecebidas + 1;

                }else if(item.isSolicitada){
                    this.qtdSolicitadas = this.qtdSolicitadas +1;
                }
            }
            this.qtdSolicitadas += this.qtdRecebidas;
            this.recebidas = this.qtdRecebidas + " Recebidas ";
            this.solicitadas = this.qtdSolicitadas + " Solicitadas ";
            this.handleRefresh();
            this.handleLoading(false);
        })
        .catch(error =>{
            console.log('Deu errado retrieve' + JSON.stringify(error));
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
                    this.handleLoading(false);
        });
        this.handleLoading(false);
    }

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    activeCotacaoDiv(){
        this.cotacao = "btn-action-quote-active slds-col slds-size_6-of-12";
        this.proposta = "btn-action-quote-deactive slds-col slds-size_6-of-12";
        this.isProposta = false;
        this.isCotacao = true;
    }

    activePropostaDiv(){
        this.proposta = "btn-action-quote-active slds-col slds-size_6-of-12";
        this.cotacao = "btn-action-quote-deactive slds-col slds-size_6-of-12";
        this.isProposta = true;
        this.isCotacao = false;
    }

    addPropostaHandler(){
        this.openForm = true;
        this.isInsertForm=true;
        this.handleRefresh();
    }

    handleForm(event){
        console.log('event' + event.detail.closeForm);
        var closeForm = event.detail.closeForm;
        if(closeForm){
            this.propostaForm = [];
            this.isEditForm=false;
            this.isInsertForm=false;
            this.openForm = false;
            this.handleRefresh();
        }
    }

    handleEditForm(event){
        console.log('event' + event.detail.editForm);
        var editForm = event.detail.editForm;
        this.propostaForm = event.detail.propostaEditForm;
        // console.log('event propostaEditForm ' + JSON.stringify(this.propostaForm));
        if(editForm){
            console.log('Editar Form');
            this.isEditForm=true;
            this.openForm = true;
        }
    }

    handleDuplicate(event){
        console.log('event' + event.detail.isDuplicate);
        this.isDuplicate = event.detail.isDuplicate;
    }

    handleUpdate(event){
        if(event.detail.updateForm){
            this.qtdRecebidas = 0;
            this.qtdSolicitadas = 0;
            this.connectedCallback();
            this.template.querySelector('c-connect-wiz-propostas-edit').reRender();
            this.handleRefresh();
        }
    }

    handleDuplicateInserted(event){
        console.log('event' + event.detail.isSubmited);
        this.isSubmited = event.detail.isSubmited;
        if(this.isSubmited){
            this.template.querySelector('c-connect-wiz-propostas-edit').reRender();
            this.handleForm();
        }
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
        // console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
    }

    handleLoading(event){
        this.isLoading = event;
    }

    async toQuoteEdit(opportunityId, caseId){
        await Promise.resolve();
        const elt =  this.template.querySelector("c-connect-wiz-propostas-edit");
        elt.getReassignPromiseValues(opportunityId, caseId);
    }
}