import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retrieveQuotes from '@salesforce/apex/ConnectWizMonitoringController.retrieveQuotes';
import deleteQuote from '@salesforce/apex/ConnectWizMonitoringController.deleteQuote';
import insertQuote from '@salesforce/apex/ConnectWizMonitoringController.insertQuote';
import updateQuote from '@salesforce/apex/ConnectWizMonitoringController.updateQuote';
import cancelQuote from '@salesforce/apex/ConnectWizMonitoringController.cancelQuote';
import createTaskHistory from '@salesforce/apex/ConnectWizController.createTaskHistory';


const lstOptions = [
                    'Sem retorno',
                    'Recusa por nomeação',
                    'Atividade restrita',
                    'Condiçoes da proposta',
                    'Falta de prazo para colocar o risco',
                    'Múltiplos fatores',
                    'Não conseguimos capacidade completa do risco',
                    'QAR incompleto',
                    'Qualidade do risco (protecionais,vistoria,etc)',
                    'Restriçao técnica',
                    'Declínio'
                ]
export default class ConnectWizPropostasEdit extends LightningElement {

    @api caseId;
    @api opportunityId;

    @track deleteQuote =false;
    @track cancelQuote =false;
    @track cloneQuote = false;
    @track isSend = false;
    @track listProposta = [];
    @track listPropostaTratada = [];
    @track showTitle = false;
    @track isLoading = false;
    @track userSelectedReason;

    errorEnvio = false;
    propostaToDeleteId;
    propostaToCancelId;
    propostaToCloneId;
    propostaToSendId;
    showSendToComercial;
    recordId;
    @track showViewFiles = true;
    @track showUploadFile = false;
    showButtonViewFile = true;
    showButtonDeleteFile = true;
    showSimpleView = true;
    documentTypeName = 'Proposta de Seguro';
    tipoDocumento = 'Proposta de Seguro';
    lstOptions = lstOptions;
    isCamposObrigatorios =true;

    connectedCallback(){
        this.handleLoading(true);
        this.retrieveQuotes();
    }

    async retrieveQuotes(){
        await retrieveQuotes({caseId : this.caseId}).then(result => {
            console.log('backend retrieve before' + JSON.stringify(result));
            this.listProposta = [...result];
            this.listPropostaTratada = JSON.parse(JSON.stringify(result));

            for(let item of this.listPropostaTratada.values()){
                (item.premio == null || item.premio =="") ? item.premio = "Não informado" : item.premio = 'R$' + this.maskPrize(item.premio);
                (item.importanciaSegurada == null || item.importanciaSegurada =="") ? item.importanciaSegurada = "Não informado" : item.importanciaSegurada = 'R$' + this.maskPrize(item.importanciaSegurada);
                (item.valorLiquidoPremio == null || item.valorLiquidoPremio =="") ? item.valorLiquidoPremio = "Não informado" : item.valorLiquidoPremio = "R$ " + this.maskPrize(item.valorLiquidoPremio);
                (item.valorIOFPremio == null || item.valorIOFPremio =="") ? item.valorIOFPremio = "Não informado" : item.valorIOFPremio = "R$ " + this.maskPrize(item.valorIOFPremio);
                (item.importanciaSeguradaAdicional == null || item.importanciaSeguradaAdicional =="") ? item.importanciaSeguradaAdicional = "Não informado" :item.importanciaSeguradaAdicional =  "R$ " +  this.maskPrize(item.importanciaSeguradaAdicional);
                (item.importanciaSeguradaAdicional2 == null || item.importanciaSeguradaAdicional2 =="") ? item.importanciaSeguradaAdicional2 = "Não informado" : item.importanciaSeguradaAdicional2 = "R$ "+  this.maskPrize(item.importanciaSeguradaAdicional2);
                (item.porcentagemComissao == null || item.porcentagemComissao =="") ? item.porcentagemComissao = "Não informado" : item.porcentagemComissao = item.porcentagemComissao + "%";
                (item.porcentagemAgenciamento == null || item.porcentagemAgenciamento =="") ? item.porcentagemAgenciamento = "Não informado" : item.porcentagemAgenciamento = item.porcentagemAgenciamento + "%";
                (item.dataDeRecebimentoDaSeguradora == null || item.dataDeRecebimentoDaSeguradora =="") ? item.dataDeRecebimentoDaSeguradora = "Não informado" : item.dataDeRecebimentoDaSeguradora = item.dataDeRecebimentoDaSeguradora;
                (item.isEnviada == true || item.isAceita ==true) ? item.showSendToComercial = true : item.showSendToComercial = false;
                if(item.isAceita || item.isEnviada || item.isNegada || item.isCancelled){
                    item.isSolicitada = false;
                    item.isRecebida = false;
                }
                item.fileLoaded = false;
            }
            console.log('backend retrieve after' + JSON.stringify(this.listPropostaTratada))
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
        });
        await this.handleLoading(false);
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

    editPropostaHandler(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));

