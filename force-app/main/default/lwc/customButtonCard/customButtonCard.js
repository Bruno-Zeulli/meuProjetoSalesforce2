import { LightningElement, api } from 'lwc';

export default class CustomButtonCard extends LightningElement {

    @api title;
    @api value;
}