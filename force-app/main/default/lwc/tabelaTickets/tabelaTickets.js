import { LightningElement, track, api } from 'lwc';
import getTickets from '@salesforce/apex/TicketsController.getTickets';
import { NavigationMixin } from 'lightning/navigation';

export default class TabelaTickets extends NavigationMixin(LightningElement){
    @track tickets;
    @track allTickets;
    visibleTickects;

    connectedCallback(){
        this.getTicketsLWC();        
    }

    getTicketsLWC(){
        getTickets()
        .then(async success => {
            this.loader = true;  
            try{
                  let ticketsOriginal = JSON.parse(success);
                    console.log('ticketsOriginal=>',ticketsOriginal);

                    if(ticketsOriginal.length > 0){
                        // let companyInformations = await this.getCompanyOfPartnerTicket(ticketsOriginal);

                        //      ticketsOriginal = await this.relatedTicketOfCompany(ticketsOriginal, companyInformations); 
                        this.tickets = this.filtrarTicketsByStatus(ticketsOriginal);
                    }else{
                        this.tickets = new Array();
                    }
                    this.allTickets = ticketsOriginal;
                    this.loader = false;
            }catch(error){
                 this.loader = false;
                console.log('error =>',error);
            }
        })
        .catch(error => console.log(error));
    }

    relatedTicketOfCompany(tickets, companyInformations){
        return new Promise ((resolve, reject) => {
             try{
                let companiesMap = new Map();
                let ticketsOfCompany = [];
                if(companyInformations.length > 0){
                    companyInformations = JSON.parse(companyInformations);

                        for(let company of companyInformations){
                            companiesMap.set(company.email, company);
                        }
                        console.log('companiesMap =>', companiesMap);                     

                        for(let ticket of tickets){

                            if(ticket.contactDetail != undefined){
                                    let company = companiesMap.get(ticket.contactDetail.email);
                            if(company != null && company != undefined){
                                ticket.hasCompany = true;
                                ticket.company = {};
                                ticket.company.name = company.empresa;
                                ticket.company.cnpj = company.cnpj;
                            }
                            ticketsOfCompany.push(ticket);
                            }                            
                        }

                    resolve(ticketsOfCompany);

                    }else{
                         resolve(tickets);
                    }      

            } catch(error){
                reject(error)
            }
            
        })
    }

    async getCompanyOfPartnerTicket(tickets){
        let ticketsOnlyContactDetail = tickets.filter(ticket => ticket.contactDetail != undefined && ticket.contactDetail != null);
        let emails = ticketsOnlyContactDetail.map((ticket) => ticket.contactDetail.email);
        const uniqueEmails = [...new Set(emails)].filter(email => email != '');
        console.log('uniqueEmails =>',uniqueEmails)

        let companyInformations = [];
        if(uniqueEmails.length > 0){
            companyInformations  = await this.getCompanyOfPartnerTicket(uniqueEmails);
        }
        //return companyInformations;
        return companyInformations;
    }
  
    @api limparFiltro(){ 
        this.tickets = this.filtrarTicketsByStatus(this.allTickets);
    }

    @api filtrarTickets(filtro){
        let tickets = JSON.parse(JSON.stringify(this.allTickets));
        //return ticket.RecordTypeId == filtro.tipoRegistro
        if(filtro.tipoRegistro != ''){
            tickets = tickets.filter( ticket => {
                return ticket.recordtype.name == filtro.tipoRegistro;
            });
        }
        if(filtro.status != ''){
            console.log('filtro.status: '+filtro.status);
            console.log('BBB12 filtro.status: '+filtro.status);
            //let ticketsFilterStatus = tickets.filter(ticket => !statusCase.includes(ticket.status))
            //tickets = tickets.filter( ticket => ticket.status.includes(filtro.status));
            tickets = tickets.filter( ticket => filtro.status.includes(ticket.status));
        } else{
            tickets = this.filtrarTicketsByStatus(tickets);
        }

        if(filtro.motivo != ''){
            tickets = tickets.filter( ticket => ticket.motivo == filtro.motivo);
        }

        if(filtro.prioridade != ''){
            tickets = tickets.filter( ticket => ticket.prioridade == filtro.prioridade);
        }

        if(filtro.tipo != ''){
            tickets = tickets.filter( ticket => ticket.tipo == filtro.tipo);
        }

        if(filtro.subtipo != ''){
            tickets = tickets.filter( ticket => ticket.subtipo == filtro.subtipo);
        }

        if(filtro.procedente != ''){
            tickets = tickets.filter( ticket => ticket.procedente == filtro.procedente);
        }

        if(filtro.proprietario != ''){
            console.log('filtro.proprietario ==> ', filtro.proprietario);
            tickets = tickets.filter( ticket => {
                return ticket.owner.name == filtro.proprietario;
            });
        }

        if(filtro.createdDateInitial != '' && filtro.createdDateEnd != ''){
            tickets = tickets.filter( ticket => {
                return ticket.createdDateToFilter >= filtro.createdDateInitial && ticket.createdDateToFilter <= filtro.createdDateEnd
            });
        } else if(filtro.createdDateInitial != '' && filtro.createdDateEnd == ''){
             tickets = tickets.filter( ticket => {
                return ticket.createdDateToFilter == filtro.createdDateInitial
            });
        }else if(filtro.createdDateInitial == '' && filtro.createdDateEnd != ''){
             tickets = tickets.filter( ticket => {
                return ticket.createdDateToFilter == filtro.createdDateEnd
            });
        }

        this.tickets = tickets;
        console.log('this.tickets ==> ', this.tickets);
    }

    formatarCamposTickets(){
        let tickets = JSON.parse(JSON.stringify(this.allTickets));
        this.tickets = this.filtrarTicketsByStatus(tickets);
    }

    filtrarTicketsByStatus(tickets){
        let statusCase = ['Fechado', 'Closed', 'Cancelado pelo solicitante', 'Resolvido'];
        let ticketsFilterStatus = tickets.filter(ticket => !statusCase.includes(ticket.status))
         return ticketsFilterStatus;
    }

    abrirGuia(event){
        let id = event.target.name;
        console.log('name =='+event.target.name)
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view',
            },
        });

    }

    updateTicketsHandler(event){
        this.visibleTickects=[...event.detail.records];
        console.log('visibleTickects ==> ', event.detail.records)
    }


    /**
     * COLOCAR TODOS OS FILTROS
     * FORMATAR AS DATAS 
     * COLOCAR ACCORDION NO LAYOUT
     * FAZER LOGICA DE NAVEGACAO PARA O CLIENTE E PARA O CASO
     * FAZER LOGICA DO FILTRO
     */
}