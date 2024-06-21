import { LightningElement, api } from 'lwc';

export default class QuestionnaireYesNo extends LightningElement {
    @api questionId;
    @api label;
    @api initialOption;
    @api allowComment;
    @api comment;
    @api readOnly = false;

    selectedOption = this.initialOption;
    commentValue = this.comment;

    typingTimer;

    get options() {
        return [{ label: 'Sim', value: 'true' }, { label: 'Não', value: 'false' }];
    }

    handleSelectionChange(event) {
        this.selectedOption = event.target.value;
        this.updateEvent();
    }

    handleCommentChange(event) {
        this.commentValue = event.target.value;
        this.updateEvent();
    }

    updateEvent() {
        window.clearTimeout(this.typingTimer);
        this.typingTimer = setTimeout(() => {
            const evt = new CustomEvent("answerchange", {
                detail: {
                    id: this.questionId,
                    answer: this.selectedOption,
                    comment: this.commentValue
                }
            });
            this.dispatchEvent(evt);
        }, 500);
    }
}