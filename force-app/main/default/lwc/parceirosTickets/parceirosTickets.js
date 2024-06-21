import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParceirosTickets extends LightningElement {
    @api cases;
    value = 'inProgress';
    @track SelectRecordTypes = [];
    isShowFilters = false;
    @track openAtribuicaoModal = false;


    @track filtro = {
        prioridade: '',
        status: '',
        recordtype: ''
    }
    /**
     * TODO FILTRAR AGENTES - VALIDAR SE O AGENTE É O DONO OU O ENCAMINHADO
     * CRIAR SELECT DINÂMICO PARA CRIAR OS FILTROS
     */
    get options(){
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }


    get status(){
        return [
            { label: 'Dúvidas', value: 'Dúvidas' },
            { label: 'Reclamações', value: 'Reclamações' },
            { label: 'Solicitações', value: 'Solicitações' },
            { label: 'Reclamação acesso CHAT', value: 'Reclamação acesso CHAT' },
            { label: 'Elogios', value: 'Elogios' },
            { label: 'Erros', value: 'Erros' },
            { label: 'Outros', value: 'Outros' },
            { label: 'Dúvidas acesso PPW', value: 'Dúvidas acesso PPW' },
            { label: 'Dúvidas acesso CHAT', value: 'Dúvidas acesso CHAT' },
        ];
    }

    get prioridades(){
        return [
            { label: 'Baixa', value: 'Baixa' },
            { label: 'Médio', value: 'Médio' },
            { label: 'Alta ', value: 'Alta ' },
            { label: 'Urgente', value: 'Urgente' }]
    }


    handleChange(event){
        this.value = event.detail.value;
    }

    filtrarTicket(event){
        console.log('event to FILTRANDO ==>'+ event)
        this.template.querySelector("c-tabela-tickets").filtrarTickets(event.detail);
    }

    limparFiltro(){
        this.template.querySelector("c-tabela-tickets").limparFiltro();
    }

    handleShowFilters(){
        this.changerIsShowFilters();
        console.log('changerIsShowFilters ==>',  this.isShowFilters);
    }

    handleShowAtribuicaoMassa(){
        this.openAtribuicaoModal = true;
    }

    changerIsShowFilters(){
        this.isShowFilters = !this.isShowFilters;
    }
    
}