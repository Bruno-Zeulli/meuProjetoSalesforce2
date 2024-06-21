import { LightningElement, api, track } from 'lwc';

export default class ConnectWizOthersOptionsPopover extends LightningElement {

    @api recordId;
    @api opportunityId;
    @api userName;
    @api contactOrLeadId;

    openReassignModal = false;
    openLostModal= false;
    closeOthersOptionsPopover = true;

    isLoading = false;
    isRendered = false;

    constructor(){
        super();
    }

    onRefresh(){
        const selectedEvent = new CustomEvent("refresh", {
            bubbles: true
        });
        this.dispatchEvent(selectedEvent);
    }

    @track showReassignModal = false;
    showReassign(){
        this.changeShowReassignModal();
        this.sendClosePopoverToParent();
    }
    changeShowReassignModal(){
        this.showReassignModal = !this.showReassignModal;
        this.closeOthersOptionsPopover = !this.closeOthersOptionsPopover;
    }

    @track showMarkAsLostModal = false;
    showMarkAsLost(){
        this.changeShowMarkAsLostModal();
        this.sendClosePopoverToParent();
    }

    changeShowMarkAsLostModal(){
        this.showMarkAsLostModal = !this.showMarkAsLostModal;
        this.closeOthersOptionsPopover = !this.closeOthersOptionsPopover;
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

    @api async getOthersOptions(recordId, opportunityId, userName, contactOrLeadId){
        this.recordId = recordId;
        this.opportunityId = opportunityId;
        this.userName = userName;
        this.contactOrLeadId = contactOrLeadId;
        this.handleLoading(false);
    }

    handleLoading(event){
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }

    async toReassignModal(recordId, opportunityId, userName, contactOrLeadId){
        await Promise.resolve();
        const elt =  this.template.querySelector("c-connect-wiz-reassign-opportunity-modal");
        elt.getReassignPromiseValues(recordId, opportunityId, userName,contactOrLeadId);
    }

    async toMarkAsLostModal(recordId, opportunityId, userName,contactOrLeadId){
        await Promise.resolve();
        const elt =  this.template.querySelector("c-connect-wiz-mark-as-lost-modal");
        elt.getMarkAsLostPromiseValues(recordId, opportunityId, userName,contactOrLeadId);
    }

    renderedCallback(){
        if(this.showReassignModal){
            this.toReassignModal(this.recordId, this.opportunityId, this.userName, this.contactOrLeadId);
        }
        if(this.showMarkAsLostModal){
            this.toMarkAsLostModal(this.recordId, this.opportunityId,this.contactOrLeadId);
        }
    }

    connectedCallback(){

    }
}