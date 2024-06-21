import { api, LightningElement } from 'lwc';
import RecurrenceTimeZoneSidKey from '@salesforce/schema/Task.RecurrenceTimeZoneSidKey';

export default class ConnectWizDatePicker extends LightningElement {

    labelButton = 'Últimos 3 meses';
    isCustomDateFilter = false;
    selectedDateStartValue = '';
    selectedDateEndValue = '';
    referenceDataByLastDays = '';
    isEmptyStartDate = false;
    isEmptyEndDate = false;
    isEndDateGreaterThanCurrentDate = false;
    isStartDateGreaterThanCurrentDate = false;
    isStartDateGreaterThanEndDate = false;
    dateFormatted;
    


    handleSelectedPreSet(){
        
        if(this.isCustomDateFilter){
            this.clearFiltersCustomDate();
        }    

        let e = this.template.querySelector('input[name="selectDate"]:checked');
        this.labelButton = this.setLabelButton(e);
        this.getDateFormatted(e.value);
        this.referenceDataByLastDays = this.dateFormatted;
        this.filterCasesByDate();
    }

    handleSelectedCustomDate(){
        this.isCustomDateFilter = true;    
        let e = this.template.querySelector('input[name="selectDate"]:checked');
        this.labelButton = this.setLabelButton(e);    
    }

    handleApplyCustomDate(){
        this.getDateFormatted();
        if(this.validateDate()){
            this.filterCasesByDate();
        };
    }

    filterCasesByDate(){
        let filters = {
            selectedDateStartValue: this.selectedDateStartValue,
            selectedDateEndValue: this.selectedDateEndValue, 
            referenceDataByLastDays: this.referenceDataByLastDays,
        }

        const selectedEvent = new CustomEvent("filtercasesbydate", {
            detail: filters
        });
        console.log('selectedEvent =>>', selectedEvent);
        this.dispatchEvent(selectedEvent);
    }

    validateDate(){

        console.log('this.selectedDateStartValue =>>', this.selectedDateStartValue);
        console.log('this.selectedDateEndValue =>>', this.selectedDateEndValue);

        if(this.selectedDateStartValue == null || this.selectedDateStartValue == ''){
            this.isEmptyStartDate = true;
        }else{
            this.isEmptyStartDate = false;
        }
        if(this.selectedDateEndValue == null || this.selectedDateEndValue == ''){
            this.isEmptyEndDate = true;
        }else{
            this.isEmptyEndDate = false;
        }
        if(!this.isEmptyStartDate && !this.isEmptyEndDate){
            if(this.selectedDateStartValue > this.selectedDateEndValue){
                this.isStartDateGreaterThanEndDate = true;
            }else{
                this.isStartDateGreaterThanEndDate = false;
            }
            if(this.selectedDateStartValue > this.dateFormatted){
                this.isStartDateGreaterThanCurrentDate = true;
            }else{
                this.isStartDateGreaterThanCurrentDate = false;
            }
            if(this.selectedDateEndValue > this.dateFormatted){
                this.isEndDateGreaterThanCurrentDate = true;
            }else{
                this.isEndDateGreaterThanCurrentDate = false;
            }
        }
        if( !this.isEmptyStartDate || 
            !this.isEmptyEndDate || 
            !this.isStartDateGreaterThanEndDate || 
            !this.isStartDateGreaterThanCurrentDate || 
            !this.isEndDateGreaterThanCurrentDate)
        {
            return true;
        }
        return false;        
    }
    

    handleChangeDateStartValue(event){
        this.selectedDateStartValue = event.target.value;
        console.log(`CreatedDateEnd - ${this.selectedDateStartValue}}`);

    }

    handleChangeDateEndValue(event){
        this.selectedDateEndValue = event.target.value;
        console.log(`CreatedDateEnd - ${this.selectedDateEndValue}}`);
    }

    clearFiltersCustomDate(){
        this.selectedDateStartValue = '';
        this.selectedDateEndValue = '';
        this.isCustomDateFilter = false;
    }

    getDateFormatted(e){

        const dateTimeNow = new Date();

         console.log('dateTimeNow =>>', dateTimeNow);

        if(e !== undefined && e !== null && e !== ''){
            dateTimeNow.setDate(dateTimeNow.getDate() - e);
            console.log('e =>>', e);
            console.log('dateTimeNow =>>', dateTimeNow);
        }

        dateTimeNow.setMinutes(
            new Date().getMinutes() - new Date().getTimezoneOffset()
        );

        this.dateFormatted = dateTimeNow.toISOString().slice(0,10);
    }

    @api setLabelButtonDefault(){
        this.labelButton = 'Últimos 3 meses';
    }

    setLabelButton(e){
        console.log(e.value);
        if(e.value == 1){
            return 'Últimas 24 horas';
        }else if(e.value == 7){
            return 'Últimos 7 dias';
        }else if(e.value == 15){
            return 'Últimos 15 dias';
        }else if(e.value == 30){
            return 'Últimos 30 dias';
        }else if(e.value == 90){
            return 'Últimos 3 meses';
        }else if(e.value == 180){
            return 'Últimos 6 meses';
        }else if(e.value == 365){
            return 'Últimos 12 meses';
        }else if(e.value == 'custom'){
            return 'Personalizado';
        }
    }
}