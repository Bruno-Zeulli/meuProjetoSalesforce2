import { LightningElement, wire } from 'lwc';
import getMyCaseBTWhatsApp from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getMyCaseBTWhatsApp';


export default class BeetalkWhatsAppConsoleMyItem extends LightningElement {
    userId = Id;
    myCases;

    @wire(getMyCaseBTWhatsApp,{recordId: '$userId'})
        getMyCaseBTWhatsApp({ error, data }){
            if(data){
                console.log('-- data returned --');     
                console.log(data);
                this.myCases = data;
            } else if(error){
                console.log(error);
            }
        }


}