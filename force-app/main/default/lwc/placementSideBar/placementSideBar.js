import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import logoutUser from '@salesforce/apex/PlacementController.logoutUser';

export default class PlacementSideBar extends NavigationMixin(LightningElement) {
    @track quoteActive = true;
    @track clientActive = false;
    @track completeActive = false;
    exitActive = false;
    logoutUrl;

    @wire(logoutUser)
    wiredLogoutUrl({ error, data }) {
        if (data) {
            this.logoutUrl = data;
        } else if (error) {
            console.error(error);
        }
    }

    connectedCallback() {
        this.verifyUrl();
    }

    handleButtonClick(event) {
        const target = event.target.label;
        if (target == 'Cotações'){
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'Home'
                }
            })
        } else if (target == 'Concluídas') {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'finished__c'
                }
            })
        }
        setTimeout(() => {
            this.verifyUrl();
            
        }, 1000);
    }

    handleLogout(){
        if (this.logoutUrl) {
            window.location.href = this.logoutUrl;
        } else {
            console.error('Logout URL is undefined');
        }
    }


    verifyUrl(){
        const urlId = this.extractIdFromUrl(window.location.href);
        if (urlId == 'acompanhamento' || urlId == '') {
            this.quoteActive = true;
            this.completeActive = false;
            this.clientActive = false;
        } else if (urlId == 'clientes') {
            this.clientActive = true;
            this.completeActive = false;
            this.quoteActive = false;
        } else if (urlId == 'finalizadas') {
            this.completeActive = true;
            this.quoteActive = false;
            this.clientActive = false;
        }
    }

    extractIdFromUrl(url) {
        // Dividir a URL com base no caractere "/"
        const parts = url.split('/');
        // Encontrar o índice do valor na URL
        const index = parts.indexOf('s');
        // Verificar se o valor foi encontrado na URL e se há um valor depois dele
        if (index !== -1 && index + 1 < parts.length) {
            // Obter o ID que está após "opportunity/"
            const id = parts[index + 1];
            return id;
        }
        return 'erro';
    }

    get quoteButtonClass() {
        return this.quoteActive == true ? "active-button" : "quote-button";
    }
    get clientButtonClass() {
        return this.clientActive == true ? "active-button" : "client-button";
    }
    get completeButtonClass() {
        return this.completeActive == true ? "active-button" : "complete-button";
    }

    get menuItemQuote() {
        return this.quoteActive == true ? "active-menu-item" : "menu-item";
    }
    get menuItemClient() {
        return this.clientActive == true ? "active-menu-item" : "menu-item";
    }
    get menuItemComplete() {
        return this.completeActive == true ? "active-menu-item" : "menu-item";
    }
}