import customButtons from './customButtons.html';
import customButtonsQuote from './customButtonsQuote.html';
import customButtonsProduct from './customButtonsProduct.html';
import customButtonsToAssign from './customButtonsToAssign.html';
import customButtonsCustomerName from './customButtonsCustomerName.html';
import customButtonsStatus from './customButtonsStatus.html';
import customButtonsCreatedDate from './customButtonsCreatedDate.html';
import customButtonsModifiedAt from './customButtonsModifiedAt.html';
import customButtonsSource from './customButtonsSource.html';
import customButtonsComercial from './customButtonsComercial.html';
import customButtonsOwner from './customButtonsOwner.html';
import customButtonsOpportunityNumber from './customButtonsOpportunityNumber.html';
import customButtonsTypeLeadSource from './customButtonsTypeLeadSource.html';
import LightningDatatable from 'lightning/datatable';
import { api } from 'lwc';

export default class ConnectWizCustomDataTypeButtons extends LightningDatatable {
    static customTypes = {
        customButtonsType: {
            template: customButtons,
            typeAttributes: ['caseId', 'isSelectableCell']
        },
        customButtonsTypeQuote: {
            template: customButtonsQuote,
            typeAttributes: ['solicitadas','recebidas','caseId','isCotacoes', 'requestInsideSLA', 'requestOutsideSLA', 'selectedInsideSLA', 'selectedOutsideSLA', 'selectedAllSLA']
        },
        customButtonsTypeProduct: {
            template: customButtonsProduct,
            typeAttributes: ['produto','caseId','isProduto']
        },
        customButtonsTypeToAssign: {
            template: customButtonsToAssign,
            typeAttributes: ['caseId','isToAssign']
        },
        customButtonsTypeCustomerName:{
            template: customButtonsCustomerName,
            typeAttributes: ['caseId','isSelectableCell','name']
        },
        customButtonsTypeStatus:{
            template: customButtonsStatus,
            typeAttributes: ['caseId', 'isSelectableCell', 'status']
        },
        customButtonsTypeCreatedDate:{
            template: customButtonsCreatedDate,
            typeAttributes: ['caseId','isSelectableCell','createdDate','strCreatedDate']
        },
        customButtonsTypeModifiedAt:{
            template: customButtonsModifiedAt,
            typeAttributes: ['caseId', 'isSelectableCell', 'modifiedAt']
        },
        customButtonsTypeSource:{
            template: customButtonsSource,
            typeAttributes: ['caseId', 'isSelectableCell', 'source']
        },
        customButtonsTypeOwner:{
            template: customButtonsOwner,
            typeAttributes: ['caseId', 'isSelectableCell', 'owner']
        },
        customButtonsComercialName:{
            template: customButtonsComercial,
            typeAttributes: ['comercialName', 'salesUnit', 'isComercial']
        },
        customButtonsTypeLeadSource:{
            template: customButtonsTypeLeadSource,
            typeAttributes: ['leadSource', 'caseId','isLeadSource']
        },
        customButtonsTypeOpportunityNumber: {
            template: customButtonsOpportunityNumber,
            typeAttributes: ['caseId','opportunityNumber','isSelectableCell','enterpriseName']
        }
    };
}