import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retrieveQuotes from '@salesforce/apex/ConnectWizMonitoringController.retrieveQuotes';
import getCaseById from '@salesforce/apex/ConnectWizMonitoringController.getCaseById';
import getOpportunityByCaseId from '@salesforce/apex/ConnectWizMonitoringController.getOpportunityByCaseId';
import emitQuote from '@salesforce/apex/ConnectWizMonitoringController.emitQuote';

export default class ConnectWizEmissionAccordionItem extends LightningElement {

    @api caseId;
    @api isCorporate
    @api isBeneficios;
    @api isMcmv;
    @api recordId;
    isOpen=false;
    // opportunityId;
    // containsQuote;
    @api quoteToEmit;
    // objOpportunity;
    // objCase;
    // hasCaseOrOppToEmit;
    @api hasQuoteToEmit;
    @api hasOppToEmit;
    @api hasCaseToEmit;
    @api isEmited = false;
    isFirstOpen = true;
    documentTypeName = 'Proposta de Seguro';
    documentTypeEstudoDeMercado = 'Estudo de Mercado';
    documentTypeNameApolice = 'Apólice';
    documentTypeNameBoleto = 'Boleto';
    documentTypeNameKitImplantacao = 'Kit de Implantação';
    documentTypeNameAceiteDoCliente = 'Comprovante da Resolução 382 SUSEP';
    showButtonViewFile = true;
    showSimpleView = true;
    showUploadFileKitImplantacao = false;
    showViewFilesKitImplantacao = true;
    showUploadFileApolice = false;
    showViewFilesApolice = true;
    showUploadFileBoleto =false;
    showViewFilesBoleto = true;
    showButtonDeleteFile = true;
    buttonEnviar = "button-enviar-disabled";
    isApoliceLoaded = false;
    isBoletoLoaded = false;
    isApoliceUploadLoaded = false;
    isBoletoUploadLoaded = false;
    showCompKit = false;
    showCompAceite = false;
    showCompApolice = false;
    showCompBoleto = false;
    showComp = false;

    async connectedCallback(){
        // await this.getCase();
        // await this.getOpportunity();
        // if(this.hasCaseToEmit || this.hasOppToEmit || this.isEmited){
        //     await this.retrieveQuotes();
        // }else{
        //     const selectedEvent = new CustomEvent("handleemit", {
        //     detail: false
        //     });
        //     this.dispatchEvent(selectedEvent);
        //     // console.log('hasQuoteToEmitSon' + this.hasQuoteToEmit);
        // }
        // this.handleRefresh();
        // this.handleLoading(false);
        if(this.isEmited){
            this.handleLoading(false);
        }

    }

    // async retrieveQuotes(){
    //     // this.handleLoading(true);
    //     await retrieveQuotes({caseId : this.caseId}).then(result => {
    //         // console.log('backend retrieve Emit' + JSON.stringify(result));
    //         this.listProposta = [...result];
    //         this.handleRefresh();
    //         this.hasQuoteToEmit = false;
    //         for(let proposta of this.listProposta.values()){
    //             (proposta.premio == null || proposta.premio == "") ?  proposta.premio = "Não informado" : proposta.premio = "R$ " + proposta.premio.toString().replace(".",",");
    //             if(proposta.status == "Accepted"){
    //                 this.hasQuoteToEmit = true;
    //                 this.quoteToEmit = proposta;
    //                 this.recordId = proposta.quoteId;
    //                 this.isBeneficios = false;
    //                 this.isCorporate = false;
    //                 this.isMcmv = false;
    //                 console.log('Pricebook', proposta.priceBook2)
    //                 let pricebookName = proposta.priceBook2;
    //                 // console.log('quote to Emit' + JSON.stringify(this.quoteToEmit));
    //                 console.log(pricebookName);
    //                 if(proposta.priceBook2 == "Benefícios"){
    //                     this.isBeneficios = true;
    //                 }else if(proposta.priceBook2 == "Corporate"){
    //                     this.isCorporate = true;
    //                 }else if(proposta.priceBook2 == "MCMV"){
    //                     console.log('Mcmv true')
    //                     this.isMcmv = true;
    //                 }
    //                 break;
    //             }
    //         }
    //         const selectedEvent = new CustomEvent("handleemit", {
    //         detail: this.hasQuoteToEmit
    //         });
    //         this.dispatchEvent(selectedEvent);
    //         // console.log('hasQuoteToEmitSon' + this.hasQuoteToEmit);
    //         this.handleLoading(false);
    //     })
    //     .catch(error =>{
    //         this.dispatchEvent(
    //                     new ShowToastEvent({
    //                         title: 'Error loading data',
    //                         message,
    //                         variant: 'error',
    //                     }),
    //                 );
    //             });
    //             this.handleLoading(false);
    // }

