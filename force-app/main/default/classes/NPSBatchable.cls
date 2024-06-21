/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 05-12-2023
 * @last modified by  : joao@beecloud.com.br
**/
global class NPSBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, ReferenceId__c, NPSConsultado__c, CaminhoURA__c FROM CallLog__c WHERE NPSConsultado__c = false
        ]);
    }    

    public void execute(Database.BatchableContext BC, List<CallLog__c> callsWithoutNPS){
        NPS.setNPS(callsWithoutNPS);
    }

    public void finish(Database.BatchableContext BC){}
}