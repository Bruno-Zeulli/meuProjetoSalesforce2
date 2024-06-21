import { LightningElement, api } from 'lwc';
import completeTask from '@salesforce/apex/ConnectWizNotificationController.completeTask';
import completeAllTasks from '@salesforce/apex/ConnectWizNotificationController.completeAllTasks';
import { NavigationMixin } from 'lightning/navigation';

export default class ConnectWizNavBarNotificationsPopover extends NavigationMixin(LightningElement){

    @api lstNotification;
    @api containsNotification;
    relatedCaseId;

    connectedCallback(){
        console.log('Entrou aqui' + JSON.stringify(this.lstNotification) + this.containsNotification);
    }

    async handleNotification(event){
        console.log('Id' + event.currentTarget.dataset.id)
        let taskId = event.currentTarget.dataset.id;
        for(let objNotification of this.lstNotification){
            if(objNotification.taskId == taskId){
                this.relatedCaseId = objNotification.caseId;
                await this.completeTaskById(taskId);
                this.handleNavigate();
            }
        }
    }

    async completeTaskById(taskId){
        completeTask({taskId : taskId}).then(result => {
            console.log('backend update' + JSON.stringify(result));
            const removeTask = new CustomEvent('removetask', { detail : {taskId: taskId} });
            this.dispatchEvent(removeTask);
        })
        .catch(error =>{
            console.log('Deu errado update' + JSON.stringify(error));
        });
    }

    async completeAllTasks(){
        completeAllTasks({lstNotificationTO : this.lstNotification}).then(result => {
            console.log('backend update' + JSON.stringify(result));
            // const removeTask = new CustomEvent('removetask', { detail : {taskId: taskId} });
            // this.dispatchEvent(removeTask);
            this.containsNotification = false;
        })
        .catch(error =>{
            console.log('Deu errado update' + JSON.stringify(error));
        });
    }

    handleNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Acompanhamento__c'
            },
            state: {
                c__caseId : this.relatedCaseId
             }
        });
    }
}