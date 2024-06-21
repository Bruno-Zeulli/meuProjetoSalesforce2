import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import getInfoForHeader from '@salesforce/apex/PlacementController.getInfoForHeader';
import createTaskHistory from '@salesforce/apex/PlacementController.createTaskHistory';
import postInChatter from '@salesforce/apex/PlacementController.postInChatter';
import updateOwnerCaseFromPlacementHeader from '@salesforce/apex/PlacementController.updateOwnerCaseFromPlacementHeader';
import getUserQueue from '@salesforce/apex/PlacementController.getUserQueueInfo';
import getUsersFromQueue from '@salesforce/apex/PlacementController.getUsersFromQueue';
import updateCaseFromPlacement from '@salesforce/apex/PlacementController.updateCaseFromPlacement';
import USER_ID from '@salesforce/user/Id';
import USER_NAME from '@salesforce/schema/User.FirstName';

function formatCNPJ(cnpj) {
    // Remove caracteres não numéricos
    cnpj = cnpj.replace(/\D/g, '');
    // Formata o CNPJ no padrão XX.XXX.XXX/XXXX-XX
    return cnpj.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, "$1.$2.$3/$4-$5");
}

export default class PlacementHeader extends LightningElement {

    @track isModalOpen = false;
    @track isAssignModalOpen = false;
    @track actualOwner;
    @track labelAssignBtn = true;
    @track labelAssignBtn2 = false;
    @track isLost = false;
    loaded = false;
    loadedAssign = false;
    btnClassComent = true;
    btnClassPendency = false;
    textAreaObservation;
    currentUserName;
    home = true;
    followUp = false;
    loaded = false;
    caseId;
    opportunityId;
    accountName;
    oppNumber;
    oppRecordType;
    productName;
    CNPJ;
    contactId;
    usersQueue;
    queueId = [];
    listUsersQueue = [];
    optionsAssignName = [];


    @wire(getRecord, { recordId: USER_ID, fields: [USER_NAME] })
    userDetails({ error, data }) {
        if (data) {
            this.currentUserName = data.fields.FirstName.value;
        } else if (error) {
            this.error = error;
        }
    }

    get buttonClassComent() {
        return this.btnClassComent == true ? "button-active" : "button-off";
    }

    get buttonClassPendency() {
        return this.btnClassPendency == true ? "button-active" : "button-off";
    }

    connectedCallback() {

        const CASE_ID = this.extractCaseIdFromUrl(window.location.href);
        const OPP_ID = this.extractOpportunityIdFromUrl(window.location.href);

        if (CASE_ID !== 'home') {
            this.home = false;
            this.followUp = true;
            this.caseId = CASE_ID;
            this.opportunityId = OPP_ID;
            this.getInfoForHeader(this.caseId, this.opportunityId);
            this.getUserQueueInfo(USER_ID);
        } 
    }

    extractCaseIdFromUrl(url) {
        // Procurar por 'caseId=' seguido por qualquer número de caracteres que não sejam '&', e terminar em '&'
        const regex = /caseId=([^&]+)&/;
        const match = url.match(regex);
        // Se encontrar uma correspondência, retornar o valor capturado
        if (match && match[1]) {
            return match[1];
        }
        // Se não encontrar uma correspondência, retornar 'home'
        return 'home';
    }

    extractOpportunityIdFromUrl(url) {
        // Procurar por 'opportunityId=' seguido por qualquer número de caracteres que não sejam '&', ou até o final da string
        const regex = /opportunityId=([^&]+)/;
        const match = url.match(regex);
        // Se encontrar uma correspondência, retornar o valor capturado
        if (match && match[1]) {
            return match[1];
        }
        // Se não encontrar uma correspondência, retornar 'erro'
        return 'erro';
    }

    getInfoForHeader(caseId, opportunityId){

        getInfoForHeader({
            caseId: caseId,
            oppId: opportunityId
        }).then(result => {
            if (result) {
                this.accountName = result.AccountName;
                this.contactId = result.ContactId;
                this.oppNumber = result.OpportunityNumber;
                this.actualOwner = result.OwnerName;
                this.productName = result.ProductName;
                this.oppRecordType = result.OpportunityRecordTypeName;
                this.CNPJ = formatCNPJ(result.CompanyIdentificationNumber);

                result.Status == 'Processo anulado' ? this.isLost = true : this.isLost = false;

                if (this.actualOwner.includes("Célula")) {
                    this.labelAssignBtn2 = true;
                    this.labelAssignBtn = false;
                } else {
                    this.labelAssignBtn = true;
                    this.labelAssignBtn2 = false;
                }
            }
        }).catch((error) => {
            console.log(`ERROR: ==> ${error}`);
        });
    }

