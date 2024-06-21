import { LightningElement,wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";

export default class ConnectWizSideBarItens extends NavigationMixin(LightningElement){

    @wire(CurrentPageReference)
    pageRef;


    navigateToQuotes(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    //Navigate to home page
    navigateToHomePage(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: ''
            },

        }).then(url => {
            window.open("https://connect.wiz.co/home/", "_self");
        });
    }

    navigateToRV(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: ''
            },

        }).then(url => {
            window.open("https://connect.wiz.co/paineis/visualizar", "_self");
        });
    }
}