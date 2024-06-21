import { LightningElement, api } from 'lwc';

export default class QuestionnaireCheckbox extends LightningElement {
    @api questionId;
    @api label;
    @api options;
    @api initialOptions;
    @api allowComment;
    @api comment;
    @api readOnly = false;

    selectedOptions = this.initialOptions;
    commentValue = this.comment;

    typingTimer;

    get _options() {
        return this.options ? this.options.split(';').map(e => { return { label: e, value: e } }) : {};
    }

    get _initialOptions() {
        return this.initialOptions ? this.initialOptions.split(';') : [];
    }

    handleSelectionChange(event) {
        this.selectedOptions = event.target.value;
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
                    answer: this.selectedOptions.join(';'),
                    comment: this.commentValue
                }
            });
            this.dispatchEvent(evt);
        }, 500);
    }
}