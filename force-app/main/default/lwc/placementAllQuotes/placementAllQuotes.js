import { LightningElement } from 'lwc';
import getQuoteRequest from '@salesforce/apex/PlacementController.getQuoteRequests';
import getUserQueue from '@salesforce/apex/PlacementController.getUserQueueInfo';
import getUsersFromQueue from '@salesforce/apex/PlacementController.getUsersFromQueue';
import USER_ID from '@salesforce/user/Id';

const COLUMNS = [
    {
        label: 'N° Oportunidade', fieldName: 'opportunityNumber', type: 'textWithButtonType', fixedWidth: 130, hideDefaultActions: true, 
        typeAttributes: {
            recordId: { fieldName: 'caseId' },
            opportunityId: { fieldName: 'opportunityId' }
        },
    },
    { label: 'Produtos', fieldName: 'productComboName', type: 'text', hideDefaultActions: true },
    { label: 'Nome do Cliente', fieldName: 'accountName', type: 'text', hideDefaultActions: true },
    { label: 'Status', fieldName: 'statusCase', type: 'text', hideDefaultActions: true },
    { label: 'Data de Criação', fieldName: 'strCreateDate', type: 'text', wrapText: true, hideDefaultActions: true },
    { label: 'Última Modificação', fieldName: 'lastModifiedDate', type: 'text', hideDefaultActions: true },
    { label: 'Comercial', fieldName: 'comercialName', type: 'text', hideDefaultActions: true },
    {
        label: 'Cotações', fieldName: 'quoteReceiptAndRequest', type: 'badgeWithIconType', fixedWidth: 80, hideDefaultActions: true 
    },
    {
        label: 'Documentos', fieldName: 'docs', type: 'text', fixedWidth: 100, cellAttributes:
            { iconName: { fieldName: 'documentStatus' }, alignment: 'center' }, hideDefaultActions: true 
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
    ownerName: 'Responsável',
    quotes: 'Cotações'
}
export default class PlacementAllQuotes extends LightningElement {

    isPending = false;
    isQuotes = true;
    isAllQuotes = true;
    loaded = false;
    allQuotesRequest = [];
    columns = COLUMNS;
    headers = HeadersToCSV;
    queueId = [];
    namesInQueue = [];
    valuesChart = [];

    connectedCallback() {
        this.getUserQueueInfo(USER_ID);
    }

    refresh(event) {
        this.loaded = false;
        this.getAllData();
    }

    getAllData(queueNames) {
        getQuoteRequest()
            .then(success => {
                try {
                    const data = JSON.parse(success);
                    for (const key in queueNames) {
                        this.allQuotesRequest = [].concat(...queueNames.map(queueName => data.filter(quote => quote.ownerName.includes(queueName) && quote.statusCase !== 'Apólice registrada')));
                        this.valuesChart = [].concat(...queueNames.map(queueName => data.filter(quote => quote.ownerName.includes(queueName) && quote.statusCase !== 'Apólice registrada')));
                    }
                    this.dispatchEvent(new CustomEvent('loaded', { detail: this.allQuotesRequest }));
                    this.loaded = true;
                    console.log(this.allQuotesRequest);
                } catch (error) {
                    console.log('error =>', error);
                }

            })
            .catch(error => console.log(error));
    }

    getUserQueueInfo(userId) {
        getUserQueue({ userId: userId })
            .then(success => {
                try {
                    for (const key in success) {
                        this.queueId.push(success[key].IdFila);
                    }
                    this.getListUsersFromQueue(this.queueId);

                } catch (error) {
                    console.log('error =>', error);
                }
            })
            .catch(error => console.log(error))
    }

    getListUsersFromQueue(queueId) {
        getUsersFromQueue({ lstQueueId: queueId })
            .then(success => {
                try {
                    this.listUsersQueue = success;
                    const uniqueUsers = new Set();
                    for (let key in this.listUsersQueue) {
                        const users = this.listUsersQueue[key];
                        users.forEach(user => {
                            uniqueUsers.add(user.userName);
                        });
                    }
                    this.namesInQueue = Array.from(uniqueUsers);
                    this.getAllData(this.namesInQueue);
                } catch (error) {
                    console.log('error =>', error);
                }

            })
            .catch(error => console.log(error));
    }
}