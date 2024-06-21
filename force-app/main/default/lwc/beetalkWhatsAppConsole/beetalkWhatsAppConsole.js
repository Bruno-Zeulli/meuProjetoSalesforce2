import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import Id from '@salesforce/user/Id';
import getUserStatus from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getUserStatus';
import changeOnlineChat from '@salesforce/apex/BeeTalkWhatsAppConsoleController.changeOnlineChat';
import changeMyCaseToView from '@salesforce/apex/BeeTalkWhatsAppConsoleController.changeMyCaseToView';
import changeAwaitCaseToView from '@salesforce/apex/BeeTalkWhatsAppConsoleController.changeAwaitCaseToView';
import getMyCaseBTWhatsApp from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getMyCaseBTWhatsApp';
import getCaseAwaitBTWhatsApp from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getCaseAwaitBTWhatsApp';
// import getCaseData from '@salesforce/apex/BeeTalkWhatsAppConsoleController.getCaseData';

export default class BeetalkWhatsAppConsole extends NavigationMixin(LightningElement) {
    @api recordId;
    userId = Id;
    @track myCases;
    @track myCasesOld;
    @track awaitCasesOld;
    @track userStatus;
    @track awaitCases;
    @track currentPageMyCases = 1;
    @track totalPageMyCases = 0;
    @track currentPageAwaitCases = 1;
    @track totalPageAwaitCases = 0;
    @track checkedAutomatic;
    @track presenceStatus;
    @track presenceStatusPlace = 'Selecione';

    showModal = false;
    showDropdown = false;
    showFlowImport = false;
    showFlowContact = false;
    showButtonTask = false;
    showButtonImport = false;
    showButtonContact = false;
    checkedOnline = false;
    checkOldMyCases = false;
    checkOldAwaitCases = false;

    awaitCases
    myCasesToViewNumber = 5;
    awaitCasesToViewNumber = 5;
    variaveldetesteMy;
    variaveldetesteAwait;

    myCasesNumber;
    awaitCasesNumber;

    wiredMyCases;
    wiredAwaitCases;
    wiredUserStatus;
    myCasesToRefresh;
    data;
    visibleMyCases;
    visibleAwaitCases;

    @wire(getUserStatus, { recordId: '$userId' })
    getUserStatus(result) {
        if (result.data) {
            this.presenceStatus = result.data.PresenceStatus__c;
            this.checkedAutomatic = result.data.AutomaticReceiverChat__c;
            this.myCasesToViewNumber = result.data.MyCasesToView__c;
            this.awaitCasesToViewNumber = result.data.AwaitCasesToView__c;
            this.wiredUserStatus = result;
            if (this.presenceStatus === 'Disponivel' || this.presenceStatus === 'Em pausa') {
                this.checkedOnline = true;
            }
        } else if (result.error) {
            console.log(result.error);
        }
    }

    // @wire(getMyCaseBTWhatsApp,{recordId: '$userId'})
    //     getMyCaseBTWhatsApp(result){
    //         if(result.data){
    //             this.myCases = result.data // Limitando para 15 registros
    //             this.myCasesNumber = this.myCases.length;
    //             this.wiredMyCases = result;
    //             this.visibleMyCases = this.myCases.slice(0, this.myCasesToViewNumber);
    //         } else if(result.error){
    //             console.log(result.error);
    //         }
    //     }

    // @wire(getCaseAwaitBTWhatsApp,{recordId: '$userId'})
    //     getCaseAwaitBTWhatsApp(result){
    //         if(result.data){
    //             this.awaitCases = result.data;
    //             this.awaitCasesNumber = this.awaitCases.length;
    //             this.wiredAwaitCases = result;
    //             this.visibleAwaitCases = this.awaitCases.slice(0, this.awaitCasesToViewNumber);
    //         } else if(result.error){
    //             console.log(result.error);
    //         }
    //     }

    async loadMyCases() {
        try {
            const result = await getMyCaseBTWhatsApp({ recordId: this.userId });
            this.myCases = [...result];
            this.myCasesNumber = this.myCases.length == '' ? 0 : this.myCases.length;
            this.wiredMyCases = [...result];
            console.log('this.myCases--->', this.myCases);
            this.visibleMyCases = this.myCases.slice(0, this.myCasesToViewNumber);
            console.log('this.visibleCases--->', this.visibleMyCases);
        } catch (error) {
            console.error(error);
        }
    }

