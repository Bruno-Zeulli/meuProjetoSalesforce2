import { LightningElement,api,wire,track } from 'lwc';
import updateQuote from '@salesforce/apex/ConnectWizMonitoringController.updateQuote';
import insertQuote from '@salesforce/apex/ConnectWizMonitoringController.insertQuote';
import insertListQuote from '@salesforce/apex/ConnectWizMonitoringController.insertListQuote';
import { getObjectInfo,getPicklistValuesByRecordType  } from 'lightning/uiObjectInfoApi';
import QUOTE_OBJECT from '@salesforce/schema/Quote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConnectWizPropostaForm extends LightningElement {
    @api caseId;
    @api recordId;
    @api objectApiName;
    @api isEditForm;
    @api propostaEditForm;

    @track objectInfo;
    @track recordTypeId;
    @track options = [];
    @track isAddValorImportancia = false;
    @track isAddValorImportanciaEValorDetalhado = false;
    @track isOnlyAddValorImportancia = false;
    @track isOnlyValorDetalhado = false;
    @track isValorDetalhado = false;
    actualSizeObs =0;
    dataDeEnvioParaSeguradora;
    dataDeRecebimentoDaSeguradora;
    // errorCurrency = "Entre com um número no formato 123.33 , usando o ponto para separar as casas decimais";
    importancia;
    importanciaSeguradaAdicional;
    importanciaSeguradaAdicional2;
    isCamposObrigatorios =true;
    isDataEnvio =true;
    isFieldsCorrect = true;
    isImportanciaValueCorrect = true;
    isImportanciaAdicionalValueCorrect = true;
    isImportanciaAdicional2ValueCorrect = true;
    isObservacoes = true;
    isPorcentagemComissaoValueCorrect = true;
    isPorcentagemAgenciamentoValueCorrect = true;
    isPrizeValueCorrect = true;
    isSeguradora = true;
    isValorIOFCorrect = true;
    isValorLiquidoPremioCorrect = true;
    @track isLoading = false;
    observacoes;
    porcentagemAgenciamento;
    porcentagemComissao;
    premio;
    quoteId;
    seguradora;
    tituloProposta = "Nova Proposta";
    valorIOFPremio;
    valorLiquidoPremio;
    labelName;
    tipoDocumento = 'Proposta de Seguro';
    documentTypeName = 'Proposta de Seguro';
    @track showTitle = false;
    showUploadFile = false;
    showViewFiles = true;
    showButtonDeleteFile = true;
    showButtonDisapproveFile;
    showButtonViewFile = true;
    showSimpleView = true;
    typeEnvio = "text";
    typeRecebimento = "text";
    selectedOptions = [];
    showComp = false;

    @wire(getObjectInfo, { objectApiName: QUOTE_OBJECT })
        objectInfo({error, data}){
            if(data){
                var listRT = data.recordTypeInfos;
                this.recordTypeId = Object.keys(listRT).find(rt => listRT[rt].name === 'Corporate');
                // console.log('RT corporate' + this.recordTypeId);
            }
            else if(error){
                window.console.log('error: => '+JSON.stringify(error));
            }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName: QUOTE_OBJECT, recordTypeId: "$recordTypeId"})
        companyPicklistValues({error, data}){
            // this.handleLoading(true);
            if(data){
                this.options = data.picklistFieldValues.Company__c.values;
                try{
                        let lSeguradora =  this.template.querySelector('[data-id="seguradoraList"]');
                        this.options.forEach(
                            key => {
                                let option = document.createElement("option");
                                // console.log(' option ==> ', option);
                                option.setAttribute('value', key.value);
                                // console.log(' option ==> ', option);

                                let optionText = document.createTextNode(key.value);
                                // console.log(' optionText ==> ', optionText);
                                option.appendChild(optionText);
                                // console.log(' option ==> ', option);
                                lSeguradora.appendChild(option);
                            });
                }catch(error){
                    console.log('error =>',error);
                }
                if(this.isEditForm){
                    this.initialMethodsOnEditForm();
                }
            }
            else if(error){
                window.console.log('error =====> '+JSON.stringify(error));
            }
            // this.handleLoading(false);
    }

    connectedCallback(){
        // this.handleLoading(true);
        // this.tipoDocumento = 'Proposta de Seguro';

        this.recordId = this.propostaEditForm.Id;
        if(!this.isEditForm){
            this.handleLoading(false);
        }
    }

    async initialMethodsOnEditForm(){
         try{
            const resultEditForm = await this.handleEditForm();
            const resultCheckBox = await this.handleCheckbox();
            const resultCheckBoxOnEdit = await this.handleCheckboxOnEdit();
            // this.handleLoading(false);
        }catch(error){
            console.log(error);
        }
        // this.handleLoading(false);
    }

    async handleEditForm(){
        // this.handleLoading(true);
        this.quoteId = this.propostaEditForm.Id;

        this.tituloProposta = "Editar Proposta";
        const inputCombobox = this.template.querySelector('[data-id="seguradoraList"]');
        // console.log('this.propostaEditForm.seguradora' + this.propostaEditForm.seguradora)
        inputCombobox.value = this.propostaEditForm.seguradora;
        this.seguradora = this.propostaEditForm.seguradora;

        let inputValuePrize = this.template.querySelector('.prize-input');
        inputValuePrize.value = (this.propostaEditForm.premio == null ||this.propostaEditForm.premio == "") ? "" : 'R$ ' + this.propostaEditForm.premio;
        this.premio = inputValuePrize.value;

        let inputValueImportancia = this.template.querySelector('.importancia-input');
        inputValueImportancia.value = (this.propostaEditForm.importanciaSegurada == null ||this.propostaEditForm.importanciaSegurada == "") ? "" :'R$ ' +  this.propostaEditForm.importanciaSegurada;
        this.importancia = inputValueImportancia.value;

        let inputValueCheckBoxValorDetalhado = this.template.querySelector('.valor-detalhado-input');
        // console.log('chack box value1' + inputValueCheckBoxValorDetalhado.checked);
        inputValueCheckBoxValorDetalhado.checked = (this.propostaEditForm.isValorDetalhado == null ||this.propostaEditForm.isValorDetalhado == "") ? false : true;

        let inputValueCheckBoxValorImportancia = this.template.querySelector('.valor-importancia-input');
        // console.log('chack box value2' + inputValueCheckBoxValorImportancia.checked);
        inputValueCheckBoxValorImportancia.checked = (this.propostaEditForm.isAddValorImportancia == null ||this.propostaEditForm.isAddValorImportancia == "") ? false : true;

        this.isValorDetalhado = inputValueCheckBoxValorDetalhado.checked;
        this.isAddValorImportancia = inputValueCheckBoxValorImportancia.checked;

        let inputValuePorcentagemComissao = this.template.querySelector('.porcentagem-comissao-input');
        inputValuePorcentagemComissao.value = (this.propostaEditForm.porcentagemComissao == null ||this.propostaEditForm.porcentagemComissao == "") ? "" : this.propostaEditForm.porcentagemComissao +' %';
        this.porcentagemComissao = inputValuePorcentagemComissao.value;

        let inputValuePorcentagemAgenciamento = this.template.querySelector('.porcentagem-agenciamento-input');
        inputValuePorcentagemAgenciamento.value = (this.propostaEditForm.porcentagemAgenciamento == null ||this.propostaEditForm.porcentagemAgenciamento == "") ? "" : this.propostaEditForm.porcentagemAgenciamento +' %';
        this.porcentagemAgenciamento = inputValuePorcentagemAgenciamento.value;

        let inputValueDataEnvio = this.template.querySelector('.data-envio-input');
        inputValueDataEnvio.value = (this.propostaEditForm.dataDeEnvioParaSeguradora == null ||this.propostaEditForm.dataDeEnvioParaSeguradora == "") ? "" : this.propostaEditForm.dataDeEnvioParaSeguradora;
        if(this.propostaEditForm.dataDeEnvioParaSeguradora != null){
            this.typeEnvio = "date";
        }
        this.dataDeEnvioParaSeguradora = inputValueDataEnvio.value;

        let inputValueDataRecebimento = this.template.querySelector('.data-recebimento-input');
        inputValueDataRecebimento.value = (this.propostaEditForm.dataDeRecebimentoDaSeguradora == null ||this.propostaEditForm.dataDeRecebimentoDaSeguradora == "") ? "" : this.propostaEditForm.dataDeRecebimentoDaSeguradora;
        if(this.propostaEditForm.dataDeRecebimentoDaSeguradora != null){
            this.typeRecebimento = "date";
            console.log('Recebeu');
        }
        this.dataDeRecebimentoDaSeguradora = inputValueDataRecebimento.value;

        let inputValueObservacoes = this.template.querySelector('.input-obs');
        inputValueObservacoes.value = (this.propostaEditForm.observacoes == null ||this.propostaEditForm.observacoes == "") ? "" : this.propostaEditForm.observacoes;
        this.actualSizeObs = inputValueObservacoes.value.length;
        this.observacoes = inputValueObservacoes.value;
        // this.handleLoading(false);
    }

    handleInputValue(value , validateExpression){
        if(value != ""){
            if((validateExpression != null || validateExpression !=undefined) && validateExpression != ""){
                value = value;
            }else{
            value = 'R$ ' + value;
            }
        }
        return value;
    }

    handleInputValuePercent(value , validateExpression){
        if(value != ""){
            if((validateExpression != null || validateExpression !=undefined) && validateExpression != ""){
                value = value;
            }else{
            value = value + ' %';
            }
        }
        return value;
    }

    handlePercentType(value){
        console.log('value' + value)
        const percentWithDecimal = new RegExp('^[0-9]+[.][0-9]+[%]$');
        const percentWithoutDecimal = new RegExp('^[0-9]+[%]$');
        const percentWithDecimalAndSpace = new RegExp('^[0-9]+[.][0-9]+[ ][%]$');
        const percentWithoutDecimalAndSpace = new RegExp('^[0-9]+[ ][%]$');
        // console.log(percentWithDecimal.test(value));
        // console.log(percentWithoutDecimal.test(value));
        // console.log(percentWithDecimalAndSpace.test(value));
        // console.log(percentWithoutDecimalAndSpace.test(value));
        if(percentWithDecimal.test(value) || percentWithoutDecimal.test(value) || percentWithDecimalAndSpace.test(value) || percentWithoutDecimalAndSpace.test(value) || value == "" ){
            return true;
        }else{
            return false;
        }
    }

    handleCurrencyType(value){
        console.log('value' + value)
        const currencyWithDecimal = new RegExp('^[R][$][0-9]+[.][0-9]+$');
        const currencyWithoutDecimal = new RegExp('^[R][$][0-9]+$');
        const currencyWithDecimalAndSpace = new RegExp('^[R][$][ ][0-9]+[.][0-9]+$');
        const currencyWithoutDecimalAndSpace = new RegExp('^[R][$][ ][0-9]+$');
        // console.log(currencyWithDecimal.test(value));
        // console.log(currencyWithoutDecimal.test(value));
        // console.log(currencyWithDecimalAndSpace.test(value));
        // console.log(currencyWithoutDecimalAndSpace.test(value));


        if(currencyWithDecimal.test(value) || currencyWithoutDecimal.test(value) || currencyWithDecimalAndSpace.test(value) || currencyWithoutDecimalAndSpace.test(value) || value == "" ){
            return true;
        }else{
            return false;
        }
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

    handleComboboxSeguradora(event){
        const inputCombobox = this.template.querySelector('[data-id="seguradoraList"]');
        this.seguradora = inputCombobox.value;
        // console.log('valor selecionado' + this.seguradora);
    }

    handlePrize(event){
        let inputValue = this.template.querySelector('.prize-input');
        // this.premio = inputValue.value;

        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.premio = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.premio'+ this.premio);
        // inputValue.value = this.handleInputValue(inputValue.value,this.premio);
        // // console.log('event' + event.target.value);
        // if(!this.premio.includes("R$")){
        //     if(this.premio != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        //     }
        // }
        // this.isPrizeValueCorrect = this.handleCurrencyType(inputValue.value);
    }

    handleImportancia(event){

        let inputValue = this.template.querySelector('.importancia-input');
        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.importancia = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.importancia'+ this.importancia);
        // this.importancia = inputValue.value;

        // inputValue.value = this.handleInputValue(inputValue.value,this.importancia);
        // if(!this.importancia.includes("R$") && this.importancia != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        // }
        // this.isImportanciaValueCorrect = this.handleCurrencyType(inputValue.value);
    }

    handleCheckboxValorDetalhado(event){
        this.isValorDetalhado = event.target.checked;
        this.handleCheckbox();
    }

    handleCheckboxValorImportancia(event){
        this.isAddValorImportancia = event.target.checked;
        this.handleCheckbox();
    }

    async handleCheckbox(){
        // this.handleLoading(true);
        if(this.isValorDetalhado && this.isAddValorImportancia){
            this.isAddValorImportanciaEValorDetalhado = true;
            this.isOnlyAddValorImportancia = false;
            this.isOnlyValorDetalhado = false;
        }else if(!this.isValorDetalhado && this.isAddValorImportancia){
            this.isAddValorImportanciaEValorDetalhado = false;
            this.isOnlyAddValorImportancia = true;
            this.isOnlyValorDetalhado = false;
        }
        else if(this.isValorDetalhado && !this.isAddValorImportancia){
            this.isAddValorImportanciaEValorDetalhado = false;
            this.isOnlyValorDetalhado = true;
            this.isOnlyAddValorImportancia = false;
        }else if(!this.isValorDetalhado && !this.isAddValorImportancia){
            this.isAddValorImportanciaEValorDetalhado = false;
            this.isOnlyAddValorImportancia = false;
            this.isOnlyValorDetalhado = false;
        }
        // this.handleLoading(false);
    }

    async handleCheckboxOnEdit(){
        // this.handleLoading(true);
        if(this.isValorDetalhado && this.isAddValorImportancia){

                let inputValueLiquidoPremio = this.template.querySelector('.valor-liquido-premio-input');
                inputValueLiquidoPremio.value = (this.propostaEditForm.valorLiquidoPremio == null ||this.propostaEditForm.valorLiquidoPremio == "")? "" :'R$ ' + this.propostaEditForm.valorLiquidoPremio;
                this.valorLiquidoPremio = this.propostaEditForm.valorLiquidoPremio;

                let inputValueIOFPremio = this.template.querySelector('.IOF-input');
                inputValueIOFPremio.value = (this.propostaEditForm.valorIOFPremio == null ||this.propostaEditForm.valorIOFPremio == "")? "" :'R$ ' + this.propostaEditForm.valorIOFPremio;
                this.valorIOFPremio = this.propostaEditForm.valorIOFPremio;

                let inputValueImportaciaAdicional = this.template.querySelector('.valor-importancia-segurada-adicional1');
                inputValueImportaciaAdicional.value = (this.propostaEditForm.importanciaSeguradaAdicional == null ||this.propostaEditForm.importanciaSeguradaAdicional == "")? "" :'R$ ' + this.propostaEditForm.importanciaSeguradaAdicional;
                this.importanciaSeguradaAdicional = this.propostaEditForm.importanciaSeguradaAdicional;

                let inputValueImportanciaAdicional2 = this.template.querySelector('.valor-importancia-segurada-adicional2');
                inputValueImportanciaAdicional2.value = (this.propostaEditForm.importanciaSeguradaAdicional2 == null ||this.propostaEditForm.importanciaSeguradaAdicional2 == "")? "" :'R$ ' + this.propostaEditForm.importanciaSeguradaAdicional2;
                this.importanciaSeguradaAdicional2 = this.propostaEditForm.importanciaSeguradaAdicional2;

        }else if(!this.isValorDetalhado && this.isAddValorImportancia){

                let inputValueImportaciaAdicional = this.template.querySelector('.valor-importancia-segurada-adicional1');
                inputValueImportaciaAdicional.value = (this.propostaEditForm.importanciaSeguradaAdicional == null ||this.propostaEditForm.importanciaSeguradaAdicional == "")? "" :'R$ ' + this.propostaEditForm.importanciaSeguradaAdicional;
                this.importanciaSeguradaAdicional = this.propostaEditForm.importanciaSeguradaAdicional;

                let inputValueImportanciaAdicional2 = this.template.querySelector('.valor-importancia-segurada-adicional2');
                inputValueImportanciaAdicional2.value = (this.propostaEditForm.importanciaSeguradaAdicional2 == null ||this.propostaEditForm.importanciaSeguradaAdicional2 == "")? "" :'R$ ' + this.propostaEditForm.importanciaSeguradaAdicional2;
                this.importanciaSeguradaAdicional2 = this.propostaEditForm.importanciaSeguradaAdicional2;

        }else if(this.isValorDetalhado && !this.isAddValorImportancia){

                let inputValueLiquidoPremio = this.template.querySelector('.valor-liquido-premio-input');
                inputValueLiquidoPremio.value = (this.propostaEditForm.valorLiquidoPremio == null ||this.propostaEditForm.valorLiquidoPremio == "")? "" :'R$ ' + this.propostaEditForm.valorLiquidoPremio;
                this.valorLiquidoPremio = this.propostaEditForm.valorLiquidoPremio;
                let inputValueIOFPremio = this.template.querySelector('.IOF-input');
                inputValueIOFPremio.value = (this.propostaEditForm.valorIOFPremio == null ||this.propostaEditForm.valorIOFPremio == "")? "" :'R$ ' + this.propostaEditForm.valorIOFPremio;
                this.valorIOFPremio = this.propostaEditForm.valorIOFPremio;
        }
        // this.handleLoading(false);
    }

    handleValorLiquidoPremio(event){
        let inputValue = this.template.querySelector('.valor-liquido-premio-input');
        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.valorLiquidoPremio = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.valorLiquidoPremio'+ this.valorLiquidoPremio);
        // this.valorLiquidoPremio = inputValue.value;

        // inputValue.value = this.handleInputValue(inputValue.value,this.valorLiquidoPremio);
        // if(!this.valorLiquidoPremio.includes("R$") && this.valorLiquidoPremio != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        // }
        // this.isValorLiquidoPremioCorrect = this.handleCurrencyType(inputValue.value);
    }

    handleImportanciaAdicional1(event){
        let inputValue = this.template.querySelector('.valor-importancia-segurada-adicional1');
        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.importanciaSeguradaAdicional = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.importanciaSeguradaAdicional'+ this.importanciaSeguradaAdicional);
        // this.importanciaSeguradaAdicional = inputValue.value;

        // inputValue.value = this.handleInputValue(inputValue.value,this.importanciaSeguradaAdicional);
        // if(!this.importanciaSeguradaAdicional.includes("R$") && this.importanciaSeguradaAdicional != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        // }
        // this.isImportanciaAdicionalValueCorrect = this.handleCurrencyType(inputValue.value);
    }

    handleImportanciaAdicional2(event){
        let inputValue = this.template.querySelector('.valor-importancia-segurada-adicional2');
        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.importanciaSeguradaAdicional2 = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.importanciaSeguradaAdicional2'+ this.importanciaSeguradaAdicional2);
        // this.importanciaSeguradaAdicional2 = inputValue.value;

        // inputValue.value = this.handleInputValue(inputValue.value,this.importanciaSeguradaAdicional2);
        // if(!this.importanciaSeguradaAdicional2.includes("R$") && this.importanciaSeguradaAdicional2 != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        // }
        // this.isImportanciaAdicional2ValueCorrect = this.handleCurrencyType(inputValue.value);
    }

    handleIOFPremio(event){
        let inputValue = this.template.querySelector('.IOF-input');
        inputValue.value = 'R$' + this.maskPrize(inputValue.value);
        this.valorIOFPremio = inputValue.value.replace('.', '').replace(',', '').replace(/\D/g, '')/100;
        console.log('this.valorIOFPremio'+ this.valorIOFPremio);

        // this.valorIOFPremio = inputValue.value;

        // inputValue.value = this.handleInputValue(inputValue.value,this.valorIOFPremio);
        // if(!this.valorIOFPremio.includes("R$") && this.valorIOFPremio != ""){
        //     inputValue.value = 'R$ ' + inputValue.value;
        // }
        // this.isValorIOFCorrect = this.handleCurrencyType(inputValue.value);
    }

    handlePorcentagemComissao(event){
        let inputValue = this.template.querySelector('.porcentagem-comissao-input');
        this.porcentagemComissao = inputValue.value;

        inputValue.value = this.handleInputValuePercent(inputValue.value,this.porcentagemComissao);
        // console.log('event' + event.target.value);
        if(!this.porcentagemComissao.includes("%")){
            if(this.porcentagemComissao != ""){
                inputValue.value = inputValue.value +' %';
            }
        }
        this.porcentagemComissao.replace = this.porcentagemComissao.replace("%","");

        this.isPorcentagemComissaoValueCorrect = this.handlePercentType(inputValue.value);
    }

    handlePorcentagemAgenciamento(event){
        let inputValue = this.template.querySelector('.porcentagem-agenciamento-input');
        this.porcentagemAgenciamento = inputValue.value;

        inputValue.value = this.handleInputValuePercent(inputValue.value,this.porcentagemAgenciamento);
        // console.log('event' + event.target.value);
        if(!this.porcentagemAgenciamento.includes("%")){
            if(this.porcentagemAgenciamento != ""){
                inputValue.value = inputValue.value +' %';
            }
        }
        this.porcentagemAgenciamento = this.porcentagemAgenciamento.replace("%","");
        this.isPorcentagemAgenciamentoValueCorrect = this.handlePercentType(inputValue.value);
    }

    handleDataEnvio(event){
        this.dataDeEnvioParaSeguradora = event.target.value;
        // console.log('this.data' + this.dataDeEnvioParaSeguradora);
    }

    handleDataRecebimento(event){
        this.dataDeRecebimentoDaSeguradora = event.target.value;
        // console.log('this.data' + this.dataDeRecebimentoDaSeguradora);
    }

    handleTextChange(event){
        this.observacoes = event.detail.value;
        this.actualSizeObs = this.observacoes.length;
    }

    async handleClickSave(){
        await this.handleLoading(true);
        await this.handleFieldFormats();
        let seguradoras = await this.validateCompany();
        if(this.isFieldsCorrect){
            this.premio = (this.premio == undefined) ? "" : isNaN(this.premio) ? parseFloat(this.premio.split("R$ ").pop()) : parseFloat(this.premio);
            this.importancia = (this.importancia == undefined) ? "" : isNaN(this.importancia) ? parseFloat(this.importancia.split("R$ ").pop()) : parseFloat(this.importancia);
            this.valorLiquidoPremio = (this.valorLiquidoPremio == undefined) ? "" : parseFloat(this.valorLiquidoPremio);
            this.importanciaSeguradaAdicional = (this.importanciaSeguradaAdicional == undefined) ? "" : parseFloat(this.importanciaSeguradaAdicional);
            this.importanciaSeguradaAdicional2 = (this.importanciaSeguradaAdicional2 == undefined) ? "" : parseFloat(this.importanciaSeguradaAdicional2);
            this.valorIOFPremio = (this.valorIOFPremio == undefined) ? "" : parseFloat(this.valorIOFPremio);
            this.porcentagemComissao = (this.porcentagemComissao == undefined) ? "" : parseFloat(this.porcentagemComissao);
            this.porcentagemAgenciamento = (this.porcentagemAgenciamento == undefined) ? "" : parseFloat(this.porcentagemAgenciamento);

            let propostaForm = {
            type : 'New',
            quoteId : this.quoteId,
            seguradora : this.isEditForm ? this.seguradora : null,
            seguradoras : this.isEditForm ? null : seguradoras,
            premio : this.premio,
            importanciaSegurada : this.importancia,
            isValorDetalhado : this.isValorDetalhado,
            isAddValorImportancia : this.isAddValorImportancia,
            valorLiquidoPremio : this.valorLiquidoPremio,
            valorIOFPremio : this.valorIOFPremio,
            importanciaSeguradaAdicional : this.importanciaSeguradaAdicional,
            importanciaSeguradaAdicional2 : this.importanciaSeguradaAdicional2,
            porcentagemComissao : this.porcentagemComissao,
            porcentagemAgenciamento : this.porcentagemAgenciamento,
            dataDeEnvioParaSeguradora : this.dataDeEnvioParaSeguradora,
            dataDeRecebimentoDaSeguradora : this.dataDeRecebimentoDaSeguradora,
            observacoes : this.observacoes,
            recordTypeId: this.recordTypeId,
            status : (this.propostaEditForm.status == null || this.propostaEditForm.status == "") ?  'Draft' : this.propostaEditForm.status
            }

            console.log('propostaForm ' + JSON.stringify(propostaForm));

            if(this.validateForm()){
                if(this.isEditForm){
                    updateQuote({proposta : propostaForm}).then(result => {
                        // console.log('backend update' + JSON.stringify(result));
                        const finishFormEvent = new CustomEvent('finishform', { detail : {closeForm: true} });
                        this.dispatchEvent(finishFormEvent);
                        const updateFormEvent = new CustomEvent('updateform', { detail : {updateForm: true} });
                        this.dispatchEvent(updateFormEvent);
                        const evt = new ShowToastEvent({
                        title: "Sucesso ao atualizar cotação.",
                        message: "Cotação atualizada com sucesso.",
                        variant: "success",
                        });
                        this.dispatchEvent(evt);
                        this.onRefresh();
                        // this.handleLoading(false);
                    })
                    .catch(error =>{
                        console.log('Deu errado insert' + JSON.stringify(error));
                        const evt = new ShowToastEvent({
                        title: "Falha ao atualizar cotação.",
                        message: "Não foi possível atualizar cotação.",
                        variant: "warning",
                        });
                        this.dispatchEvent(evt);
                        // this.handleLoading(false);
                    });
                    // console.log('JSON EDIT ' + JSON.stringify(propostaForm));
                    // this.handleLoading(false);
                }else{
                    const insertList = await insertListQuote({caseId : this.caseId , proposta : propostaForm}).then(result => {
                        // console.log('backend insert' + JSON.stringify(result));
                        // this.handleLoading(true);
                        const finishFormEvent = new CustomEvent('finishform', { detail : {closeForm: true} });
                        this.dispatchEvent(finishFormEvent);
                        const updateFormEvent = new CustomEvent('updateform', { detail : {updateForm: true} });
                        const evt = new ShowToastEvent({
                            title: "Sucesso ao inserir todas as cotações",
                            message: "Todas as cotações foram inseridas com sucesso",
                            variant: "success",
                        });
                        this.dispatchEvent(evt);
                        this.dispatchEvent(updateFormEvent);
                        this.onRefresh();
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
                        this.handleLoading(false);
                    });
                }
            }else{
                this.handleLoading(false);
            }
        }else{
            // this.handleLoading(false);
        }
    }

    handleClickCancel(){
        this.handleLoading(true);
        const finishFormEvent = new CustomEvent('finishform', { detail : {closeForm: true} });
        this.dispatchEvent(finishFormEvent);
        this.handleLoading(false);
    }

    validateForm(){
        // this.handleLoading(true);
        let isFormValid = true;
        if(this.seguradora == null && this.selectedOptions == null){
            this.isSeguradora = false;
            isFormValid = false;
        }else{
            this.isSeguradora = true;
        }
        if(this.dataDeEnvioParaSeguradora == null || this.dataDeEnvioParaSeguradora == ""){
            this.isDataEnvio = false;
            isFormValid = false;
        }else{
            this.isDataEnvio = true;
        }
        // if(this.observacoes == null || this.observacoes == ""){
        //     this.isObservacoes = true;
        //     isFormValid = false;
        // }else{
        //     this.isObservacoes = false;
        // }

        this.isCamposObrigatorios = isFormValid;
        // this.handleLoading(false);
        return isFormValid;
    }

    async handleFieldFormats(){
        // this.handleLoading(true);
        if(this.isPrizeValueCorrect && this.isImportanciaValueCorrect && this.isValorLiquidoPremioCorrect && this.isImportanciaAdicionalValueCorrect && this.isImportanciaAdicional2ValueCorrect
           && this.isPorcentagemComissaoValueCorrect && this.isPorcentagemAgenciamentoValueCorrect && this.isValorIOFCorrect){
            this.isFieldsCorrect = true;
        }else{
            this.isFieldsCorrect = false;
        }
        // this.handleLoading(false);
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
        // this.handleLoading(true);
        this.showViewFiles = event.detail;
        if(this.showViewFiles){
            this.showUploadFile = false;
        } else{
            if(this.propostaEditForm.Id !== undefined){
                this.showUploadFile = true;
            } else{
                this.showUploadFile = false;
            }
        }
        this.showComp = true;
        // this.handleLoading(false);
    }

    handleFocusEnvio(){
        this.typeEnvio = "date";
    }
    handleBlurEnvio(){
        if(this.dataDeEnvioParaSeguradora == null || this.dataDeEnvioParaSeguradora ==""){
            this.typeEnvio = "text";
        }
    }

    handleFocusRecebimento(){
        this.typeRecebimento = "date";
    }
    handleBlurRecebimento(){
        if(this.dataDeRecebimentoDaSeguradora == null || this.dataDeRecebimentoDaSeguradora ==""){
            this.typeRecebimento = "text";
        }
    }

    onRefresh(){
        // console.log('filho')
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    async handleLoading(event){
        console.log('Entrou no loading cotacao');
        this.isLoading = event;
    }

    handleChange(event){
        this.selectedOptions = event.detail;
        console.log(JSON.stringify(this.selectedOptions));
    }

    async validateCompany(){
        let seguradoras = [];
        for(let seguradora of this.selectedOptions){
            seguradoras=[...seguradoras,seguradora.value];
        }
        return seguradoras;
               
    }
}