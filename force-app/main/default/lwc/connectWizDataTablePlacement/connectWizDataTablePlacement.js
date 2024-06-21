import { api, LightningElement, track } from 'lwc';
import getQuoteRequest from '@salesforce/apex/ConnectWizController.getQuoteRequests';
import userCurrentId from '@salesforce/user/Id'
import sizeOfNumberOfCases from '@salesforce/label/c.MaxSizeQuoteList';

const columns = [
    {
        label: 'Nº Oportunidade',
        hideDefaultActions: true,
        fieldName: 'opportunityNumber',
        type: 'customButtonsTypeOpportunityNumber',
        sortable: true,
        typeAttributes: {
            caseId: { fieldName: 'id' },
            opportunityNumber: { fieldName: 'opportunityNumber' },
            isSelectableCell: true,
            enterpriseName: { fieldName: 'enterpriseName' },
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Produtos',
        hideDefaultActions: true,
        fieldName: 'produto',
        type: 'customButtonsTypeProduct',
        sortable: true,
        typeAttributes: {
            produto: { fieldName: 'produto' },
            caseId: { fieldName: 'id' },
            isProduto: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Nome do Cliente',
        hideDefaultActions: true,
        fieldName: 'name',
        sortable: true,
        wrapText: true,
        type: 'customButtonsTypeCustomerName',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            name: { fieldName: 'name' },
            isSelectableCell: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Cotações',
        hideDefaultActions: true,
        fieldName: 'cotacoes',
        type: 'customButtonsTypeQuote',
        sortable: true,
        typeAttributes: {
            solicitadas: { fieldName: 'quotesRequest' },
            recebidas: { fieldName: 'quotesReceived' },
            requestInsideSLA: { fieldName: 'requestInsideSLA' },
            requestOutsideSLA: { fieldName: 'requestOutsideSLA' },
            caseId: { fieldName: 'id' },
            isCotacoes: true,
            selectedInsideSLA: { fieldName: 'selectedInsideSLA' },
            selectedOutsideSLA: { fieldName: 'selectedOutsideSLA' },
            selectedAllSLA: { fieldName: 'selectedAllSLA' }
        }, cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Status',
        hideDefaultActions: true,
        fieldName: 'status',
        sortable: true,
        type: 'customButtonsTypeStatus',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            status: { fieldName: 'status' },
            isSelectableCell: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Origem',
        hideDefaultActions: true,
        fieldName: 'leadSource',
        sortable: true,
        type: 'customButtonsTypeLeadSource',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            leadSource: { fieldName: 'leadSource' },
            isLeadSource: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    },
    {
        label: 'Data da Criação',
        hideDefaultActions: true,
        fieldName: 'createdDate',
        sortable: true,
        type: 'customButtonsTypeCreatedDate',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            createdDate: { fieldName: 'createdDate' },
            isSelectableCell: true,

        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Última Modificação',
        hideDefaultActions: true,
        fieldName: 'modifiedAt',
        sortable: true,
        wrapText: true,
        type: 'customButtonsTypeModifiedAt',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            modifiedAt: { fieldName: 'modifiedAt' },
            isSelectableCell: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        label: 'Responsável',
        hideDefaultActions: true,
        fieldName: 'assignedTo',
        sortable: true,
        wrapText: true,
        type: 'customButtonsTypeOwner',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            owner: { fieldName: 'owner' },
            isSelectableCell: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
    }, {
        label: 'Comercial',
        hideDefaultActions: true,
        fieldName: 'comercialName',
        sortable: true,
        wrapText: true,
        type: 'customButtonsComercialName',
        typeAttributes: {
            comercialName: { fieldName: 'comercialName' },
            salesUnit: { fieldName: 'salesUnit' },
            isComercial: true,
        },
        cellAttributes: {
            class: 'datatable-CellColor'
        }
    }, {
        hideDefaultActions: true,
        fieldName: 'id',
        type: 'customButtonsTypeToAssign',
        typeAttributes: {
            caseId: { fieldName: 'id' },
            isToAssign: true
        }, cellAttributes: {
            class: 'datatable-CellColor'
        }
    }
];

export default class ConnectWizDataTablePlacement extends LightningElement {
    @track lQuotesRequest;
    // isScreenQuoteRequest = true;
    isLoading = false;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    @track lAllQuotesRequest = [];
    data = [];
    // dataNew=[];
    filtersSLA;
    columns = columns;
    sizeNewCasesList;
    sortedBy;
    caseIdSelected;
    selectedInsideSLA;
    selectedOutsideSLA;
    selectedAllSLA;

    visibleCases


    connectedCallback() {
        this.handleLoading(true);
        this.getAllData()
        let dataFilter = {
            filterByGroup: true,
            filterByUser: false,
            filterCaseDataByLastDays: "",
            filterCaseEndDate: "",
            filterCaseStartDate: "",
            filterCasesInsideSLA: "",
            filterCasesOutsideSLA: "",
            filterFields: "",
            filterStatus: "Novo pedido"
        }
        setTimeout(() => {
            this.filterCases(dataFilter)
        }, 2000);

        // this.getQuoteRequestLWC();
    }

    getAllData() {
        getQuoteRequest()
            .then(async success => {
                try {
                    this.lAllQuotesRequest = JSON.parse(success);
                    // console.log('data completa: ', this.lAllQuotesRequest);
                } catch (error) {
                    this.loader = false;
                    console.log('error =>', error);
                    this.handleLoading(false);
                }

            })
            .catch(error => console.log(error));
        this.handleLoading(false);
    }
    getQuoteRequestLWC() {
        this.sendCasesToParent(this.lAllQuotesRequest);
        this.getColumns();
        let lCases = JSON.parse(JSON.stringify(this.lAllQuotesRequest));
        let newCases = [];
        // console.log('lCases =>',lCases);
        lCases = lCases.filter(
            item => {
                return !item.ownerId.startsWith('005');
            }
        )
        this.lQuotesRequest = lCases;
        for (let objCase of this.lQuotesRequest) {
            if (objCase.statusCase == 'Novo pedido') {
                newCases = [...newCases, objCase];
            }
        }
        this.sendCasesToParent(this.lAllQuotesRequest, newCases);

        // setTimeout(() => {
        //     console.log('chegou no setTimeout')
        //     let dataFilter = {
        //         filterByGroup:true,
        //         filterByUser:false,
        //         filterCaseDataByLastDays:"",
        //         filterCaseEndDate: "",
        //         filterCaseStartDate: "",
        //         filterCasesInsideSLA: "",
        //         filterCasesOutsideSLA: "",
        //         filterFields: "",
        //         filterStatus: ""
        //     }
        //     this.filterCases(dataFilter)
        // }, 1000)

        this.handleLoading(false);


    }

    getData(data) {
        //  if(this.isScreenQuoteRequest){
        //     for(let i=0; i < data.length ;i++)
        //     {
        //         if(data[i].statusCase == 'Novo pedido') {
        //             this.dataNew = [...this.dataNew,{
        //             opportunityNumber: data[i].opportunityNumber,
        //             produto: data[i].productComboName,
        //             name: data[i].accountName,
        //             quotesRequest : data[i].quantityQuoteRequest,
        //             quotesReceived : data[i].quantityQuoteReceipt,
        //             status : data[i].statusCase,
        //             createdDate : data[i].createDate,
        //             strCreatedDate : data[i].strCreateDate,
        //             modifiedAt : data[i].lastModifiedDate + "\n" + data[i].lastModifiedName,
        //             // source : data[i].originCase,
        //             assignedTo : data[i].ownerName,
        //             requestInsideSLA : data[i].quantityRequestInsideSLA,
        //             requestOutsideSLA : data[i].quantityRequestOutsideSLA,
        //             id : data[i].caseId,
        //             selectedInsideSLA : this.selectedInsideSLA,
        //             selectedOutsideSLA : this.selectedOutsideSLA,
        //             isVioleted : data[i].isVioleted,
        //             selectedAllSLA : this.selectedAllSLA,
        //             enterpriseName : data[i].enterpriseName,
        //             comercialName : data[i].comercialName,
        //             salesUnit : data[i].salesUnit,
        //             leadSource : data[i].leadSource
        //         }];
        //         }
        //     }
        // }else{
        for (let i = 0; i < data.length; i++) {
            this.data = [...this.data, {
                opportunityNumber: data[i].opportunityNumber,
                produto: data[i].productComboName,
                name: data[i].accountName,
                quotesRequest: data[i].quantityQuoteRequest,
                quotesReceived: data[i].quantityQuoteReceipt,
                status: data[i].statusCase,
                createdDate: data[i].createDate,
                strCreatedDate: data[i].strCreateDate,
                modifiedAt: data[i].lastModifiedDate + "\n" + data[i].lastModifiedName,
                // source : data[i].originCase,
                assignedTo: data[i].ownerName,
                requestInsideSLA: data[i].quantityRequestInsideSLA,
                requestOutsideSLA: data[i].quantityRequestOutsideSLA,
                id: data[i].caseId,
                selectedInsideSLA: this.selectedInsideSLA,
                selectedOutsideSLA: this.selectedOutsideSLA,
                isVioleted: data[i].isVioleted,
                selectedAllSLA: this.selectedAllSLA,
                enterpriseName: data[i].enterpriseName,
                comercialName: data[i].comercialName,
                salesUnit: data[i].salesUnit,
                leadSource: data[i].leadSource
            }];
        }
        // }
        console.log('values ' + JSON.stringify(this.data));
        // console.log('values ' + JSON.stringify(this.dataNew));
    }

    getCaseId(event) {
        const selectedRows = event.detail.selectedRows;
        console.log('You selected: ' + JSON.stringify(selectedRows));
    }

    handleRowSelection(event) {
        const ev = event.detail;
        console.log('CUSTOM TYPE A - ' + JSON.stringify(ev));
    }

    getCaseIdToAssign(event) {
        this.caseIdSelected = event.detail;
        this.sendCaseIdToAssign(this.caseIdSelected);
    }

    sendCaseIdToAssign(caseIdSelected) {
        const selectedEvent = new CustomEvent("sendcaseidtoassign", {
            detail: caseIdSelected
        });
        this.dispatchEvent(selectedEvent);
    }

    @api async filterCases(filters) {
        this.isScreenQuoteRequest = false;
        let lCases = JSON.parse(JSON.stringify(this.lAllQuotesRequest));
        let quotesInsedeSLA = [];
        let quotesOutsideSLA = [];

        //filters by Groups or users from tabs container Quote Order Management
        if (!filters.filterByGroup && filters.filterByUser) {
            lCases = lCases.filter(
                item => {
                    return item.ownerId.startsWith(userCurrentId);
                }
            );

        } else if (filters.filterByGroup && !filters.filterByUser) {
            lCases = lCases.filter(
                item => {
                    return !item.ownerId.startsWith('005');
                }
            );
            this.isScreenQuoteRequest = true;
        }

        //filters by status from chart container
        if (filters.filterStatus !== '') {
            lCases = lCases.filter(item => item.statusCase === filters.filterStatus);
        }

        //filters by cards SLA
        if (!filters.filterCasesInsideSLA && !filters.filterCasesOutsideSLA) {
            this.selectedInsideSLA = false;
            this.selectedOutsideSLA = false;
            this.selectedAllSLA = true;
        }
        else if (filters.filterCasesInsideSLA && !filters.filterCasesOutsideSLA) {
            this.selectedInsideSLA = true;
            this.selectedOutsideSLA = false;
            this.selectedAllSLA = false;
            for (let objQuote of lCases) {
                if (!objQuote.isViolated) {
                    quotesInsedeSLA.push(objQuote);
                }
            }
        }
        else if (!filters.filterCasesInsideSLA && filters.filterCasesOutsideSLA) {
            this.selectedInsideSLA = false;
            this.selectedOutsideSLA = true;
            this.selectedAllSLA = false;
            for (let objQuote of lCases) {
                if (objQuote.isViolated) {
                    quotesOutsideSLA.push(objQuote);
                }
            }
        }

        //filters by button Search
        if (filters.filterFields !== '' && filters.filterFields.valueSearch !== '') {
            lCases = this.filterCaseByButtonSearch(filters, lCases);
        }

        //filters by button Date
        if (filters.filterCaseStartDate !== '' && filters.filterCaseEndDate !== '') {
            lCases = lCases.filter(item => {
                return item.createDate >= filters.filterCaseStartDate && item.createDate <= filters.filterCaseEndDate
            });

        } else if (filters.filterCaseDataByLastDays !== '') {
            lCases = lCases.filter(item => {
                return item.createDate >= filters.filterCaseDataByLastDays
            });
        }

        if (filters.filterCasesInsideSLA) {
            this.lQuotesRequest = quotesInsedeSLA;
        } else if (filters.filterCasesOutsideSLA) {
            this.lQuotesRequest = quotesOutsideSLA;
        } else {
            this.lQuotesRequest = lCases;
        }

        await this.sendCasesToParent(this.lAllQuotesRequest, this.lQuotesRequest);
        this.getColumns();
    }

    async sendCasesToParent(lAllCases, lCases) {
        let dataCases = {
            lAllQuotesRequest: lAllCases,
            lQuotesRequest: lCases
        }
        //console.log('Chegou no meio do sendCasesToParent')
        const selectedEvent = new CustomEvent("getcasesfromchilddatatable", {
            detail: dataCases
        });
        this.dispatchEvent(selectedEvent);
    }

    filterCaseByButtonSearch(filters, lCases) {
        //console.log('chegou aqui: filterCaseByButtonSearch')
        let valueSearchUpperCase = filters.filterFields.valueSearch.toUpperCase();
        let valueSearchLowerCase = filters.filterFields.valueSearch.toLowerCase();
        let valueSearchStartUpperCase = filters.filterFields.valueSearch[0].toUpperCase() + filters.filterFields.valueSearch.substring(1);

        let getKeyWithUpperCase = this.getFilteredCasesByParams(filters, lCases, valueSearchUpperCase);
        let getKeyLowerCase = this.getFilteredCasesByParams(filters, lCases, valueSearchLowerCase);
        let getKeyStartUpperCase = this.getFilteredCasesByParams(filters, lCases, valueSearchStartUpperCase);

        let mapCasesByCaseId = new Map();

        if (getKeyWithUpperCase.length > 0) {
            getKeyWithUpperCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }
        if (getKeyLowerCase.length > 0) {
            getKeyLowerCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }
        if (getKeyStartUpperCase.length > 0) {
            getKeyStartUpperCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }

        console.log(`[...mapCasesByCaseId.values()] ==> ${JSON.stringify([...mapCasesByCaseId.values()])}`);
        return [...mapCasesByCaseId.values()];
    }


    getFilteredCasesByParams(filters, lCases, valueSearch) {

        console.log(`filters in getFilteredCasesByParams ==> ${JSON.stringify(filters)}`);
        console.log(`lCases in getFilteredCasesByParams ==> ${JSON.stringify(lCases)}`);
        console.log(`valueSearch in getFilteredCasesByParams ==> ${JSON.stringify(valueSearch)}`);

        let lFilteredCases = lCases.filter(
            item => {
                if (filters.filterFields.valueParamSearch == 'productComboName' && item.productComboName !== null) {
                    return item.productComboName.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'accountName' && item.accountName !== null) {
                    return item.accountName.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'originCase' && item.originCase !== null) {
                    return item.originCase.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'ownerName' && item.ownerName !== null) {
                    return item.ownerName.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'accountIdentificationNumber' && item.accountIdentificationNumber !== null) {
                    return item.accountIdentificationNumber.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'statusCase' && item.statusCase !== null) {
                    return item.statusCase.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'enterpriseName' && item.enterpriseName !== null) {
                    return item.enterpriseName.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'comercialName' && item.comercialName !== null) {
                    return item.comercialName.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'leadSource' && item.leadSource !== null) {
                    return item.leadSource.includes(valueSearch);
                }
                if (filters.filterFields.valueParamSearch == 'opportunityNumber' && item.opportunityNumber !== null) {
                    return item.opportunityNumber.includes(valueSearch);
                }
            }
        );

        return lFilteredCases;
    }

    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];
        // if(this.isScreenQuoteRequest){
        //     const cloneData = [...this.dataNew];
        // }else{
        //     const cloneData = [...this.data];
        // }
        // const cloneData = this.isScreenQuoteRequest ? [...this.dataNew] :[...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        // if(this.isScreenQuoteRequest){
        //     this.data = cloneData;

        // }else{
        //     this.data = cloneData;

        // }
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleLoading(event) {
        this.isLoading = event;
        console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    updatePaginationCaseHandler(event) {
        console.log(`passou em updatePaginationCaseHandler: ==> ${event.detail.records}`);
        this.visibleCases = [...event.detail.records]
        console.log(event.detail.records);
        this.data = [];
        // this.dataNew = [];
        this.getData(this.visibleCases);
    }

    getColumns() {
        this.columns = [];
        if (this.isScreenQuoteRequest) {
            this.columns = [...this.columns, {
                label: 'Nº Oportunidade',
                hideDefaultActions: true,
                fieldName: 'opportunityNumber',
                type: 'customButtonsTypeOpportunityNumber',
                sortable: true,
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    opportunityNumber: { fieldName: 'opportunityNumber' },
                    isSelectableCell: true,
                    enterpriseName: { fieldName: 'enterpriseName' },
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Produtos',
                hideDefaultActions: true,
                fieldName: 'produto',
                type: 'customButtonsTypeProduct',
                sortable: true,
                wrapText: true,
                typeAttributes: {
                    produto: { fieldName: 'produto' },
                    caseId: { fieldName: 'id' },
                    isProduto: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Nome do Cliente',
                hideDefaultActions: true,
                fieldName: 'name',
                sortable: true,
                wrapText: true,
                type: 'customButtonsTypeCustomerName',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    name: { fieldName: 'name' },
                    isSelectableCell: true,
                },
                fieldName: 'name',
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Status',
                hideDefaultActions: true,
                fieldName: 'status',
                sortable: true,
                type: 'customButtonsTypeStatus',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    status: { fieldName: 'status' },
                    isSelectableCell: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Data da Criação',
                hideDefaultActions: true,
                fieldName: 'strCreatedDate',
                sortable: true,
                type: 'customButtonsTypeCreatedDate',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    createdDate: { fieldName: 'createdDate' },
                    strCreatedDate: { fieldName: 'strCreatedDate' },
                    isSelectableCell: true,

                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Última Modificação',
                hideDefaultActions: true,
                fieldName: 'modifiedAt',
                sortable: true,
                wrapText: true,
                type: 'customButtonsTypeModifiedAt',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    modifiedAt: { fieldName: 'modifiedAt' },
                    isSelectableCell: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Comercial',
                hideDefaultActions: true,
                fieldName: 'comercialName',
                sortable: true,
                wrapText: true,
                type: 'customButtonsComercialName',
                typeAttributes: {
                    comercialName: { fieldName: 'comercialName' },
                    salesUnit: { fieldName: 'salesUnit' },
                    isComercial: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                hideDefaultActions: true,
                fieldName: 'id',
                type: 'customButtonsTypeToAssign',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    isToAssign: true
                }, cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }];
        } else if (!this.isScreenQuoteRequest) {
            this.columns = [...this.columns, {
                label: 'Nº Oportunidade',
                hideDefaultActions: true,
                fieldName: 'opportunityNumber',
                type: 'customButtonsTypeOpportunityNumber',
                sortable: true,
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    opportunityNumber: { fieldName: 'opportunityNumber' },
                    isSelectableCell: true,
                    enterpriseName: { fieldName: 'enterpriseName' },
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Produtos',
                hideDefaultActions: true,
                fieldName: 'produto',
                type: 'customButtonsTypeProduct',
                sortable: true,
                wrapText: true,
                typeAttributes: {
                    produto: { fieldName: 'produto' },
                    caseId: { fieldName: 'id' },
                    isProduto: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Nome do Cliente',
                hideDefaultActions: true,
                fieldName: 'name',
                sortable: true,
                wrapText: true,
                type: 'customButtonsTypeCustomerName',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    name: { fieldName: 'name' },
                    isSelectableCell: true,
                },
                fieldName: 'name',
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Cotações',
                hideDefaultActions: true,
                fieldName: 'cotacoes',
                type: 'customButtonsTypeQuote',
                sortable: true,
                typeAttributes: {
                    solicitadas: { fieldName: 'quotesRequest' },
                    recebidas: { fieldName: 'quotesReceived' },
                    requestInsideSLA: { fieldName: 'requestInsideSLA' },
                    requestOutsideSLA: { fieldName: 'requestOutsideSLA' },
                    caseId: { fieldName: 'id' },
                    isCotacoes: true,
                    selectedInsideSLA: { fieldName: 'selectedInsideSLA' },
                    selectedOutsideSLA: { fieldName: 'selectedOutsideSLA' },
                    selectedAllSLA: { fieldName: 'selectedAllSLA' }
                }, cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Status',
                hideDefaultActions: true,
                fieldName: 'status',
                sortable: true,
                type: 'customButtonsTypeStatus',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    status: { fieldName: 'status' },
                    isSelectableCell: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Data da Criação',
                hideDefaultActions: true,
                fieldName: 'strCreatedDate',
                sortable: true,
                type: 'customButtonsTypeCreatedDate',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    createdDate: { fieldName: 'createdDate' },
                    strCreatedDate: { fieldName: 'strCreatedDate' },
                    isSelectableCell: true,

                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Última Modificação',
                hideDefaultActions: true,
                fieldName: 'modifiedAt',
                sortable: true,
                wrapText: true,
                type: 'customButtonsTypeModifiedAt',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    modifiedAt: { fieldName: 'modifiedAt' },
                    isSelectableCell: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Comercial',
                hideDefaultActions: true,
                fieldName: 'comercialName',
                sortable: true,
                wrapText: true,
                type: 'customButtonsComercialName',
                typeAttributes: {
                    comercialName: { fieldName: 'comercialName' },
                    salesUnit: { fieldName: 'salesUnit' },
                    isComercial: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }, {
                label: 'Responsável',
                hideDefaultActions: true,
                fieldName: 'assignedTo',
                sortable: true,
                wrapText: true,
                type: 'customButtonsTypeOwner',
                typeAttributes: {
                    caseId: { fieldName: 'id' },
                    owner: { fieldName: 'assignedTo' },
                    isSelectableCell: true,
                },
                cellAttributes: {
                    class: 'datatable-CellColor'
                }
            }];
        }
    }
}