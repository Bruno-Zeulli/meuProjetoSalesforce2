/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class AuraSelectOption implements Comparable {
    global AuraSelectOption(String value, String label, boolean selected){
        this.value = value;
        this.label = label;
        this.selected = selected;
    }
    global AuraSelectOption(String value, String label){
        this.value = value;
        this.label = label;
        this.selected = false;
    }
    @AuraEnabled
    public String label { get;set; }
    @AuraEnabled
    public String value { get;set; }
    @AuraEnabled
    public Boolean selected { get;set; }

    public Integer compareTo(Object compareTo){
        AuraSelectOption compareToASO = (AuraSelectOption)compareTo;

        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if(label > compareToASO.label){
            returnValue = 1;
        }else if(compareToASO.label>label){
            // Set return value to a negative value.
            returnValue = -1;
        }

        return returnValue;
    }

}