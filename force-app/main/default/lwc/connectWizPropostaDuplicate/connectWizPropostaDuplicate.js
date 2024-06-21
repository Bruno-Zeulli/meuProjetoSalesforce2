import { LightningElement , api , track,wire } from 'lwc';
import insertListQuote from '@salesforce/apex/ConnectWizMonitoringController.insertListQuote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConnectWizPropostaDuplicate extends LightningElement {

    @api caseId;
    @api options;
    @api recordTypeId;
    @track yourSelectedValues;

    dataEnvio;
    dataRecebimento;
    importancia;
    premio;
    selectedOptions = [];
    @track isLoading= false;

    closeModal(){
        // this.handleLoading(true);
        const duplicateQuoteEvent = new CustomEvent('duplicateproposta', { detail : {isDuplicate: false }});
        this.dispatchEvent(duplicateQuoteEvent);
        // this.handleLoading(false);
    }

    handleClick(){
        // console.log('options' + JSON.stringify(this.options));
    }

    handleChange(event){
        this.selectedOptions = event.detail;
        // console.log(JSON.stringify(this.selectedOptions));
    }

    handlePremio(event){
        console.log('value' + event.target.value);
        this.premio = event.target.value;
    }

    handleImportania(event){
        console.log('value' + event.target.value);
        this.importancia = event.target.value;
    }

    handleDataEnvio(event){
        console.log('value' + event.target.value);
        this.dataEnvio = event.target.value;
    }

    handleDataRecebimento(event){
        console.log('value' + event.target.value);
        this.dataRecebimento = event.target.value;
    }

    async handleLoading(event){
        this.isLoading = event;
    }

    async handleClickDuplicate(){
        await this.handleLoading(true);
        console.log('isDuplicate');
        let seguradoras = [];
        for(let seguradora of this.selectedOptions){
            seguradoras=[...seguradoras,seguradora.value];
        }
        let propostaForm = {
            seguradoras : seguradoras,
            premio : this.premio,
            importanciaSegurada : this.importancia,
            dataDeEnvioParaSeguradora : this.dataEnvio,
            dataDeRecebimentoDaSeguradora : this.dataRecebimento,
            recordTypeId : this.recordTypeId
        }
        // console.log('propostaForm' + JSON.stringify(propostaForm));

        const insertList = await insertListQuote({proposta : propostaForm, caseId : this.caseId}).then(result => {
            // console.log('backend insert' + JSON.stringify(result));
            // this.handleLoading(true);
            const evt = new ShowToastEvent({
                title: "Sucesso ao inserir todas as cotações",
                message: "Todas as cotações foram inseridas com sucesso",
                variant: "success",
            });
            this.dispatchEvent(evt);
        })
        .catch(error =>{
            console.log('Deu errado insert' + JSON.stringify(error));
            // this.handleLoading(false);
            const evt = new ShowToastEvent({
                title: "Falha ao inserir todas as cotações",
                message: "Uma ou mais cotações não foram inseridas com sucesso",
                variant: "warning",
            });
            this.dispatchEvent(evt);
        });
        this.closeModal();
        const duplicateQuoteInsertedEvent = new CustomEvent('duplicatepropostainserted', { detail : {isSubmited: true}});
        this.dispatchEvent(duplicateQuoteInsertedEvent);
        // this.handleLoading(false);
    }
}