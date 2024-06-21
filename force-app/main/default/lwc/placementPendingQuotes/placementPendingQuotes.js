import { LightningElement, track, wire } from 'lwc';
import getQuoteRequest from '@salesforce/apex/PlacementController.getQuoteRequests';
import getUserQueue from '@salesforce/apex/PlacementController.getUserQueueInfo';
import getUsersFromQueue from '@salesforce/apex/PlacementController.getUsersFromQueue';
import USER_ID from '@salesforce/user/Id';

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
    { label: 'Status', fieldName: 'statusCase', type: 'text', hideDefaultActions: true },
    { label: 'Data de Criação', fieldName: 'strCreateDate', type: 'text', hideDefaultActions: true },
    { label: 'Última Modificação', fieldName: 'lastModifiedName', type: 'text', hideDefaultActions: true },
    { label: 'Comercial', fieldName: 'comercialName', type: 'text', hideDefaultActions: true },
    {
        label: 'Responsável',
        type: 'button-icon',
        typeAttributes: {
            title: "Atribuir",
            iconName: "utility:adduser",
            iconClass: "slds-icon_small",
            variant: "container",
            name: "atribuir",
            class: "assign-button"
        }
    }
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
export default class PlacementPendingQuotes extends LightningElement {

    isPending = true;
    isQuotes = false;
    loaded = false;
    allQuotesRequest = [];
    columns = COLUMNS;
    headers = HeadersToCSV;
    userData;
    currentUserName;
    queueId = [];
    queueName = [];
    listUsersQueue;

    connectedCallback() {
        this.getUserQueueInfo(USER_ID);

    }

    refresh(event) {
        this.loaded = false;
        this.allQuotesRequest = [];
        this.getAllData(this.queueName);
    }

    getAllData(queueNames) {

        if (!this.queueName) {
            // Agendar a chamada para getAllData para ser executada novamente mais tarde
            setTimeout(() => this.getAllData(), 1000); // Tente novamente após  1 segundo
            return;
        }

        getQuoteRequest()
            .then(success => {
                try {
                    const data = JSON.parse(success);
                    for (const key in queueNames) {
                        this.allQuotesRequest = [].concat(...queueNames.map(queueName => data.filter(quote => quote.ownerName.includes(queueName))));
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
                        // Criar um novo array com os valores após "Célula"
                        const nameParts = success[key].NomeFila.split("Célula");
                        if (nameParts.length > 1) {
                            // Pegar a parte após "Célula" e adicionar ao array this.queueName
                            this.queueName.push(nameParts[nameParts.length - 1].trim());
                        }
                    }
                    this.getListUsersFromQueue(this.queueId);
                    this.getAllData(this.queueName);
                    


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

                } catch (error) {
                    console.log('error =>', error);
                }

            })
            .catch(error => console.log(error));
    }


}