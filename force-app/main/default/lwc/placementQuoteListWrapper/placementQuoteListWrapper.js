import { LightningElement, track } from 'lwc';

export default class PlacementQuoteListWrapper extends LightningElement {

    tabPending = true;
    tabMyQuotes = false;
    tabAllQuotes = false;
    countQuotes;

    handleDataLoaded(event) {
        let allQuotesRequest = event.detail;
        this.countQuotes = allQuotesRequest.length + ' novas';
    }

    handleButtonClick(event) {
        const buttonTitle = event.detail.buttonTitle;

        if (buttonTitle === 'Pedidos de cotação') {

            this.tabPending = true;
            this.tabMyQuotes = false;
            this.tabAllQuotes = false;
        } else if (buttonTitle === 'Minhas cotações') {

            this.tabMyQuotes = true;
            this.tabPending = false;
            this.tabAllQuotes = false;
        } else if (buttonTitle === 'Todas as cotações') {

            this.tabAllQuotes = true;
            this.tabPending = false;
            this.tabMyQuotes = false;
        }
    }
}