    // async getCase(){
    //     // this.handleLoading(true);
    //     await getCaseById({caseId : this.caseId}).then(result => {
    //         // console.log('backend getCase Emit' + JSON.stringify(result));
    //         if(result.Status == "Aguardando emissão da apólice"){
    //             this.hasCaseToEmit = true;
    //         }else if(result.Status == "Apólice registrada"){
    //             this.hasCaseToEmit = false;
    //             this.isEmited = true;
    //             this.showButtonDeleteFile = false;
    //         }
    //         else{
    //             this.hasCaseToEmit = false;
    //         }
    //         this.handleLoading(false);
    //     })
    //     .catch(error =>{
    //         console.log('error getCase ' + JSON.stringify(error));
    //         this.dispatchEvent(
    //                     new ShowToastEvent({
    //                         title: 'Error loading data',
    //                         message,
    //                         variant: 'error',
    //                     }),
    //                 );
    //     });
    // }

    // async getOpportunity(){
    //     await getOpportunityByCaseId({caseId : this.caseId}).then(result => {
    //         // console.log('backend getOppEmit' + JSON.stringify(result));
    //         if(result.StageName == "Em Emissão"){
    //             this.hasOppToEmit = true;
    //         }else if(result.StageName == "Fechado e ganho"){
    //             this.hasCaseToEmit = false;
    //             this.isEmited = true;
    //         }
    //         else{
    //             this.hasOppToEmit = false;
    //         }
    //         this.handleRefresh();
    //     })
    //     .catch(error =>{
    //         console.log('error getOportunity: ' + JSON.stringify(error));

    //         this.dispatchEvent(
    //                     new ShowToastEvent({
    //                         title: 'Error loading data',
    //                         message,
    //                         variant: 'error',
    //                     }),
    //                 );
    //             });
    // }

    handleControlShowUploadFileKitImplantacao(event){
        // this.handleLoading(true);
        this.showUploadFileKitImplantacao = event.detail;
        if(this.showUploadFileKitImplantacao){
            this.showViewFilesKitImplantacao = false;
        } else{
            this.showViewFilesKitImplantacao = true;
        }
        this.showCompKit = true;
        this.handleLoading(false);
    }

    handleControlShowViewFileKitImplantacao(event){
        this.showViewFilesKitImplantacao = event.detail;
        if(this.showViewFilesKitImplantacao){
            this.showUploadFileKitImplantacao = false;
        } else{
            this.showUploadFileKitImplantacao = true;
            // console.log('Entrou no upload.')
        }
        this.showCompKit = true;
        this.handleLoading(false);
        this.enableButtonEnviar();
    }

     handleDeleteFileKitImplantacao(event){

        let isDeleted = event.isDeleted;
        if(isDeleted){
            this.showViewFilesKitImplantacao = false;
            this.showUploadFileKitImplantacao = true;
        }
    }

    async handleControlShowUploadFileApolice(event){
        this.showUploadFileApolice = event.detail;
        if(this.showUploadFileApolice){
            this.showViewFilesApolice = false;
            this.isApoliceUploadLoaded = true;
            this.isApoliceLoaded = false;
        } else{
            this.showViewFilesApolice = true;
            this.isApoliceUploadLoaded = false;
            this.isApoliceLoaded = true;
        }
        this.showCompApolice = true;
        await this.handleFilesLoading();
    }

    async handleControlShowViewFileApolice(event){
        this.showViewFilesApolice = event.detail;
        if(this.showViewFilesApolice){
            this.showUploadFileApolice = false;
            this.isApoliceLoaded = true;
            this.isApoliceUploadLoaded = false;
        } else{
            this.showUploadFileApolice = true;
            this.isApoliceLoaded = false;
            this.isApoliceUploadLoaded = true;
            // console.log('Entrou no upload.')
        }
        this.showCompApolice = true;
        await this.handleFilesLoading();
        this.handleLoading(false);
        this.enableButtonEnviar();
    }

    handleDeleteFileApolice(event){
        this.handleLoading(true);
        let isDeleted = event.isDeleted;
        if(isDeleted){
            this.showViewFilesApolice = false;
            this.showUploadFileApolice = true;
            this.isApoliceUploadLoaded = false;
            this.isApoliceLoaded = true;
        }
    }

