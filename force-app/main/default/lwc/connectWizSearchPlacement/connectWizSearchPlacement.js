import { LightningElement, track, api } from 'lwc';

export default class ConnectWizSearchPlacement extends LightningElement {

    @api quotesToExport=[];
    @track filterFields;
    @track selectedValueParamSearch = 'productComboName';
    @track selectedValueSearch;


    @track csvData= [];

    @track csvHeaders = {
        opportunityNumer:'Nº Oportunidade',
        product:'Produtos',
        clientName:'Nome do Cliente',
        quotes : 'Cotações',
        status : 'Status',
        lastModified : 'Última Modificação',
        source : 'Origem da Demanda',
        resposible : "Responsável"
    };

    connectedCallback() {
        console.log('Search comp' + JSON.stringify(this.quotesToExport));
        for(let opp of this.quotesToExport) {
            this.csvData = [...this.csvData, {
                opportunityNumer : opp.opportunityNumber,
                product : opp.productComboName,
                clientName : opp.accountName,
                quotes : opp.quantityQuoteRequest + ' Solicitadas/ ' + opp.quantityQuoteReceipt + ' Recebidas',
                status : opp.statusCase,
                lastModified : opp.lastModifiedDate + opp.lastModifiedName,
                source : opp.originCase,
                resposible : opp.ownerName
            }]
        }
    }

    handleSelectFieldSearch(){
        let e = this.template.querySelector('[data-id="selectFieldSearch"]');
        this.selectedValueParamSearch = e.value;
        console.log(`selectedValueParamSearch: ==> ${this.selectedValueParamSearch}`);
    }

    handleClearFilters(){
        this.clearFilters();
    }

   handleValueSearch(){
        let e = this.template.querySelector('[data-id="selectValueSearch"]');
        this.selectedValueSearch = e.value;
        console.log(`selectedValueSearch: ==> ${this.selectedValueSearch}`);
        console.log(`selectedValueParamSearch: ==> ${this.selectedValueParamSearch}`);
        this.filterCases();
    }

    filterCases(){
        let filters = {
            valueParamSearch: this.selectedValueParamSearch,
            valueSearch: this.selectedValueSearch
        };
        const selectedEvent = new CustomEvent("filtercasesbyparams", {
            detail: filters
        });
        console.log(`filters: ==> ${JSON.stringify(filters)}`);
        this.dispatchEvent(selectedEvent);
    }

    clearFilters(){
        const selectedEvent = new CustomEvent("clearfilters", {});
        this.dispatchEvent(selectedEvent);
        let e = this.template.querySelector('[data-id="selectValueSearch"]');
        e.value = '';
    }

    @api async reRender(quotes) {
        this.csvData = [];
        this.quotesToExport = quotes;
        this.connectedCallback();
    }

}