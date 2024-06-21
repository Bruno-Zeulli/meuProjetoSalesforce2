import { LightningElement } from 'lwc';

export default class PlacementFinishedListWrapper extends LightningElement {

    tabMyFinishedQuotes = true;
    tabAllFinishedQuotes = false;

    handleButtonClick(event) {
        const buttonTitle = event.detail.buttonTitle;

        if (buttonTitle === 'Minhas cotações finalizadas') {

            this.tabMyFinishedQuotes = true;
            this.tabAllFinishedQuotes = false;
        } else if (buttonTitle === 'Todas as cotações finalizadas') {

            this.tabAllFinishedQuotes = true;
            this.tabMyFinishedQuotes = false;
        }
    }
}