import { LightningElement, track, wire } from 'lwc';
import userCurrentId from '@salesforce/user/Id'
import { getRecord } from 'lightning/uiRecordApi'; //this scoped module get the record details
import Name from '@salesforce/schema/User.Name';
import RoleName from '@salesforce/schema/User.UserRole.Name';
import ProfileName from '@salesforce/schema/User.Profile.Name';

export default class ConnectWizQuoteOrderManagement extends LightningElement {
    @track filterByGroup = true;
    @track filterByUser = false;
    @track filterStatus = '';
    @track filterFieldsParams = '';
    @track filterCasesInsideSLA = '';
    @track filterCasesOutsideSLA = '';
    @track lAllQuotesRequest = [];
    @track lQuotesRequest = [];
    @track showModalToAssignCase = false;
    @track requestOutsideSLA;
    @track requestInsideSLA;
    @track userName;
    @track userRoleName;
    @track userProfileName;
    @track userManagerName;
    @track filterCaseStartDate = '';
    @track filterCaseEndDate = '';
    @track filterCaseDataByLastDays = '';

    @track showModalToAutoAssignCase = false;
    @track caseIdSelected;
    @track sizeAllNewCases;
    @track chart;

    last3months = 90;
    hasNewCase = false;
    sizeNewCasesList = 0;
    isScreenQuoteRequest = true;
    changeTabOrigin = true;
    changeTabNew = true;
    dateFormatted;

    recordId;


    @wire(getRecord, { recordId: userCurrentId, fields: [Name, RoleName, ProfileName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            console.log(`data - ${JSON.stringify(data)} `)
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
            }
        }
    }

    handleSelectNewCases() {
        let classTab = '.button-quote-management-001';
        this.clearFilters();
        this.handleCssTabClear(classTab);
        this.handleChangeTab();
        this.isScreenQuoteRequest = false;
        this.isScreenQuoteRequest = true;
        this.filterByGroup = true;
        this.filterByUser = false;
        this.filterCaseDataByLastDays = '';
        this.filterStatus = 'Novo pedido';


        console.log(`filterByGroup - ${this.filterByGroup}
                ..... filterByUser - ${this.filterByUser}
                ..... isScreenQuoteRequest - ${this.isScreenQuoteRequest} `)

        this.filterCases();
        this.handleCssTabSelected(classTab);

    }

    handleSelectMyCases() {
        let classTab = '.button-quote-management-002';
        this.clearFilters();
        this.handleCssTabClear(classTab);
        this.handleChangeTab();
        this.getDateFormatted(this.last3months);
        this.controlScreenRenderingMyCases();
        this.filterByGroup = false;
        this.filterByUser = true;
        this.filterCaseDataByLastDays = this.dateFormatted;

        // console.log(`filterByGroup - ${this.filterByGroup}
        //         ..... filterByUser - ${this.filterByUser}
        //         ..... isScreenQuoteRequest - ${this.isScreenQuoteRequest} `)
        this.filterCases();
        this.handleCssTabSelected(classTab);
    }

    handleSelectAllCases() {
        let classTab = '.button-quote-management-003';
        this.clearFilters();
        this.handleCssTabClear(classTab);
        this.handleChangeTab();
        this.getDateFormatted(this.last3months);
        this.controlScreenRenderingMyCases();
        this.filterByGroup = false;
        this.filterByUser = false;
        this.filterCaseDataByLastDays = this.dateFormatted;

        // console.log(`filterByGroup - ${this.filterByGroup}
        //         ..... filterByUser - ${this.filterByUser}
        //         ..... isScreenQuoteRequest - ${this.isScreenQuoteRequest} `)
        this.filterCases();
        this.handleCssTabSelected(classTab);
    }

    //Events parant to childs
    filterCases() {
        let filters = this.createObjectFilter();
        console.log('filters in filterCases QuoteOrder', JSON.stringify(filters));
        this.template.querySelector("c-connect-wiz-data-table-placement").filterCases(filters);
        if (!this.isScreenQuoteRequest) {
            this.sendAllCasesToChildChartBar(this.lAllQuotesRequest);
        }

    }

    //events from childs
    filterCasesBySla(event) {
        let response = event.detail;

        // console.log(`response - ${JSON.stringify(response)} `);
        this.filterCasesInsideSLA = response.filterCasesInsideSLA;
        this.filterCasesOutsideSLA = response.filterCasesOutsideSLA;
        this.filterCases();

        // console.log(`response - ${JSON.stringify(response)} `);
    }

