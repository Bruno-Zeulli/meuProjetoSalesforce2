import { LightningElement, wire, track, api } from 'lwc';
import getOppsList from '@salesforce/apex/B2U_AgendaMaisListController.getOppsList';

export default class AgendaMais extends LightningElement {
    
    @track oppData;
    @track sortedBy = 'lastModifiedDate';
    @track sortedDirection = 'asc';
    @api db = '';
    @api city = '';
    @api stage = '';
    @api descriptionFilter = '';
    @api offset = 0;

    @wire(getOppsList, { db: '$db', city: '$city', stageName: '$stage', description: '$descriptionFilter', offsetValue: '$offset' } ) 
    opps( {error, data} ){
        if(error){
            window.console.log(error);
        } else if(data){
            this.oppData = data;
        }
    }

    columns = [
        { label: 'Oportunidade', fieldName: 'oppURL', type: 'url', sortable: true, typeAttributes: { label: {fieldName: 'oppName'}, target: '_self' } },
        { label: 'Cliente', fieldName: 'accURL', type: 'url', sortable: true, typeAttributes: { label: {fieldName: 'accName'}, target: '_self' } },
        { label: 'Descrição', fieldName: 'description', type: 'text', sortable: true },
        { label: 'Ramo', fieldName: 'industry', type: 'text', sortable: true },
        { label: 'Quantidade de Funcionários', fieldName: 'employees', type: 'number', sortable: true },
        { label: 'Fase', fieldName: 'stageName', type: 'text', sortable: true},
        { label: 'Data de fechamento', fieldName: 'closeDate', type: 'date', sortable: true },
        { label: 'Última modificação', fieldName: 'lastModifiedDate', type: 'date', sortable: true, typeAttributes:{ year: 'numeric' ,month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' }}
    ];

    updateColumnSorting(event){
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
   }

   sortData(fieldname, direction){
        let parseData = JSON.parse(JSON.stringify(this.oppData));
        let keyValue = (a) => {
            return a[fieldname];
        };

        let isReverse = direction === 'asc' ? 1: -1;

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });

        this.oppData = parseData;
    }
}