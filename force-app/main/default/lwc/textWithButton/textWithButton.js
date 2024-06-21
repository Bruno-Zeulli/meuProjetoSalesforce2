import { LightningElement, api } from 'lwc';

export default class TextWithButton extends LightningElement {

    @api recordId;
    @api opportunityId;
    @api value = '';

    handleButtonClick() {
        const event = new CustomEvent('buttonclick', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: { recordId: this.recordId, opportunityId: this.opportunityId }
        });
        this.dispatchEvent(event);
    }
}