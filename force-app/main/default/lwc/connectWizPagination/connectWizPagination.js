import { LightningElement, api } from 'lwc';

export default class ConnectWizPagination extends LightningElement {
    currentPage = 1
    totalRecords
    totalPage = 0
    @api recordSize = 25

    get records() {
        return this.visibleRecords
    }

    @api
    set records(data) {
        if (data) {
            // console.log('Data in Pagination ==> ', JSON.stringify(data));
            if (data.length < 1) {
                this.currentPage = 0;
                this.totalPage = 0;
            } else {
                this.currentPage = 1
            }
            this.totalRecords = data
            this.recordSize = Number(this.recordSize)
            this.totalPage = Math.ceil(data.length / this.recordSize)
            this.updateRecords()
        }
    }

    get disablePrevious() {
        return this.currentPage <= 1
    }
    get disableNext() {
        return this.currentPage >= this.totalPage
    }
    previousHandler() {
        if (this.currentPage > 1) {
            this.currentPage = this.currentPage - 1
            this.updateRecords()
        }
    }
    nextHandler() {
        if (this.currentPage < this.totalPage) {
            this.currentPage = this.currentPage + 1
            this.updateRecords()
        }
    }

    handleToFirstPage() {
        this.currentPage = 1;
        this.updateRecords();
    }

    handleToLastPage() {
        this.currentPage = this.totalPage;
        this.updateRecords();
    }


    updateRecords() {
        const start = (this.currentPage - 1) * this.recordSize
        const end = this.recordSize * this.currentPage
        this.visibleRecords = this.totalRecords.slice(start, end)
        this.dispatchEvent(new CustomEvent('update', {
            detail: {
                records: this.visibleRecords
            }
        }))
    }
}