import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTickets from '@salesforce/apex/TicketsController.getTicketsAtribuicao';
import atribuirTickets from '@salesforce/apex/TicketsController.atribuirTickets';

export default class AtribuicaoMassaTktLwc extends LightningElement {
    @track isModalOpen = true;
    @track selectedOldUser;
    @track selectedNewUser;
    @track ticketsData = [];
    @track showSpinner = false;
    @track showDataTable = false;
    @track lstDataChecked = [];
    @track lstIds = [];
    @track disabledAtribuir = true;
    @track newUserDisabled = true;
    @track newUserValue;
    @track checkBoxChecked;
    @track checkBoxDisabled = true;
    @track dataTableSize = 3;
    @track visibleTickects;
    @track dataTicketsJSON;


    handleOldUserSelection(event){
        this.selectedOldUser = event.target.value;
        this.getTickets();
        if(this.selectedOldUser == null || this.selectedOldUser == ''){
            this.lstDataChecked = [];
            this.lstIds = [];
            this.newUserDisabled = true;
            this.disabledAtribuir = true;
            this.template.querySelector(`[data-id="newUser"]`).reset();
        }else{
            this.checkBoxDisabled = true;
            this.newUserDisabled = false;
        }        
    }

    handleNewUserSelection(event){
        this.selectedNewUser = event.target.value;
        if(this.selectedNewUser == this.selectedOldUser){
            this.showToast('', 'Selecione um proprietário diferente do atual para atribuir!', 'error');
            this.template.querySelector(`[data-id="newUser"]`).reset();
        }else if(this.selectedNewUser == null || this.selectedNewUser == ''){
            this.disabledAtribuir = true;
            this.checkBoxDisabled = true;
        }else{
            this.checkBoxDisabled = false;
            this.disabledAtribuir = false;
        }
    }

    getTickets(){
        this.showSpinner = true;
        getTickets({ userId: this.selectedOldUser })
        .then(result => {
            if(result != ''){
                this.showDataTable = true;
            }else{
                this.showDataTable = false;
            }
            this.ticketsData = result;
            this.dataTicketsJSON = JSON.parse(JSON.stringify(this.ticketsData));
            this.populateTicketList();
            this.showSpinner = false;
        })
        .catch(error => {
            this.showToast('', 'Erro ao carregar tickets!', 'error');
            console.log(error);
            this.showSpinner = false;
            this.showDataTable = false;
        });
    }

    populateTicketList(){
        this.checkBoxChecked = false;
        for(let i=0; i < this.ticketsData.length; i++){
            console.log('BBB96 index: '+index);
            var index = this.lstDataChecked.findIndex(item => { return item.id == this.ticketsData[i].Id});
            if(index == -1 || index == null){
                this.lstDataChecked.push({id: this.ticketsData[i].Id, value: false});
            }else{
                this.lstDataChecked[index].id = this.ticketsData[i].Id;
                this.lstDataChecked[index].value = false;
            }
            
        }
        console.log('BBB96: this.lstDataChecked: '+JSON.stringify(this.lstDataChecked));
    }

    atribuirHandle(){
        this.showSpinner = true;
        for(let i = 0; i < this.lstDataChecked.length; i++){
            if(this.lstDataChecked[i].value){
                this.lstIds.push(this.lstDataChecked[i].id);
            }
        }
        if(this.lstIds == ''){
            this.showSpinner = false;
            this.showToast('', 'Selecione tickets que deseja atribuir!', 'error');
        }else{
            console.log('BBB98 lstIds: '+this.lstIds);
            atribuirTickets({ lstIds: this.lstIds, newUserId: this.selectedNewUser })
            .then(result => {
                if(result){
                    this.showSpinner = false;
                    this.getTickets();
                    this.showToast('', 'Tickets atribuidos com sucesso!', 'success');
                }
                
            })
            .catch(error => {
                this.showSpinner = false;
                this.showToast('', 'Erro ao atribuir tickets!', 'error');
                console.log(error);
            });
        }

    }

    checkTicket(event){
        var idSelected = event.target.name;
        var index = this.lstDataChecked.findIndex(item => { return item.id == idSelected});
        console.log('BBB98 index: '+index);
        this.lstDataChecked[index].id = idSelected;
        this.lstDataChecked[index].value = event.target.checked;

        console.log('BBB98 finalArray: '+JSON.stringify(this.lstDataChecked));
        
    }

    closeModal(){
        this.isModalOpen = false;
        this.showToast('', 'Aguarde, vamos atualizar a página!', 'success');
        location.reload();
    }

    openModalEvent(){
        this.dispatchEvent(new CustomEvent('openmodal',{ 
            detail:{ 
                records:this.visibleRecords
            }
        }))
    }

    updateTicketsHandler(event){
        for(let i=0; i < this.lstDataChecked.length; i++){
            if(this.lstDataChecked[i].value){
                console.log('BBB98 tttt: '+this.template.querySelector(`[name=`+this.lstDataChecked[i].id+`]`).checked)
            }
        }
        this.visibleTickects=[...event.detail.records];
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}