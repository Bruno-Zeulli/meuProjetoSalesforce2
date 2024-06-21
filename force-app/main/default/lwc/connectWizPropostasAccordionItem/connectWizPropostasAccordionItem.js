import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProposal from '@salesforce/apex/ConnectWizController.getProposal';
import insertProposal from '@salesforce/apex/ConnectWizController.insertProposal';
import updateProposal from '@salesforce/apex/ConnectWizController.updateProposal';
import deleteProposal from '@salesforce/apex/ConnectWizController.deleteProposal';

const Operations = {
    Insert: 'insert',
    Update: 'update'
}

const TOAST_SUCCESS_INSERT_TITLE = 'Sucesso ao inserir a proposta';
const TOAST_SUCCESS_INSERT_MESSAGE = 'A proposta foi inserida com sucesso';
const TOAST_SUCCESS_UPDATE_TITLE = 'Sucesso ao atualizar a proposta';
const TOAST_SUCCESS_UPDATE_MESSAGE = 'A proposta foi atualizada com sucesso';
const TOAST_SUCCESS_DELETE_TITLE = 'Sucesso ao excluir a proposta';
const TOAST_SUCCESS_DELETE_MESSAGE = 'A proposta foi excluída com sucesso';
const TOAST_ERROR_INSERT_TITLE = 'Falha ao inserir a proposta';
const TOAST_ERROR_INSERT_MESSAGE = 'Ocorreu um erro ao inserir a proposta';
const TOAST_ERROR_UPDATE_TITLE = 'Falha ao atualizar a proposta';
const TOAST_ERROR_UPDATE_MESSAGE = 'Ocorreu um erro ao atualizar a proposta';
const TOAST_ERROR_DELETE_TITLE = 'Falha ao excluir a proposta';
const TOAST_ERROR_DELETE_MESSAGE = 'Ocorreu um erro ao excluir a proposta';

const QUOTE_TABLE_COLUMNS = [
    { label: 'Nome', fieldName: 'name' },
    { label: 'Seguradora', fieldName: 'insuranceCompany' },
    { label: 'Prêmio', fieldName: 'insurancePremium', type: 'currency' },
    { label: 'Importância Segurada', fieldName: 'amountInsurance', type: 'currency' },
    { label: '% Total', fieldName: 'insuredPercentage', type: 'percentFixed' }
];

const COMPOSITION_TABLE_COLUMNS = [
    { label: 'Cotação', fieldName: 'name' },
    { label: 'Prêmio', fieldName: 'insurancePremium', type: 'currency' },
    { label: 'Max. Imp. Segurada', fieldName: 'amountInsurance', type: 'currency' },
    { label: '% Máxima', fieldName: 'insuredPercentage', type: 'percentFixed' },
    { label: '% Utilizada', fieldName: 'insuredPercentageUsed', type: 'percentFixed', editable: { fieldName: 'isEditable' }, typeAttributes: { required: true } },
    { label: 'Importância Segurada', fieldName: 'amountInsuranceUsed', type: 'currency', editable: { fieldName: 'isEditable' } }
]

export default class ConnectWizPropostasAccordionItem extends LightningElement {
    @api opportunityId;
    @api insuredAmount;
    @api
    get partialQuoteList() {
        return this.partialQuotes;
    };
    set partialQuoteList(value) {
        this.partialQuotes = JSON.parse(JSON.stringify(value));
        this.partialQuotes.forEach(e => {
            e.insuredPercentage = this.insuredAmount && e.amountInsurance ? (e.amountInsurance / this.insuredAmount * 100) : 0
        });

        this.proposalList.forEach(e => {
            // e.availablePartialQuotes = this.partialQuotes;
            this.handleCompositionData(e);
        });
    }
    partialQuotes = [];
    isOpen = false;
    isLoading = false;
    wiredData;
    openQuotes = [];
    @track proposalList = [];
    draftCounter = 0;
    currentProposalId;
    deleteModal = false;
    errors;

    // Files properties
    showButtonViewFile = true;
    showButtonDeleteFile = true;
    showSimpleView = true;
    viewFileLoading = true;
    documentTypeName = 'Proposta de Seguro';

    quoteTableColumns = QUOTE_TABLE_COLUMNS;
    @track compositionTableColumns = COMPOSITION_TABLE_COLUMNS;

