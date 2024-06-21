import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunity from '@salesforce/apex/ConnectWizController.getOpportunity';
import updateStageOpportunity from '@salesforce/apex/ConnectWizController.updateStageOpportunity';

const stagesDisableButtonSend =
    [
        'Aberto',
        'Qualificação',
        'Levantamento de Necessidades',
        'Cotação',
        'Em negociação',
        'Em Emissão',
        'Fechado e ganho',
        'Fechado e perdido'
    ];

const stagesDisableButtonDeleteAndSend =
    [
        'Em negociação',
        'Em Emissão',
        'Fechado e ganho',
        'Fechado e perdido'
    ];
export default class ConnectWizOrderAccordionItem extends LightningElement {
    @api recordId; //get the recordId for which files will be attached
    labelName= 'Anexar estudo de mercado';
    tipoDocumento= 'Estudo de Mercado';
    documentTypeName = this.tipoDocumento;
    isOpen = false;
    showUploadFile = false;
    showViewFiles = true;
    showButtonSend = false;
    showButtonDeleteFile = true;
    showButtonDisapproveFile;
    showButtonViewFile = true;
    showSimpleView = true;
    isLoading = false;
    objOpportunity = [];
    showComp = false;

    async connectedCallback(){
        this.handleLoading(false);
        await this.getOpportunity();
        if(this.recordId !== undefined){
            this.handleLoading(true);
        }
    }

    async renderedCallback(){
        // console.log('this.recordId==??',this.recordId);
    }

    async getOpportunity(){
        getOpportunity({recordId : this.recordId})
            .then( async result => {
                    // console.log('get opportunity in backend' + result);
                    this.objOpportunity = JSON.parse(result);
                    await this.controlShowButtonSend();
                    this.handleLoading(false);
                })
                .catch(error =>{
                    console.log('fail get opportunity in backend' + JSON.stringify(error));
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
                    this.handleLoading(false);
                });
    }

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    handleControlShowUploadFile(event){
        this.showUploadFile = event.detail;
        if(this.showUploadFile){
            this.showViewFiles = false;
        } else{
            this.showViewFiles = true;
        }
        this.showComp = true;
    }

    handleControlShowViewFile(event){
        this.showViewFiles = event.detail;
        if(this.showViewFiles){
            this.showUploadFile = false;
        } else{
             this.showUploadFile = true;
        }
        this.showComp = true;
        this.handleLoading(false);
    }

    async controlShowButtonSend(){
        // console.log('this.objOpportunity', this.objOpportunity);
        if(!stagesDisableButtonSend.includes(this.objOpportunity.StageName) && this.showViewFiles){
            this.showButtonSend = true;
            this.showButtonDeleteFile = true;
            this.handleLoading(false);
        } else if(stagesDisableButtonDeleteAndSend.includes(this.objOpportunity.StageName) && this.showViewFiles){
            this.showButtonSend = false;
            this.showButtonDeleteFile = false;
            this.handleLoading(false);
        }
        else{
            this.showButtonSend = false;
            this.showButtonDeleteFile = true;
            this.handleLoading(false);
        }
        this.handleLoading(false);
    }

    handleLoading(event){
        this.isLoading = event;
    }

    handleSelectToSend(){
        // this.handleLoading(true);
        updateStageOpportunity({
            recordId : this.recordId,
            stageName : 'Em negociação'
        }).then( async result => {
                if(result){
                    await this.getOpportunity();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sucesso',
                            message: 'Proposta enviada ao comercial, status atualizado com sucesso.',
                            variant: 'success',
                        }),
                    );
                } else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: ' Erro ao enviar ao comercial',
                            message: 'Houve um erro ao enviar o estudo de mercado com comercial, tente novamente.',
                            variant: 'error',
                        }),
                    );
                }
                this.onRefresh();
                this.handleLoading(false);
            })
            .catch(error =>{
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
            this.handleLoading(false);
            this.onRefresh();
    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }
}