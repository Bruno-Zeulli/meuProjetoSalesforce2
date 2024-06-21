import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateOwnerCaseFromPlacement from '@salesforce/apex/PlacementController.updateOwnerCaseFromPlacement';
import Case from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import USER_ID from '@salesforce/user/Id';

export default class PaginationDatatable extends NavigationMixin(LightningElement) {

    @api isPending;
    @api isQuotes;
    @api isAllQuotes = false;
    @api receivedData;
    @api columns;
    @api headers;
    @api usersQueue;
    @track isModalOpen = false;
    @track isAssignModalOpen = false;
    @track startDate;
    @track endDate;
    @track range;
    valueAssignName = USER_ID;
    optionsAssignName = [];
    textAreaObservation;
    accountName;
    oppTotal;
    product;
    caseId;
    ownerName;
    loaded = false;
    loadedAssign = false;
    ownerNames = [];
    today = new Date();
    activeSections = ['Status'];
    recordTypeIdFilter;
    @track statusFields = [];
    @track checkboxValue = [];
    checkboxOwnerValue = [];
    statusValueLocalStorage = [];

    isFilter = false;
    isModalFilter = false;
    isLast;
    receivedDataFilter;
    receivedDataFilterModal;
    displayData = [];
    rowsPerPage = 10;
    currentPage = 1;
    lastPage;

    @wire(getObjectInfo, { objectApiName: Case })
    getObjectdata({ error, data }) {
        if (data) {
            for (let key in data.recordTypeInfos) {
                if (data.recordTypeInfos[key].name === 'Corporate - Célula Técnica') {
                    this.recordTypeIdFilter = data.recordTypeInfos[key].recordTypeId;
                    break;
                }
            }   
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeIdFilter',
        fieldApiName: STATUS_FIELD
    })
    getStatusPicklistValues({ error, data }) {
        if (data) {
            if (this.isFinished) {
                const filteredValues = data.values.filter(value => value.label === 'Apólice registrada' || value.label === 'Processo anulado');
                this.statusFields = filteredValues.map(value => ({ label: value.label, value: value.label, checked: false }));
            } else {
                this.statusFields = data.values.map(value => ({ label: value.label, value: value.label, checked: false }));
            }
            this.loaded = true;
            localStorage.setItem('filterData', '');
        } else if (error) {
            console.error(error)
        }
    }


    connectedCallback() {
        this.handlePageChange();
        this.endDate = (this.endDate) ? this.endDate : this.today.toJSON().slice(0, 10);
        this.range = this.diff(this.startDate, this.endDate);
        
        
    }

    get pageCount() {
        return this.receivedData.length / this.rowsPerPage;
    }
    get isFirst() {
        return this.currentPage === 1;
    }

    pageCountFilter() {
        return this.isModalFilter ? this.receivedDataFilterModal.length / this.rowsPerPage : this.receivedDataFilter.length / this.rowsPerPage;
    }


    handlePageChange() {
        let count = this.receivedData;
        this.oppTotal = count.length;
        this.ownerNames = this.getUniqueOwnerNames();
        let startIndex = (this.currentPage - 1) * this.rowsPerPage;
        let endIndex = startIndex + this.rowsPerPage;
        this.displayData = this.receivedData.slice(startIndex, endIndex);
        this.lastPage = Math.ceil(this.receivedData.length / this.rowsPerPage);
        this.currentPage >= this.pageCount ? this.isLast = true : this.isLast = false;
    }

    handlePageChangeFilter() {
        
        let startIndex = (this.currentPage - 1) * this.rowsPerPage;
        let endIndex = startIndex + this.rowsPerPage;
        if (this.isModalFilter) {
            let count = this.receivedDataFilterModal;
            this.oppTotal = count.length;
            this.displayData = this.receivedDataFilterModal.slice(startIndex, endIndex);
            this.lastPage = Math.ceil(this.receivedDataFilterModal.length / this.rowsPerPage);
        } else {
            let count = this.receivedDataFilter;
            this.oppTotal = count.length;
            this.displayData = this.receivedDataFilter.slice(startIndex, endIndex);
            this.lastPage = Math.ceil(this.receivedDataFilter.length / this.rowsPerPage);
        }

        this.currentPage >= this.pageCountFilter() ? this.isLast = true : this.isLast = false;
    }

    handlePrevPage() {
        this.currentPage--;
        this.isFilter == true ? this.handlePageChangeFilter() : this.handlePageChange();
    }
    handleNextPage() {
        this.currentPage++;
        this.isFilter == true ? this.handlePageChangeFilter() : this.handlePageChange();
    }

    handleFirstPage() {
        this.currentPage = 1;
        this.isFilter == true ? this.handlePageChangeFilter() : this.handlePageChange();
    }

    handleLastPage() {
        this.currentPage = this.lastPage;
        this.isFilter == true ? this.handlePageChangeFilter() : this.handlePageChange();
    }

