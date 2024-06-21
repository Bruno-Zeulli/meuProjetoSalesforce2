/**
 * @description       :
 * @author            : Italo Ramillys
 * @group             :
 * @last modified on  : 02-24-2024
 * @last modified by  : Italo Ramillys
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   02-24-2024   Italo Ramillys   Initial Version
 **/

import { LightningElement, track, wire, api } from 'lwc';
import getContacts from '@salesforce/apex/ContactDAO.getBusinessPartnerContactByAccountOpportunityId';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Opportunity.RecordTypeId'];

export default class DatatableSocios extends LightningElement {

    @api recordId;

    error;
    records;
    countOpportunities;

    rtOperacoesEstruturadas;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS, modes: ['View', 'Edit', 'Create'] })
    wiredRecord({ error, data }) {
        if (data) {
            this.data = data;
            this.rtOperacoesEstruturadas = data.recordTypeInfo.name == 'Consórcio';
            console.log('RT OPP: ', data.recordTypeInfo.name);
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }

    @wire(getContacts, { oppId: '$recordId' })
    retrievedContacts({ error, data }) {
        console.log('@getContacts');
        console.log('Id: ', this.recordId);
        if (data) {
            console.log(data);
            this.records = data;
            this.error = undefined;
        } else if (error) {
            console.log('Erro');
            this.error = error;
            this.records = undefined;
            console.log(JSON.stringify(this.error));
        }
    }

    @track sociosColumns = [
        { label: 'Nome', fieldName: 'Name', sortable: true },
        {
            label: 'Data de criação', fieldName: 'CreatedDate', type: "date",
            typeAttributes: {
                day: "2-digit",
                month: "2-digit",
                year: "numeric",
                hour: "2-digit",
                minute: "2-digit",
                second: "2-digit",
                timeZone: 'UTC'
            }, sortable: true
        }
    ];

    sortedBy = 'Name';
    sortedDirection = 'asc';

    sociosData = [];

    @track isLoading = false;

    doSorting(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.botQueueData));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // Cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // Sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.botQueueData = parseData;
    }

    onChangeNameUser(event) {
        try {
            let nameInput = event.target.value;
            console.log(nameInput);
            if (nameInput == '' || nameInput.length < 3) {
                this.availableUsers = this.availableUsersBackup;
                this.template.querySelector("div[data-id='info-message']").style = 'opacity:1';
            } else {
                let arr = [];
                this.availableUsersBackup.forEach((e) => {
                    if (this.selectedUsers.includes(e.value)) {
                        arr.push(e);
                    }
                    else if (e.label.toLowerCase().includes(nameInput.toLowerCase())) {
                        arr.push(e);
                    }
                });
                this.availableUsers = arr;
                this.template.querySelector("div[data-id='info-message']").style = 'opacity:0';
            }
        } catch (e) {
            console.log('Error: ');
            console.log(e);
        }
    }

    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}