    filterStatusCases(event) {
        let response = event.detail;
        this.filterStatus = response.filterStatus;
        // console.log('event in filterstatuscases QuoteManagement', this.filterStatus);
        this.filterCases();
    }

    filterCasesByParams(event) {
        let response = event.detail;
        // console.log('event in filterFieldsParams response', response);
        let filterFieldsParams = {
            valueParamSearch: response.valueParamSearch,
            valueSearch: response.valueSearch
        }

        // console.log('event in filterFieldsParams filterFieldsParams', filterFieldsParams);
        this.filterFieldsParams = filterFieldsParams;
        // console.log('event in filterFieldsParams QuoteManagement', JSON.stringify(this.filterFieldsParams));
        this.filterCases();
    }

    filterCasesByDate(event) {
        let response = event.detail;
        this.filterCaseStartDate = response.selectedDateStartValue;
        this.filterCaseEndDate = response.selectedDateEndValue;
        this.filterCaseDataByLastDays = response.referenceDataByLastDays;

        // console.log('event in filterCasesByDate QuoteManagement', response);
        this.filterCases();
    }

    clearFilters() {
        this.filterStatus = '';
        this.filterFieldsParams = '';
        this.filterCasesInsideSLA = '';
        this.filterCasesOutsideSLA = '';
        this.filterCaseStartDate = '';
        this.filterCaseEndDate = '';
        this.filterCaseDataByLastDays = this.dateFormatted;
        this.handleChangeTab();
        this.filterCases();
    }

    async getCasesFromChildDataTable(event) {
        let result = event.detail;
        this.lAllQuotesRequest = result.lAllQuotesRequest;
        this.lQuotesRequest = await result.lQuotesRequest;
        this.getSizeCasesList(this.lAllQuotesRequest, this.lQuotesRequest);
        this.template.querySelector("c-connect-wiz-search-placement").reRender(this.lQuotesRequest);
    }

    async sendAllCasesToChildCardFilters(listCases, sizeAllCasesSelect, filterByUser, requestOutsideSLA, requestInsideSLA) {
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-cards-filters-placement");
        elt.getCasesFromParentQuoteOrderManagement(listCases, sizeAllCasesSelect, filterByUser, requestOutsideSLA, requestInsideSLA);
    }

    async sendAllCasesToChildChartBar(listCases) {
        await Promise.resolve();
        let filters = this.createObjectFilter();

        if (!this.isScreenQuoteRequest) {
            const elt = this.template.querySelector("c-connect-wiz-container-dashboard-placement");
            elt.getCasesFromParentQuoteOrderManagement(listCases, filters);
        }

    }

    async sendLabelButtonDefault() {
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-container-dashboard-placement");
        elt.getEventLabelButtonDefault();
    }

    //privates functions
    getSizeCasesList(lAllCases, lCases) {
        console.log(` hasNewCase - ${JSON.stringify(this.hasNewCase)} `);
        this.sizeNewCasesList = 0;
        let lstNewCases = lAllCases.filter(
            item => {
                return !item.ownerId.startsWith('005') && item.statusCase === 'Novo pedido';
            }
        )
        this.sizeNewCasesList = Object.keys(lstNewCases).length;
        console.log('list size => ', this.sizeNewCasesList)
        // this.sizeAllNewCases = this.sizeNewCasesList;
        // console.log('list size => ', this.sizeAllNewCases)
        // for(let objCase of lstNewCases){
        //     if(objCase.statusCase == 'Novo pedido'){
        //         this.sizeNewCasesList ++;
        //     }
        // }
        if (this.sizeNewCasesList > 0) {
            this.hasNewCase = true;
        }

        let requestInsideSLA = 0;
        let requestOutsideSLA = 0;

        for (let objQuote of lAllCases) {
            if (this.filterByUser) {
                if (objQuote.ownerId.startsWith(userCurrentId)) {
                    if (objQuote.isViolated) {
                        requestOutsideSLA++;
                    } else {
                        requestInsideSLA++;
                    }
                }
            } else {
                if (objQuote.isViolated) {
                    requestOutsideSLA++;
                } else {
                    requestInsideSLA++;
                }
            }

        }
        // const requestInsideSLA = lCases.reduce((accumulator, item) => {
        //     return accumulator + item.quantityRequestInsideSLA;
        // }, 0);

        // const requestOutsideSLA = lCases.reduce((accumulator, item) => {
        //     return accumulator + item.quantityRequestOutsideSLA;
        // }, 0);

        this.requestOutsideSLA = requestOutsideSLA;
        this.requestInsideSLA = requestInsideSLA;
        this.sizeAllCasesSelect = requestOutsideSLA + requestInsideSLA;
        this.controlScreenRenderingMyCases();
    }

