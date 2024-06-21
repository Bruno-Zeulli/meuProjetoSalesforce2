import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import hasAccess from '@salesforce/apex/B2U_SupervisorController.hasAccess';
import isSupposedToHaveAccess from '@salesforce/apex/B2U_SupervisorController.isSupposedToHaveAccess';
import getRanking from '@salesforce/apex/B2U_SupervisorController.getRanking';

export default class SupervisorUtilityItem extends NavigationMixin(LightningElement){

    channelName = '/event/IncorrectDisposition__e';
    subscription;
    lastModifiedTaskId = '';
    lastTaskReason = '';
    error;
    @wire(getRanking) ranking;

    rankingColumns = [
        { label: 'Tab. incorretas', fieldName: 'quantity', type: 'number' },
        { label: 'Consultor', fieldName: 'ownerName' }
    ];

    handleButtonClick(){
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Supervisor'
            }
        });
    }

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
            console.log('New message received : ', JSON.stringify(response));
            that.lastModifiedTaskId = response.data.payload.Task__c;
            that.lastTaskReason = response.data.payload.Reason__c;
            hasAccess({ taskId : that.lastModifiedTaskId })
               .then(result => {
                    if(result){
                        const evt = new ShowToastEvent({
                            title: 'Tabulação incorreta',
                            message: '{0}',
                            messageData: [
                                {
                                    url: '/' + that.lastModifiedTaskId,
                                    label: that.lastTaskReason
                                }
                            ],
                            variant: 'error'
                        });
                        that.dispatchEvent(evt);
                        refreshApex(that.ranking);
                    } else{
                        console.log('result false');
                    }
               })
               .catch(error => {
                   this.error = error;
               });
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('1 - Successfully subscribed: ', JSON.stringify(response));
            this.subscription = response;
        }).catch(error => {
            console.log('2 - Couldn\'t subscribe to channel');
            console.log(error);
            this.error = error;
        });
    }
}