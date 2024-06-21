import { LightningElement } from 'lwc';

export default class ConnecWizLegendBarCard extends LightningElement {
    filterStatus = '';


    handleNewResquest(){
        this.filterStatus = 'Novo Pedido';
        this.filterStatusCase();
    }

    handleOpportunityDataAnalysis(){
        this.filterStatus = 'Análise de dados da oportunidade';
        this.filterStatusCase();
    }

    handlePending(){
        this.filterStatus = 'Com pendência';
        this.filterStatusCase();
    }

    handleAWaitingQuotation(){
        this.filterStatus = 'Aguardando cotação';
        this.filterStatusCase();
    }

    handleAwaitingQuoteApproval(){
        this.filterStatus = 'Aguardando aprovação da cotação';
        this.filterStatusCase();
    }

    handleRepique(){
        this.filterStatus = 'Repique';
        this.filterStatusCase();
    }

    handleAwaintingPolicyIssuance(){
        this.filterStatus = 'Aguardando emissão da apólice';
        this.filterStatusCase();
    }

    // handlePolicyIssued(){
    //    this.filterStatus = 'Apólice emitida - Cadastro pendente';
    //    this.filterStatusCase();
    // }

    handleRegisteredPolicy(){
        this.filterStatus = 'Apólice registrada';
        this.filterStatusCase();
    }

    handleProcessAnnulled(){
        this.filterStatus = 'Processo anulado';
        this.filterStatusCase();
    }

    filterStatusCase(){
        let filters = {
            filterStatus : this.filterStatus
        };

        const selectedEvent = new CustomEvent("filterstatuscases", {
            detail: filters,
        });

        console.log(`selectedEvent in filterStatusCase - ${JSON.stringify(filters)} `)
        this.dispatchEvent(selectedEvent);

    }

}