import { LightningElement, api, track } from 'lwc';

export default class CustomCheckbox extends LightningElement {

    @api options = [];
    @track selectedValues = [];
    @track deselectedValues = [];

    handleCheckboxChange(event) {

        const { name, checked } = event.target;
        if (checked) {
            this.selectedValues = [...this.selectedValues, name];
            this.deselectedValues = this.deselectedValues.filter(value => value !== name);

        } else {
            this.selectedValues = this.selectedValues.filter(value => value !== name);
            this.deselectedValues = [...this.deselectedValues, name];
        }


        this.dispatchEvent(new CustomEvent('selectionchange', { detail: { selected: this.selectedValues, deselected: this.deselectedValues } }));
    }
}