        const propostaId = event.currentTarget.dataset.id;
        this.recordId = propostaId;
        for(let item of this.listPropostaTratada.values()){
            if(item.quoteId == propostaId){
                item.showDetails = !item.showDetails;
            }
        }
        if(item.showDetails){
            item.fileLoaded = false;
        }
    }

    editPropostaFormHandler(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));
        this.handleLoading(true);
        let propostaId =event.currentTarget.dataset.id;
        this.loading = true;
        for(let item of this.listProposta.values()){
            if(item.quoteId == propostaId){
                let propostaForm = {
                    Id : item.quoteId,
                    seguradora : item.seguradora,
                    premio : item.premio,
                    importanciaSegurada : item.importanciaSegurada,
                    isValorDetalhado : item.isValorDetalhado,
                    isAddValorImportancia : item.isAddValorImportancia,
                    valorLiquidoPremio : item.valorLiquidoPremio,
                    valorIOFPremio : item.valorIOFPremio,
                    importanciaSeguradaAdicional : item.importanciaSeguradaAdicional,
                    importanciaSeguradaAdicional2 : item.importanciaSeguradaAdicional2,
                    porcentagemComissao : item.porcentagemComissao,
                    porcentagemAgenciamento : item.porcentagemAgenciamento,
                    dataDeEnvioParaSeguradora : item.dataDeEnvioParaSeguradora,
                    dataDeRecebimentoDaSeguradora : item.dataDeRecebimentoDaSeguradora,
                    observacoes : item.observacoes,
                    recordTypeId: item.recordTypeId,
                    status : item.status
                }
                const editFormEvent = new CustomEvent('editform', { detail : {editForm: true , propostaEditForm : propostaForm} });
                this.dispatchEvent(editFormEvent);
                const updateFormEvent = new CustomEvent('updateform', { detail : {updateForm: true} });
                this.dispatchEvent(updateFormEvent);
            }
        }
        this.handleLoading(false);
    }

    enviarComercial(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));
        this.propostaToSendId = event.currentTarget.dataset.id;
        this.isSend =true;
    }
    enviarComercialHandler(){
        this.handleLoading(true);

        for(let item of this.listProposta.values()){
            if(item.quoteId == this.propostaToSendId && item.dataDeRecebimentoDaSeguradora != null && item.dataDeRecebimentoDaSeguradora != ""){
                // console.log("entrou no fluxo para enviar ao comercial.")
                let propostaForm = {
                    quoteId : item.quoteId,
                    seguradora : item.seguradora,
                    premio : item.premio,
                    importanciaSegurada : item.importanciaSegurada,
                    isValorDetalhado : item.isValorDetalhado,
                    isAddValorImportancia : item.isAddValorImportancia,
                    valorLiquidoPremio : item.valorLiquidoPremio,
                    valorIOFPremio : item.valorIOFPremio,
                    importanciaSeguradaAdicional : item.importanciaSeguradaAdicional,
                    importanciaSeguradaAdicional2 : item.importanciaSeguradaAdicional2,
                    porcentagemComissao : item.porcentagemComissao,
                    porcentagemAgenciamento : item.porcentagemAgenciamento,
                    dataDeEnvioParaSeguradora : item.dataDeEnvioParaSeguradora,
                    dataDeRecebimentoDaSeguradora : item.dataDeRecebimentoDaSeguradora,
                    observacoes : item.observacoes,
                    recordTypeId: item.recordTypeId,
                    status : "Presented"
                }
                updateQuote({proposta : propostaForm}).then(result => {
                    // console.log('backend update' + JSON.stringify(result));
                    const updateFormEvent = new CustomEvent('updateform', { detail : {updateForm: true} });
                    this.dispatchEvent(updateFormEvent);
                    const evt = new ShowToastEvent({
                    title: "Sucesso ao enviar cotação ao comercial",
                    message: "Cotação enviado ao comercial",
                    variant: "success",
                    });
                    this.dispatchEvent(evt);
                    this.handleRefresh();
                })
                .catch(error =>{
                    console.log('Deu errado insert' + JSON.stringify(error));
                    const evt = new ShowToastEvent({
                    title: "Falha ao enviar cotação ao comercial",
                    message: "Não foi possível enviar cotação para o comercial.",
                    variant: "warning",
                });
                    this.dispatchEvent(evt);
                });
                this.errorEnvio = false;
                this.isSend = false;
                break;
            }else if(item.quoteId == this.propostaToSendId && (item.dataDeRecebimentoDaSeguradora == null || item.dataDeRecebimentoDaSeguradora == "")){
                // const evt = new ShowToastEvent({
                //     title: "Campos obrigatórios não foram preenchidos.",
                //     message: "Preencha a data de recebimento da seguradora para poder enviar ao comercial.",
                //     variant: "error",
                // });
                // this.dispatchEvent(evt);
                // console.log("entrou no else");
                this.errorEnvio = true;
                // this.loading = false;
                // this.isSend = false;
                break;
            }
        }
        this.loading = false;
    }

    clonePropostaHandler(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));
        this.propostaToCloneId = event.currentTarget.dataset.id;
        this.cloneQuote = true;
        // const duplicateQuoteEvent = new CustomEvent('duplicateproposta', { detail : {isDuplicate: true }});
        // this.dispatchEvent(duplicateQuoteEvent);
    }

    deletePropostaHandler(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));
        this.propostaToDeleteId = event.currentTarget.dataset.id;
        this.deleteQuote = true;
    }

    closeDeleteModal(){
        this.deleteQuote = false;
        this.propostaToDeleteId ="";
        this.handleLoading(false);
    }

    closeEnviarComercialModal(){
        this.isSend = false;
        this.propostaToSendId ="";
        this.errorEnvio = false;
        this.handleLoading(false);
    }

    closeCloneModal (){
        this.cloneQuote = false;
        this.propostaToCloneId ="";
        this.handleLoading(false);
    }

    async deleteQuoteHandler(){
        // console.log('this.propostaToDeleteId' + this.propostaToDeleteId);
        this.handleLoading(true);
        const resultDeleteQuote = await this.deletQuote();
        this.deleteQuote = false;
        const resultCallback = await this.retrieveQuotes();
        this.handleLoading(false);
    }


    async cloneQuoteHandler(){
        // console.log('this.propostaToCloneId' + this.propostaToCloneId);
        await this.handleLoading(true);
        this.cloneQuote = false;
        for(let item of this.listProposta.values()){
            if(item.quoteId == this.propostaToCloneId){
                let propostaForm = {
                    Id : item.quoteId,
                    seguradora : item.seguradora,
                    premio : item.premio,
                    importanciaSegurada : item.importanciaSegurada,
                    isValorDetalhado : item.isValorDetalhado,
                    isAddValorImportancia : item.isAddValorImportancia,
                    valorLiquidoPremio : item.valorLiquidoPremio,
                    valorIOFPremio : item.valorIOFPremio,
                    importanciaSeguradaAdicional : item.importanciaSeguradaAdicional,
                    importanciaSeguradaAdicional2 : item.importanciaSeguradaAdicional2,
                    porcentagemComissao : item.porcentagemComissao,
                    porcentagemAgenciamento : item.porcentagemAgenciamento,
                    dataDeEnvioParaSeguradora : item.dataDeEnvioParaSeguradora,
                    dataDeRecebimentoDaSeguradora : item.dataDeRecebimentoDaSeguradora,
                    observacoes : item.observacoes,
                    recordTypeId: item.recordTypeId,
                    status : "Draft"
                }

                await insertQuote({caseId : this.caseId , proposta : propostaForm}).then(result => {
                    console.log('backend insert' + JSON.stringify(result));
                     const evt = new ShowToastEvent({
                    title: "Sucesso ao clonar cotação.",
                    message: "Cotação duplicada com sucesso.",
                    variant: "success",
                    });
                    this.dispatchEvent(evt);
                    this.cloneQuote = false;
                })
                .catch(error =>{
                    console.log('Deu errado insert' + JSON.stringify(error));
                    const evt = new ShowToastEvent({
                    title: "Falha ao clonar cotação.",
                    message: "Não foi possível clonar cotação.",
                    variant: "warning",
                });
                    this.dispatchEvent(evt);
                    this.cloneQuote = false;
                });
                const resultCallback = await this.retrieveQuotes();
                break;
            }
        }
    }

    async deletQuote(){
        this.handleLoading(true);
        await deleteQuote({quoteId : this.propostaToDeleteId}).then(result => {
            console.log('backend delete ' + JSON.stringify(result));
            const evt = new ShowToastEvent({
                    title: "Sucesso ao deletar cotação.",
                    message: "Cotação deletada com sucesso.",
                    variant: "success",
                    });
                    this.dispatchEvent(evt);
            })
            .catch(error =>{
                console.log('Deu errado delete' + JSON.stringify(error));
                const evt = new ShowToastEvent({
                    title: "Falha ao deletar cotação.",
                    message: "Não foi possível deletar cotação.",
                    variant: "warning",
                });
                    this.dispatchEvent(evt);
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error delete data',
                            message,
                            variant: 'error',
                        }),
                    );
                });
    }

    handleControlShowViewFile(event){
        // this.showViewFiles = event.detail;
        // this.showTitle = true;
        // this.handleLoading(false);
        console.log('handleControlShowViewFile this.showViewFiles' + this.showViewFiles);
        // this.showViewFiles = event.detail;
        // if(this.showViewFiles){
        //     this.showUploadFile = false;
        // } else{
        //     this.showUploadFile = true;
        // }
        let propostaId =this.recordId;
        for(let item of this.listPropostaTratada.values()){
                if(item.quoteId == propostaId){
                    item.fileLoaded = true;
                    item.showUploadFile = !event.detail;
                    item.showViewFiles = event.detail;
            }
        }
        this.handleLoading(false);
    }

    handleControlShowUploadFile(event){
        // this.showUploadFile = event.detail;
        console.log('handleControlShowUploadFile this.showUploadFile' + this.showUploadFile);
        // if(this.showUploadFile){
        //     this.showViewFiles = false;
        // } else{
        //     this.showViewFiles = true;
        // }
        let propostaId =this.recordId;
        for(let item of this.listPropostaTratada.values()){
            if(item.quoteId == propostaId){
                    item.fileLoaded = true;
                    item.showUploadFile = event.detail;
                    item.showViewFiles = !event.detail;
            }
        }
        this.handleLoading(false);
    }

    handleLoading(event){
        this.loading = event;
    }

    @api reRender(){
        this.connectedCallback();
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
        console.log('Loading active...')
    }

    cancelPropostaHandler(event){
        // console.log('propostaId ' + JSON.stringify(event.currentTarget.dataset.id));
        this.propostaToCancelId = event.currentTarget.dataset.id;
        this.cancelQuote = true;

    }

    closeCancelModal(){
        this.cancelQuote = false;
        this.propostaToCancelId = "";
        this.handleLoading(false);
    }


    get lstOptions(){
        return lstOptions;
    }


    async cancelQuoteHandler(){
        this.handleLoading(true);
        if(this.validatForm()){
            const resultCancelQuote = await this.cancellQuote();
            const task = await this.createTaskHistory();
            this.cancelQuote = false;
            const resultCallback = await this.retrieveQuotes();
        }
         this.handleRefresh();
            this.onRefresh();
            // this.handleLoading(false);
        this.handleLoading(false);

    }

    async cancellQuote(){
        this.handleLoading(true);
        await cancelQuote({quoteId : this.propostaToCancelId}).then(result => {
            console.log('backend cancel ' + JSON.stringify(result));
            const evt = new ShowToastEvent({
                    title: "Sucesso ao cancelar cotação.",
                    message: "Cotação cancelada com sucesso.",
                    variant: "success",
                    });
                    this.dispatchEvent(evt);
            })
            .catch(error =>{
                console.log('Deu errado cancel' + JSON.stringify(error));
                const evt = new ShowToastEvent({
                    title: "Falha ao cancelar cotação.",
                    message: "Não foi possível cancelar cotação.",
                    variant: "warning",
                });
                    this.dispatchEvent(evt);
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error update data',
                            message,
                            variant: 'error',
                        }),
                    );
                });

    }

    handleSelectReason(){
        let e = this.template.querySelector('[data-id="reasonList"]');
        this.userSelectedReason = e.value;
        console.log(`options list: ==> ${e}`);
    }

    handleSelectedDescription(){
        let e = this.template.querySelector('[data-id="descriptionData"]');
        this.userSelectedDescription = e.value;
        console.log(`dascription: ==> ${this.userSelectedDescription}`);
    }

    async createTaskHistory(){
        // console.log('dentro da task')
        let order;
        for(let item of this.listProposta.values()){
            if(item.quoteId == this.propostaToCancelId){
                order = {
                    quoteId :item.quoteId,
                    company : item.seguradora
                }
            }
        }
        createTaskHistory({
            whatId: this.opportunityId,
            whotId: '',
            subject: 'Cancelamento de cotação - ' + order.company,// todo verificar lista
            description: this.userSelectedReason + ' - ' + this.userSelectedDescription,
            type: 'Cancelamento de cotação'// todo add tipos ou tabulação
        }).then(result =>{
            if(result){}

        }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                this.handleLoading(false);
                throw new Error(error);
            });
    }

    validatForm(){
        let isFormValid = true;
        if(this.userSelectedReason == null) isFormValid = false;
        if(this.userSelectedDescription == null) isFormValid =false;
        this.isCamposObrigatorios = isFormValid;
        return isFormValid;
    }
}