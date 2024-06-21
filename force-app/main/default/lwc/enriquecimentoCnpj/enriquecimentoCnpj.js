import { LightningElement, track, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// importing to refresh the apex if any record changes the datas
import {refreshApex} from '@salesforce/apex';
import findCompany from '@salesforce/apex/DiretrixController.findCompanyByIndentificationNumber';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import IdentificationNumber from '@salesforce/schema/Lead.IdentificationNumber__c';
import RazaoSocial from '@salesforce/schema/Lead.Company';
import AnnualRevenue from '@salesforce/schema/Lead.AnnualRevenue';
import Email from '@salesforce/schema/Lead.Email';
import LeadId from '@salesforce/schema/Lead.Id';
import Endereco from '@salesforce/schema/Lead.Street';
import Cidade from '@salesforce/schema/Lead.City';
import CEP from '@salesforce/schema/Lead.PostalCode';
import UF from '@salesforce/schema/Lead.State';
import Phone from '@salesforce/schema/Lead.Phone';

// tables row actions
const actionsAddress = [
    { label: 'Salvar', name: 'save'}
];
const actionsEmail = [
    { label: 'Salvar', name: 'save'}
];
const actionsPhone = [
    { label: 'Salvar', name: 'save'}
];

export default class EnriquecimentoCnpj extends LightningElement {
    objresult = [];
    // Salesforce record
    @api recordId;

    //tracked reactive private props
    @track result = [];
    @track error;
    @track stack; 

    @track searchKey = '';
    @track dadosEmpresa;
    @track enderecos;
    @track emails;
    @track loading = false;
    @track loadingSaving = false;
    @track disableButton = false;
    @track disableText = true;
    @track record;
    
    @track cnpj;
    @track annualRevenue;
    @track annualRevenueGrouplabel;
    @track annualRevenuelabel;
    @track razaoSocial;
    @track emailPrincipal;

    @track isModalOpen = false;
    @track bShowModal = false;

    @track isDadosEmpresa = false;
    @track isEndereco = false;
    @track isEmail = false;
    @track isPhone = false;


    renderedCallback(){
        this.verifyFields();
    }

    verifyFields(){
        if(this.cnpj == null){
            this.disableButton = false;
            //this.disableText = false;
        }
        else{
            this.disableButton = false;  
            //this.disableText = true;      
        }
    }

    @wire(
        getRecord, {
            recordId: '$recordId',
            fields: ['Lead.Id', 'Lead.IdentificationNumber__c', 'Lead.AnnualRevenue']
        }
    )
    
    wiredLead({ error, data }){
        if(data){
            //console.log('this.record on wired: ' + this.record);
            //this.IdLead = data.fields.Id.value;
            this.cnpj = data.fields.IdentificationNumber__c.value;
            //console.log('this.IdLead after wired ' + this.IdLead);
            this.verifyFields();

            this.searchKey = this.cnpj;
            this.record = data;
            this.error = undefined;
        } else if(error){
            this.error = error;
            this.record = undefined;
        }
    }

    handleClick(event)
    {
        //console.log(event.target.label);
        var inp = this.template.querySelectorAll("lightning-input");

        inp.forEach(function(element){
            if(element.name=="cnpj"){
                this.searchKey = element.value;
            }
            // else if(element.name=="input2")
            //     this.age=element.value;
        },this);

        if(this.searchKey != ''){
            this.handleSearch();
        }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Info!',
                    message: 'Informar o CNPJ para realizar a pesquisa!',
                    variant: 'info',
                }),
            );
        }
    }

    handleSearch(){
        this.loading = true;
        this.disableButton = true;
        console.log(this.searchKey);
        findCompany({ identificationNumber: this.searchKey })
        .then(result => {
            console.log(result);

            this.objresult = JSON.parse(result);

            console.log(this.objresult)

            if(this.objresult.sucesso){
                this.dadosEmpresa = this.objresult.consulta.dadosGerais[0];
                this.enderecos = this.objresult.consulta.enderecos;
                this.emails = this.objresult.consulta.emails;
                this.telefones = this.objresult.consulta.telefones;
                this.error = undefined;
                this.loading = false;

                this.fillData(this.objresult);
            }
            else{
                this.loading = false;
                let msg = '';
                if(this.objresult.msg == 'CNPJ não encontrado'){
                    msg = 'O CNPJ informado não foi encontrado';
                }
                else{
                    msg = this.objresult.msg;
                }

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Oops!',
                        message: msg,
                        variant: 'info',
                    }),
                );
            }
        })
        .catch(error => {
            this.error = error;
            
            console.log(error);

            this.loading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erro!',
                    message: error,
                    variant: 'error',
                }),
            );
            
        })
        // .finally(() => {
        //     this.loading = false;
        // });
    }

    fillData(result){
        this.cnpj = result.consulta.dadosGerais[0].CNPJ.trim();
        this.razaoSocial = result.consulta.dadosGerais[0].RAZAO.trim();
        this.annualRevenuelabel =  'R$ ' + parseFloat(result.consulta.dadosGerais[0].FATURAMENTO_PRESUMIDO_ANUAL.trim()).toLocaleString("PT-BR", {style: "decimal", minimumFractionDigits: 2});
        this.annualRevenue = result.consulta.dadosGerais[0].FATURAMENTO_PRESUMIDO_ANUAL.trim();
        this.annualRevenueGrouplabel = 'R$ ' + parseFloat(result.consulta.dadosGerais[0].FATURAMENTO_PRESUMIDO_ANUAL_GRUPO.trim()).toLocaleString("PT-BR", {style: "decimal", minimumFractionDigits: 2});
    }

    handleActionDadosEmpresa(){
        this.isDadosEmpresa = true;
        this.isEndereco = false;
        this.isEmail = false;
        this.isPhone = false;

        this.bShowModal = true;
    }

    handleRowActionAddress(event){
        let row = event.detail.row;

        this.isDadosEmpresa = false;
        this.isEndereco = true;
        this.isEmail = false;
        this.isPhone = false;

        this.viewCurrentRecord(row);
    }

    handleRowActionEmail(event){
        //let actionName = event.detail.action.name;
        //window.console.log('actionName ====> ' + actionName);
        let row = event.detail.row;
        //window.console.log('row ====> ' + row);
        //window.console.log('row ====> ' + JSON.stringify(row));
        // eslint-disable-next-line default-case

        this.isDadosEmpresa = false;
        this.isEndereco = false;
        this.isEmail = true;
        this.isPhone = false;

        this.viewCurrentRecord(row);
    }

    handleRowActionPhone(event){
        //let actionName = event.detail.action.name;
        //window.console.log('actionName ====> ' + actionName);
        let row = event.detail.row;
        //window.console.log('row ====> ' + row);
        //window.console.log('row ====> ' + JSON.stringify(row));

        this.isDadosEmpresa = false;
        this.isEndereco = false;
        this.isEmail = false;
        this.isPhone = true;

        this.viewCurrentRecord(row);   
    }

    // view the current record details
    viewCurrentRecord(currentRow){
        this.bShowModal = true;
        this.record = currentRow;
    }

    openModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
        this.bShowModal = false;
    }

    SalvarRegistro(){
        //console.log('SalvarRegistro');
        if(this.isDadosEmpresa){
            this.setDataEmpresa();
        }
        else if(this.isEndereco){
            this.setDataEndereco();
        }
        else if(this.isEmail){
            this.setDataEmail();
        }
        else if(this.isPhone){
            this.setDataPhone();
        }
    }

    setDataEmpresa(){
        this.loadingSaving = true;
        const fields = {};

        fields[LeadId.fieldApiName] = this.recordId;
        fields[RazaoSocial.fieldApiName] = this.razaoSocial.trim();
        fields[IdentificationNumber.fieldApiName] = this.cnpj.trim();
        fields[AnnualRevenue.fieldApiName] = this.annualRevenue.trim();

        const recordInput = { fields };

        console.log(recordInput);

        this.handleSalvar(recordInput,'Lead foi atualizado com sucesso')
    }

    setDataEndereco(){
        const fields = {};

        //console.log('handleSalvarEndereco');

        fields[LeadId.fieldApiName] = this.recordId;
        fields[Endereco.fieldApiName] = this.record.ENDERECO.trim();
        fields[Cidade.fieldApiName] = this.record.CIDADE.trim();
        fields[CEP.fieldApiName] = this.record.CEP.trim();
        fields[UF.fieldApiName] = this.record.UF.trim();
        
        const recordInput = { fields };

        this.handleSalvar(recordInput, 'Endereço foi atualizado com sucesso');
    }

    setDataEmail(){
        const fields = {};

        //console.log('handleSalvarEmail');

        fields[LeadId.fieldApiName] = this.recordId;
        fields[Email.fieldApiName] = this.record.EMAIL.trim();
        
        const recordInput = { fields };

        this.handleSalvar(recordInput, 'Email foi atualizado com sucesso');
    }

    setDataPhone(){
        const fields = {};

        //console.log('handleSalvarPhone');

        fields[LeadId.fieldApiName] = this.recordId;
        fields[Phone.fieldApiName] = this.record.DDD.trim() + this.record.TELEFONE.trim();
        
        const recordInput = { fields };

        this.handleSalvar(recordInput, 'Telefone foi atualizado com sucesso');
    }

    handleSalvar(recordInput, msg){
        this.loadingSaving = true;
        console.log(recordInput);
        //console.log('handleSalvar: ' + JSON.stringify(recordInput));

        updateRecord(recordInput)
            .then(() => {
                this.bShowModal = false;
                this.loadingSaving = false;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: msg,
                        variant: 'success'
                    })
                );
                return refreshApex(this.record);
            })
            .catch(error => {
                console.log(error);
                this.loadingSaving = false;
                this.bShowModal = false;

                if(error.body.message == 'The requested resource does not exist'){
                    //console.log(' if this record null '+ this.record)
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Após enriquecimento, LEAD atribuído para outra regional por diferença de Faturamento ou Região! {1}.",
                        "messageData": [
                            'Salesforce',
                            {
                                url: '/00Q',
                                label: 'Voltar'
                            }
                        ]
                    });
                    this.dispatchEvent(event);
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erro ao enriquecer o Lead',
                            message: error,
                            variant: 'error'
                        })
                    );
                }
            });
    }
    
    columns = [
        { label: 'Endereço', fieldName: 'ENDERECO' },
        { label: 'Número', fieldName: 'NUMERO' },
        { label: 'Bairro', fieldName: 'BAIRRO' },
        { label: 'Cidade', fieldName: 'CIDADE' },
        { label: 'CEP', fieldName: 'CEPOK' },
        { label: 'UF', fieldName: 'UF' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: actionsAddress,
                menuAlignment: 'right'
            }
        }
    ];

    columnsEmails = [
        { label: 'Qualificação', fieldName: 'QUALIFICACAO' },
        { label: 'E-mail', fieldName: 'EMAIL' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: actionsEmail,
                menuAlignment: 'right'
            }
        }
    ];

    columnsTelefones = [
        { label: 'Telefone', fieldName: 'TELEFONEOK' },
        { label: 'Tipo telefone', fieldName: 'TIPO_TELEFONE' },
        { label: 'Restrição', fieldName: 'RESTRICAO' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: actionsPhone,
                menuAlignment: 'right'
            }
        }
    ];
}