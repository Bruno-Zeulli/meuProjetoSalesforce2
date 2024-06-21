import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordTypeIdByGrupoName from '@salesforce/apex/TicketsController.getRecordTypeIdByGrupoName';
import changeRecordType from '@salesforce/apex/TicketsController.updateRecordType';
import getRecordType from '@salesforce/apex/TicketsController.getRecordTypeName';

import getProdutoOption from '@salesforce/apex/TicketsController.getProdutoOptions';
import getBandeiraOption from '@salesforce/apex/TicketsController.getBandeiraOptions';
import getGroupOption from '@salesforce/apex/TicketsController.getGroupOptions';
import getMotivoOption from '@salesforce/apex/TicketsController.getMotivoOptions';
import getTipoOption from '@salesforce/apex/TicketsController.getTipoOptions';
import getSubtipoOption from '@salesforce/apex/TicketsController.getSubtipoOptions';
import createTask from '@salesforce/apex/TicketsController.createTask';
import verifyTasks from '@salesforce/apex/TicketsController.verifyTasks';
import { updateRecord } from 'lightning/uiRecordApi';

export default class TicketsInfo extends NavigationMixin(LightningElement){

    @api recordId;

    @track spinner = false;
    @track selectedGrupoValue = '';
    @track tipoRegistro = '';
    @track recordTypeIdSelected = '';

    @track produtoOptions = [];
    @track produtoSelected;
    @track bandeiraOptions = [];
    @track bandeiraSelected;
    @track groupOptions = [];
    @track groupSelected;
    @track motivoOptions = [];
    @track motivoSelected;
    @track tipoOptions = [];
    @track tipoSelected;
    @track subtipoOptions = [];
    @track subtipoSelected;
    @track descriptionSelected;
    @track contactSelected;
    @track dispositionPathId;

    @track produtoNotSelected = true;
    @track bandeiraNotSelected = true;
    @track groupNotSelected = true;
    @track motivoNotSelected = true;
    @track tipoNotSelected = true;

    connectedCallback(){
        //this.getRecordType();
        this.verifyTasks();
    }

    handleSubmit(){
        this.spinner = true;
        this.createTask();
    }

    getRecordTypeIdByGrupoName(){
        getRecordTypeIdByGrupoName({ nomeRecordType: this.groupSelected })
        .then(result => {
            this.recordTypeIdSelected = result;
            this.changeRecordType();
        })
        .catch(error => console.log(error));
    }

    changeRecordType(){
        changeRecordType({ recordTypeSelected: this.recordTypeIdSelected, caseRecordId: this.recordId })
        .then(result => {
            this.updateTicketsOnScreen();
        })
        .catch(error => {
            this.showToast('', 'Erro ao alterar o grupo!', 'error');
            console.log(error);
            this.spinner = false;
        });
    }

    updateTicketsOnScreen(){
        updateRecord({fields: {Id: this.recordId }}).then(result=>{
            this.showToast('', 'As informações foram salvas com sucesso!', 'success');
            this.spinner = false;
        }).catch(error=>{
            this.showToast('', 'Erro ao salvar as informações!', 'error');
            this.spinner = false;
        });


    }

    createTask(){
        createTask({ contactId: this.contactSelected, caseId: this.recordId, caseDescription: this.descriptionSelected, tipoValue: this.tipoSelected, groupValue: this.groupSelected, motivoValue: this.motivoSelected, subtipoValue: this.subtipoSelected, produtoValue: this.produtoSelected, bandeiraValue: this.bandeiraSelected})
        .then(result => {
            //this.changeRecordType();
            this.getRecordTypeIdByGrupoName();
        })
        .catch(error => console.log(error));
    }

    getRecordType(){
        getRecordType({ caseRecordId: this.recordId })
        .then(result => {
            this.selectedGrupoValue = result;
        })
        .catch(error => console.log(error));
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

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

    groupHandleChange(event){
        this.groupSelected = event.target.value;
        this.groupNotSelected = false;
        this.getMotivoOption();
    }

    getMotivoOption(){
        getMotivoOption({groupToSearch: this.groupSelected})
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

    motivoHandleChange(event){
        this.motivoSelected = event.target.value;
        this.motivoNotSelected = false;
        this.getTipoOption();
    }

    getTipoOption(){
        getTipoOption({groupToSearch: this.groupSelected, motivoToSearch: this.motivoSelected})
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

    tipoHandleChange(event){
        this.tipoSelected = event.target.value;
        this.tipoNotSelected = false;
        this.getSubtipoOption();
    }

    getSubtipoOption(){
        getSubtipoOption({groupToSearch: this.groupSelected, motivoToSearch: this.motivoSelected, tipoToSearch: this.tipoSelected})
        .then(result => {
            let options = [];
            console.log('BBB subtipoOptions: '+options);
            result.forEach(subtipoName =>{
                options.push({label: subtipoName, value: subtipoName});
            });
            this.subtipoOptions = options;
            if(options == ''){
                this.subtipoSelected = '';
                this.tipoNotSelected = true;
            }else{
                this.tipoNotSelected = false;
            }
        })
        .catch(error => console.log(error));
    }

    subtipoHandleChange(event){
        this.subtipoSelected = event.target.value;
    }

    verifyTasks(){
        verifyTasks({caseRecordId: this.recordId})
        .then(result => {
            this.getProdutoOption();
            if(result != null){
                result.forEach(tasksValues =>{
                    this.produtoSelected = tasksValues.Disposition__r.Product__c;
                    this.bandeiraSelected = tasksValues.Disposition__r.UNProduct__c;
                    this.groupSelected = tasksValues.Disposition__r.Group__c;
                    this.motivoSelected = tasksValues.Disposition__r.Category__c;
                    this.tipoSelected = tasksValues.Disposition__r.Reason__c;
                    this.subtipoSelected = tasksValues.Disposition__r.SpecificReason__c;
                });
                if(this.produtoSelected == null){
                    this.produtoNotSelected = true;
                }else{
                    this.produtoNotSelected = false;
                }
                if(this.bandeiraSelected == null){
                    this.bandeiraNotSelected = true;
                }else{
                    this.bandeiraNotSelected = false;
                }
                if(this.groupSelected == null){
                    this.groupNotSelected = true;
                }else{
                    this.groupNotSelected = false;
                }
                if(this.motivoSelected == null){
                    this.motivoNotSelected = true;
                }else{
                    this.motivoNotSelected = false;
                }
                if(this.tipoSelected == null){
                    this.tipoNotSelected = true;
                }else{
                    this.tipoNotSelected = false;
                }
            }
        })
        .catch(error => console.log(error));
    }

}