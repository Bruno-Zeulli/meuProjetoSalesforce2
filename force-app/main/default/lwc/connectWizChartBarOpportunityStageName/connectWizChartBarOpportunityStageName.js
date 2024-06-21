import { api, LightningElement, track, wire} from 'lwc'
import chartjs from '@salesforce/resourceUrl/chartJs';
import {loadScript} from 'lightning/platformResourceLoader';
import { showToast } from 'c/util';
// import getQuoteRequest from '@salesforce/apex/ConnectWizController.getQuoteRequests'
import { getObjectInfo, getPicklistValuesByRecordType  } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import userCurrentId from '@salesforce/user/Id'

export default class ConnectWizChartBarOpportunityStageName extends LightningElement {
    @api objectApiName;
    @track lQuotesRequest;
    @track objectInfo;
    @track recordTypeId;
    @track lStatus = [];
    @track filters;
    @track lAllQuotesRequest;
    chartjsInitialized = false;
    mapCountCaseByStatus;
    lCountCase = [];
    lDataStatus;
    @track chart;
    listCase;
    isRenderedChart = false;
    isLoading = false;

    // Add colors na ordem do status case/lStatus para atribuir ao legend
    lColors = [
        'rgb(131, 134, 138)',
        'rgb(0,47,81)',
        'rgb(196,86,0)',
        'rgb(23,82,150)',
        'rgb(90, 53, 136)',
        'rgb(246,172,60)',
        'rgb(0,143,248)',
        'rgb(0,112,25)',
        'rgb(224,7,7)'
    ];