    @wire(getProposal, { recordId: "$opportunityId" })
    wiredProposal(value) {
        this.wiredData = value;
        const { data, error } = value;
        if (data) {
            this.processProposal();
        } else if (error) {
            console.error('error on getProposal', JSON.parse(JSON.stringify(error)));
        }
    }

    @api refreshProposal() {
        refreshApex(this.wiredData);
    }

    processProposal() {
        const proposalData = JSON.parse(JSON.stringify(this.wiredData.data));
        this.proposalList = [];
        proposalData.forEach(proposal => {
            proposal.availableQuotes.forEach(e => {
                e.insuredPercentage = this.insuredAmount && e.amountInsurance ? (e.amountInsurance / this.insuredAmount * 100) : 0;
                e.name = e.name.replace("Cotação | ", "");
            });

            const leadComposition = proposal.composition.find(e => e.isLead);
            let leadQuote = leadComposition.partialQuote;
            leadQuote.amountInsuranceUsed = leadComposition.amountInsuranceUsed;
            leadQuote.insuredPercentage = this.insuredAmount && leadQuote.amountInsurance ? (leadQuote.amountInsurance / this.insuredAmount * 100) : 0;
            leadQuote.insuredPercentageUsed = this.insuredAmount && leadQuote.amountInsuranceUsed ? (leadQuote.amountInsuranceUsed / this.insuredAmount * 100) : 0;
            leadQuote.name = leadQuote.name.replace("Cotação | ", "");
            const availableCoinsureQuotes = proposal.availableQuotes.filter(e => e.id != leadQuote.id);
            let selectedCoinsurance = [];
            let coinsuranceQuotes = [];
            availableCoinsureQuotes.forEach(e => {
                const coInsuranceQuote = proposal.composition.find(element => element.partialQuote.id === e.id)
                if (coInsuranceQuote) {
                    selectedCoinsurance.push(e.id);
                    e.amountInsuranceUsed = coInsuranceQuote.amountInsuranceUsed;
                    coinsuranceQuotes.push(e);
                }
            });

            coinsuranceQuotes.forEach(e => {
                e.insuredPercentageUsed = this.insuredAmount && e.amountInsuranceUsed ? (e.amountInsuranceUsed / this.insuredAmount * 100) : 0;
            });
            const myProposal = {
                id: proposal.compositeQuote.id,
                showDetails: false,
                availablePartialQuotes: proposal.availableQuotes,
                availableCoinsureQuotes: availableCoinsureQuotes,
                disableSaveButton: false,
                leadQuote: leadQuote,
                selectedLead: [leadQuote.id],
                selectedCoinsurance: selectedCoinsurance,
                coinsuranceQuotes: coinsuranceQuotes,
                fileLoaded: false,
                showViewFile: true,
                showUploadFile: true,
                filesAvailable: true
            };
            this.proposalList.push(myProposal);
            this.handleCompositionData(myProposal);
        })
    }

    handleAccordionClick(event) {
        this.isOpen = !this.isOpen;
    }

    handleOpenCloseProposal(event) {
        const currentProposal = this.proposalList.find(e => e.id === event.currentTarget.dataset.id);
        currentProposal.showDetails = !currentProposal.showDetails;
    }

    handleLeadQuoteSelection(event) {
        const selectedRows = event.detail.selectedRows;
        const proposalId = event.currentTarget.parentElement.parentElement.dataset.id;

        const currentProposal = this.proposalList.find(e => e.id === proposalId);
        currentProposal.leadQuote = selectedRows[0];
        currentProposal.availableCoinsureQuotes = currentProposal.availablePartialQuotes.filter(e => e.id != currentProposal.leadQuote.id);
        this.handleCompositionData(currentProposal);
    }

    handleCoinsureQuoteSelection(event) {
        const selectedRows = event.detail.selectedRows;
        const proposalId = event.currentTarget.parentElement.parentElement.dataset.id;

        const currentProposal = this.proposalList.find(e => e.id === proposalId);
        currentProposal.coinsuranceQuotes = selectedRows;
        this.handleCompositionData(currentProposal);
    }

