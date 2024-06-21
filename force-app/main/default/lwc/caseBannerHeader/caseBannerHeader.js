import { LightningElement, wire, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { getRecord, getFieldValue, deleteRecord } from 'lightning/uiRecordApi';

import CASE_SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import CASE_PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import CASE_STATUS_FIELD from '@salesforce/schema/Case.Status';
import CASE_NUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';

export default class CaseBannerHeader extends NavigationMixin(LightningElement){
    @api recordId;
    showModal =false; // Variável para controlar a exibição do fluxo
    flowApiName; // api name of your flow

    @wire(getRecord, { recordId: '$recordId', fields: [CASE_SUBJECT_FIELD, CASE_PRIORITY_FIELD, CASE_STATUS_FIELD, CASE_NUMBER_FIELD] })
    case;

    get caseSubject(){
        return getFieldValue(this.case.data, CASE_SUBJECT_FIELD);
    }

    get casePriority(){
        return getFieldValue(this.case.data, CASE_PRIORITY_FIELD);
    }

    get caseStatus(){
        return getFieldValue(this.case.data, CASE_STATUS_FIELD);
    }

    get caseNumber(){
        return getFieldValue(this.case.data, CASE_NUMBER_FIELD);
    }

    get inputVariables(){
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            },
        ];
    }

    showToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
    closeModal(){
        this.showModal = false;
    }

    handleTaskButtonClick(){
        this.showModal =true;
        this.flowApiName = 'CreateCaseTask';
        this.startFlow(flowApiName);
        this.closeModal();
    }

    handleFlowStatusChange(event){
        // Manipula o status do fluxo
        if(event.detail.flowStatus === 'FINISHED' || event.detail.flowStatus === 'FINISHED_SCREEN'){
            this.showToast('Status', 'Tabulação inserida com sucesso!', 'success', 'dismissable');
            this.showModal = false; // Fecha o componente do fluxo
        } else if(event.detail.flowStatus === 'ERROR'){
            // Ocorreu um erro durante a execução do fluxo
            // Trate o erro adequadamente
        }
    }
    startFlow(flowApiName){
        const flow = this.template.querySelector('lightning-flow');
        flow.startFlow(flowApiName).then(() => {
            // Fluxo iniciado com sucesso
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }).catch(error => {
            // Ocorreu um erro ao iniciar o fluxo
            console.error('Erro ao iniciar o fluxo:', error);
        });
    }

    editRecord(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'edit'
            }
        });
    }

    handleDeleteButtonClick(){
        deleteRecord(this.recordId)
            .then(() => {
                // Registro excluído com sucesso, exibe uma mensagem de sucesso
                this.showToast('Sucesso', 'Registro excluído com sucesso.', 'success');

                // Navega de volta para a lista de registros
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Case',
                        actionName: 'list'
                    }
                });
            })
            .catch(error => {
                // Ocorreu um erro ao excluir o registro, exibe uma mensagem de erro
                this.showToast('Erro', 'Ocorreu um erro ao excluir o registro.', 'error');
                console.error('Erro ao excluir o registro:', error);
            });
    }

    cloneRecord(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'clone'
            }
        });
    }
    //  handleFollowButtonClick(){
    //     // Alterna o estado de seguir/deixar de seguir
    //     this.isFollowing = !this.isFollowing;

    //     // Atualiza o campo de follow-up do caso com o novo valor
    //     const fields = {};
    //     fields[CASE_STATUS_FIELD.fieldApiName] = this.isFollowing;
    //     const recordInput = { fields };
    //     updateRecord(recordInput)
    //         .then(() => {
    //             // Follow-up do caso atualizado com sucesso
    //             if(this.isFollowing){
    //                 this.showToast('Sucesso', 'Agora você está seguindo o caso.', 'success');
    //             } else{
    //                 this.showToast('Sucesso', 'Você deixou de seguir o caso.', 'success');
    //             }
    //         })
    //         .catch(error => {
    //             // Ocorreu um erro ao atualizar o follow-up do caso
    //             this.showToast('Erro', 'Ocorreu um erro ao atualizar o follow-up do caso.', 'error');
    //             console.error('Erro ao atualizar o follow-up do caso:', error);
    //         });
    // }

    // handleFollowButtonMouseOver(){
    //     // Altera o texto do botão para "Deixar de seguir" durante o hover
    //     if(this.isFollowing){
    //         const button = this.template.querySelector('button');
    //         button.textContent = 'Deixar de seguir';
    //     }
    // }

    // handleFollowButtonMouseOut(){
    //     // Retorna o texto do botão para "Seguir" após o hover
    //     if(this.isFollowing){
    //         const button = this.template.querySelector('button');
    //         button.textContent = 'Seguindo';
    //     }
    // }
}