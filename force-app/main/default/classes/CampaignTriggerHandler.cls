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
public with sharing class CampaignTriggerHandler {
  private boolean isExecuting = false;
  public List<Campaign> oldRecordsList = null;
  public List<Campaign> newRecordsList = null;
  public Map<Id, Campaign> oldRecordsMap = null;
  public Map<Id, Campaign> newRecordsMap = null;

  public CampaignTriggerHandler(boolean isExecuting){
    this.isExecuting = isExecuting;
  }

  public void onBeforeUpdate(){
    Map<Id, Campaign> mapCampaigns = new Map<Id, Campaign>();
    for(Id key : newRecordsMap.keySet()){
      if(
        (oldRecordsMap.get(key).CTIListName__c != newRecordsMap.get(key).CTIListName__c) &&
        oldRecordsMap.get(key).CTIListName__c != null
      ){
        mapCampaigns.put(key, oldRecordsMap.get(key));
      }
    }
    if(!mapCampaigns.isEmpty()){
      sendToCTI(mapCampaigns, System.TriggerOperation.BEFORE_DELETE);
    }
  }

  public void onAfterUpdate(){
    Map<Id, Campaign> mapCampaigns = new Map<Id, Campaign>();
    for(Id key : newRecordsMap.keySet()){
      if(
        (oldRecordsMap.get(key).CTIListName__c != newRecordsMap.get(key).CTIListName__c) &&
        newRecordsMap.get(key).CTIListName__c != null
      ){
        mapCampaigns.put(key, newRecordsMap.get(key));
      }
    }
    if(!mapCampaigns.isEmpty()){
      sendToCTI(mapCampaigns, System.TriggerOperation.AFTER_INSERT);
    }
  }

  public void onBeforeDelete(){
    sendToCTI(oldRecordsMap, Trigger.operationType);
  }

  private void sendToCTI(Map<Id, Campaign> mapCampaigns, System.TriggerOperation operation){
    CTIIntegrationBatchable batchable = new CTIIntegrationBatchable(mapCampaigns, operation);
    Database.executeBatch(batchable);
  }
}