    async loadAwaitCases() {
        try {
            const result = await getCaseAwaitBTWhatsApp({ recordId: this.userId });
            this.awaitCases = [...result];
            console.log('this.awaitCases--->', this.awaitCases);
            this.wiredAwaitCases = [...result];
            this.awaitCasesNumber = this.awaitCases.length == '' ? 0 : this.awaitCases.length;
            this.visibleAwaitCases = this.awaitCases.slice(0, this.awaitCasesToViewNumber);
            console.log('this.visibleAwaitCases--->', this.visibleAwaitCases);
        } catch (error) {
            console.error(error);
        }
    }
    async connectedCallback() {
        // console.log('Dentro do callBack');
        await this.checkRecordId(this.recordId);
        await this.loadMyCases();
        await this.loadAwaitCases();
        // this.event1 = setInterval(() => {
        //     refreshApex(this.wiredMyCases);
        //     if(this.checkedAutomatic == false){
        //         refreshApex(this.wiredAwaitCases);
        //     }
        // }, 6000);
        this.refreshData();
        // await this.disconnectedCallback()
        // await this.renderedCallback()

    }

    async renderedCallback() {
        await this.checkRecordId(this.recordId);
        // await this.loadMyCases();
        // await this.loadAwaitCases();
    }

    async disconnectedCallback() {
        clearInterval(this.event1);
    }

    async refreshData() {
        try {
            // await refreshApex(this.getCaseAwaitBTWhatsApp());
            // await this.disconnectedCallback()
            // await this.renderedCallback()
            await this.loadMyCases();
            await this.loadAwaitCases();
            if (this.checkMyCases === false && this.myCasesToViewNumber != undefined) {
                await this.paginationMyCases();
                this.myCasesOld = this.myCases;
                this.checkMyCases = true;
            } else if (this.myCases != this.myCasesOld) {
                await this.paginationMyCases();
                this.myCasesOld = this.myCases;
            }

            if (this.checkedAutomatic === false) {
                // await refreshApex(this.wiredAwaitCases);
                // await this.disconnectedCallback()
                // await this.renderedCallback()
                await this.loadMyCases();
                await this.loadAwaitCases();
                if (this.checkAwaitCases === false && this.awaitCasesToViewNumber != undefined) {
                    await this.paginationAwaitCases();
                    this.awaitCasesOld = this.awaitCases;
                    this.checkAwaitCases = true;
                } else if (this.awaitCases != this.awaitCasesOld) {
                    await this.paginationAwaitCases();
                    this.awaitCasesOld = this.awaitCases;
                }
            }
        } catch (error) {
            console.error('Erro ao atualizar os casos:', error);
        } finally {
            // Chamar a função novamente após 10000 ms (10 segundos)
            this.event1 = setTimeout(() => this.refreshData(), 10000);
        }
    }

    async checkRecordId(recordId) {
        if (recordId === undefined || recordId === null) {
            this.showButtonImport = true;
            this.showButtonTask = false;
            this.showButtonContact = true;
        } else {
            this.showButtonImport = false;
            this.showButtonTask = true;
            this.showButtonContact = false;
        }
    }

    async handlerChangeMyCasesToView(event) {
        try {
            this.myCasesToViewNumber = event.target.value;
            changeMyCaseToView({
                recordId: this.userId,
                myCasesToView: this.myCasesToViewNumber
            });
            this.connectedCallback();


        } catch (error) {
            console.error(error);
        } finally {
            refreshApex(this.wiredUserStatus);
        }
    }

    async handlerChangeAwaitCasesToView(event) {
        try {
            this.awaitCasesToViewNumber = event.target.value;
            changeAwaitCaseToView({
                recordId: this.userId,
                awaitCasesToView: this.awaitCasesToViewNumber
            });
            this.connectedCallback();
        } catch (error) {
            console.error(error);
        } finally {
            refreshApex(this.wiredUserStatus);
        }
    }

    async handleChangeStatus(event) {
        this.presenceStatus = this.template.querySelector('lightning-combobox').value;
        changeOnlineChat({
            recordId: this.userId,
            presenceStatus: this.presenceStatus
        });
        if (this.presenceStatus === 'Disponivel' || this.presenceStatus === 'Em pausa') {
            this.checkedOnline = true;
        } else {
            this.checkedOnline = false;
        }
    }

    openModal() {
        this.showModal = true;
    }
    closeModal() {
        this.showModal = false;
    }
    openFlowImport() {
        this.showFlowImport = true;
    }
    closeFlowImport() {
        this.showFlowImport = false;
    }
    openFlowContact() {
        this.showFlowContact = true;
    }
    closeFlowContact() {
        this.showFlowContact = false;
    }
    clickDropdown() {
        this.showDropdown = !this.showDropdown;
    }

    get optionsStatus() {
        return [
            { label: 'Indisponivel', value: 'Indisponivel' },
            { label: 'Disponivel', value: 'Disponivel' },
            { label: 'Em pausa', value: 'Em pausa' },
            { label: 'Ausente', value: 'Ausente' },
            { label: 'Ocupado', value: 'Ocupado' },
        ];
    }