    async getCasesIdToAssignFromChildDataTable(event) {
        this.caseIdSelected = event.detail;
        this.recordId = event.detail.caseId;
        if (this.userProfileName.includes('Gerente')) {
            this.showModalToAssignCase = true;
        } else {
            this.showModalToAssignCase = true;
        }
    }

    async toAssignCase(caseIdSelected, lAllQuotesRequest) {
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-assignment-owner");
        elt.getCaseIdToAssign(caseIdSelected, lAllQuotesRequest);
    }

    async toAutoAssignCase(caseIdSelected) {
        await Promise.resolve();
        const elt = this.template.querySelector("c-connect-wiz-auto-assingment-owner");
        elt.getCaseIdToAssign(caseIdSelected);
    }

    closeModalToAssignCase(event) {
        this.showModalToAssignCase = event.detail;
    }

    closeModalAutoToAssignCase(event) {
        this.showModalToAutoAssignCase = event.detail;
    }

    handleCssTabSelected(className) {

        console.log('className', className);

        let stringCss = 'border-bottom: 2px solid var(--color-border-customer , #EF6C00);';
        stringCss += 'background-color: var(--color-background-customer, #FCFCFC);';
        stringCss += 'color: var(--color-text-customer, #602B00);';


        let e = this.template.querySelector(className);
        e.style.cssText = stringCss;

    }

    handleCssTabClear() {

        let stringCss = 'background-color: var(--color-background-customer, #FCFCFC);';
        stringCss += 'border-bottom: 2px solid var(--color-border-customer , #B7BBBF);';
        stringCss += 'border-top: none;';
        stringCss += 'color: var(--color-text-customer, #353638);';

        console.log('stringCss handleCssTabClear', stringCss);

        let eButton1 = this.template.querySelector('.button-quote-management-001');
        let eButton2 = this.template.querySelector('.button-quote-management-002');
        let eButton3 = this.template.querySelector('.button-quote-management-003');
        eButton1.style.cssText = stringCss;
        eButton2.style.cssText = stringCss;
        eButton3.style.cssText = stringCss;
    }

    handleChangeTab() {
        this.changeTabNew = !this.changeTabOrigin;
    }

    createObjectFilter() {
        let filters = {
            filterByGroup: this.filterByGroup,
            filterByUser: this.filterByUser,
            filterStatus: this.filterStatus,
            filterFields: this.filterFieldsParams,
            filterCasesInsideSLA: this.filterCasesInsideSLA,
            filterCasesOutsideSLA: this.filterCasesOutsideSLA,
            filterCaseStartDate: this.filterCaseStartDate,
            filterCaseEndDate: this.filterCaseEndDate,
            filterCaseDataByLastDays: this.filterCaseDataByLastDays
        };

        return filters;
    }

    controlScreenRenderingMyCases() {
        if (!this.filterByGroup) {
            this.isScreenQuoteRequest = true;
            this.isScreenQuoteRequest = false;
        }
    }

    getDateFormatted(e) {

        const dateTimeNow = new Date();

        console.log('dateTimeNow =>>', dateTimeNow);

        if (e !== undefined && e !== null && e !== '') {
            dateTimeNow.setDate(dateTimeNow.getDate() - e);
            console.log('e =>>', e);
            console.log('dateTimeNow =>>', dateTimeNow);
        }

        dateTimeNow.setMinutes(
            new Date().getMinutes() - new Date().getTimezoneOffset()
        );

        this.dateFormatted = dateTimeNow.toISOString().slice(0, 10);
    }

    renderedCallback() {
        if (!this.isScreenQuoteRequest) {
            this.sendAllCasesToChildCardFilters(this.lAllQuotesRequest, this.sizeAllCasesSelect, this.filterByUser, this.requestOutsideSLA, this.requestInsideSLA);
            this.sendAllCasesToChildChartBar(this.lAllQuotesRequest);
            if (this.changeTabNew !== this.changeTabOrigin) {
                this.sendLabelButtonDefault();
                this.changeTabOrigin = this.changeTabNew;
            }
        }
        if (this.showModalToAssignCase) {
            this.toAssignCase(this.caseIdSelected, this.lAllQuotesRequest);
        }
        if (this.showModalToAutoAssignCase) {
            this.toAutoAssignCase(this.caseIdSelected);
        }
    }

}