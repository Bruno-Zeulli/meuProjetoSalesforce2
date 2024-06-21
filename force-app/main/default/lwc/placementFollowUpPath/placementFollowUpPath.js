import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCaseRecordTypeId from '@salesforce/apex/PlacementFollowUpController.getCaseRecordTypeId';
import updateCaseAndOppStatus from '@salesforce/apex/PlacementFollowUpController.updateCaseAndOppStatus';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import CASE_STATUS from '@salesforce/schema/Case.Status'

export default class PlacementFollowUpPath extends LightningElement {
    @api oppId;
    @api caseId;
    @api caseRecord;

    @track caseRecordTypeId;

    currentStep
    stepList
    selectedStep
    size
    lastStepName
    nextStep;

    showCompleteStep;

    loaded = false;
    
    async connectedCallback() {
        await this.initialize();
    }

    @wire(getCaseRecordTypeId, {recordTypeName : 'CorporateCelulaTecnica'})
    wiredCaseRecordTypeId({error, data}) {
        if(data) {
            this.caseRecordTypeId = data;
        } else if (error) {
            console.error('Error retrieving record type id: ', error);
        }
    }


    @wire(getPicklistValues, { recordTypeId: '$caseRecordTypeId', fieldApiName: CASE_STATUS })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.stepList = data.values.map(picklistValue => picklistValue.label);
            this.initialize();
        } else if (error) {
            console.error('Error retrieving picklist values: ', error);
        }
    }


    async initialize() {
        if (this.stepList && this.caseRecord) { 

            this.currentStep = this.caseRecord[0].Status;
            this.size = this.stepList.length;
            this.lastStepName = this.stepList[this.size - 1];
            this.selectedStep = this.currentStep;
            //this.showCompleteStep = this.stepList.indexOf(this.currentStep) === (this.size-1) ? false : true;
            this.showCompleteStep = this.currentStep === 'Aguardando cotação';
            this.loaded = true;
        }
    }

    async handleComplete() {
        if (this.currentStep === "Aguardando cotação") {
            this.toggleLoading(false);
            const nextStep = this.calculateNextStep();
            if (nextStep) {
                this.updateStep(nextStep);
                await this.updateRecords(nextStep);
            }
        }
    }
    
    calculateNextStep() {
        const currentIndex = this.stepList.indexOf(this.currentStep);
        return currentIndex < this.size - 1 ? this.stepList[currentIndex + 1] : null;
    }
    
    updateStep(nextStep) {
        this.currentStep = nextStep;
        this.selectedStep = nextStep;
        this.showCompleteStep = nextStep === "Aguardando cotação";
    }
    
    async updateRecords(nextStep) {
        const opp = { Id: this.oppId, StageName: 'Em negociação' };
        const cse = { Id: this.caseId, Status: 'Aguardando aprovação da cotação' };
        try {
            const data = await updateCaseAndOppStatus({ oppRec: opp, caseRec: cse });
            this.showSuccessToast(nextStep);
            this.toggleLoading(true);
        } catch (error) {
            this.handleError(error);
        }
    }
    
    toggleLoading(isLoaded) {
        this.loaded = isLoaded;
    }
    
    showSuccessToast(nextStep) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: `Step ${nextStep} completed.`,
            variant: 'success',
        }));
    }
    
    handleError(error) {
        console.error('ERR: ', error);
        let errorMessageFormatted = this.formatErrorMessage(error.body.message);
        this.currentStep = 'Aguardando cotação';
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: `Falha ao atualizar status: ${errorMessageFormatted}`,
            variant: 'error',
        }));
        this.toggleLoading(true);
    }
    
    formatErrorMessage(errorMessage) {
        return errorMessage.replace(/\"/g, '')
            .replace(/message:/g, '')
            .replace(/:/g, '')
            .replace(/{|}/g, '')
            .replace(/\[|\]/g, '');
    }
    
}