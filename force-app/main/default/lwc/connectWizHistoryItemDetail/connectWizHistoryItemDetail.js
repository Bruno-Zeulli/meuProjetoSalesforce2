import { LightningElement,api } from 'lwc';

export default class ConnectWizHistoryItemDetail extends LightningElement {
    @api contentDetails;
    @api typeOfContent;
    @api columns;
    @api subject;
    @api description;
    @api containsDescription;
    task = this.contentDetails;
    hasDocument = false;

    connectedCallback(){

    }

    get isLayout()
    {
        return this.typeOfContent.toLowerCase() == 'layout+text';
    }

    get size()
    {
        return 12 / this.columns;
    }
}