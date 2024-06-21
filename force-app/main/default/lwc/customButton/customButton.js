import { LightningElement, api } from 'lwc';

export default class CustomButton extends LightningElement {

    @api title;
    @api description;
    @api isActive;
    @api badgeActive = false;
    @api countQuotes;

    handleButtonClick() {
        const clickEvent = new CustomEvent('buttonclick', {
            detail: { buttonTitle: this.title }
        });
        this.dispatchEvent(clickEvent);
    }

    

    get buttonClass(){
        return this.isActive == true ? "fill-container-button2" : "fill-container-button";
    }

}