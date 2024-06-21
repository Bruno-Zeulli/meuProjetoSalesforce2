import { api, LightningElement ,track,wire} from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';


export default class ConnectWizQuotationDataPage extends NavigationMixin(LightningElement){

    @wire(CurrentPageReference)pageRef;
    @track quotationFormOriginal = [];
    formId;
    caseId;
    isQuotationData = true;
    isAcompanhamento = true;
    isShowViewData = true;
    isShowEditForm = false

    async connectedCallback(){
        var pageRefParams = this.pageRef.state;
        console.log('pageRefParams', pageRefParams);
        this.formId = pageRefParams.c__formId;
        this.caseId = pageRefParams.c__caseId;
    }

    editQuotationForm(event){
        console.log('event', event);
        this.quotationFormOriginal = event.detail;
        this.isShowViewData = false;
        this.isShowEditForm = true;
    }
}