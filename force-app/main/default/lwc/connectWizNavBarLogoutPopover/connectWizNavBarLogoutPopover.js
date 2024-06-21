import { LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class ConnectWizNavBarLogoutPopover extends NavigationMixin(LightningElement){

     navigateToLogout(){
        this[NavigationMixin.Navigate]({
            type: 'comm__loginPage',
            attributes: {
                actionName: 'logout'
            }
        });
    }
}