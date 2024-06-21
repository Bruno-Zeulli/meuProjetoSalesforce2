import { LightningElement, api, wire, track } from 'lwc';
// import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getSobjectHistory from '@salesforce/apex/ConnectWizController.getTaskHistory';
import getCaseStatus from '@salesforce/apex/ConnectWizController.getCaseStatus';

// import CASE_STATUS from '@salesforce/schema/Case.Status'

export default class ConnectWizHistoryHeader extends LightningElement {

    @api recordId; //Id of the Record in context
    @api opportunityId;
    @track paramWrapper;
    @track reRefresh = false;
    tasks = [];
    @track cases = [];
    @track status;

    classNameStatus = 'status-style';
    statusContextClass;
    isLoading= false;
    status;
    isOpen=false;

    async connectedCallback(){
        console.log('Task befor ' + JSON.stringify(this.tasks));
        console.log('opportunityId' + this.opportunityId);
        this.paramWrapper = {
            recordId: this.opportunityId
        };
        this.handleLoading(true);
        if(this.opportunityId != undefined && this.opportunityId != null){
            await this.getSobjectHistory();
        }
        await this.getCaseStatus();

    }

    renderedCallback(){
        // this.handleChangeColorByStatus();
    }

    async getSobjectHistory(){
        getSobjectHistory({
            recordId : this.opportunityId
        })
        .then(result => {
            try{
                // console.log('result => ', result)
                this.tasks = JSON.parse(JSON.stringify([...result]));
                console.log('Task after ' + JSON.stringify(this.tasks));
                this.handleLoading(false);
            }catch(error){
                console.log('error =>',error);
                this.handleLoading(false);
            }
        })
        .catch(error => console.log(error));
        // this.handleLoading(false);
    }

    async getCaseStatus(){
        getCaseStatus({
            recordId : this.recordId
        })
        .then(result => {
            try{
                // console.log('result => ', result[0].Status)
                this.cases = JSON.parse(JSON.stringify([...result]));
                this.status = result[0].Status
                this.handleChangeColorByStatus(this.status);
                this.handleLoading(false);
            }catch(error){
                console.log('error =>',error);
                this.handleLoading(false);
            }
        })
        .catch(error => console.log(error));
        // this.handleLoading(false);
    }

    //fetching objet history records
    // @wire(getSobjectHistory, { recordId: '$opportunityId'})
    // tasks;

    // @wire(getRecord, { recordId: '$recordId',  fields: CASE_STATUS })
    // cases;

    // get status(){
    //     let vStatus = this.cases[0].status;
    //     this.handleChangeColorByStatus(vStatus);

    //     return vStatus;
    // }


    handleChangeColorByStatus(status){
        console.log(status);

        this.statusContextClass = this.classNameStatus;
        if(status == 'Análise de dados da oportunidade' ||
            status == 'Aguardando cotação' ||
            status == 'Aguardando aprovação da cotação' ||
            status == 'Cotação enviada' ||
            status == 'Repique' ||
            status == 'Aguardando emissão da apólice'){
            this.statusContextClass += ' status-style_yellow';
            // console.log(this.statusContextClass);
        } else
        if(status == 'Com pendência'|| status == 'Processo anulado'){
            this.statusContextClass += ' status-style_red';
            // console.log(this.statusContextClass);
        } else
        if(status == 'Apólice registrada' || status =='Novo pedido'){
            this.statusContextClass += ' status-style_green';
            // console.log(this.statusContextClass);
        }


    }

    handleLoading(event){
        this.isLoading = event;
    }

    @api reRender(oppId){
        this.opportunityId = oppId;
        this.connectedCallback();
    }

}