    handleOnChange(event) {
        this.isFilter = true;
        const searchTerms = event.target.value.toLowerCase().split(';');

        if (this.isModalFilter) {
            this.receivedDataFilter = this.receivedDataFilterModal.filter(item => {
                return searchTerms.every(term => {
                    return Object.values(item).some(val => String(val).toLowerCase().includes(term.trim()));
                });
            });
        } else {
            this.receivedDataFilter = this.receivedData.filter(item => {
                return searchTerms.every(term => {
                    return Object.values(item).some(val => String(val).toLowerCase().includes(term.trim()));
                });
            });
        }

        this.displayData = this.receivedDataFilter;
        this.isModalFilter = false;
        this.handlePageChangeFilter();
    }

    handleRefresh() {
        this.dispatchEvent(new CustomEvent('refresh'));
    }

    exportCsv() {
        try {

            // Converte o objeto this.headers em um array de objetos com chave e valor
            const headersArray = Object.keys(this.headers).map(key => {
                return { key: key, value: this.headers[key] };
            });

            // Mapeia os dados recebidos para um novo array com apenas as chaves especificadas nos cabeçalhos
            const mappedData = JSON.parse(JSON.stringify(this.receivedData.map(item => {
                let newItem = {};
                headersArray.forEach(headerObj => {
                    newItem[headerObj.key] = item[headerObj.key];
                });
                return newItem;
            })));
            const csvDoc = this.convertToCSV(mappedData, headersArray);
            const BOM = '\uFEFF';
            const element = 'data:text/csv;charset=utf-8,' + BOM + csvDoc;
            let downloadElement = document.createElement('a');
            downloadElement.href = element;
            downloadElement.target = '_self';
            downloadElement.download = 'Lista-de-cotacoes.csv'; // Nome do arquivo CSV
            document.body.appendChild(downloadElement);
            downloadElement.click();
            document.body.removeChild(downloadElement); // Remova o elemento após o download
        } catch (error) {
            console.error('Error exporting CSV:', error);
        }
    }

    convertToCSV(tableData, headers) {
        const columnDelimiter = ';';
        const lineDelimiter = '\r\n';
        const actualHeaderKey = headers.map(headerObj => headerObj.key);
        const headerToShow = headers.map(headerObj => headerObj.value);

        let csvContent = headerToShow.join(columnDelimiter) + lineDelimiter;

        tableData.forEach(obj => {
            let line = '';
            actualHeaderKey.forEach(key => {
                if (line !== '') {
                    line += columnDelimiter;
                }
                let value = obj[key] + '';
                // Verifica se a chave é 'quotes' e, em caso afirmativo, itera sobre a lista e cria uma representação de string
                if (key === 'quotes') {
                    // Verifica se 'quotes' não é null antes de tentar mapeá-lo
                    if (obj[key]) {
                        value = obj[key].map(quote => `{Seguradora: ${quote.insuranceCompany}, Data recebida: ${quote.quoteReceiptDate || 'N/A'}, Data enviada: ${quote.quoteRequestDate || 'N/A'}}`).join(', ');
                    } else {
                        value = '';
                    }
                }
                line += value ? value.replace(/,/g, '') : value;
            });
            csvContent += line + lineDelimiter;
        });

        return csvContent;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        
        if (actionName === 'atribuir') {
            this.accountName = row.accountName;
            this.product = row.productComboName;
            this.caseId = row.caseId;
            this.ownerName = row.ownerName;
            this.openAssignModal();
        }

        if (actionName === 'urlredirect') {
            this.showRowDetails(row);
        }

        //EDIT AND DELETE QUOTE BUTTON FROM FOLLOW UP PAGE
        if(actionName === 'editQuote') {
            const editEvent = new CustomEvent('editmodal', {
                detail: {recordId: row.Id}
            });

            this.dispatchEvent(editEvent);
        }

        if(actionName === 'deleteQuote') {
            const deleteEvent = new CustomEvent('deletemodal', {
                detail: {recordId: row.Id}
            });

            this.dispatchEvent(deleteEvent);
        }
    }

