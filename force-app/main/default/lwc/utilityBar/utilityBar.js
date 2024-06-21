import getSObjectInfos from '@salesforce/apex/ClickToDialController.getSObjectInfos';
import createCallLog from '@salesforce/apex/CreateLogsGenesys.createCallLog';
import getCampaignTime from '@salesforce/apex/CampaignService.getTimeCampaign';
import addContactIntoCampaign from '@salesforce/apex/GenesysAddMemberIntoCampaign.addContactIntoCampaign';
import addLeadIntoCampaign from '@salesforce/apex/GenesysAddMemberIntoCampaign.addLeadIntoCampaign';
import findContactDetail from '@salesforce/apex/GenesysFindContactDetail.findContactDetail';
import getProtocol from '@salesforce/apex/GenesysGetProtocol.getProtocol';
import createTaskTabulationExpired from '@salesforce/apex/TaskService.createTabulationExpiredTask';
import createTaskTabulationPreview from '@salesforce/apex/TaskService.createTabulationPreviewTask';
import checkUserStatus from '@salesforce/apex/GetStatusId.checkUserStatus';
import getStatusId from '@salesforce/apex/GetStatusId.getStatusId';
import getUserId from '@salesforce/apex/GetUserId.getUserId';
import userCurrentId from '@salesforce/user/Id';
import getDialerDetail from '@salesforce/apex/GenesysIntegrationService.getDialerDetail';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, api, track, wire } from 'lwc';

export default class UtilityBar extends NavigationMixin(LightningElement) {
    @api recordId;
    @api phoneNumber;
    data = [];
    showUtilityBar = true;
    showPhone = true;
    showClickToDial = false;

    interval;
    callLogId = '';
    objectName;
    recordIdentifier;
    phone = '';
    campaignOrigin = '';
    find;
    blankInput;
    conversationId;
    previewHistory;
    campaignId;

    @track isPreview = false;

    @track showTabulationFlow = false;
    @track showCreateLeadFlow = false;
    @track showProtocol = false;
    @track protocol = '';
    @track isAgentOnCall = false;

    @track tempoMinTabulacao = 60;
    @track tabulationTime = 60;

    @wire(CurrentPageReference)
    async setCurrentPageReference(currentPageReference) {
        console.log('### currentPageReference', currentPageReference)
        if (currentPageReference) {
            this.recordId = currentPageReference.attributes.recordId;
        }
        if (this.showClickToDial === true) {
            this.showClickToDial = !this.showClickToDial;
        }
    }

    async handlerShowPhone() {
        const e = this.template.querySelector('.modal-sofphone');
        console.log(`display: ${e.style.display};`)
        if (this.showClickToDial === true) {
            this.showClickToDial = !this.showClickToDial;
        }
        if (e.style.display === 'none') {
            e.style.display = 'block'
        } else if (e.style.display === 'block') {
            e.style.display = 'none'
        }
    }

    async handlerOpenPhone() {
        const e = this.template.querySelector('.modal-sofphone');
        e.style.display = 'block';

    }

    async handlerClosePhone() {
        const e = this.template.querySelector('.modal-sofphone');
        e.style.display = 'none';

    }

    handlerShowClickToDial(event) {
        if (event) {
            event.preventDefault();
        }
        this.handlerClosePhone();
        this.showClickToDial = !this.showClickToDial;
        this.getSObjectInfos();
    }