    config = {
        type: 'bar',
        data: {
            labels: null,
            datasets: [{
                data: null,
                backgroundColor: this.lColors
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            barPercentage: 0.995,
            categoryPercentage: 1,
            plugins: {
                legend: {
                    display: false
                }
            },
            animation: {
                animateScale: true,
                animateRotate: true
            },
            tooltips: {
                enabled	: true,

            },
            scales: {
                x:{
                    display: false,
                    stacked: false
                },
                y:{
                    stacked: false,
                    grid : {
                        display : false
                    }
                },
            },
            borderRadius: {
                topLeft: 4,
                topRight: 4
            }
        },
    };

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo({error, data}){
        if(data){
            this.handleLoading(true);
            var listRT = data.recordTypeInfos;
            this.recordTypeId = Object.keys(listRT).find(rt => listRT[rt].name === 'Corporate - Célula Técnica');
            // console.log('RTId corporate => ' + this.recordTypeId);
        }
        else if(error){
            window.console.log('error: '+JSON.stringify(error));
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: CASE_OBJECT, recordTypeId: "$recordTypeId"})
    getStatusPicklistValues({error, data}){
        if(data){

            // console.log('data ' + JSON.stringify(data));
            // console.log('data.picklistFieldValues.CaseStatus ' + JSON.stringify(data.picklistFieldValues.Status.values));

            data.picklistFieldValues.Status.values.forEach(item => {
                this.lStatus.push(item.label);
            })
            // console.log('this.lStatus ' + JSON.stringify(this.lStatus));
            this.filterCases(this.filters);
        }
        else if(error){
            window.console.log('error =====> '+JSON.stringify(error));
        }
    }

    @api async getCasesFromParentContainerDashboard(listCases, filters){
        this.handleLoading(true);
        this.lAllQuotesRequest = listCases;
        this.filters = filters;
        this.filterCases(this.filters);
    }

    filterCases(filters){
        let lCases = JSON.parse(JSON.stringify(this.lAllQuotesRequest));

        //filters by Groups or users from tabs container Quote Order Management
        if(!filters.filterByGroup &&  filters.filterByUser){
            lCases = lCases.filter(
                item => {
                    return item.ownerId.includes(userCurrentId);
                }
            );

        } else if(filters.filterByGroup && !filters.filterByUser){
            lCases = lCases.filter(
                item => {
                    return !item.ownerId.includes('005');
                }
            );
        }

        //filters by status from chart container
        if(filters.filterStatus !== ''){
            lCases = lCases.filter( item => item.statusCase == filters.filterStatus);
        }

        //filters by cards SLA
        if(!filters.filterCasesInsideSLA && !filters.filterCasesOutsideSLA){
            this.selectedInsideSLA = false;
            this.selectedOutsideSLA = false;
            this.selectedAllSLA = true;
        }
        else if(filters.filterCasesInsideSLA && !filters.filterCasesOutsideSLA){
            this.selectedInsideSLA = true;
            this.selectedOutsideSLA = false;
            this.selectedAllSLA = false;
        }
        else if(!filters.filterCasesInsideSLA && filters.filterCasesOutsideSLA){
            this.selectedInsideSLA = false;
            this.selectedOutsideSLA = true;
            this.selectedAllSLA = false;
        }

        //filters by button Search
        if(filters.filterFields !== '' && filters.filterFields.valueSearch !== ''){
            lCases = this.filterCaseByButtonSearch(filters, lCases);
        }

        //filters by button Date
        if(filters.filterCaseStartDate !== ''  && filters.filterCaseEndDate !== ''){
            lCases = lCases.filter( item => {
                return item.createDate >= filters.filterCaseStartDate && item.createDate <= filters.filterCaseEndDate
            });

        } else if(filters.filterCaseDataByLastDays !== ''){
            lCases = lCases.filter( item => {
                return item.createDate >= filters.filterCaseDataByLastDays
            });
        }

        this.lQuotesRequest = [];
        this.lQuotesRequest = lCases;
        this.getData(this.lQuotesRequest);
    }

    getData(){
        this.mapCountCaseByStatus = this.createMapCasesByStatus(this.lQuotesRequest);
        this.lCountCase = [];
        this.lDataStatus = [];

        this.lStatus.forEach(item => {
            if(item ===  'Novo pedido'){
                this.lQuotesRequest = this.lQuotesRequest.filter(
                    item => {
                        return item.statusCase.includes('Novo pedido');
                    }
                )
                let size = Object.keys(this.lQuotesRequest).length;
                this.lCountCase.push(size);
            } else if(this.mapCountCaseByStatus.has(item)){
                this.lCountCase.push(this.mapCountCaseByStatus.get(item));
            } else{
                this.lCountCase.push(0);
            }
        })

        let convertList = this.lCountCase.toString();
        convertList = convertList.split(',');
        this.lDataStatus = Array.from(convertList);
        // console.log('lDataStatus Size  ' + JSON.stringify(Object.keys(this.lDataStatus).length));
        // console.log('lDataStatus ' + JSON.stringify(this.lDataStatus));
        if(Object.keys(this.lDataStatus).length > 0 && this.lDataStatus[0] !== ''){
            // console.log('this.chart ' + JSON.stringify(this.lDataStatus));
            // console.log('this.lStatus' + JSON.stringify(this.lStatus));
            this.renderedDataChart(this.chart, this.lStatus, this.lDataStatus);
        }

    }

    createMapCasesByStatus(listCases){

        let mapCountCaseByStatus = new Map();
        let countCase = 1;

        listCases.forEach(item => {
            if(mapCountCaseByStatus.has(item.statusCase)){
                let countCase = mapCountCaseByStatus.get(item.statusCase);
                countCase++;
                mapCountCaseByStatus.set(item.statusCase, countCase);
            } else{
                mapCountCaseByStatus.set(item.statusCase, countCase);
            }
        })

        return mapCountCaseByStatus;
    }

    createMapColorsByStatus(lStatus){

        let mapColorsByStatus = new Map();
        for(let i; lStatus.length <= i; i++){
            mapColorsByStatus.set(lStatus[i], this.lColors[i]);
        }
    }

    filterCaseByButtonSearch(filters, lCases){
        let valueSearchUpperCase = filters.filterFields.valueSearch.toUpperCase();
        let valueSearchLowerCase = filters.filterFields.valueSearch.toLowerCase();
        let valueSearchStartUpperCase = filters.filterFields.valueSearch[0].toUpperCase() + filters.filterFields.valueSearch.substring(1);

        let getKeyWithUpperCase = this.getFilteredCasesByParams(filters, lCases, valueSearchUpperCase);
        let getKeyLowerCase = this.getFilteredCasesByParams(filters, lCases, valueSearchLowerCase);
        let getKeyStartUpperCase = this.getFilteredCasesByParams(filters, lCases, valueSearchStartUpperCase);

        let mapCasesByCaseId = new Map();

        if(getKeyWithUpperCase.length > 0){
            getKeyWithUpperCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }
        if(getKeyLowerCase.length > 0){
            getKeyLowerCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }
        if(getKeyStartUpperCase.length > 0){
            getKeyStartUpperCase.forEach(item => {
                mapCasesByCaseId.set(item.caseId, item);
            });
        }

        console.log(`[...mapCasesByCaseId.values()] ==> ${JSON.stringify([...mapCasesByCaseId.values()])}`);
        return [...mapCasesByCaseId.values()];
    }


    getFilteredCasesByParams(filters, lCases, valueSearch){

        // console.log(`filters in getFilteredCasesByParams ==> ${JSON.stringify(filters)}`);
        // console.log(`lCases in getFilteredCasesByParams ==> ${JSON.stringify(lCases)}`);
        // console.log(`valueSearch in getFilteredCasesByParams ==> ${JSON.stringify(valueSearch)}`);

        let lFilteredCases = lCases.filter(
            item => {
                if(filters.filterFields.valueParamSearch == 'productComboName' && item.productComboName !== null){
                    return item.productComboName.includes(valueSearch);
                }
                if(filters.filterFields.valueParamSearch == 'accountName' && item.accountName !== null){
                    return item.accountName.includes(valueSearch);
                }
                if(filters.filterFields.valueParamSearch == 'originCase' && item.originCase !== null){
                    return item.originCase.includes(valueSearch);
                }
                if(filters.filterFields.valueParamSearch == 'ownerName' && item.ownerName !== null){
                    return item.ownerName.includes(valueSearch);
                }
                if(filters.filterFields.valueParamSearch == 'accountIdentificationNumber' && item.accountIdentificationNumber !== null){
                    return item.accountIdentificationNumber.includes(valueSearch);
                }
                if(filters.filterFields.valueParamSearch == 'statusCase' && item.statusCase !== null){
                    return item.statusCase.includes(valueSearch);
                }
            }
        );

        return lFilteredCases;
    }

    handleLoading(event){
        this.isLoading = event;
        // console.log(`this.isLoading: ==> ${this.isLoading}`);
    }

    renderedDataChart(chart, label, data){

        // console.log(`chart in updateDataChart - ${chart} `);
        // console.log(`chart in label - ${label} `);

        if(chart === undefined){
            // console.log(`chart in updateDataChart else - ${JSON.stringify(chart)} `);
            Promise.all([loadScript(this, chartjs)])
            .then(() => {
                const canvas = document.createElement('canvas');
                if(this.template.querySelector('canvas')){
                    this.template.querySelector('canvas').remove();
                }
                this.template.querySelector('div.chart').appendChild(canvas);
                const ctx = canvas.getContext('2d');
                chart = new window.Chart(ctx, this.config);
                chart.data.labels = label;
                chart.data.datasets[0].data = data;
                chart.update();
                chart.resize();
                this.chart = chart;
                this.handleLoading(false);
            })
            .catch((error) => {
                showToast('Erro', error.message, 'error', this);
                this.handleLoading(false);
            });
        }else{
            Promise.all([loadScript(this, chartjs)])
                .then(() => {
                    // console.log(`chart in updateDataChart - ${chart}`);
                    // console.log(`chart in chart.data.datasets[0].data - ${JSON.stringify(chart.data.datasets[0].data)}`);
                    // console.log(`chart.data.labels.push(label); - ${JSON.stringify(label)}`);
                    chart.data.labels = label;
                    chart.data.datasets[0].data = data;
                    chart.update();
                    chart.resize();
                    this.handleLoading(false);
                })
                .catch((error) => {
                    showToast('Erro', error.message, 'error', this);
                    this.handleLoading(false);
                });

        }
    }
}