    handleButtonClick(event) {
        const recordId = event.detail.recordId;
        const opportunityId = event.detail.opportunityId;
      
        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'followUp__c'
            },
            state: {
                caseId: recordId,
                opportunityId: opportunityId
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    /* métodos do modal FILTROS*/

    openModal() {
        this.isModalOpen = true;
        const storageFilter = JSON.parse(localStorage.getItem('filterData'));

        if(!storageFilter?.length)
        return

        this.statusFields = this.statusFields.map(field => storageFilter.includes(field.value) ? { ...field, checked: true } : { ...field, checked: false });
        this.ownerNames = this.ownerNames.map(field => storageFilter.includes(field.value) ? { ...field, checked: true } : { ...field, checked: false });
    }

    closeModal() {
        this.isModalOpen = false;
    }

    clearData() {
        localStorage.setItem('filterData', '');
        this.statusFields = this.statusFields.map(field => ({...field, checked: false}));
        this.ownerNames = this.ownerNames.map(field => ({ ...field, checked: false }));
        this.checkboxValue = [];
        this.checkboxOwnerValue = [];
        this.isModalFilter = false;
        this.isFilter = false;
        this.closeModal();
        this.handlePageChange();
    }
    submitDetails() {
        const selectedStatus = Object.values(this.checkboxValue);
        const selectedOwners = Object.values(this.checkboxOwnerValue);
        const endDate = new Date(this.endDate);
        const startDate = this.startDate ? new Date(this.startDate) : null;

        // Filtra os dados com base nos status selecionados e no intervalo de datas
        this.receivedDataFilterModal = this.receivedData.filter(item => {
            const isMatchStatus = !selectedStatus.length || (item.statusCase && selectedStatus.includes(item.statusCase));
            const isMatchOwner = !selectedOwners.length || (item.ownerName && selectedOwners.includes(item.ownerName));
            const createDateItem = new Date(item.createDate);
            const isWithinDateRange = (!startDate || createDateItem >= startDate) && createDateItem <= endDate;

            return isMatchStatus && isWithinDateRange && isMatchOwner;
        });

        this.isModalFilter = true;
        this.isFilter = true;
        this.handlePageChangeFilter();
        this.isModalOpen = false;
    }

    addDays = (sd, days) => {
        const d = new Date(Number(sd));
        d.setDate(sd.getDate() + days);
        return d;
    }

    diff = (sdate, edate) => {
        let diffTime = Math.abs(new Date(edate).getTime() - new Date(sdate).getTime());
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }

    valid_date = (sdate, edate) => {
        return new Date(edate) >= new Date(sdate);
    }

    handleDateChange = (evt) => {
        let field_name = evt.target.name;

        if (field_name === 'startdate')
            this.startDate = evt.target.value;
        if (field_name === 'enddate')
            this.endDate = evt.target.value;

        if (this.valid_date(this.startDate, this.endDate) === true) {
            this.range = this.diff(this.startDate, this.endDate);
        } else {
            let inputfield = this.template.querySelector("." + field_name);
            inputfield.setCustomValidity('Data final deve ser maior que a data inicial');
            inputfield.reportValidity();
        }
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
    }

    handleCheckboxChange(e){
        
        e.detail.selected.forEach(value => {
            if (!this.statusValueLocalStorage.includes(value)) {
                this.statusValueLocalStorage.push(value);
            }
        });

        // Removendo valores deselecionados
        e.detail.deselected.forEach(value => {
            const index = this.statusValueLocalStorage.indexOf(value);
            if (index !== -1) {
                this.statusValueLocalStorage.splice(index, 1);
            }
        });

        this.checkboxValue = this.statusValueLocalStorage;

        localStorage.setItem('filterData', JSON.stringify(this.statusValueLocalStorage));
    }

    handleCheckboxOwnerChange(e) {

        e.detail.selected.forEach(value => {
            if (!this.statusValueLocalStorage.includes(value)) {
                this.statusValueLocalStorage.push(value);
            }
        });

        // Removendo valores deselecionados
        e.detail.deselected.forEach(value => {
            const index = this.statusValueLocalStorage.indexOf(value);
            if (index !== -1) {
                this.statusValueLocalStorage.splice(index, 1);
            }
        });

        this.checkboxOwnerValue = this.statusValueLocalStorage;

        localStorage.setItem('filterData', JSON.stringify(this.statusValueLocalStorage));
    }

    getUniqueOwnerNames() {
        const uniqueOwnerNames = [...new Set(this.receivedData.map(item => item.ownerName))];
        const owners = [];
        owners.push(...uniqueOwnerNames.map(item => ({ label: item, value: item, checked: false })));
        return owners; 
    }

    /* métodos do modal ATRIBUIR*/

    openAssignModal() {
        this.optionsAssignName = [];
        let sortedOptions = [];
        for (let key in this.usersQueue) {
            if (key == this.ownerName) {
                const users = this.usersQueue[key];
                users.forEach(user => {
                    sortedOptions.push({ label: user.userName, value: user.userId });
                });
            }
        }

        // Ordena o array sortedOptions com base no label
        sortedOptions.sort((a, b) => a.label.localeCompare(b.label));

        // Agora, sortedOptions contém os itens ordenados por label
        this.optionsAssignName = sortedOptions;
        this.isAssignModalOpen = true;
        this.loadedAssign = true;
    }

    closeAssignModal() {
        this.isAssignModalOpen = false;
    }

    handleChangeAssignName(event){
        this.valueAssignName = event.detail.value;
    }

    handleObservation(event){
        this.textAreaObservation = event.detail.value;
    }

    updateOwnerCaseFromPlacement() {
        this.loadedAssign = false;
        updateOwnerCaseFromPlacement({
            caseId: this.caseId,
            userId: this.valueAssignName,
            status: 'Análise de dados da oportunidade'
        }).then(result => {
            if (result) {
                this.closeAssignModal();
                this.showToast('Sucesso!', 'Atribuição feita', 'success')
                this.handleRefresh();

            } else {
                console.log(`UPD Owner fail`);
            }
        }).catch((error) => {
            console.log(`ERROR: ==> ${error}`);
            this.loadedAssign = true;
            throw new Error(error);
        });
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    handleSave(event){
        
        let draftValues = event.detail.draftValues;
        const saveEvent = new CustomEvent('savedraftvalues', {
            detail: {draftValues: draftValues}
        });
        this.dispatchEvent(saveEvent);
    }

}