    async connectedCallback() {

        const style = document.createElement("style");
        style.innerHTML = ".flow-dt-height-395{height: auto !important;}.tabulationFlow .dt-outer-container{max-height: 150px;overflow-y: scroll;}.tabulationFlow::-webkit-scrollbar {display: none;}";
        document.getElementsByTagName("body")[0].appendChild(style);

        if (this.recordId === null || this.recordId === '' || this.recordId === undefined) {
            this.recordId = userCurrentId;
        }
        await this.getSObjectInfos();

        window.addEventListener('beforeunload', this.handleWarnAgentBeforeUnload);

        window.addEventListener('message', (event) => {
            const message = JSON.parse(event.data);

            console.log('###message');
            console.log(JSON.stringify(message));

            if (message.data == undefined) {
                return;
            }

            let { interaction, category, eventName } = message.data;

            if (category == 'change' && interaction.old.isDialerPreview) {
                console.log('isPreview = true');
                this.previewHistory = interaction.old.id;
                this.isPreview = true;
            }

            if (interaction.isDialerPreview == false) {
                console.log('isPreview = false');
                this.isPreview = false;
            }

            if (message.type === 'interactionSubscription') {
                const { old } = interaction;
                const { disposition } = interaction;
                if (category === 'change' && old.dispositionDurationSeconds === 3) {
                    this.checkAgentStatusBeforeReplace('Atendimento', this.conversationId);
                } else if (this.isPreview && category == 'acw') {
                    this.createTaskWhenPreviewTabulation(this.callLogId, disposition);
                    this.checkAgentStatusBeforeReplace('Onqueue', this.conversationId);
                    this.handlerEndTabulation();
                    this.isPreview = false;
                } else if (this.isPreview && category == 'callbackCallEnded') {
                    console.log('callbakCallEnded chamou o contador de tempo');
                    this.handlerShowTabulation();
                }
            } else if (message.type === 'processCallLog') {
                this.conversationId = interaction.id;

                createCallLog({ callLogJSON: JSON.stringify(interaction), eventName: eventName })
                    .then(response => {
                        this.callLogId = response.callLogId;

                        getCampaignTime({ callLogId: this.callLogId }).then(result => {
                            console.log('Tempo tabulacao: ' + result);
                            this.tempoMinTabulacao = result;
                            this.tabulationTime = result;

                            console.log('Ultimo id de ligação preview: ' + this.previewHistory);
                            console.log('Id da ligação atual: ' + interaction.id);
                            
                            if (eventName === 'interactionDisconnected' && !this.isPreview && (this.previewHistory != interaction.id)) {
                                this.checkAgentStatusBeforeReplace('Atendimento', this.conversationId);
                                this.handlerShowTabulation();
                                this.isAgentOnCall = false;
                            } else if (
                                eventName === 'interactionChanged' &&
                                interaction.state === 'CONECTADO' &&
                                (interaction.direction === "Inbound" || interaction.direction === "Outbound")
                            ) {

                                if (interaction.dialerContactId && interaction.dialerContactListId) {
                                    this.checkDialerContact(interaction.dialerContactId, interaction.dialerContactListId);
                                } else {
                                    this.callFindContactDetail();
                                }
                                this.getProtocolController();
                                this.isAgentOnCall = true;
                            }

                        }).catch(e => {
                            console.error(e);
                        })


                    })
                    .catch(e => {
                        console.error(e);
                    })
            }
        });
    }

    checkDialerContact(dialerContactId, dialerContactListId) {
        getDialerDetail({ dialerContactId, dialerContactListId })
            .then(response => {
                let parsedResponse = JSON.parse(response);
                this.objectName = parsedResponse.objectApiName;
                this.recordIdentifier = parsedResponse.recordId;
                this.navigateToRecordPage();
            })
            .catch(error => {
                console.error(error);
                this.callFindContactDetail();
            });
    }

    createTaskWhenExpireTime(callLogId) {
        console.log('#createTaskWhenExpireTime');
        createTaskTabulationExpired({ callLogId })
            .then(response => {
                this.showToast('Tarefa criada', 'Foi criada uma tarefa para a tabulação não finalizada', 'success', 'dismissible');
            })
            .catch(error => {
                console.log(error);
                this.showToast('Erro na criação da tarefa', 'Ocorreu uma falha na criação da tarefa e da tabulação', 'error', 'dismissible');
            });
    }