    createTaskHistory(){

        this.closeModal();
        this.loaded = true;
        createTaskHistory({
            whatId: this.opportunityId, 
            whoId: this.contactId, 
            subject: 'Pendência', 
            description: this.textAreaObservation, 
            type: 'Pendência'
        }).then(result => {
            if (result) {
                this.loaded = false;
                this.textAreaObservation = '';
                this.showToast('Sucesso', 'Pendência enviada!', 'success');
            }
        }).catch((error) => {
            console.log(`ERROR: ==> ${error}`);
        });
    }

    postInChatter() {

        this.closeModal();
        this.loaded = true;
        postInChatter({
            oppId: this.opportunityId,
            observation: this.textAreaObservation
        }).then(result => {
            if (result) {
                this.loaded = false;
                this.textAreaObservation = '';
                this.showToast('Sucesso', result, 'success');
            }
        }).catch((error) => {
            console.log(error);
        });
    }

    handleCopy() {
        navigator.clipboard.writeText(this.CNPJ)
            .then(() => {
                this.showToast('', 'CNPJ copiado!', 'success');
            })
            .catch(err => {
                console.error('Falha ao copiar o CNPJ: ', err);
            });
    }

    handleMenuSelect(event){
        const target = event.detail.value;
        
        if (target === 'Reatribuir oportunidade') this.openAssignModal();

        if (target === 'Marcar como perdido') this.updateCaseFromPlacement();
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    /* MODAL REGISTRAR HISTÓRICO */
    openModal() {
        this.isModalOpen = true;
        this.loadedHistory = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    sendHistory() {
        this.btnClassPendency == true ? this.createTaskHistory() : this.postInChatter();
    }

    activeBtnClassComent() {
        if (this.btnClassComent == false){
            this.btnClassComent = true;
            this.btnClassPendency = false;
        }
    }

    activeBtnClassPendency() {
        if (this.btnClassPendency == false){
            this.btnClassPendency = true;
            this.btnClassComent = false;
        }
    }

    handleObservation(event) {
        this.textAreaObservation = event.detail.value;
    }

    /* MODAL REATRIBUIR */

    openAssignModal() {
        this.optionsAssignName = [];
        let sortedOptions = [];
        for (let key in this.listUsersQueue) {
            const users = this.listUsersQueue[key];
            users.forEach(user => {
                sortedOptions.push({ label: user.userName, value: user.userId });
            });
        }

        sortedOptions.sort((a, b) => a.label.localeCompare(b.label));
        const uniqueOptions = new Set(sortedOptions.map(option => option.label));
        this.optionsAssignName = Array.from(uniqueOptions).map(label => {
            const user = sortedOptions.find(option => option.label === label);
            return { label: label, value: user.value };
        });

        this.isAssignModalOpen = true;
        this.loadedAssign = true;
    }

    closeAssignModal() {
        this.isAssignModalOpen = false;
    }
    
    handleChangeAssignName(event) {
        this.valueAssignName = event.detail.value;
    }

    getUserQueueInfo(userId) {
        getUserQueue({ userId: userId })
            .then(success => {
                try {
                    for (const key in success) {
                        this.queueId.push(success[key].IdFila);
                    }
                    this.getListUsersFromQueue(this.queueId);
                } catch (error) {
                    console.log('error =>', error);
                }
            })
            .catch(error => console.log(error))
    }

    getListUsersFromQueue(queueId) {
        getUsersFromQueue({ lstQueueId: queueId })
            .then(success => {
                try {
                    this.listUsersQueue = success;

                } catch (error) {
                    console.log('error =>', error);
                }

            })
            .catch(error => console.log(error));
    }

    updateOwnerCaseFromPlacementHeader() {
        this.loadedAssign = false;
        updateOwnerCaseFromPlacementHeader({
            caseId: this.caseId,
            userId: this.valueAssignName
        }).then(result => {
            if (result) {
                this.closeAssignModal();  
                this.getInfoForHeader(this.caseId, this.opportunityId);
                this.showToast('Atribuído com sucesso!','','success');
            } else {
                console.log(`UPD Owner fail`);
            }
        }).catch((error) => {
            console.log(`ERROR: ==> ${error}`);
            this.loadedAssign = true;
            throw new Error(error);
        })
    }

    async updateCaseFromPlacement() {

        const result = await LightningConfirm.open({
            variant: 'headerless',
            message: "Tem certeza que deseja anular o processo?",
        });
        if (result == true){
            this.loaded = true;
            updateCaseFromPlacement({
                caseId: this.caseId,
                reason: 'Processo anulado',
                status: 'Processo anulado'
            }).then(result => {
                if (result) {
                    this.showToast('Status foi atualizado', '', 'success');
                    this.loaded = false;
                } else {
                    console.log(`UPD Owner fail`);
                }
            }).catch((error) => {
                console.log(`ERROR: ==> ${error}`);
                throw new Error(error);
            })
        }
    }

}