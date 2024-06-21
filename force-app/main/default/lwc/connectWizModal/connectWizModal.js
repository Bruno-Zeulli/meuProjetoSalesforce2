import { LightningElement,api } from 'lwc';

export default class ConnectWizModal extends LightningElement {

    @api modalHeading;
    @api content;

    handleOkay(){
        this.close('okay');
    }
}