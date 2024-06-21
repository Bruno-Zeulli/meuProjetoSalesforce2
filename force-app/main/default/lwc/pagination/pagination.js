import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage = 1
    totalRecords
    totalPage = 0
    @api recordSize;
    
    get records(){
        return this.visibleRecords
    }

    @api 
    set records(data){
        if(data){ 
            this.totalRecords = data
            this.forceSync();
        }
    }

    get disablePrevious(){ 
        return this.currentPage <= 1
    }
    get disableNext(){ 
        return this.currentPage>=this.totalPage
    }

    connectedCallback(){
        this.forceSync();
    }

    forceSync(){
        this.recordSize = Number(this.recordSize);
        if(this.totalRecords != null){
            this.totalPage = Math.ceil(this.totalRecords.length / this.recordSize);
            this.updateRecords();
        }
    }

    previousHandler(){ 
        if(this.currentPage>1){
            this.currentPage = this.currentPage - 1
            this.updateRecords()
        }
    }
    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage + 1
            this.updateRecords()
        }
    }
    updateRecords(){ 
        const start = (this.currentPage-1) * this.recordSize
        const end = this.recordSize * this.currentPage
        this.visibleRecords = this.totalRecords.slice(start, end)
        this.dispatchEvent(new CustomEvent('update',{ 
            detail:{ 
                records:this.visibleRecords
            }
        }))
    }
}