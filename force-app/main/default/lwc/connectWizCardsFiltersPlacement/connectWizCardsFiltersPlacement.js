import { LightningElement, track, api } from 'lwc';

export default class ConnectWizCardsFiltersPlacement extends LightningElement {

    @track filterCasesInsideSLA = false;
    @track filterCasesOutsideSLA = false;
    @track filterByUser = false;
    @track listCases;
    @track requestOutsideSLA;
    @track requestInsideSLA;
    sizeAllCasesSelect;

    connectedCallback() {
        this.handleLoading(true);
        this.getCasesFromParentQuoteOrderManagement();
        this.handleLoading(false);
    }

    handleSelectAllCasesSLA() {
        let classTButton = '.bnt-all-case-sla';
        this.handleCssButtonClear();
        this.filterCasesInsideSLA = false;
        this.filterCasesOutsideSLA = false;
        this.handleCssButtonSelected(classTButton);
        this.filterCases();
        //console.log(`filterCasesInsideSLA - ${this.filterCasesInsideSLA}
        //           .... filterCasesOutsideSLA ${this.filterCasesOutsideSLA} `)
    }

    handleSelectInsideSLA() {
        let classTButton = '.bnt-case-inside-sla';
        this.handleCssButtonClear();
        this.filterCasesInsideSLA = true;
        this.filterCasesOutsideSLA = false;
        this.handleCssButtonSelected(classTButton);
        this.filterCases();
    }

    handleSelectOutsideSLA() {
        let classTButton = '.bnt-case-outside-sla';
        this.handleCssButtonClear();
        this.filterCasesInsideSLA = false;
        this.filterCasesOutsideSLA = true;
        this.handleCssButtonSelected(classTButton);
        this.filterCases();
    }

    filterCases() {
        let filters = {
            filterCasesInsideSLA: this.filterCasesInsideSLA,
            filterCasesOutsideSLA: this.filterCasesOutsideSLA,
            filterByUser: this.filterByUser
        };

        // console.log(`filters - ${JSON.stringify(filters)} `)

        const selectedEvent = new CustomEvent("filtercasesbysla", {
            detail: filters
        });

        //console.log(`selectedEvent - ${JSON.stringify(selectedEvent)} `)
        this.dispatchEvent(selectedEvent);
    }


    @api async getCasesFromParentQuoteOrderManagement(listCases, sizeAllCasesSelect, filterByUser, requestOutsideSLA, requestInsideSLA) {
        this.sizeAllCasesSelect = sizeAllCasesSelect;
        this.filterByUser = filterByUser;
        this.requestInsideSLA = requestInsideSLA;
        this.requestOutsideSLA = requestOutsideSLA;

        //console.log(`sizeAllCasesSelect - ${this.sizeAllCasesSelect} `)
    }

    handleCssButtonSelected(className) {

        //console.log('className', className);

        let stringCss = 'color: var(--color-text-customer, #353638);';
        stringCss += 'background-color: var(--color-background-customer, #FFE1CA);';
        stringCss += 'border: 2px solid var(--color-border-customer , #f64c00);';

        let e = this.template.querySelector(className);
        e.style.cssText = stringCss;

    }

    handleCssButtonClear() {

        let stringCss = 'background-color: var(--color-background-customer, #FCFCFC);';
        stringCss += 'border: 1px solid var(--color-border-customer , #50555A);';
        stringCss += ' color: var(--color-text-customer, #8F4100);';

        //console.log('stringCss handleCssButtonClear', stringCss);

        let eButton1 = this.template.querySelector('.bnt-all-case-sla');
        let eButton2 = this.template.querySelector('.bnt-case-inside-sla');
        let eButton3 = this.template.querySelector('.bnt-case-outside-sla');
        eButton1.style.cssText = stringCss;
        eButton2.style.cssText = stringCss;
        eButton3.style.cssText = stringCss;
    }

    handleLoading(event) {
        this.isLoading = event;
    }
}