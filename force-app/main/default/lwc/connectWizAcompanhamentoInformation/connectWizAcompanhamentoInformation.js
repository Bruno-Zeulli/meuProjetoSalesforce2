import { api, LightningElement ,wire,track} from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import { refreshApex} from '@salesforce/apex'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordInfo from '@salesforce/apex/ConnectWizController.getCaseInfo'
import CASE_OBJECT from '@salesforce/schema/Case';
import retrieveQuotes from '@salesforce/apex/ConnectWizMonitoringController.retrieveQuotes';
import getCaseById from '@salesforce/apex/ConnectWizMonitoringController.getCaseById';
import getOpportunityByCaseId from '@salesforce/apex/ConnectWizMonitoringController.getOpportunityByCaseId';
export default class ConnectWizAcompanhamentoInformation extends NavigationMixin(LightningElement){

    @wire(CurrentPageReference)
    pageRef;
    isAcompanhamento = true;
    caseId;
    recordId;
    data;
    accountName;
    identificationNumber;
    userName;
    origin;
    opportunityNumber;
    @track opportunityId;
    contactOrLeadId;
    accountId;
    productName;
    hasForm;
    hasQuoteToEmit = false;
    isLoading= false;
    quoteId;
    listProposta;
    isCorporate;
    isBeneficios;
    isMcmv;
    hasQuoteToEmit;
    hasOppToEmit;
    hasCaseToEmit;
    quoteToEmit;
    isEmited = false;
    insuredAmount;
    partialQuotes = [];

    // caseObject = CASE_OBJECT;

    async connectedCallback(){
        var pageRefParams = this.pageRef.state;
        this.caseId = pageRefParams.c__caseId;
        this.recordId = this.caseId;
        this.handleLoading(true);
        await this.getRecordInfo();
        this.updateRecordView();
        await this.getCase();
        await this.getOpportunity();
        await this.retrieveQuotes();

        await this.loadEmitAccordion();
        // this.handleRefresh();
        await this.renderRefreshHistory();
    }

    async loadEmitAccordion(){

        if(this.hasCaseToEmit || this.hasOppToEmit || this.isEmited){

        }else{
            this.hasQuoteToEmit = false;
            this.handleLoading(false);
        }
    }

