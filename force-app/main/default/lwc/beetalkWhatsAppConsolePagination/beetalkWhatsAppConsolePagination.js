import { LightningElement, api} from 'lwc';

export default class BeetalkWhatsAppConsolePagination extends LightningElement {
    @api testemy;
    recordsize;
    currentPage = 1;
    totalRecords;
    totalPage = 0;


    get records(){
       return this.visibleRecords;
    }
    
    @api
    set records(data){
        console.log('recordSize1--->', this.recordsize);
        this.recordsize = this.testemy;
        console.log('recordSize2--->', this.recordsize);
        

        if(data && this.recordsize != undefined){
            if(data.length < 1){
                this.currentPage = 0;
                this.totalPage = 0;
                this.totalRecords = [];
            } else{
                this.currentPage = 1;
                this.totalRecords = data;
                this.totalPage = Math.ceil(data.length / this.recordsize);
                this.updateRecords();
            }
        }
    }

    get disablePrevious(){
        return this.currentPage <= 1;
    }

    get disableNext(){
        return this.currentPage >= this.totalPage || this.totalPage === 0;
    }

    previousHandler(){
        if(this.currentPage > 1){
            this.currentPage = this.currentPage - 1;
            this.updateRecords();
        }
    }

    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage + 1;
            this.updateRecords();
        }
    }

    handleToFirstPage(){
        this.currentPage = 1;
        this.updateRecords();
    }

    handleToLastPage(){
        this.currentPage = this.totalPage;
        this.updateRecords();
    }

    updateRecords(){
        if(!this.totalRecords || this.totalRecords.length === 0){
            this.visibleRecords = [];
        } else{
            const start = (this.currentPage - 1) * this.recordsize;
            const end = this.recordsize * this.currentPage;
            this.visibleRecords = this.totalRecords.slice(start, end);
        }
        this.dispatchEvent(
            new CustomEvent('update', {
                detail: {
                    records: this.visibleRecords
                }
            })
        );
    }
}