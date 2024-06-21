import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCaseMilestonesMethod from '@salesforce/apex/SlaCounterController.getCaseMilestone';
import getCompletedCaseMilestonesMethod from '@salesforce/apex/SlaCounterController.getCompletedCaseMilestone';

export default class SlaCounterLwc extends LightningElement {

    @api recordId;
    @track showSpinner = false;
    @track nomeEtapa;
    @track returnToShow;
    @track showButton = true;
    @track showEtapa = true;
    @track showCompletedMilestones = false;
    @track completedMS = [];

    activeSections = [];

    connectedCallback(){
        this.getCaseMilestones();
        this.getCompletedCaseMilestones();
    }

    getCaseMilestones(){
        //this.showSpinner = true;
        console.log('@BPS this.recordId: '+this.recordId);
        getCaseMilestonesMethod({ caseId: this.recordId })
        .then(result => {
            if(result != ''){
                console.log('@BPS getCaseMilestonesMethod result: '+JSON.stringify(result));
                this.nomeEtapa = result[0].MilestoneType.Name;
                var milestoneHours = result[0].TimeRemainingInMins;
                var totalMins;
                console.log('@BPS milestoneHours: '+milestoneHours);
                var status;
                if(milestoneHours.substring(0, milestoneHours.length-3) <= 0){
                    var dateSalesforce = new Date(result[0].TargetDate);
                    console.log('@BPS dateSalesforce: '+dateSalesforce);
                    var dateNow = new Date();
                    console.log('@BPS dateNow: '+dateNow);
                    totalMins = dateNow - dateSalesforce;
                    totalMins = Math.floor(totalMins / 60000);
                    status = ' atrasado';
                }else{
                    totalMins = milestoneHours.substring(0, milestoneHours.length-3);
                    status = '';
                }
                
                var mins= totalMins % 60;
                var hours = Math.floor(totalMins / 60);
                var days= Math.floor(hours / 24);
                var hourss = hours % 24;

                this.returnToShow = '';
                if(days > 0){
                    this.returnToShow = this.returnToShow.concat(days+ ' dias ');
                }
                if(hourss > 0){
                    this.returnToShow = this.returnToShow.concat(hourss + ' horas ');
                }
                if(mins > 0){
                    this.returnToShow = this.returnToShow.concat(mins + ' min');
                }
                if(days == null && hourss == null && mins == null){
                    this.returnToShow = 'Nenhum marco a ser exibido';
                    this.showButton = false;
                    this.showEtapa = false;
                }

                if(status != ''){
                    this.returnToShow = this.returnToShow.concat(status);
                    this.showButton = true;
                }

                console.log('@BPPS this.returnToShow: '+this.returnToShow);

                this.showSpinner = false;
            }else{
                this.showButton = false;
                this.returnToShow = 'Nenhum marco a ser exibido';
                this.showSpinner = false;
                this.showEtapa = false;
            }
            
        })
        .catch(error => {
            console.log('@BPS gerror: '+JSON.stringify(error));
        });
    }

    getCompletedCaseMilestones(){
        console.log('@BPS this.recordId: '+this.recordId);
        getCompletedCaseMilestonesMethod({ caseId: this.recordId })
        .then(result => {
            if(result != ''){
                this.completedMS = result;
                this.showCompletedMilestones = true;
                console.log('@BPPS 26-10: '+this.completedMS);
            }else{
                this.showCompletedMilestones = false;
            }
            
        })
        .catch(error => {
            console.log('@BPS gerror: '+JSON.stringify(error));
        });
    }

    updateMilestone(){
        this.getCaseMilestones();
        this.getCompletedCaseMilestones();
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
    }

}