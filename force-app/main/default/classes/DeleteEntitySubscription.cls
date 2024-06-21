/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

public class DeleteEntitySubscription implements Queueable {
  private Map<Id, Case> newRecordsMap;

  public DeleteEntitySubscription(Map<Id, Case> newRecordsMap){
    this.newRecordsMap = newRecordsMap;
  }

  public void execute(QueueableContext context){
    List<Case> newRecordsList = newRecordsMap.values();
    Set<Id> caseIds = newRecordsMap.keySet();
    Map<Id, Integer> caseCountMap = new Map<Id, Integer>();
    List<EntitySubscription> subscriptionsToDelete = new List<EntitySubscription>();
    Map<Id, List<EntitySubscription>> subscriptionsMap = new Map<Id, List<EntitySubscription>>();

    for(Case c : newRecordsList){
      if(!caseCountMap.containsKey(c.CreatedById)){
        caseCountMap.put(c.CreatedById, 0);
      }
      caseCountMap.put(c.CreatedById, caseCountMap.get(c.CreatedById) + 1);
    }

    List<EntitySubscription> subscriptions = [
      SELECT Id, SubscriberId, ParentId
      FROM EntitySubscription
      WHERE SubscriberId IN :caseCountMap.keySet()
      ORDER BY CreatedDate
      LIMIT 50000
    ];

    for(EntitySubscription es : subscriptions){
      Id key = es.SubscriberId;
      if(!subscriptionsMap.containsKey(key)){
        subscriptionsMap.put(key, new List<EntitySubscription>());
      }
      subscriptionsMap.get(key).add(es);
    }

    for(Id userId : subscriptionsMap.keySet()){
      Integer amountToDelete =
        subscriptionsMap.get(userId).size() +
        caseCountMap.get(userId) -
        FollowCreatedCasesSchedule.MAX_ENTITY_SUBSCRIPTIONS;
      amountToDelete = (amountToDelete > FollowCreatedCasesSchedule.MAX_ENTITY_SUBSCRIPTIONS
        ? FollowCreatedCasesSchedule.MAX_ENTITY_SUBSCRIPTIONS
        : amountToDelete);
      amountToDelete = amountToDelete > subscriptionsMap.get(userId).size()
        ? subscriptionsMap.get(userId).size()
        : amountToDelete;
      for(Integer i = 0; i < amountToDelete; i++){
        subscriptionsToDelete.add(subscriptionsMap.get(userId).get(i));
      }
    }

    if(!subscriptionsToDelete.isEmpty()){
      if(subscriptionsToDelete.size() <= 200){
        delete subscriptionsToDelete;
      }else{
        List<EntitySubscription> deleteList = new List<EntitySubscription>();
        for(EntitySubscription es : subscriptionsToDelete){
          deleteList.add(es);
          if(deleteList.size() == 200){
            delete deleteList;
            deleteList.clear();
          }
        }
        if(!deleteList.isEmpty()){
          delete deleteList;
        }
      }
    }
    InsertEntitySubscription ies = new InsertEntitySubscription(newRecordsMap);
    if(!Test.isRunningTest()){
      System.enqueueJob(ies);
    }
  }
}