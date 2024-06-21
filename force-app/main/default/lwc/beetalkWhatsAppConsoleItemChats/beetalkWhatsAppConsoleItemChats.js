import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCaseToMe from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getCaseToMe';
import changeActualPage from '@salesforce/apex/BeeTalkWhatsAppConsoleController.changeActualPage';



export default class BeetalkWhatsAppConsoleItemChatInQueue extends NavigationMixin(LightningElement){

    @api userid;
    @api recordpageid;
    @api caseid;
    @api casephoneorigin;
    @api caseproduct;
    @api casesubject;
    @api casenumber;
    @api caseorigin;
    @api casecontactdetailnumber;
    @api casecontactdetailname;
    @api queued;
    @api mycase;
    @api selectedcase;
    @api messagenotanswered;
    // Inside your LWC class
    selectedCard;


    async connectedCallback(){
        if(this.caseid === this.recordpageid){
            await this.markActualPage(this.caseid,true);
            this.markBoxSelected();
        }
    }

    async renderedCallback() {
        if(this.caseid === this.recordpageid){
            await this.markActualPage(this.caseid, true);
            this.markBoxSelected();
        }
    }

    changeSelectedTab() {
        this.markActualPage(this.recordpageid, false);
        this.selectedCard = { caseId: this.caseid };
        this.navigateToRecordViewPage();
        this.markActualPage(this.caseid, true);
        this.markBoxSelected();
    }


    async markActualPage(recordId, isSelectedOrNot){
        changeActualPage({recordId: recordId,
                          isSelectedCase: isSelectedOrNot})
        .then(()=>{

        })
        .catch(error => {
            console.log(error);
        })
    }


    async buttonAccept(){
        getCaseToMe({userId: this.userid,
                     recordId: this.caseid})
        .then(() => {
            this.markBoxSelected();
            this.navigateToRecordViewPage();
        })
        .catch(error => {
            console.log(error);
        });
    }


   markBoxSelected(){
        this.template.querySelector('.slds-button_neutral').classList.add('boxSelected');
    }

    async navigateToRecordViewPage(){
        console.log(this.caseid);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.caseid,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }
}