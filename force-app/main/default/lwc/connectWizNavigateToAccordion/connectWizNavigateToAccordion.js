import { LightningElement , api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ConnectWizNavigateToAccordion extends NavigationMixin(LightningElement){

    @api caseId;
    @api isCotacoes;
    @api isProduto;
    @api produto;
    @api isToAssign;
    @api solicitadas;
    @api recebidas;
    @api requestInsideSLA;
    @api requestOutsideSLA;
    @api selectedInsideSLA;
    @api selectedOutsideSLA;
    @api selectedAllSLA;
    @api isSelectableCell;
    @api opportunityNumber;
    @api name;
    @api status;
    @api createdDate;
    @api modifiedAt;
    @api source;
    @api owner;
    @api isOppCell;
    @api enterpriseName;
    @api comercialName;
    @api salesUnit;
    @api isComercial;
    @api leadSource;
    @api isLeadSource;

    showQuantityQuoteRequest;
    isSelected = false;
    containsEnterpriseName =false;

    connectedCallback(){
        this.solicitadas += this.recebidas;
        if(this.enterpriseName != null){
            this.containsEnterpriseName = true;
        }else{
            this.containsEnterpriseName = false;
        }

        let tempSalesUnit = this.salesUnit != null && this.salesUnit != '' ? '(' + this.salesUnit + ')' : '';
        this.comercialName = this.comercialName != null && this.comercialName != '' ? this.comercialName : 'Não Informado';
    }
    fireGetCaseId(){
        const event = new CustomEvent('dataselect', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                caseId: this.caseId
            },
        });

        this.dispatchEvent(event);
        this.handleNavigate();
    }

    fireToAssignCase(){
        const event = new CustomEvent('toassigncase', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                caseId: this.caseId
            },
        });

        this.dispatchEvent(event);

    }

    handleNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Acompanhamento__c'
            },
            state: {
                c__caseId : this.caseId
             }
        });
    }
}