    handleCompositionData(proposal) {
        proposal.compositionQuotes = [
            proposal.leadQuote
        ];
        if (proposal.coinsuranceQuotes) {
            proposal.compositionQuotes.push(...proposal.coinsuranceQuotes);
        }
        proposal.compositionQuotes.forEach(e => {
            e.insuredPercentageUsed = e.insuredPercentageUsed ? e.insuredPercentageUsed : e.insuredPercentage;
            e.amountInsuranceUsed = e.amountInsuranceUsed ? e.amountInsuranceUsed : e.amountInsurance;
            e.isEditable = true;
        });
        proposal.insuranceCompanies = Array.from(proposal.compositionQuotes.reduce((s, e) => s.add(e.insuranceCompany), new Set())).join(' - ');

        proposal.compositionQuotes.push(this.handleSubtotalComposition(proposal.compositionQuotes));
        proposal.disableSaveButton = false;
        proposal.compositionQuotesDraft = [];
    }

    handleSubtotalComposition(compositionQuotes) {
        let subTotalRow = {
            id: 'subtotal',
            name: 'SUBTOTAL',
            isEditable: false,
            insurancePremium: 0,
            insuredPercentageUsed: 0,
            amountInsuranceUsed: 0
        };
        return compositionQuotes.reduce((newObject, quote) => {
            newObject.insuredPercentageUsed += quote.insuredPercentageUsed;
            newObject.amountInsuranceUsed += quote.amountInsuranceUsed;
            newObject.insurancePremium += quote.insurancePremium ? quote.insurancePremium : 0;
            return newObject;
        }, subTotalRow);
    }

    handleCellChange(event) {
        let draftValue = event.detail.draftValues[0];

        const proposalId = event.currentTarget.parentElement.parentElement.dataset.id;
        const currentProposal = this.proposalList.find(e => e.id === proposalId);
        const currentQuote = currentProposal.compositionQuotes.find(e => e.id === draftValue.id);
        let discardChange = false;

        if (draftValue.hasOwnProperty('insuredPercentageUsed')) {
            if (draftValue.insuredPercentageUsed === '' || parseFloat(draftValue.insuredPercentageUsed) > currentQuote.insuredPercentage || parseFloat(draftValue.insuredPercentageUsed) === 0) {
                discardChange = true;
            } else {
                draftValue.insuredPercentageUsed = parseFloat(draftValue.insuredPercentageUsed);
                draftValue.amountInsuranceUsed = draftValue.insuredPercentageUsed * this.insuredAmount / 100;

            }
        } else if (draftValue.hasOwnProperty('amountInsuranceUsed')) {
            if (draftValue.amountInsuranceUsed === '' || parseFloat(draftValue.amountInsuranceUsed) > currentQuote.amountInsurance || parseFloat(draftValue.amountInsuranceUsed) === 0) {
                discardChange = true;
            } else {
                draftValue.amountInsuranceUsed = parseFloat(draftValue.amountInsuranceUsed);
                draftValue.insuredPercentageUsed = draftValue.amountInsuranceUsed / this.insuredAmount * 100;
            }
        }

        currentProposal.compositionQuotesDraft = currentProposal.compositionQuotesDraft.filter(e => e.id !== draftValue.id && e.id !== 'subtotal');
        if (!discardChange) {
            currentProposal.compositionQuotesDraft.push(draftValue);
        }

        if (currentProposal.compositionQuotesDraft.length > 0) {
            const subtotal = this.handleSubtotalComposition(Array.from(
                [...currentProposal.compositionQuotes, ...currentProposal.compositionQuotesDraft]
                    .reduce((m, o) => { if (o.id !== 'subtotal') m.set(o.id, o); return m; }, new Map)
                    .values()
            ));
            delete subtotal.name;
            delete subtotal.insurancePremium;
            currentProposal.compositionQuotesDraft.push(subtotal);
        }

        this.compositionTableColumns = [...this.compositionTableColumns];
    }

    resetTable(event) {
        const proposalId = event.currentTarget.parentElement.parentElement.dataset.id;
        const currentProposal = this.proposalList.find(e => e.id === proposalId);
        currentProposal.compositionQuotesDraft = [];
    }

    handleCompositionTableSave(event) {
        const proposalId = event.currentTarget.parentElement.parentElement.dataset.id;
        const currentProposal = this.proposalList.find(e => e.id === proposalId);

        // const newValues = Array.from(
        //     [...currentProposal.compositionQuotes, ...currentProposal.compositionQuotesDraft]
        //     .reduce((m, o) => { if (o.id !== 'subtotal') m.set(o.id, o); return m; }, new Map)
        //     .values()
        // );
        currentProposal.compositionQuotes = currentProposal.compositionQuotes.map(e => {
            const draftValue = currentProposal.compositionQuotesDraft.find(d => d.id === e.id);
            if (draftValue) {
                if (draftValue.hasOwnProperty('insuredPercentageUsed')) {
                    e.insuredPercentageUsed = draftValue.insuredPercentageUsed;
                }
                if (draftValue.hasOwnProperty('amountInsuranceUsed')) {
                    e.amountInsuranceUsed = draftValue.amountInsuranceUsed;
                }
            }
            return e;
        });
        currentProposal.compositionQuotesDraft = [];
    }

