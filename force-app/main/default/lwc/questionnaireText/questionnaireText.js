import { LightningElement, api } from 'lwc';

export default class QuestionnaireText extends LightningElement {
    @api questionId;
    @api label;
    @api value;
    @api allowComment;
    @api comment;
    @api readOnly = false;

    answerValue = this.value;
    commentValue = this.comment;

    typingTimer;

    handleAnswerChange(event) {
        this.answerValue = event.target.value;
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
                    answer: this.answerValue,
                    comment: this.commentValue
                }
            });
            this.dispatchEvent(evt);
        }, 500);
        
    }

}