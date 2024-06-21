/**
 * @description       :
 * @author            : Samuel Sirkis
 * @group             :
 * @last modified on  : 02-02-2021
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   02-02-2021   Samuel Sirkis   Initial Version
 **/
import BasePrechat from 'lightningsnapin/basePrechat';
import { api, track, wire, LightningElement } from 'lwc';
import startChatLabel from '@salesforce/label/c.StartChat';
// import botPreChatFormCSS from '@salesforce/resourceUrl/preChatFormCSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
// import CASE_CHATREASON from '@salesforce/schema/Case.ChatReason__c';
// import CPF_CNPJ from '@salesforce/schema/Contact.Account.IndividualIdentificationNumber__pc';

export default class BotPreChatForm extends BasePrechat {
    @api prechatFields;
    @track fields;
    @track lastNameValue;
    @track cpfOrCnpjValue;
    @track subjectValue;
    @track reasonValue;
    @track namelist;
    @track motivoChat = '';
    @track assunto = '';
    startChatLabel;
    treeModel;
    error;

    @wire(getPicklistValuesByRecordType, {
        objectApiName: CASE_OBJECT,
        recordTypeId: '0122H0000007oWrQAI'
    })
    wiredValues({ error, data }){
        if(data){
            this.treeModel = this.buildTreeModel(data.picklistFieldValues);
            this.error = undefined;
        } else{
            this.error = error;
            this.treeModel = undefined;
        }
    }

    buildTreeModel(picklistValues){
        const treeNodes = [];
        Object.keys(picklistValues).forEach((picklist) => {
            treeNodes.push({
                label: picklist,
                items: picklistValues[picklist].values.map((item) => ({
                    label: item.label,
                    name: item.value
                }))
            });
        });
        return treeNodes;
    }

    //Set the button label and prepare the prechat fields to be shown in the form.
    connectedCallback(){
        this.startChatLabel = startChatLabel;
        this.fields = this.prechatFields.map((field) => {
            const { label, type, name, value, required, maxLength } = field;

            return { label, type, name, value, required, maxLength };
        });
        this.namelist = this.fields.map((field) => field.name);
        console.log(this.reasonValues);
    }

    //Focus on the first input after this component renders.
    renderedCallback(){
        Promise.all([loadStyle(this)]).then(() => {});
        if(!this.inputFocused){
            let lightningInputElement = this.template.querySelector('lightning-input');
            if(lightningInputElement){
                lightningInputElement.focus();
                this.inputFocused = true;
            }
        }
    }

    selectionChangeHandler(event){
        this[event.target.name] = event.target.value;

        console.log(`motivo --${this.motivoChat}, assunto=-- ${this.assunto}`);
    }
    /**
     * Focus on the first input after this component renders.
     */
    // renderedCallback(){
    //     //this.template.querySelector('lightning-input').focus();
    // }

    // getter property to render the prechat fields
    get hasFields(){
        return this.fields && this.fields.length > 0;
    }

    get tabClass(){
        // console.log(this.fields.name)
        return this.fields.name ? 'slds-style-' + this.fields.type : 'slds-style-inputtext';
    }

    get enableButtonStartChat(){
        return this.assunto != '' && this.motivoChat != '' ? false : true;
    }

    //On clicking the 'Start Chatting' button, send a chat request.
    async handleStartChat(event){
        event.preventDefault();
        this.fields.forEach((input) => {
            if(input.name == 'ChatReason__c'){
                input.value = this.motivoChat;
            } else if(input.name == 'Subject'){
                input.value = this.assunto;
            }
            //this.fields[this.namelist.indexOf(input.name)].value = input.value;
        });

        console.log('this fields ==>', JSON.stringify(this.fields));

        let cpfOrCnpj = this.fields.find((field) => field.name == 'IndividualIdentificationNumber__c');
        cpfOrCnpj = JSON.parse(JSON.stringify(cpfOrCnpj));
        console.log('### CPF =>', cpfOrCnpj);

        //await this.updateContactOfChatTranscript(cpfOrCnpj.value);
        this.startChat(this.fields);
    }
}