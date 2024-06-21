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

public class InsertEntitySubscription implements Queueable {
  private Map<Id, Case> newRecordsMap;

  public InsertEntitySubscription(Map<Id, Case> newRecordsMap){
    this.newRecordsMap = newRecordsMap;
  }

  public void execute(QueueableContext context){
    Map<Id, Integer> caseCountMap = new Map<Id, Integer>();
    Map<Id, Integer> entityCountMap = new Map<Id, Integer>();
    Set<String> alreadyFollowedSet = new Set<String>();
    for(Case c : newRecordsMap.values()){
      if(!caseCountMap.containsKey(c.CreatedById)){
        caseCountMap.put(c.CreatedById, 0);
      }
      caseCountMap.put(c.CreatedById, caseCountMap.get(c.CreatedById) + 1);
      entityCountMap.put(c.CreatedById, 0);
    }
    List<EntitySubscription> subscriptions = [
      SELECT Id, SubscriberId, ParentId
      FROM EntitySubscription
      WHERE ParentId IN :newRecordsMap.keySet() AND SubscriberId IN :caseCountMap.keySet()
      ORDER BY CreatedDate
      LIMIT 50000
    ];

    for(EntitySubscription es : subscriptions){
      String key = String.valueOf(es.ParentId) + String.valueOf(es.SubscriberId);
      alreadyFollowedSet.add(key);
      entityCountMap.put(es.SubscriberId, entityCountMap.get(es.SubscriberId) + 1);
    }

    List<EntitySubscription> subscriptionsToInsert = new List<EntitySubscription>();
    for(Case c : newRecordsMap.values()){
      String key = String.valueOf(c.Id) + String.valueOf(c.CreatedById);
      if(
        !alreadyFollowedSet.contains(key) &&
        entityCountMap.get(c.CreatedById) < FollowCreatedCasesSchedule.MAX_ENTITY_SUBSCRIPTIONS
      ){
        EntitySubscription es = new EntitySubscription(ParentId = c.Id, SubscriberId = c.CreatedById);
        subscriptionsToInsert.add(es);
        entityCountMap.put(c.CreatedById, entityCountMap.get(c.CreatedById) + 1);
      }
    }

    if(!subscriptionsToInsert.isEmpty()){
      if(subscriptionsToInsert.size() <= 200){
        insert subscriptionsToInsert;
      }else{
        List<EntitySubscription> insertList = new List<EntitySubscription>();
        for(EntitySubscription es : subscriptionsToInsert){
          insertList.add(es);
          if(insertList.size() == 200){
            insert insertList;
            insertList.clear();
          }
        }
        if(!insertList.isEmpty()){
          insert insertList;
        }
      }
    }
  }
}