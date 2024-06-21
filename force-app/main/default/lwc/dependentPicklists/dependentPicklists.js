import { LightningElement, track, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class DependentPicklists extends LightningElement {
    //To hold API Name of the object to which dependent picklists belongs
    @api objectName;
    //To hold name or label of the record type
    @api recordTypeName;
    //To hold API Names of the dependent piklists
    @api fieldNameOne;
    @api fieldNameTwo;
    @api fieldNameThree;
    @api fieldNameFour;
    @api fieldNameFive;
    //To hold the field names in the array in the order of dependency
    @track fieldNames = [];
    //To hold the selected values in the picklist in the order of dependency
    selectedValues = [];
    //To hold value selected against the field name for maintaining integrity with UI
    @track selectedValuesMap = {};
    @track recordTypeId;
    //To retrieve object information
    @wire(getObjectInfo, { objectApiName: '$objectName' })
    objectInfo({ error, data }){
        if(error){
            alert('There is error fetching object information. Please check if correct object API name is specified.');
        } else if(data){
            const rtis = data.recordTypeInfos;
            var inputRecordTypeId = Object.keys(rtis).find((rti) => rtis[rti].name === this.recordTypeName);
            if(inputRecordTypeId){
                this.recordTypeId = inputRecordTypeId;
            } else{
                this.recordTypeId = data.defaultRecordTypeId;
            }
        }
    }

    connectedCallback(){
        //Add the input field API anames to the array
        this.fieldNames.push(this.fieldNameOne, this.fieldNameTwo, this.fieldNameThree, this.fieldNameFour, this.fieldNameFive);
        //Remove the input if it is blank, null or undefined
        this.fieldNames = this.fieldNames.filter(function (fieldName){
            var tempVar;
            return fieldName !== tempVar;
        });
    }

    @api
    get picklistValueOne(){
        return this.selectedValues.length > 0 ? this.selectedValues[0] : '';
    }

    @api
    get picklistValueTwo(){
        return this.selectedValues.length > 1 ? this.selectedValues[1] : '';
    }

    @api
    get picklistValueThree(){
        return this.selectedValues.length > 2 ? this.selectedValues[2] : '';
    }

    @api
    get picklistValueFour(){
        return this.selectedValues.length > 3 ? this.selectedValues[3] : '';
    }

    @api
    get picklistValueFive(){
        return this.selectedValues.length > 4 ? this.selectedValues[4] : '';
    }

    //Common handler for all the picklists
    onPicklistValueChangeHandler(event){
        //Get the field name for which the value is changed
        let fieldName = event.target.getAttribute('data-my-id');
        //Get the selected value
        let fieldValue = event.target.value;
        this.selectedValuesMap[fieldName] = fieldValue;
        this.selectedValues = Object.values(this.selectedValuesMap);
        var matchFound = false;
        var i = 0;
        var index = 0;
        var resetselectedValues = false;
        for(i = 0; i < this.selectedValues.length; i++){
            var tempVar;
            //If the first picklist is set to null reset the earlier selected values if any
            if(i === 0 && this.selectedValues[i] === tempVar){
                resetselectedValues = true;
            }
            //Note the index of the picklist being changed
            if(this.selectedValues[i] === fieldValue){
                index = i + 1;
            }
        }
        //Reset the selected values if the first picklist is set to none
        if(resetselectedValues){
            this.selectedValues = [];
        } else{
            this.selectedValues.splice(index, this.selectedValues.length - index);
        }
    }
}