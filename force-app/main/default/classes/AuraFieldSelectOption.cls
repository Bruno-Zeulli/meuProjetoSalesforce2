/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class AuraFieldSelectOption implements Comparable {
    global AuraFieldSelectOption(String fieldname, String objectname,  String label){
        this.fieldname = fieldname;
        this.objectname = objectname;
        this.label = label;
    }

    @AuraEnabled
    public String label { get;set; }
    @AuraEnabled
    public String fieldname { get;set; }
    @AuraEnabled
    public String objectname { get;set; }


    public Integer compareTo(Object compareTo){
        AuraFieldSelectOption compareToASO = (AuraFieldSelectOption)compareTo;

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