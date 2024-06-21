import { LightningElement, track } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import five9_sdk  from '@salesforce/resourceUrl/five9_sdk';

export default class FloatPhoneButton extends LightningElement {

    showButtonEngage = false;
    showButtonEngager(){
        this.handlerShowButtonEngage();
    }
    handlerShowButtonEngage(){
        // todo código para abrir uma janela de ajuda aqui
        this.showButtonEngage = !this.showButtonEngage;
    }
}