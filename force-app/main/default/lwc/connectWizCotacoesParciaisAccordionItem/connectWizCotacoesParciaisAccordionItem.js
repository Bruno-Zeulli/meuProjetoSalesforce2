import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import QUOTE_OBJECT from '@salesforce/schema/Quote';
import getPartialQuotes from '@salesforce/apex/ConnectWizController.getPartialQuotes';
import insertQuote from '@salesforce/apex/ConnectWizController.insertPartialQuote';
import updateQuote from '@salesforce/apex/ConnectWizController.updatePartialQuote';
import deleteQuote from '@salesforce/apex/ConnectWizController.deletePartialQuote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const CORPORATE_PARCIAL_RT = 'Corporate';

const TOAST_SUCCESS_INSERT_TITLE = 'Sucesso ao inserir a cotação parcial';
const TOAST_SUCCESS_INSERT_MESSAGE = 'A cotação parcial foi inserida com sucesso';
const TOAST_SUCCESS_UPDATE_TITLE = 'Sucesso ao atualizar a cotação parcial';
const TOAST_SUCCESS_UPDATE_MESSAGE = 'A cotação parcial foi atualizada com sucesso';
const TOAST_SUCCESS_DELETE_TITLE = 'Sucesso ao excluir a cotação parcial';
const TOAST_SUCCESS_DELETE_MESSAGE = 'A cotação parcial foi excluída com sucesso';
const TOAST_ERROR_INSERT_TITLE = 'Falha ao inserir a cotação parcial';
const TOAST_ERROR_INSERT_MESSAGE = 'Ocorreu um erro ao inserir a cotação parcial';
const TOAST_ERROR_UPDATE_TITLE = 'Falha ao atualizar a cotação parcial';
const TOAST_ERROR_UPDATE_MESSAGE = 'Ocorreu um erro ao atualizar a cotação parcial';
const TOAST_ERROR_DELETE_TITLE = 'Falha ao excluir a cotação parcial';
const TOAST_ERROR_DELETE_MESSAGE = 'Ocorreu um erro ao excluir a cotação parcial';

const Operations = {
    Insert: 'insert',
    Update: 'update'
}

const LOCALE_OPTIONS = {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
}

export default class ConnectWizCotacoesParciaisAccordionItem extends LightningElement {
    @api opportunityId;
    @api insuredAmount;
    isOpen = false;
    isLoading = true;
    showComp = false;
    wiredData;
    @track partialQuotes = [];
    openQuotes = [];
    recordTypeId;
    insuranceCompanyOptions = [];
    draftCounter = 0;
    currentQuoteId;
    deleteModal = false;

    // Files properties
    showButtonViewFile = true;
    showButtonDeleteFile = true;
    showSimpleView = true;
    viewFileLoading = true;
    documentTypeName = 'Proposta de Seguro';

