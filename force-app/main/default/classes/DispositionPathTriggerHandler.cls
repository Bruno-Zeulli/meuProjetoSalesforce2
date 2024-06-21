/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public class DispositionPathTriggerHandler {
    private boolean isExecuting = false;
    public List<DispositionPath__c> oldRecordsList = null;
    public List<DispositionPath__c> newRecordsList = null;
    public Map<Id, DispositionPath__c> oldRecordsMap = null;
    public Map<Id, DispositionPath__c> newRecordsMap = null;

    public DispositionPathTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    @future(callout=true)
    public static void createDispositionPathGenesys(List<Id> dispositionIds){
        List<DispositionPath__c> getDispositions = [SELECT Id, Reason__c FROM DispositionPath__c WHERE Id in : dispositionIds];
        List<DispositionPath__c> dispositionsToUpdate = new List<DispositionPath__c>();

        try{
            for(DispositionPath__c disposition : getDispositions){
                Map<String, String> returnMap = GenesysCloudCreateTabulationController.createTabulation(disposition.Reason__c);

                DispositionPath__c dispoToUpdate = new DispositionPath__c();
                dispoToUpdate.Id = disposition.Id;
                dispoToUpdate.ExternalId__c = returnMap.get('id');
                dispositionsToUpdate.add(dispoToUpdate);
            }
        }catch(Exception e){
            System.debug('Ocorreu um no processo: ' + e);
        } 

        if(!dispositionsToUpdate.isEmpty()){
            update dispositionsToUpdate;
        }
    }
}