    async handleControlShowUploadFileBoleto(event){
        this.showUploadFileBoleto = event.detail;
        if(this.showUploadFileBoleto){
            this.showViewFilesBoleto = false;
            this.isBoletoLoaded = false;
            this.isBoletoUploadLoaded = true;
        } else{
            this.showViewFilesBoleto = true;
            this.isBoletoLoaded = true;
            this.isBoletoUploadLoaded = false;
        }
        this.showCompBoleto = true;
        await this.handleFilesLoading();
    }

    async handleControlShowViewFileBoleto(event){
        this.showViewFilesBoleto = event.detail;
        if(this.showViewFilesBoleto){
            this.showUploadFileBoleto = false;
            this.isBoletoUploadLoaded = false;
            this.isBoletoLoaded = true;
        } else{
            this.showUploadFileBoleto = true;
            this.isBoletoUploadLoaded = true;
            this.isBoletoLoaded = false;
        }
        this.showCompBoleto = true;
        this.enableButtonEnviar();
        await this.handleFilesLoading();
        this.handleLoading(false);
    }

    handleDeleteFileBoleto(event){

        let isDeleted = event.isDeleted;
        if(isDeleted){
            this.showViewFilesBoleto = false;
            this.showUploadFileBoleto = true;
            this.isBoletoLoaded = true;
            this.isBoletoUploadLoaded = false;
        }
    }

    async handleFilesLoading(){
        if(this.isBoletoLoaded == true && (this.isApoliceLoaded || this.isApoliceUploadLoaded)){
            this.handleLoading(false);
        }
        if(this.isBoletoUploadLoaded == true && (this.isApoliceLoaded || this.isApoliceUploadLoaded)){
            this.handleLoading(false);
        }
        if(this.isApoliceLoaded == true && (this.isBoletoLoaded || this.isBoletoUploadLoaded)){
            this.handleLoading(false);
        }
        if(this.isApoliceUploadLoaded == true && (this.isBoletoLoaded || this.isBoletoUploadLoaded)){
            this.handleLoading(false);
        }
        
    }

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
        if(this.isFirstOpen && this.isEmited == false){
            this.handleLoading(true);
            this.isFirstOpen = false;
        }
    }

    enableButtonEnviar(){
        if(this.isCorporate){
            if(this.showViewFilesBoleto && this.showViewFilesApolice){
                this.buttonEnviar = "button-enviar"
            }else{
                this.buttonEnviar = "button-enviar-disabled"
            }
        }else if(this.isBeneficios){
            if( this.showViewFilesKitImplantacao){
                this.buttonEnviar = "button-enviar"
            }else{
                this.buttonEnviar = "button-enviar-disabled"
            }
        }else if(this.isMcmv){
             if(this.showViewFilesBoleto && this.showViewFilesApolice){
                this.buttonEnviar = "button-enviar"
            }else{
                this.buttonEnviar = "button-enviar-disabled"
            }
        }
    }

    handleSend(){
        this.handleLoading(true);
        if(this.isCorporate){
            if(this.showViewFilesBoleto && this.showViewFilesApolice){
                // console.log('Botão habilitado.');
                this.emitQuote();
            }else{
                console.log('Botão desabilitado.');
            }
        }else if(this.isBeneficios){
            if( this.showViewFilesKitImplantacao){
                // console.log('Botão habilitado.');
                this.emitQuote();
            }else{
                console.log('Botão desabilitado.');
            }
        }else if(this.isMcmv){
            if(this.showViewFilesBoleto && this.showViewFilesApolice){
                // console.log('Botão habilitado.');
                this.emitQuote();
            }else{
                console.log('Botão desabilitado.');
            }
        }
        this.handleRefresh();
    }

    async emitQuote(){
        await emitQuote({caseId : this.caseId}).then(result => {
            // console.log('backend emissão' + JSON.stringify(result));
            this.isEmited = true;
            this.showButtonDeleteFile = false;
            this.handleRefresh();
            const evt = new ShowToastEvent({
                        title: "Sucesso ao realizar emissão.",
                        message: "Emissão realizada com sucesso.",
                        variant: "success",
                        });
                        this.dispatchEvent(evt);
                        this.handleLoading(false);
        })
        .catch(error =>{
            console.log('error: ' + JSON.stringify(error));

            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error insert data',
                            message,
                            variant: 'error',
                        }),
                    );
                });
        this.handleLoading(false);

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
        console.log('Entrou no loading document' + this.isLoading);
    }
}