import { LightningElement, wire, track, api } from 'lwc';
import getLocations from '@salesforce/apex/B2U_AgendaMaisMapController.getLocations';

export default class AgendaMaisMap extends LightningElement {
    
    markersTitle = 'Clientes';
    @track mapMarkers = [];
    @api db = '';
    @api city = '';
    @api stage = '';
    @api descriptionFilter = '';
    @api offset = 0;

    @wire(getLocations, { db: '$db', city: '$city', stageName: '$stage', description: '$descriptionFilter', offsetValue: '$offset' } ) 
    loadAddresses( { error, data }){
        if(error){
            window.console.log(error);
        } else if(data){
            console.log('loadAdresses success');
            this.mapMarkers = data;
        }
    }
}