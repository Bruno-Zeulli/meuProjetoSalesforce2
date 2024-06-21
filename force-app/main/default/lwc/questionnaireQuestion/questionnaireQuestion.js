import { LightningElement, api } from 'lwc';
import templateText from "./templates/text.html";
import templateCheckbox from "./templates/checkbox.html";
import templateYesNo from "./templates/yesNo.html";
import templateCombobox from "./templates/combobox.html";
import templateTable from "./templates/table.html";

export default class QuestionnaireQuestion extends LightningElement {
    @api question;
    @api readOnly = false;

    get question_() {
        return JSON.parse(JSON.stringify(this.question));
    }

    render() {
        switch (this.question.Question_Type__c) {
            case 'Checkbox':
                return templateCheckbox;
            case 'Sim/Não':
                return templateYesNo;
            case 'Lista de Opções':
                return templateCombobox;
            case 'Tabela':
                return templateTable;
            default:
                return templateText;
        }
    }

    handleChange(event) {
        this.dispatchEvent(new CustomEvent("update", { detail: event.detail }));
    }
}