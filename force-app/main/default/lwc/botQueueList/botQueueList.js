/**
 * @description       :
 * @author            : Italo Ramillys
 * @group             :
 * @last modified on  : 11-28-2023
 * @last modified by  : Italo Ramillys
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   11-28-2023   Italo Ramillys   Initial Version
 **/

import { LightningElement, track, wire } from 'lwc';
import getBotQueueListByLoggedUser from '@salesforce/apex/BotQueueService.getBotQueueByLoggedUser';
import fetchQueueAssignments from '@salesforce/apex/QueueAssignmentController.fetchQueueAssignments';
import addRemoveInQueues from '@salesforce/apex/QueueAssignmentController.addRemoveInQueues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ModalPopupLWC extends LightningElement {

    botQueueColumns = [
        { label: 'Nome da fila', fieldName: 'Name', sortable: true },
        { label: 'Membros ativos na fila', fieldName: 'Count', sortable: true },
        {
            label: 'Data de criação da Fila', fieldName: 'CreatedDate', type: "date",
            typeAttributes: {
                day: "2-digit",
                month: "2-digit",
                year: "numeric",
                hour: "2-digit",
                minute: "2-digit",
                second: "2-digit",
                timeZone: 'UTC'
            }, sortable: true
        },
        {
            type: "button", label: 'Gerenciar membros', typeAttributes: {
                label: 'Editar',
                name: 'View',
                title: 'Gerenciar membros',
                disabled: false,
                value: 'view',
                iconPosition: 'left',
                iconName: 'utility:edit',
                variant: 'Brand'
            }, cellAttributes: { alignment: 'left' }
        }
    ];

    sortedBy = 'Name';
    sortedDirection = 'asc';

    botQueueData = [];

    @track queueRecordId = '';
    @track isLoading = false;

    //Variaveis para controle dos usuarios no modal
    @track availableUsers;
    @track availableUsersBackup;
    @track selectedUsers;

    queueName;
    updatedQueues;

    @wire(getBotQueueListByLoggedUser) botQueueFunction({ error, data }) {
        console.log('@getBotQueueListByLoggedUser');
        if (data) {
            var objList = [];
            data.forEach((e) => {
                var obj = {};
                obj.Id = e.Id;
                obj.Name = e.Name;

                //Contando somente "usuários" no grupo
                if (e.GroupMembers != null) {
                    let count = 0;
                    e.GroupMembers.forEach((x) => {
                        if (x.UserOrGroupId.startsWith('005')) {
                            count++;
                        }
                    })
                    obj.Count = count;
                } else {
                    obj.Count = 0;
                }

                obj.CreatedDate = e.CreatedDate;
                objList.push(obj);
            });
            this.botQueueData = objList;
        } else if (error) {
            console.log(error)
        }
    }

    doSorting(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.botQueueData));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // Cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // Sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.botQueueData = parseData;
    }


    callRowAction(event) {
        console.log('@callRowAction')
        const recId = event.detail.row.Id;
        const actionName = event.detail.action.name;
        if (actionName === 'View') {
            this.handleClickViewMembers(recId, event);
        }
    }

    handleClickViewMembers(recordId, event) {
        this.isModalOpen = true;
        this.queueRecordId = recordId;
        console.log('@handleClickViewMembers');
        this.getQueueMember();
    }

    onChangeNameUser(event) {
        try {
            let nameInput = event.target.value;
            if (nameInput == '' || nameInput.length < 3) {
                this.availableUsers = this.availableUsersBackup;
                this.template.querySelector("div[data-id='info-message']").style = 'opacity:1';
            } else {
                let arr = [];
                this.availableUsersBackup.forEach((e) => {
                    if (this.selectedUsers.includes(e.value)) {
                        arr.push(e);
                    }
                    else if (e.label.toLowerCase().includes(nameInput.toLowerCase())) {
                        arr.push(e);
                    }
                });
                this.availableUsers = arr;
                this.template.querySelector("div[data-id='info-message']").style = 'opacity:0';
            }
        } catch (e) {
            console.log('Error: ');
            console.log(e);
        }
    }

    getQueueMember() {
        try {

            console.log('@getQueueMember');
            fetchQueueAssignments({ queueId: this.queueRecordId }).
                then(data => {
                    if (data) {

                        this.availableUsers = data.availableUsers;
                        this.availableUsersBackup = data.availableUsers;
                        this.selectedUsers = data.selectedUsers;
                        this.queueName = data.queueName;

                    } else if (error) {

                        console.log(error);
                        console.log('Error ' + JSON.stringify(error));

                    }

                }).catch(error => {
                    console.log(error);
                    console.log('Error ' + JSON.stringify(error));

                });
        } catch (e) {
            console.log('Erros: ');
            console.log(e);
        }
    }

    handleChange(event) {

        const selectedOptionsList = event.detail.value;
        this.updatedQueues = selectedOptionsList;
        this.selectedUsers = event.detail.value;

    }

    saveChanges() {
        this.isLoading = true;
        console.log('@saveChanges');
        addRemoveInQueues({ selectedUsers: this.selectedUsers, queueId: this.queueRecordId })
            .then(result => {

                var arrayAux = [];
                this.botQueueData.forEach((e) => {
                    console.log(e);
                    if (e.Id == this.queueRecordId) {

                        e.Count = this.selectedUsers.length;

                    }
                    arrayAux.push(e);
                });

                this.botQueueData = arrayAux;

                let message;
                let variant;

                if (result === 'Successful') {

                    message = 'Registros atualizados com sucesso!';
                    variant = 'success';

                } else {

                    message = 'Um erro ocorreu. Por favor entre em contato com o administrador.';
                    variant = 'error';

                }

                this.isLoading = false;

                const toastEvent = new ShowToastEvent({

                    title: 'Atribuição de usuário',
                    message: message,
                    variant: variant

                });
                this.dispatchEvent(toastEvent);

                window.location.reload(true);

            })
            .catch(error => {

                console.log(error);
                console.log('Error ' + JSON.stringify(error));

            });
        this.selectedUsers = this.updatedQueues;

    }

    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}