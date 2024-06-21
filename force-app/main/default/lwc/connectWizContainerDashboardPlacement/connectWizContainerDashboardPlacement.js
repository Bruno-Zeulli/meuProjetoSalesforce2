import { api, LightningElement, track } from 'lwc';

export default class ConnectWizContainerDashboardPlacement extends LightningElement {

    mapCountCaseByStatus;
    @track isFullScreen = true;
    @track listCases= [];

    connectedCallback(){
        this.handleGridSlds();
    }

    handleGridSlds(){
        let screenSize = screen.width;
        if(screenSize <= 1620){
            this.isFullScreen = false;
        }else if(screenSize > 1620){
            this.isFullScreen = true;
        }
        // console.log('test ====== ? >>>>>>>>', screenSize);
    }

    filterStatusCases(event){

        const selectedEvent = new CustomEvent("filterstatuscases", {
            detail: event.detail,
        });

        // console.log(`selectedEvent in filterStatusCase - ${JSON.stringify(event.detail)} `);
        this.dispatchEvent(selectedEvent);
    }

    filterCasesByDate(event){
        // console.log(`selectedEvent in filterCasesByDate - ${JSON.stringify(event.detail)} `);
        const selectedEvent = new CustomEvent("filtercasesbydate", {
            detail: event.detail,
        });

        // console.log('selectedEvent in filterCasesByDate' , selectedEvent);
        this.dispatchEvent(selectedEvent);
    }

    @api async getCasesFromParentQuoteOrderManagement(listCases, filters, chartJs){
        await this.sendAllCasesToChildChartBar(listCases, filters, chartJs);
    }

    async sendAllCasesToChildChartBar(listCases, filters, chartJs){
        const elt =  this.template.querySelector("c-connect-wiz-chart-bar-opportunity-stage-name");
        await elt.getCasesFromParentContainerDashboard(listCases, filters, chartJs);
    }

    @api async getEventLabelButtonDefault(){
        await this.setLabelButtonDefault();
    }

    async setLabelButtonDefault(){
        const elt =  this.template.querySelector("c-connect-wiz-date-picker");
        await elt.setLabelButtonDefault();
    }
}