    async getRecordInfo(){
        getRecordInfo({recordId: this.recordId})
        .then(async data =>{
             try{
                console.log('data => ',data)
                    this.data = JSON.parse(data)
                    this.accountName = this.data.accountName;
                    if(this.data.identificationNumber.length == 11){
                        this.identificationNumber = this.data.identificationNumber.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/g, '$1.$2.$3-$4');
                    } else if(this.data.identificationNumber.length == 14){
                        this.identificationNumber = this.data.identificationNumber.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.$2.$3/$4-$5');
                    }
                    this.userName = this.data.ownerName;
                    this.origin = this.data.caseOrigin;
                    this.opportunityNumber = this.data.opportunityNumber;
                    this.opportunityId = this.data.opportunityId;
                    this.contactOrLeadId = this.data.contactOrLeadId;
                    this.accountId = this.data.accountId;
                    this.productName = this.data.productName;
                    this.hasForm = this.data.hasForm;
                    console.log('Responsalve nome: ==> ', this.userName)
            } catch(error){
                console.log('error =>',error);
                }
        })
        .catch(error => console.log(error));
    }

    async retrieveQuotes(){
        // this.handleLoading(true);
        await retrieveQuotes({caseId : this.caseId}).then(result => {
            // console.log('backend retrieve Emit' + JSON.stringify(result));
            this.listProposta = [...result];
            this.handleRefresh();
            this.hasQuoteToEmit = false;
            for(let proposta of this.listProposta.values()){
                (proposta.premio == null || proposta.premio == "") ?  proposta.premio = "Não informado" : proposta.premio = "R$ " + this.maskPrize(proposta.premio);
                if(proposta.status == "Accepted"){
                    this.hasQuoteToEmit = true;
                    this.quoteToEmit = proposta;
                    this.quoteId = proposta.quoteId;
                    this.isBeneficios = false;
                    this.isCorporate = false;
                    this.isMcmv = false;
                    console.log('Pricebook', proposta.priceBook2)
                    let pricebookName = proposta.priceBook2;
                    // console.log('quote to Emit' + JSON.stringify(this.quoteToEmit));
                    console.log(pricebookName);
                    if(proposta.priceBook2 == "Benefícios"){
                        this.isBeneficios = true;
                    }else if(proposta.priceBook2 == "Corporate"){
                        this.isCorporate = true;
                    }else if(proposta.priceBook2 == "MCMV"){
                        console.log('Mcmv true')
                        this.isMcmv = true;
                    }
                    break;
                }
            }
            const selectedEvent = new CustomEvent("handleemit", {
            detail: this.hasQuoteToEmit
            });
            this.dispatchEvent(selectedEvent);
            // console.log('hasQuoteToEmitSon' + this.hasQuoteToEmit);
            this.handleLoading(false);
        })
        .catch(error =>{
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
                });
                this.handleLoading(false);
    }

    maskPrize(value){

        if(value == '' || value =='R$'){
            value = '0,00';
        }
        value = value.replace('.', ',').replace(',', ',').replace(/\D/g, '');

        const options = { minimumFractionDigits: 2 }
        const result = new Intl.NumberFormat('pt-BR', options).format(
            parseFloat(value) / 100
        );

        return result;
    }

    async getCase(){
        // this.handleLoading(true);
        await getCaseById({caseId : this.caseId}).then(result => {
            // console.log('backend getCase Emit' + JSON.stringify(result));
            if(result.Status == "Aguardando emissão da apólice"){
                this.hasCaseToEmit = true;
            }else if(result.Status == "Apólice registrada"){
                this.hasCaseToEmit = false;
                this.isEmited = true;
                // this.showButtonDeleteFile = false;
            }
            else{
                this.hasCaseToEmit = false;
            }
        })
        .catch(error =>{
            console.log('error getCase ' + JSON.stringify(error));
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
        });
    }

    async getOpportunity(){
        await getOpportunityByCaseId({caseId : this.caseId}).then(result => {
            // console.log('backend getOppEmit' + JSON.stringify(result));
            if(result.StageName == "Em Emissão"){
                this.hasOppToEmit = true;
            }else if(result.StageName == "Fechado e ganho"){
                this.hasCaseToEmit = false;
                this.isEmited = true;
            }
            else{
                this.hasOppToEmit = false;
            }
            this.insuredAmount = result.InsuredAmount__c;
            this.handleRefresh();
        })
        .catch(error =>{
            console.log('error getOportunity: ' + JSON.stringify(error));

            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
                });
    }

    // @wire(getRecordInfo,{ recordId: '$recordId'})
    // wiredRecord({error, data}){

    //     if(error){
    //         let message = 'Unknown error';
    //         if(Array.isArray(error.body)){
    //             message = error.body.map(e => e.message).join(', ');
    //         } else if(typeof error.body.message === 'string'){
    //             message = error.body.message;
    //         }
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                     title: 'Error loading data',
    //                     message,
    //                     variant: 'error',
    //                 }),
    //             );
    //         } else if(data){
    //             // console.log(data);
    //             this.data = JSON.parse(data)
    //             this.accountName = this.data.accountName;
    //             console.log('data => ',data)
    //             if(this.data.identificationNumber.length == 11){
    //                 this.identificationNumber = this.data.identificationNumber.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/g, '$1.$2.$3-$4');
    //             } else if(this.data.identificationNumber.length == 14){
    //                 this.identificationNumber = this.data.identificationNumber.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.$2.$3/$4-$5');
    //             }
    //             this.userName = this.data.ownerName;
    //             this.origin = this.data.caseOrigin;
    //             this.opportunityNumber = this.data.opportunityNumber;
    //             this.opportunityId = this.data.opportunityId;
    //             this.contactOrLeadId = this.data.contactOrLeadId;
    //             this.accountId = this.data.accountId;
    //             this.productName = this.data.productName;
    //             this.hasForm = this.data.hasForm;
    //         }
    //     }

    handleRefresh(){
        this.refresh();
    }

    refresh(){
        // return refreshApex(this.getRecordInfo());
    }

    updateRecordView(){
        console.log('Entrou no updateRecordView');
        setTimeout(() => {
                eval("$A.get('e.force:refreshView').fire();");
        }, 1000);
        console.log('Saiu no updateRecordView');
    }

    handleEmit(event){
        let hasQuoteToEmit = event.detail;
        if(hasQuoteToEmit && hasQuoteToEmit != undefined){
            this.hasQuoteToEmit = true;
        }else if(!hasQuoteToEmit && hasQuoteToEmit != undefined){
            this.hasQuoteToEmit = false;
        }
    }

    // @api hideEmission(){
    //     this.hasQuoteToEmit = false;
    // }

    // async toOpportunityAcordion(recordId, opportunityId){
    //     await Promise.resolve();
    //     const elt =  this.template.querySelector("c-connect-wiz-opportunity-accordion-item");
    //     elt.getPromisedValues(recordId, opportunityId);
    // }

    // renderedCallback(){
    //     this.toOpportunityAcordion(this.recordId, this.opportunityId);
    // }

    async renderRefreshHistory(){
        this.template.querySelector('c-connect-wiz-history-header').reRender(this.opportunityId);
    }

    handleLoading(event){
        this.isLoading = event;
    }

    handlePartialQuoteUpdate(event){
        this.partialQuotes = event.detail.quotes;
    }

    handleProposalCreation(event){
        this.template.querySelector("c-connect-wiz-propostas-accordion-item").refreshProposal();
    }

}