import { LightningElement, wire, track } from 'lwc';
import databaseList from '@salesforce/apex/B2U_AgendaMaisController.getDatabaseList'
import cityList from '@salesforce/apex/B2U_AgendaMaisController.getCityList'
import recordsCount from '@salesforce/apex/B2U_AgendaMaisController.getRecordsCount'
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';

export default class AgendaMais extends LightningElement {

    @track databaseOpt = [];
    @track cityOpt = [];
    @track stageOpt = [];
    @track databaseValue = null;
    @track cityValue = null;
    @track stageValue = null;
    @track descriptionValue = null;
    @track offset = 0;
    @track currentPage = 1;
    OFFSET_STEP = 50;

    get recordInnerLimit(){
        return (this.currentPage - 1) * this.OFFSET_STEP + 1;
    }
    
    get recordOutterLimit(){
        if(this.offset + this.OFFSET_STEP < this.totalRecords.data)
            return this.offset + this.OFFSET_STEP;
        return this.totalRecords.data;
    }

    @wire(recordsCount, { db: '$databaseValue', city: '$cityValue', stageName: '$stageValue' } )
    totalRecords;

    get hasRecordsToShow(){
        return this.totalRecords.data !== 0;
    }

    @wire(databaseList)
    loadDatabases({ error, data }){
        if(error){
            console.log(error);
        } else if(data){
            this.databaseOpt = [...this.databaseOpt, { value: null , label: '-- Selecione --' } ];
            for(let i = 0; i < data.length; i++){
                this.databaseOpt = [...this.databaseOpt, { value: data[i].DerivedFrom__c , label: data[i].Name } ];
            }
        }
    }

    get databaseOptions(){
        return this.databaseOpt;
    }

    handleDatabaseChange(event){
        this.databaseValue = event.detail.value;
        this.template.querySelector("c-agenda-mais-list").db = this.databaseValue;
        this.template.querySelector("c-agenda-mais-map").db = this.databaseValue;
        this.restartPagination();
    }
    
    @wire(cityList, { db: '$databaseValue', stageName: '$stageValue'})
    loadCities({ error, data }){
        if(error){
            console.log(error);
        } else if(data){
            this.cityOpt = [];
            this.cityOpt = [...this.cityOpt, {value: null , label: '-- Selecione --'} ];
            for(let i = 0; i < data.length; i++){
                this.cityOpt = [...this.cityOpt ,{value: data[i].BillingCity , label: data[i].BillingCity} ];
            }
        }
    }
    
    get cityOptions(){
        return this.cityOpt;
    }
    
    handleCityChange(event){
        this.cityValue = event.detail.value;
        this.template.querySelector("c-agenda-mais-list").city = this.cityValue;
        this.template.querySelector("c-agenda-mais-map").city = this.cityValue;
        this.restartPagination();
    }

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '0121U000000jXjdQAE', fieldApiName: STAGE_FIELD })
    loadStages( { error, data } ){
        if(error){
            console.log(error)
        } else if(data){
            this.stageOpt = [...this.stageOpt, { value: null , label: '-- Selecione --' } ];
            for(let i = 0; i < data.values.length; i++){
                this.stageOpt = [...this.stageOpt ,{ value: data.values[i].value , label: data.values[i].label } ];
            }
        }
    }

    get stageOptions(){
        return this.stageOpt;
    }

    handleStageChange(event){
        this.stageValue = event.detail.value;
        this.template.querySelector("c-agenda-mais-list").stage = this.stageValue;
        this.template.querySelector("c-agenda-mais-map").stage = this.stageValue;
        this.restartPagination();
    }

    get showPreviousButton(){  
        if(this.currentPage === 1){  
            return true;  
        }  
        return false;  
      }  
    
    get showNextButton(){ 
        if(this.totalRecords.data === 0 || Math.ceil(this.totalRecords.data / this.OFFSET_STEP) === this.currentPage){  
            return true;  
        }  
        return false;  
    }  

    handlePrevious(event){
        this.offset -= this.OFFSET_STEP;
        this.currentPage--;
        this.handlePageChange();
    }

    handleNext(event){
        this.offset += this.OFFSET_STEP;
        this.currentPage++;
        this.handlePageChange();
    }
    
    handlePageChange(){
        this.template.querySelector("c-agenda-mais-list").offset = this.offset;
        this.template.querySelector("c-agenda-mais-map").offset = this.offset;
    }

    restartPagination(){
        this.currentPage = 1;
        this.offset = 0;
        this.handlePageChange();
    }

    handleDescriptionChange(event){
        this.descriptionValue = event.target.value;
    }

    handleSearch(event){
        this.template.querySelector("c-agenda-mais-list").descriptionFilter = this.descriptionValue;        
        this.template.querySelector("c-agenda-mais-map").descriptionFilter = this.descriptionValue;        
        this.restartPagination();
    }
}