    addNewProposal() {
        this.proposalList.push({
            id: 'draft' + this.draftCounter++,
            showDetails: true,
            availablePartialQuotes: this.partialQuotes,
            disableSaveButton: true,
            selectedLead: [],
            selectedCoinsurance: [],
            filesAvailable: false
        });
    }

    openDeleteModal(event) {
        this.currentProposalId = event.currentTarget.dataset.id;
        this.deleteModal = true;
    }

    closeDeleteModal() {
        this.deleteModal = false;
    }

    async handleDelete() {
        const proposalId = this.currentProposalId;
        this.closeDeleteModal();
        if (proposalId.startsWith('draft')) {
            this.proposalList.filter((item, index, arr) => {
                if (item.id === proposalId) {
                    arr.splice(index, 1);
                    return true;
                }
                return false;
            });
        } else {
            this.isLoading = true;
            try {
                await deleteProposal({ proposalId: proposalId });
                await refreshApex(this.wiredData);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: TOAST_SUCCESS_DELETE_TITLE,
                        message: TOAST_SUCCESS_DELETE_MESSAGE,
                        variant: 'success',
                    })
                );
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
        const proposalId = event.currentTarget.dataset.id;
        const proposal = this.proposalList.find(e => e.id === proposalId);
        const operation = proposalId.startsWith('draft') ? Operations.Insert : Operations.Update;
        let title;
        let message;
        if (!this.isValidProposal(proposal)) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Não foi possível criar a proposta',
                    message: proposal.errors,
                    variant: 'warning',
                })
            );
            return;
        }
        try {
            this.isLoading = true;
            const editedQuotes = proposal.compositionQuotes.filter(e => e.id !== 'subtotal');
            const proposalComposition = editedQuotes.map((e, idx) => {
                if (e.id !== 'subtotal') {
                    const composition = {
                        partialQuote: e,
                        amountInsuranceUsed: e.amountInsuranceUsed
                    };
                    if (idx === 0) {
                        composition.isLead = true;
                    } else {
                        composition.isLead = false;
                    }
                    return composition;
                }
            });
            const proposalObj = {
                composition: proposalComposition,
                observations: ''
            };
            if (operation === Operations.Insert) {
                await insertProposal({ proposal: proposalObj, oppId: this.opportunityId });
                title = TOAST_SUCCESS_INSERT_TITLE;
                message = TOAST_SUCCESS_INSERT_MESSAGE;
            } else {
                await updateProposal({ proposal: proposalObj, compositeQuoteid: proposal.id });
                title = TOAST_SUCCESS_UPDATE_TITLE;
                message = TOAST_SUCCESS_UPDATE_MESSAGE;
            }
            await refreshApex(this.wiredData);
            // this.processProposal();

            this.dispatchEvent(
                new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: 'success',
                })
            );

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

    isValidProposal(proposal) {
        const subtotal = proposal.compositionQuotes.find(e => e.id === 'subtotal');
        let errors = [];
        if (parseFloat(subtotal.amountInsuranceUsed) < this.insuredAmount) {
            errors.push('O subtotal segurado não atinge o valor da oportunidade');
        }

        if (proposal.compositionQuotesDraft && proposal.compositionQuotesDraft.length > 0) {
            errors.push('Há valores não salvos na tabela de composição, Salve a tabela ou cancele para prosseguir');
        }

        if (errors.length === 0) {
            proposal.errors = '';
            return true;
        } else {
            proposal.errors = errors.join('. ');
            return false;
        }
    }

    // Files functions
    handleControlShowViewFile(event) {
        const eventDetail = event.detail;

        let currentProposal = this.proposalList.find(e => e.id === eventDetail.parentId);
        currentProposal.fileLoaded = true;
        if (event.target.tagName === 'C-CONNECT-WIZ-FILE-VIEW') {
            currentProposal.showViewFile = eventDetail.hasFiles;
            currentProposal.showUploadFile = !eventDetail.hasFiles;
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