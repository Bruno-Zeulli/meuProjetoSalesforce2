import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';
import getTasksList from '@salesforce/apex/B2U_SupervisorController.getTasksList';
import hasAccess from '@salesforce/apex/B2U_SupervisorController.hasAccess';
import isSupposedToHaveAccess from '@salesforce/apex/B2U_SupervisorController.isSupposedToHaveAccess';

export default class Supervisor extends LightningElement { 
    
    channelName = '/event/IncorrectDisposition__e';
    @wire(getTasksList) tasks;
    subscription;
    error;

    columns = [
        { label: 'Atividade', fieldName: 'url', type: 'url', typeAttributes: { label: {fieldName: 'subject'}, target: '_self' } },
        { label: 'Tabulação', fieldName: 'disposition' },
        { label: 'Consultor', fieldName: 'owner' },
        { label: 'Relativo a', fieldName: 'whatURL', type: 'url', typeAttributes: { label: {fieldName: 'whatName'}, target: '_self' } },
        { label: 'Cliente', fieldName: 'whoURL', type: 'url', typeAttributes: { label: {fieldName: 'whoName'}, target: '_self' } },
        { label: 'Campanha', fieldName: 'campaign' },
        { label: 'Razão', fieldName: 'reason' }
    ];

    connectedCallback(){
        if(!this.subscription){
            isSupposedToHaveAccess()
                .then(result => {
                    if(result){
                        this.subscribeToIncorrectDispositionEvents();                    
                    }
                })
                .catch(error => {
                    console.log(error);
                    this.error = error;
                });
        }
    }

    disconnectedCallback(){
        if(this.subscription){
            unsubscribe(this.subscription, response => {
                console.log('unsubscribe() response: ', JSON.stringify(response));
            });
        }
    }

    subscribeToIncorrectDispositionEvents(){
        let that = this;
        let messageCallback = function(response){
            console.log('New message received : ' + JSON.stringify(response));
            this.lastModifiedTaskId = response.data.payload.Task__c;
            hasAccess({ taskId : this.lastModifiedTaskId })
               .then(result => {
                    if(result){
                        refreshApex(that.tasks);
                    }
               })
               .catch(error => {
                   this.error = error;
               });
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('2 - Successfully subscribed: ' + JSON.stringify(response));
            this.subscription = response;
        }).catch(error => {
            console.log('2 - Couldn\'t subscribe to channel');
            console.log(error);
            this.error = error;
        });
    }
}