    get inputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            },
        ];
    }

    async handleStatusChange(event) {

        let objDetails = event.detail;
        console.log('objDetails.status', objDetails.status);
        if (objDetails.status === 'FINISHED_SCREEN' || objDetails.status === "FINISHED") {
            this.showToast('Status', 'Fluxo executado com sucesso!', 'success', 'dismissable');
            this.showFlowImport = false;
            this.showModal = false;
            this.navToHomePage();

        }
    }

    navToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    async paginationMyCases() {
        console.log('dentro do pagination');
        if (this.myCases != null && this.myCasesToViewNumber != undefined) {
            if (this.myCasesNumber < 1) {
                this.currentPageMyCases = 0;
                this.totalPageMyCases = 0;
                this.myCases = [];
            } else {
                this.currentPageMyCases = 1;
                this.totalPageMyCases = Math.ceil(this.myCasesNumber / this.myCasesToViewNumber);
                await this.visibleMyCasesCompouse();
            }
        }
    }

    async visibleMyCasesCompouse() {
        if (!this.myCases || this.myCases.length === 0) {
            this.visibleMyCases = [];
        } else {
            const start = (this.currentPageMyCases - 1) * this.myCasesToViewNumber;
            const end = this.myCasesToViewNumber * this.currentPageMyCases;
            this.visibleMyCases = this.myCases.slice(start, end);
        }
    }

    async paginationAwaitCases() {
        console.log('dentro do pagination');
        if (this.awaitCases != null && this.awaitCasesToViewNumber != undefined) {
            if (this.AwaitCasesNumber < 1) {
                this.currentPageAwaitCases = 0;
                this.totalPageAwaitCases = 0;
                this.awaitCases = [];
            } else {
                this.currentPageAwaitCases = 1;
                this.totalPageAwaitCases = Math.ceil(this.awaitCasesNumber / this.awaitCasesToViewNumber);
                await this.visibleAwaitCasesCompouse();
            }
        }
    }

    async visibleAwaitCasesCompouse() {
        if (!this.awaitCases || this.awaitCases.length === 0) {
            this.visibleAwaitCases = [];
        } else {
            const start = (this.currentPageAwaitCases - 1) * this.awaitCasesToViewNumber;
            const end = this.awaitCasesToViewNumber * this.currentPageAwaitCases;
            this.visibleAwaitCases = this.awaitCases.slice(start, end);
        }
    }



    get disablePreviousMyCases() {
        return this.currentPageMyCases <= 1;
    }

    get disableNextMyCases() {
        return this.currentPageMyCases >= this.totalPageMyCases || this.totalPageMyCases === 0;
    }

    previousHandlerMyCases() {
        if (this.currentPageMyCases > 1) {
            this.currentPageMyCases = this.currentPageMyCases - 1;
            this.visibleMyCasesCompouse();
        }
    }

    nextHandlerMyCases() {
        if (this.currentPageMyCases < this.totalPageMyCases) {
            this.currentPageMyCases = this.currentPageMyCases + 1;
            this.visibleMyCasesCompouse();
        }
    }

    handleToFirstPageMyCases() {
        this.currentPageMyCases = 1;
        this.visibleMyCasesCompouse();
    }

    handleToLastPageMyCases() {
        this.currentPageMyCases = this.totalPageMyCases;
        this.visibleMyCasesCompouse();
    }


    get disablePreviousAwaitCases() {
        return this.currentPageAwaitCases <= 1;
    }

    get disableNextAwaitCases() {
        return this.currentPageAwaitCases >= this.totalPageAwaitCases || this.totalPageAwaitCases === 0;
    }

    previousHandlerAwaitCases() {
        if (this.currentPageAwaitCases > 1) {
            this.currentPageAwaitCases = this.currentPageAwaitCases - 1;
            this.visibleAwaitCasesCompouse();
        }
    }

    nextHandlerAwaitCases() {
        if (this.currentPageAwaitCases < this.totalPageAwaitCases) {
            this.currentPageAwaitCases = this.currentPageAwaitCases + 1;
            this.visibleAwaitCasesCompouse();
        }
    }

    handleToFirstPageAwaitCases() {
        this.currentPageAwaitCases = 1;
        this.visibleAwaitCasesCompouse();
    }

    handleToLastPageAwaitCases() {
        this.currentPageAwaitCases = this.totalPageAwaitCases;
        thisAwaitCasesCompouse();
    }

    markBoxSelected() {
        this.template.querySelector('.slds-button_neutral').classList.add('boxSelected');
    }

}