    createTaskWhenPreviewTabulation(callLogId, dispositionPath) {
        console.log('#createTaskWhenPreviewTabulation');
        createTaskTabulationPreview({ callLogId, dispositionPath })
            .then(response => {
                this.showToast('Tarefa criada', 'Foi criada uma tarefa para a tabulação', 'success', 'dismissible');
            })
            .catch(error => {
                console.log(error);
                this.showToast('Erro na criação da tarefa', 'Ocorreu uma falha na criação da tarefa', 'error', 'dismissible');
            });
    }

    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }

    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleWarnAgentBeforeUnload);
    }

    clickToDialLink(event) {
        event.preventDefault();
        this.showClickToDial = false;
        this.showPhone = true;
        const phoneNumber = event.currentTarget.getAttribute('data-phone');
        this.phoneNumber = phoneNumber;

        this.handlerOpenPhone();
        setTimeout(() => {
            const softphone = this.template.querySelector('iframe');
            if (softphone) {
                softphone.contentWindow.postMessage(
                    JSON.stringify({
                        type: 'clickToDial',
                        data: { number: this.phoneNumber, autoPlace: true }
                    }),
                    '*'
                );
            }
        }, 500);
    }

    async replaceAgentStatus(status) {
        try {
            const id = await getStatusId({ status })

            setTimeout(() => {
                const softphone = this.template.querySelector('iframe');
                if (softphone) {
                    softphone.contentWindow.postMessage(
                        JSON.stringify({
                            type: 'updateStatus',
                            data: { id }
                        }),
                        '*'
                    );
                }
            }, 0);
        } catch (e) {
            console.error(`###### replaceAgentStatusError: ${e}`);
        }
    }

    async checkAgentStatusBeforeReplace(status, conversationId) {
        try {
            const userId = await getUserId({ conversationId });
            const canReplaceAgentStatus = await checkUserStatus({ userId });

            if (canReplaceAgentStatus) {
                this.replaceAgentStatus(status);
            }
        } catch (e) {
            console.error(`###### checkAgentStatusBeforeReplace: ${e}`);
        }
    }

    // Adicione um ouvinte de eventos para o evento "beforeunload"
    beforeunload(event) {
        // Cancele a promessa do iframeLoaded
        this.iframePromise.reject();

        // Adicione um manipulador de eventos para o evento "unload"
        window.addEventListener('unload', () => {
            // Remova o iframe do DOM
            const softphone = this.template.querySelector('iframe');
            softphone.parentNode.removeChild(softphone);
        });
    }

    async getSObjectInfos() {
        getSObjectInfos({ recordId: this.recordId })
            .then(async data => {
                try {
                    console.log('### data => ', data)
                    this.data = data;
                    for (let item of this.data) {
                        console.log('### let', item);
                        // Criar um novo objeto para cada atributo com o nome do atributo como valor e rótulo
                        let atributos = [
                            { phoneNumber: item.name, value: item.name, label: 'Name' },
                            { phoneNumber: item.mobilephone, value: item.mobilephone, label: 'Mobile Phone' },
                            { phoneNumber: item.homephone, value: item.homephone, label: 'Home Phone' },
                            { phoneNumber: item.otherphone, value: item.otherphone, label: 'Other Phone' },
                            { phoneNumber: item.bestphone, value: item.bestphone, label: 'Best Phone' },
                            { phoneNumber: item.objectId, value: item.objectId, label: 'Object ID' },
                            { phoneNumber: item.sobjectname, value: item.sobjectname, label: 'SObject Name' }
                        ];

                        // Iterar sobre os atributos e imprimir seus valores e rótulos
                        atributos.forEach(atributo => {
                            console.log('### => ', atributo.label + ':', atributo.value);
                        });
                        this.data = atributos;
                    }

                } catch (error) {
                    console.log('error =>', error);
                }
            })
            .catch(error => console.log(error));
    }

    get inputVariables() {
        return [
            {
                name: 'callLogId',
                type: 'String',
                value: this.callLogId
            }
        ];
    }

    handleStatusChange(event) {
        if (event.detail.status === "FINISHED") {
            this.handlerEndTabulation();
            this.showProtocol = false;
            this.checkAgentStatusBeforeReplace('Onqueue', this.conversationId);
            console.log(`### Fluxo Tabulação Retorno => ${event.detail.outputVariables[0].value}`);
        }
    }

    handlerShowTabulation() {
        console.log('#handlerShowTabulation');
        if(!this.isPreview){
            this.showTabulationFlow = true;
        }
        if (this.tabulationTime === this.tempoMinTabulacao) {
            this.interval = setInterval(() => {
                this.tabulationTime -= 1;
                if (this.tabulationTime === 0) {
                    console.log('Fechando a tabulação');
                    this.createTaskWhenExpireTime(this.callLogId);
                    this.showProtocol = false;
                    this.checkAgentStatusBeforeReplace('Onqueue', this.conversationId);
                    this.handlerEndTabulation();
                }
            }, 1000);
        }
    }

    handlerEndTabulation() {
        clearInterval(this.interval);
        this.tabulationTime = this.tempoMinTabulacao;
        this.showTabulationFlow = false;
    }

    callFindContactDetail() {
        findContactDetail({ callLog: this.callLogId })
            .then(response => {
                this.blankInput = response.blankInput == 'true' ? true : false;
                this.find = response.find == 'true' ? true : false;

                if (this.blankInput) {
                    return;
                } else if (!this.find) {
                    this.phone = response.phone;
                    this.campaignOrigin = response.campaignSource;
                    this.campaignId = response.campaignId;
                    this.showCreateLeadFlow = true;
                    return;
                } if (this.find) {
                    this.objectName = response.ObjectApiName;
                    this.recordIdentifier = response.RecordId;

                    addContactIntoCampaign({ callLog: this.callLogId, contactDetail: this.recordIdentifier })
                        .then(() => {
                            console.log('#### Contato do membro adicionado na campanha corretamente');
                        })
                        .catch(e => {
                            console.error('#### Ocorreu um erro ao adicionar o contato do membro na campanha: ' + e);
                        });

                    this.navigateToRecordPage();
                }

                return;
            })
            .catch(e => {
                console.error(`#### Erro => ${e}`);
            })
    }

    get inputVariablesCreateLead() {
        return [
            {
                name: 'phone',
                type: 'String',
                value: this.phone || ''
            },
            {
                name: 'campaignOrigin',
                type: 'String',
                value: this.campaignOrigin || ''
            },
            {
                name: 'CampaignId',
                type: 'String',
                value: this.campaignId || ''
            },
            {
                name: 'callLogId',
                type: 'String',
                value: this.callLogId || ''
            }
        ];
    }

    handleStatusChangeCreateLead(event) {
        if (event.detail.status === "FINISHED") {
            this.recordIdentifier = event.detail.outputVariables[0].value;
            this.objectName = event.detail.outputVariables[1].value;

            this.navigateToRecordPage();

            if (this.objectName === 'Lead') {
                addLeadIntoCampaign({ callLog: this.callLogId, leadId: this.recordIdentifier })
                    .then(() => {
                        console.log('#### Lead do membro adicionado na campanha corretamente');
                    })
                    .catch(e => {
                        console.error('#### Ocorreu um erro ao adicionar o lead membro na campanha: ' + e);
                    });
            } else {
                addContactIntoCampaign({ callLog: this.callLogId, contactDetail: this.recordId })
                    .then(() => {
                        console.log('#### Contato do membro adicionado na campanha corretamente');
                    })
                    .catch(e => {
                        console.error('#### Ocorreu um erro ao adicionar o contato do membro na campanha: ' + e);
                    });
            }

            this.showCreateLeadFlow = false;
        } else if (event.detail.status === "ERROR") {
            console.log(`#### Erro ${event.detail}`);
        }
    }

    navigateToRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordIdentifier,
                objectApiName: this.objectName,
                actionName: 'view'
            }
        });
    }

    getProtocolController() {
        getProtocol({ recordId: this.callLogId })
            .then(protocol => {
                this.protocol = protocol;
                this.showProtocol = true;
            })
            .catch(e => {
                console.error(`#### Erro ao obter protocolo: ${e}`);
            })
    }

    copyProtocol() {
        const inputTemporario = document.createElement('input');
        inputTemporario.value = this.protocol
        document.body.appendChild(inputTemporario);

        inputTemporario.select();
        inputTemporario.setSelectionRange(0, 99999);

        document.execCommand('copy');
        document.body.removeChild(inputTemporario);
    }

    handleWarnAgentBeforeUnload(event) {
        if (this.isAgentOnCall) {
            event.preventDefault();
            const warnMessage = 'Você está em uma chamada. Tem certeza que deseja atualizar a página? A chamada será encerrada e as alterações não salvas serão perdidas.';
            event.returnValue = warnMessage;
            return warnMessage;
        }
    }
}