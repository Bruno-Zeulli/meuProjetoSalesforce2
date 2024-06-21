import { LightningElement, wire, track, api } from 'lwc';
import { getPicklistValuesByRecordType, getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import getRecordTypeTicketlist from '@salesforce/apex/TicketsController.getRecordTypeTicketlist';
import getUserOrGroupIds from '@salesforce/apex/TicketsController.getUserOrGroupIds';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordTypeIdByGrupoName from '@salesforce/apex/TicketsController.getRecordTypeIdByGrupoName';

import getProdutoOption from '@salesforce/apex/TicketsController.getProdutoOptions';
import getBandeiraOption from '@salesforce/apex/TicketsController.getBandeiraOptions';
import getGroupOption from '@salesforce/apex/TicketsController.getGroupOptions';
import getMotivoOption from '@salesforce/apex/TicketsController.getMotivoOptions';
import getTipoOption from '@salesforce/apex/TicketsController.getTipoOptions';
import getSubtipoOption from '@salesforce/apex/TicketsController.getSubtipoOptions';
import getOwnerOptions from '@salesforce/apex/TicketsController.getUserOrGroupNames';

export default class FiltroTickets extends LightningElement {
    @track value = 'inProgress';
    @track statusLista = [];
    @track motivoLista = [];
    @track tipoLista = [];
    @track prioridadeLista = [];
    @track tiposRegistro = [];
    @track status = [];
    @track motivo = '';
    @track tipo = '';
    @track subtipo = '';
    @track procedente = '';
    @track prioridade = '';
    @track proprietario = '';
    @track tipoRegistro = 'Todos';
    @track recordTypeIdChange;
    @track motivoPk = [];
    @track typeDisabled = true;
    @track motivoDisabled = true;
    @track tipoValues=[];
    @track createdDateInitial = '';
    @track createdDateEnd = '';

    dependentPicklist;
    showpicklist = false;
    dependentDisabled=true;
    @track recordTypeIdSelected = '';

    @track typeDependentPicklistWrapperArray;
    @track selectedGrupoValue = '';
    @track selectedMotivoValue = '';
    @track selectedTipoValue = '';
    @track selectedSubtipoValue = '';
    @track selectedProcedenteValue = '';
    @track selectedOwnerValue = '';
    @track selectedCreatedDateInitialValue = '';
    @track selectedCreatedDateEndValue = '';

    @track produtoOptions = [];
    @track produtoSelected;
    @track bandeiraOptions = [];
    @track bandeiraSelected;
    @track groupOptions = [];
    @track motivoOptions = [];
    @track tipoOptions = [];
    @track subtipoOptions = [];
    @track ownerOptions = [];

    @track produtoNotSelected = true;
    @track bandeiraNotSelected = true;
    @track groupNotSelected = true;
    @track motivoNotSelected = true;
    @track tipoNotSelected = true;

    @track valueStatusSelected = [];

    @wire(getPicklistValuesByRecordType, { objectApiName: CASE_OBJECT, recordTypeId: '$objectInfo.data.defaultRecordTypeId' })
    loadPickListsCase({ error, data }){
        if(error){
            console.log(error);
        } else if(data){
            this.populatePicklists(data);
        }
    }

    connectedCallback(){
        this.getRecordTypeTicketlist();
        this.getProdutoOption();
        this.getOwnerOptions();
    }

    getUserOrGroupIds(){
        return new Promise((resolve, reject) => {
            getUserOrGroupIds()
            .then((data) => {
                resolve(data)
            })
            .catch((error) => {
                reject(error);
            })
        })
     
    }

    populatePicklists(data){
       
        let picklistValues = data.picklistFieldValues;
        let prioridades = picklistValues.Priority.values;
        let status = picklistValues.Status.values;
        this.prioridadeLista = prioridades;
        this.statusLista = status;
    }
 
    getRecordTypeTicketlist(){
        getRecordTypeTicketlist()
        .then(result => {
            let lista = new Array();
            for(let tipoRegistro of result){
                  lista.push({
                        label: tipoRegistro.Name,
                        value: tipoRegistro.Id,
                        id: tipoRegistro.Id,
                        filaId: tipoRegistro.Description
                  });
            }
            this.tiposRegistro = lista;
          
        })
        .catch(error => console.log(error));
    }

    getRecordTypeIdByGrupoName(){
        getRecordTypeIdByGrupoName({ nomeRecordType: this.selectedGrupoValue })
        .then(result => {
            this.recordTypeIdSelected = result;
        })
        .catch(error => console.log(error));
    }

    genericOnChange(event){
        this[event.target.name] = event.target.value;
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue}`)
    }

    procedenteChange(event){
        this.procedente = event.target.value;
        this.selectedProcedenteValue = this.procedente;
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue} .....Subtipo -${this.selectedSubtipoValue}
         .....Procedente -${this.selectedProcedenteValue}`)
    }

    exibirNotificacao(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    definirWhereouAndQuery(filtroQuery){
        return filtroQuery += filtroQuery == '' ? ' WHERE ' : ' AND ';
    }

    filtrarCasos(){
        //JSON.parse(JSON.stringify(this.tipoRegistro))
        let objFiltro = {
            status : this.status,
            motivo : this.selectedMotivoValue,
            prioridade : this.prioridade,
            tipo : this.selectedTipoValue,
            tipoRegistro : this.selectedGrupoValue,
            subtipo : this.selectedSubtipoValue,
            procedente : this.selectedProcedenteValue,
            proprietario : this.selectedOwnerValue, 
            createdDateInitial : this.selectedCreatedDateInitialValue,
            createdDateEnd : this.selectedCreatedDateEndValue
        }
        this.disparaEvent(objFiltro);  
        //console.log('OBVJFILTRO ==>', filtroQuery);
    }

    disparaEvent(objFiltro){
        console.log('dispararevent ==>'+ JSON.stringify(objFiltro));
        const selectedEvent = new CustomEvent("filtrarticket", {
            detail: objFiltro
        });
        this.dispatchEvent(selectedEvent);
    }

    limparFiltro(){
        this.limpar();
        const selectedEvent = new CustomEvent("limparfiltro", {
            detail: ''
        });
        this.dispatchEvent(selectedEvent);
    }

    changeRecordType(event){
        console.log('value ==>',  event.detail.value);
    }

    handleChange(event){
        this.value = event.detail.value;
    }

    limpar(){
        this.status = '--Nenhum--';
        this.selectedMotivoValue = '';
        this.selectedTipoValue = '';
        this.prioridade = '';
        this.selectedProdutoValue = '';
        this.selectedBandeiraValue = '';
        this.selectedGrupoValue = '';
        this.selectedSubtipoValue = '';
        this.selectedProcedenteValue = '';
        this.selectedOwnerValue = '';
        this.selectedCreatedDateInitialValue = '';
        this.selectedCreatedDateEndValue = '';
    }

    @wire (getObjectInfo, {objectApiName: CASE_OBJECT})
    objectInfo;

    getProdutoOption(){
        getProdutoOption({})
        .then(result => {
            let options = [];
            result.forEach(produtoName =>{
                options.push({label: produtoName, value: produtoName});
            }); 
            this.produtoOptions = options;
            this.getBandeiraOption();
        })
        .catch(error => console.log(error));
    }

    produtoHandleChange(event){
        this.produtoSelected = event.target.value;
        this.produtoNotSelected = false;
        this.getBandeiraOption();
    }

    getBandeiraOption(){
        getBandeiraOption({produtoToSearch: this.produtoSelected})
        .then(result => {
            let options = [];
            result.forEach(bandeiraName =>{
                options.push({label: bandeiraName, value: bandeiraName});
            }); 
            this.bandeiraOptions = options;
            this.getGroupOption();
        })
        .catch(error => console.log(error));
    }

    bandeiraHandleChange(event){
        this.bandeiraSelected = event.target.value;
        this.bandeiraNotSelected = false;
        this.getGroupOption();
    }

    getGroupOption(){
        getGroupOption({produtoToSearch: this.produtoSelected, bandeiraToSearch: this.bandeiraSelected})
        .then(result => {
            let options = [];
            result.forEach(groupName =>{
                options.push({label: groupName, value: groupName});
            }); 
            this.groupOptions = options;
            this.getMotivoOption();
        })
        .catch(error => console.log(error));
    }

    getOwnerOptions(){
        getOwnerOptions({})
        .then(result => {
            let options = [];
            console.log('result ==>', result);
             result.forEach(ownerName =>{
                options.push({label: ownerName, value: ownerName});
            });
            console.log('ownerOptions ==>', options);
            this.ownerOptions = options;
        })
        .catch(error => console.log(error));
    }

    getMotivoOption(){
        getMotivoOption({groupToSearch: this.selectedGrupoValue})
        .then(result => {
            let options = [];
            result.forEach(motivoName =>{
                options.push({label: motivoName, value: motivoName});
            }); 
            this.motivoOptions = options;
            this.getTipoOption();
        })
        .catch(error => console.log(error));
    }

    getTipoOption(){
        getTipoOption({groupToSearch: this.selectedGrupoValue, motivoToSearch: this.selectedMotivoValue})
        .then(result => {
            let options = [];
            result.forEach(tipoName =>{
                options.push({label: tipoName, value: tipoName});
            }); 
            this.tipoOptions = options;
            this.getSubtipoOption();
        })
        .catch(error => console.log(error));
    }

    getSubtipoOption(){
        getSubtipoOption({groupToSearch: this.selectedGrupoValue, motivoToSearch: this.selectedMotivoValue, tipoToSearch: this.selectedTipoValue})
        .then(result => {
            let options = [];
            result.forEach(tipoName =>{
                options.push({label: tipoName, value: tipoName});
            }); 
            this.subtipoOptions = options;
        })
        .catch(error => console.log(error));
    }

    motivoHandleChange(event){
        this.selectedMotivoValue = event.target.value;
        this.motivoNotSelected = false;
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue}`)
        this.getTipoOption();
    }

    tipoHandleChange(event){
        this.selectedTipoValue = event.target.value;
        this.tipoNotSelected = false;
        this.getSubtipoOption();
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue}`)
    }

    groupHandleChange(event){
        this.selectedGrupoValue = event.target.value;
        this.groupNotSelected = false;
        this.tipoRegistro = event.target.value;
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue}`)
        this.getRecordTypeIdByGrupoName();
        this.getMotivoOption();
    }

    subtipoHandleChange(event){
        this.selectedSubtipoValue = event.target.value;
        console.log(`Status - ${this.status} ..... Motivo - ${this.selectedMotivoValue} .....Prioridade - ${this.prioridade}
         .....Tipo - ${this.selectedTipoValue} .....RecordType - ${this.selectedGrupoValue}`)
    }

    ownerHandleChange(event){
        this.selectedOwnerValue = event.target.value;
        console.log(`owner - ${this.selectedOwnerValue}}`);
    }
    
    createDateInitialHandleChange(event){
        this.selectedCreatedDateInitialValue = event.target.value;
        console.log(`CreatedDateInitial - ${this.selectedCreatedDateInitialValue}}`);
    }

    createDateEndHandleChange(event){
        this.selectedCreatedDateEndValue = event.target.value;
        console.log(`CreatedDateEnd - ${this.selectedCreatedDateEndValue}}`);
    }

    handleStatusChange(event){
        let options = [];
        var statusConcat = ''; //      '\''+statusConcat+'\'' + ', ' + 
        event.detail.forEach((item) => (options.push(item.value)));
        /*event.detail.forEach((item) => (statusConcat += '\''+item.value+'\'' + ', '));

        this.valueStatusSelected = options;
        
        if(statusConcat != null){
            statusConcat = statusConcat.slice(0, -2);
        }

        statusConcat = '('+statusConcat+')';*/
        this.status = options;
        console.log('BBB12 this.status: '+this.status);
    }
}