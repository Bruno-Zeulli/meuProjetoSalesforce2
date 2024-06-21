import { LightningElement, api } from 'lwc';

export default class PicklistByRecordType extends LightningElement {
    // API name of object
    @api objectName;
        
    // Label for picklist
    @api objectLabel;

    // Picklist object (Account)
    @api fieldName;

    // RecordTypeId picklist
    @api recordTypeId;

    // input isRequired
    @api isRequired;

    // Error message
    @api errorMessage;

    // Value of selected picklist
    @api fieldValue;

    // @api outputValue;

    // Function execute on 'next' click to validate
    @api validate(){
        if( !this.isRequired
            || ( this.isRequired && this.fieldValue && this.fieldValue.length > 0 ) ){
            return { isValid: true };
        } else{
            return {
                isValid: false,
                errorMessage: this.errorMessage
            };
        }
    }

    /**
     * Function set value to the fieldValue variable
     */
    handleChange(event){
        this.fieldValue = event.target.value;
        // console.log(event.target);
        // console.log(event.target.value);
        // console.log(this.fieldName);
        // this.dispatchEvent(new FlowAttributeChangeEvent('outputValue', this.fieldValue));
    }
}