import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class ConnectWizFollowUpHeader extends NavigationMixin(LightningElement){
    @api recordId; //Id of the Record in context
    @api accountName;
    @api identificationNumber;
    @api userName;
    @api origin;
    @api opportunityNumber;
    @api opportunityId;
    @api accountId;
    @api contactOrLeadId;
    @api productName;

    openReassignModal = false;
    openLostModal= false;
    closeOthersOptionsPopover = true;

    isLoading = false;
    isRendered = false;

    constructor(){
        super();
    }

    connectedCallback(){}

    @track showRegisterHistoryModal = false;
    showRegisterHistory(){
        this.changeShowRegisterHistoryModal();
    }
    changeShowRegisterHistoryModal(){
        this.showRegisterHistoryModal = !this.showRegisterHistoryModal;
    }

    @track showOthersOptionsPopover = false;
    showOthersOptions(){
        this.changeShowOthersOptionsPopover();
    }
    changeShowOthersOptionsPopover(){
        this.showOthersOptionsPopover = !this.showOthersOptionsPopover;
    }

    @track showReassignModal = false;
    showReassign(){
        this.changeShowReassignModal();
    }
    changeShowReassignModal(){
        this.showReassignModal = !this.showReassignModal;
        this.showOthersOptionsPopover = !this.showOthersOptionsPopover;
    }

    @track showMarkAsLostModal = false;
    showMarkAsLost(){
        this.changeShowMarkAsLostModal();
    }
    changeShowMarkAsLostModal(){
        this.showMarkAsLostModal = !this.showMarkAsLostModal;
        this.showOthersOptionsPopover = !this.showOthersOptionsPopover;
    }

    copyText(){
        const textarea = this.identificationNumber;
        this.template.querySelector('c-copy-to-clipboard-util')?.doCopy(textarea);
        this.showInfoToast();
    }

    closeModalRegisterHistory(event){
        this.showRegisterHistoryModal = event.detail;
        // this.handleNavigate();
        const selectedEvent = new CustomEvent("refresh");
        console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
        // this.updateRecordView();
    }

  closeOthersOptionsPopover(event){
        this.showOthersOptionsPopover = event.detail;
        // this.updateRecordView();
        const selectedEvent = new CustomEvent("refresh");
        console.log('Passou no pai')
        this.dispatchEvent(selectedEvent);
    }

    closeModalOthersOptions(event){
        if(this.showReassignModal){
            this.showReassignModal = event.detail;
            this.handleSelectCloseModal = event.detail;
        }
        if(this.showMarkAsLostModal){
            this.showMarkAsLostModal = event.detail;
            this.handleSelectCloseModal = event.detail;
        }
        const selectedEvent = new CustomEvent("refresh");
        console.log('Passou no pai');
        this.dispatchEvent(selectedEvent);
        this.onRefresh();
    }

    handleSelectCloseModal(){
        this.sendCloseModalToParent();
        this.handleSelectClosePopover();
    }

    handleSelectClosePopover(){
         this.sendClosePopoverToParent();
         this.onRefresh();

    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    closePopoverOthersOptions(event){
        if(this.closeOthersOptionsPopover){
            this.closeOthersOptionsPopover = event.detail;
            this.handleSelectClosePopover = event.detail;
        }
    }

    sendClosePopoverToParent(){
        const selectedEvent = new CustomEvent("sendclosepopovertoparent", {
            bubbles: true,
            detail: false
        });
            this.dispatchEvent(selectedEvent);
    }

    // updateRecordView(){
    //    setTimeout(() => {
    //         eval("$A.get('e.force:refreshView').fire();");
    //    }, 1000);
    //    this.renderedCallback();
    // }


    async toRegisterHistory(recordId, opportunityId, accountId, contactOrLeadId, ){
        await Promise.resolve();
        const elt =  this.template.querySelector("c-connect-wiz-register-history-modal");
        elt.getRegisterHistory(recordId, opportunityId, accountId, contactOrLeadId);
    }

    // async toOthersOptions(recordId, opportunityId, userName, contactOrLeadId){
    //     await Promise.resolve();
    //     const elt =  this.template.querySelector("c-connect-wiz-others-options-popover");
    //     elt.getOthersOptions(recordId, opportunityId, userName, contactOrLeadId);
    // }

    // @api async getOthersOptions(recordId, opportunityId, userName, contactOrLeadId){
    //     this.recordId = recordId;
    //     this.opportunityId = opportunityId;
    //     this.userName = userName;
    //     this.contactOrLeadId = contactOrLeadId;
    //     this.handleLoading(false);
    // }

    handleLoading(event){
        this.isLoading = event;
        // console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }

    async toReassignModal(recordId, opportunityId, userName, contactOrLeadId){
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-reassign-opportunity-modal");
        elt.getReassignPromiseValues(recordId, opportunityId, userName,contactOrLeadId);
    }

    async toMarkAsLostModal(recordId, opportunityId, userName,contactOrLeadId){
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-mark-as-lost-modal");
        elt.getMarkAsLostPromiseValues(recordId, opportunityId, userName,contactOrLeadId);
    }

    renderedCallback(){
        if(this.showRegisterHistoryModal){
            this.toRegisterHistory(this.recordId, this.opportunityId, this.accountId, this.contactOrLeadId);
        }
        // if(this.showOthersOptionsPopover){
        //     this.toOthersOptions(this.recordId,this.opportunityId, this.userName, this.contactOrLeadId);
        // }
        if(this.showReassignModal){
            this.toReassignModal(this.recordId, this.opportunityId, this.userName, this.contactOrLeadId);
        }
        if(this.showMarkAsLostModal){
            this.toMarkAsLostModal(this.recordId, this.opportunityId,this.contactOrLeadId);
        }
    }

    showInfoToast(){
        const evt = new ShowToastEvent({
            title: 'CNPJ copiado',
            message: this.identificationNumber,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    @api reRender(){
        this.connectedCallback();
    }

    selectedUserHandler(event){
        console.log('Entrou no evento de Reasign2' +event.detail)
        this.userName = event.detail;

    }

    // handleNavigate(){
    //     this[NavigationMixin.Navigate]({
    //         type: 'comm__namedPage',
    //         attributes: {
    //             name: 'Acompanhamento__c'
    //         },
    //         state: {
    //             c__caseId : this.recordId
    //          }
    //     });
    // }
}