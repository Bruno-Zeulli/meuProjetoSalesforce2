import { LightningElement,api,wire } from 'lwc';
import getOpportunityByCaseId from '@salesforce/apex/ConnectWizMonitoringController.getOpportunityByCaseId';

export default class ConnectWizOpportunityAccordionItem extends LightningElement {
    @api recordId; //get the recordId
    @api caseId;
    opportunityId;
    showOpp =true;
    isOpen=false;

    isProposta = true;
    isCotacao = false;
    isFirstSolic = true;
    openForm = false;

    isLoading = false;
    isRendered = false;

    data;
    type;
    product2Name;
    stageName;
    probabilityOfWinning;
    opportunity;
    expectedCommission;
    closeDate;
    insuredAmount;
    isOpportunityNomination;
    isInsuranceRestriction;
    restrictionDescription
    description;
    hasRestriction;
    containsEnterpriseName = false;
    enterpriseName;
    comercialName;

    async retrieveOpportunity(){
        await getOpportunityByCaseId({caseId : this.caseId}).then(result => {
            console.log('backend getOpp' + JSON.stringify(result));

            let key = result.Type;
            switch (key){
                case 'New':
                    this.type = 'Venda nova'
                    break;
                case 'ReNew':
                    this.type = 'Renovação'
                    break;
                case 'Endorsement':
                    this.type = 'Endosso'
                    break;
                case 'CrossSell':
                    this.type = 'Cross Sell'
                    break;
                case 'Recovery':
                    this.type = 'Recuperação'
                    break;

                default:
                    his.type = result.Type == null ? "Não Informado" : result.Type;
                    break;
            }

            let comercialUnit = result.Owner.SalesUnit__c != null && result.Owner.SalesUnit__c != '' ? '('+ result.Owner.SalesUnit__c + ')' : '';
            this.comercialName = result.OpportunityOwner__c != null && result.OpportunityOwner__c != '' ? result.OpportunityOwner__c + ' ' + comercialUnit : 'Não Informado';

            this.product2Name = result.OpportunityLineItems[0].Product2.Name == null ? "Não Informado" : result.OpportunityLineItems[0].Product2.Name;
            this.stageName = result.StageName == null ? "Não Informado" : result.StageName;
            this.probabilityOfWinning = result.ProbabilityOfWinning__c == null ? "Não Informado" : result.ProbabilityOfWinning__c;
            if(result.EnterpriseName__c != null){
                this.containsEnterpriseName = true;
                this.enterpriseName = result.EnterpriseName__c;
            }
            this.opportunity = result.OpportunityLineItems[0].TotalPrice == null ? "Não Informado" : new Intl.NumberFormat('pt-BR' ,{
                style : 'currency',
                currency :'BRL'
            }).format(result.OpportunityLineItems[0].TotalPrice);

            this.expectedCommission = result.OpportunityLineItems[0].ExpectedCommission__c == null ? "Não Informado" : new Intl.NumberFormat('pt-BR' ,{
                style : 'currency',
                currency :'BRL'
            }).format(result.OpportunityLineItems[0].ExpectedCommission__c);

            this.closeDate = result.CloseDate == null ? "Não Informado" : this.closeDate = result.CloseDate;
            this.insuredAmount = result.InsuredAmount__c == null ? "Não Informado" : new Intl.NumberFormat('pt-BR' ,{
                style : 'currency',
                currency :'BRL'
            }).format(result.InsuredAmount__c);

            this.hasRestriction = result.IsInsuranceRestriction__c == false ? false : true;
            console.log('isInsuranceRestriction ', this.hasRestriction)
            this.isOpportunityNomination = result.IsOpportunityNomination__c == null ? "Não Informado" : result.IsOpportunityNomination__c == false ? "Não" : "Sim";
            this.isInsuranceRestriction = result.IsInsuranceRestriction__c == null ? "Não Informado" : result.IsInsuranceRestriction__c == false ?"Não" : "Sim";
            this.restrictionDescription = result.DescriptionOfRestriction__c == null ? "Não Informado" : result.DescriptionOfRestriction__c;
            this.description = result.Description == null ? "Não Informado" : result.Description;
        })
        .catch(error =>{
            console.log('Deu errado getOpp' + JSON.stringify(error));
        });
    }


    connectedCallback(){
        this.retrieveOpportunity();
    }

    handleAccordionClick(event){
        // console.log('clicou no accordion' + JSON.stringify(event.detail));
        this.isOpen = !this.isOpen;
    }

    handleLoading(event){
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    handleRendered(event){
        this.isRendered = event;
    }
}