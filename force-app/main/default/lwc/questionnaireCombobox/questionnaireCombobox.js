import { LightningElement, api } from 'lwc';

export default class QuestionnaireCombobox extends LightningElement {
    @api questionId;
    @api label;
    @api options;
    @api initialOption;
    @api allowComment;
    @api comment;
    @api readOnly = false;

    selectedOption = this.initialOption;
    commentValue = this.comment;

    typingTimer;

    get _options() {
        return this.options ? this.options.split(';').map(e => { return { label: e, value: e } }) : {};
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