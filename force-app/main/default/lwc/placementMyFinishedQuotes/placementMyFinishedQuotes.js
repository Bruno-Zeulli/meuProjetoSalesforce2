import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import USER_NAME from '@salesforce/schema/User.Name';
import getQuoteRequest from '@salesforce/apex/PlacementController.getQuoteRequests';

const COLUMNS = [
    {
        label: 'N° Oportunidade', fieldName: 'opportunityNumber', type: 'textWithButtonType', hideDefaultActions: true,
        typeAttributes: {
            recordId: { fieldName: 'caseId' },
            opportunityId: { fieldName: 'opportunityId' }
        }
    },
    { label: 'Produtos', fieldName: 'productComboName', type: 'text', hideDefaultActions: true },
    { label: 'Nome do Cliente', fieldName: 'accountName', type: 'text', hideDefaultActions: true },
    { label: 'Cotações', fieldName: 'quoteReceiptAndRequest', type: 'badgeWithIconType', hideDefaultActions: true },
    { label: 'Status', fieldName: 'statusCase', type: 'text', hideDefaultActions: true },
    { label: 'Data de Criação', fieldName: 'strCreateDate', type: 'text', hideDefaultActions: true },
    { label: 'Última Modificação', fieldName: 'lastModifiedDate', type: 'text', hideDefaultActions: true },
    { label: 'Comercial', fieldName: 'comercialName', type: 'text', hideDefaultActions: true },
    {
        label: 'Documentos', fieldName: 'teste', type: 'text', cellAttributes:
            { iconName: { fieldName: 'documentStatus' }, class: 'slds-align_absolute-center' }, hideDefaultActions: true
    },
];

const HeadersToCSV = {
    opportunityNumber: 'N° Oportunidade',
    productComboName: 'Produtos',
    accountName: 'Nome do Cliente',
    statusCase: 'Status',
    strCreateDate: 'Data de Criação',
    lastModifiedDate: 'Última Modificação',
    comercialName: 'Comercial',
    ownerName: 'Responsável'
}

export default class PlacementMyFinishedQuotes extends LightningElement {

    isPending = true;
    isQuotes = false;
    loaded = false;
    columns = COLUMNS;
    headers = HeadersToCSV;
    allQuotesRequest = [];
    valuesChart = [];
    currentUserName;


    connectedCallback() {
        this.getAllData();
    }

    @wire(getRecord, { recordId: USER_ID, fields: [USER_NAME] })
    userDetails({ error, data }) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
        } else if (error) {
            this.error = error;
        }
    }

    refresh(event) {
        this.loaded = false;
        this.getAllData();
    }

    getAllData() {
        // Verificar se currentUserName está disponível antes de tentar filtrar
        if (!this.currentUserName) {
            // Agendar a chamada para getAllData para ser executada novamente mais tarde
            setTimeout(() => this.getAllData(), 1000); // Tente novamente após  1 segundo
            return;
        }

        getQuoteRequest()
            .then(success => {
                try {
                    const AllQuotes = JSON.parse(success);
                    this.allQuotesRequest = AllQuotes.filter(quote => quote.ownerName === this.currentUserName && (quote.statusCase === 'Apólice registrada' || quote.statusCase === 'Processo anulado'));
                    this.valuesChart = AllQuotes.filter(quote => quote.ownerName === this.currentUserName && (quote.statusCase === 'Apólice registrada' || quote.statusCase === 'Processo anulado'));
                    this.loaded = true;
                    console.log(this.allQuotesRequest);

                } catch (error) {
                    console.log('error =>', error);
                }
            })
            .catch(error => console.log(error));

    }

}