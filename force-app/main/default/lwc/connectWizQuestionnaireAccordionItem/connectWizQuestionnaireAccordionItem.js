import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";
import getQuestionnaireAnswers from '@salesforce/apex/ConnectWizController.getQuestionnaireAnswers';


const COLUMNS = [
    { label: 'Pergunta', fieldName: 'questionLabel', wrapText: true },
    { label: 'Tipo', fieldName: 'questionType' },
    { label: 'Resposta', fieldName: 'answer', editable: true, wrapText: true },
    { label: 'Comentário', fieldName: 'comment', editable: true, wrapText: true }
];

export default class ConnectWizQuestionnaireAccordionItem extends LightningElement {
    @api recordId;
    @track questionnaires;
    isOpen = false;
    isLoading = true;
    showComp = false;
    columns = COLUMNS;
    draftValues = [];
    wiredData;

    @wire(getQuestionnaireAnswers, { recordId: "$recordId" })
    wiredQuestionnaire(value) {
        this.wiredData = value;
        const { data, error } = value;
        if (data) {
            console.log('backend getQuestionnaire' + JSON.stringify(data));
            this.questionnaires = JSON.parse(JSON.stringify(data));
            this.isLoading = false;
        } else if (error) {
            console.log('Deu errado getQuestionnaire' + JSON.stringify(error));
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

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    handleLoading(event){
        this.isLoading = event;
    }

    handleQuestionnaireInformation(event){
        console.log('questionnaireId ' + JSON.stringify(event.currentTarget.dataset.id));
        let questId = event.currentTarget.dataset.id;
        for(let form of this.questionnaires.values()){
            if(form.id == questId){
                console.log("entrou no if: " + form.showDetails);
                form.showDetails = !form.showDetails;
                console.log("form" + JSON.stringify(form));
            }
        }
    }

    async handleSave(event){
        // Convert datatable draft values into record objects
        const records = event.detail.draftValues.slice().map((draftValue) => {
            let fields = {};
            if (draftValue.id){
                fields.Id = draftValue.id;
            }
            if (draftValue.answer){
                fields.Answer__c = draftValue.answer;
            }
            if (draftValue.comment){
                fields.Comment__c = draftValue.comment;
            }
            return { fields };
        });
        console.log("records", records);
        // Clear all datatable draft values
        this.draftValues = [];

        try {
            // Update all records in parallel thanks to the UI API
            const recordUpdatePromises = records.map((record) => updateRecord(record));
            await Promise.all(recordUpdatePromises);

            // Report success with a toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Sucesso",
                    message: "Questionário atualizado",
                    variant: "success",
                })
            );

            // Display fresh data in the datatable
            await refreshApex(this.wiredData);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                title: "Erro na atualização ou no recarregamento dos dados",
                message: error.body.message,
                variant: "error",
                }),
            );
        }
    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    get hasData(){
        return this.questionnaires && this.questionnaires.length > 0;
    }
}