    @wire(getPartialQuotes, { recordId: "$opportunityId", openQuotes: "$openQuotes" })
    wiredPartialQuotes(value) {
        this.wiredData = value;
        const { data, error } = value;
        if (data) {
            this.partialQuotes = JSON.parse(JSON.stringify(data));
            this.partialQuotes.forEach(e => {
                e.insuredPercentage = this.insuredAmount && e.amountInsurance ? (e.amountInsurance / this.insuredAmount * 100).toLocaleString(undefined, LOCALE_OPTIONS) + '%' : null;
                e.fileLoaded = false;
                e.showViewFile = true;
                e.showUploadFile = true;
                e.filesAvailable = true;
            });
            this.isLoading = false;
            this.dispatchEvent(new CustomEvent('partialquoteupdated', { detail: { quotes: this.wiredData.data } }));
        } else if (error) {
            console.error('error on getPartialQuotes' + JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading data',
                    message: error.body.message,
                    variant: 'error',
                })
            );
            this.isLoading = false;
        }
    }

    @wire(getObjectInfo, { objectApiName: QUOTE_OBJECT })
    objectInfo({ error, data }) {
        if (data) {
            let listRT = data.recordTypeInfos;
            this.recordTypeId = Object.keys(listRT).find(rt => listRT[rt].name === CORPORATE_PARCIAL_RT);
        }
        else if (error) {
            console.error('error on getObjectInfo', JSON.stringify(error));
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: QUOTE_OBJECT, recordTypeId: "$recordTypeId" })
    companyPicklistValues({ error, data }) {
        if (data) {
            this.insuranceCompanyOptions = [...data.picklistFieldValues.Company__c.values];
            this.insuranceCompanyOptions.unshift({ label: 'Selecione...', value: '' });
        }
        else if (error) {
            console.error('error on getPicklistValuesByRecordType', JSON.stringify(error));
        }
    }

    handleAccordionClick(event) {
        this.isOpen = !this.isOpen;
    }

    handleOpenCloseQuote(event) {
        const currentQuote = this.partialQuotes.find(e => e.id === event.currentTarget.dataset.id);
        currentQuote.showDetails = !currentQuote.showDetails;
    }

    handleFieldChangeValue(event) {
        const fieldName = event.currentTarget.name;
        const quoteId = event.currentTarget.parentElement.parentElement.dataset.id;
        const change = event.detail;

        const currentQuote = this.partialQuotes.find(e => e.id === quoteId);
        switch (fieldName) {
            case 'detailView':
                currentQuote.detailView = change.checked;
                break;
            case 'integralization':
                currentQuote.integralization = change.checked;
                break;
            case 'amountInsurance':
                currentQuote.amountInsurance = change.value;
                currentQuote.insuredPercentage = this.insuredAmount && currentQuote.amountInsurance ? (currentQuote.amountInsurance / this.insuredAmount * 100).toLocaleString(undefined, LOCALE_OPTIONS) + '%' : null
            default:
                currentQuote[fieldName] = change.value;
                break;
        }
    }

    addNewQuote() {
        this.partialQuotes.push({
            id: 'draft' + this.draftCounter++,
            requestDate: new Date(),
            showDetails: true,
            filesAvailable: false,
            integralization: false
        });
    }

    openDeleteModal(event) {
        this.currentQuoteId = event.currentTarget.dataset.id;
        this.deleteModal = true;
    }

    closeDeleteModal() {
        this.deleteModal = false;
    }

    async handleDelete() {
        const quoteId = this.currentQuoteId;
        this.closeDeleteModal();
        if (quoteId.startsWith('draft')) {
            this.partialQuotes.filter((item, index, arr) => {
                if (item.id === quoteId) {
                    arr.splice(index, 1);
                    return true;
                }
                return false;
            });
        } else {
            this.isLoading = true;
            try {
                await deleteQuote({ quoteId: quoteId });
                await refreshApex(this.wiredData);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: TOAST_SUCCESS_DELETE_TITLE,
                        message: TOAST_SUCCESS_DELETE_MESSAGE,
                        variant: 'success',
                    })
                );
                this.dispatchEvent(new CustomEvent('partialquoteupdated', { detail: { quotes: this.wiredData.data } }));
            } catch (ex) {
                console.error(ex);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: TOAST_ERROR_DELETE_TITLE,
                        message: TOAST_ERROR_DELETE_MESSAGE,
                        variant: 'error',
                    })
                );
            } finally {
                this.isLoading = false;
            }
        }
    }

    async handleSave(event) {
        const quoteId = event.currentTarget.dataset.id;
        const quote = this.partialQuotes.find(e => e.id === quoteId);
        const operation = quoteId.startsWith('draft') ? Operations.Insert : Operations.Update;
        let title;
        let message;
        if (!this.isValidQuote(quote)) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Preencha os campos obrigatórios',
                    message: 'Há campos obrigatórios não preenchidos, faça o preenchimento e volte a salvar',
                    variant: 'warning',
                })
            );
            return;
        }
        try {
            this.isLoading = true;
            if (operation === Operations.Insert) {
                await insertQuote({ partialQuote: quote, oppId: this.opportunityId });
                title = TOAST_SUCCESS_INSERT_TITLE;
                message = TOAST_SUCCESS_INSERT_MESSAGE;
            } else {
                await updateQuote({ partialQuote: quote });
                title = TOAST_SUCCESS_UPDATE_TITLE;
                message = TOAST_SUCCESS_UPDATE_MESSAGE;
            }
            await refreshApex(this.wiredData);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: 'success',
                })
            );

            this.dispatchEvent(new CustomEvent('partialquoteupdated', { detail: { quotes: this.wiredData.data } }));
            if (!quote.integralization) {
                this.dispatchEvent(new CustomEvent('proposalcreation'));
            }

        } catch (ex) {
            console.error(ex);
            if (operation === Operations.Insert) {
                title = TOAST_ERROR_INSERT_TITLE;
                message = TOAST_ERROR_INSERT_MESSAGE;
            } else {
                title = TOAST_ERROR_UPDATE_TITLE;
                message = TOAST_ERROR_UPDATE_MESSAGE;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: 'error',
                })
            );
        } finally {
            this.isLoading = false;
        }
    }

    isValidQuote(quote) {
        const quoteDiv = this.template.querySelector('[data-id="' + quote.id + '"]');
        const allValid = [
            ...quoteDiv.querySelectorAll('lightning-input'),
            ...quoteDiv.querySelectorAll('lightning-select'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if (allValid) {
            return true;
        } else {
            return false;
        }
    }

    get percentageSum() {
        const totalInsured = this.partialQuotes.reduce((partialSum, e) => partialSum + (e.amountInsurance ? parseInt(e.amountInsurance) : 0), 0);
        return this.insuredAmount && totalInsured ? (totalInsured / this.insuredAmount * 100).toLocaleString(undefined, LOCALE_OPTIONS) + '%' : null;
    }

    get percentageSumClass() {
        if (!this.percentageSum) {
            return null;
        }

        const percentageNum = parseFloat(this.percentageSum.replace('%', ''));
        if (percentageNum >= 100) {
            return 'slds-theme_success';
        }
        if (percentageNum >= 70) {
            return 'slds-theme_warning';
        }
        return 'slds-badge_lightest';
    }

    // Files functions
    handleControlShowViewFile(event) {
        const eventDetail = event.detail;

        let currentQuote = this.partialQuotes.find(e => e.id === eventDetail.parentId);
        currentQuote.fileLoaded = true;
        if (event.target.tagName === 'C-CONNECT-WIZ-FILE-VIEW') {
            currentQuote.showViewFile = eventDetail.hasFiles;
            currentQuote.showUploadFile = !eventDetail.hasFiles;
        } else {
            currentQuote.showViewFile = true;
            currentQuote.showUploadFile = false;
        }
    }

    onRefresh() {
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    handleRefresh() {
        this.onRefresh();
        const selectedEvent = new CustomEvent("refresh");
        this.dispatchEvent(selectedEvent);
    }
}