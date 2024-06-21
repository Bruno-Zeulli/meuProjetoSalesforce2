/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 10-23-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class FollowCreatedCasesScheduleTest {
    @isTest
    static void testSchedule(){
        Test.startTest();
        CaseDataFactory.insertCase();
        Map<Id, Case> newRecordsMap = new Map<Id, Case>([SELECT Id, CreatedById FROM Case WHERE CreatedDate = TODAY AND (NOT CreatedBy.Name LIKE '%Integrador%')]);

        FollowCreatedCasesSchedule.schedule();
        DeleteEntitySubscription des = new DeleteEntitySubscription(newRecordsMap);
        InsertEntitySubscription ies = new InsertEntitySubscription(newRecordsMap);
        des.execute(null);
        ies.execute(null);

        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 49; i++){
            Case c = CaseDataFactory.createCase();
            cases.add(c);
            if(cases.size() == 50){
                insert cases;
                cases.clear();
            }
        }
        insert cases;
        newRecordsMap = new Map<Id, Case>([SELECT Id, CreatedById FROM Case WHERE CreatedDate = TODAY AND (NOT CreatedBy.Name LIKE '%Integrador%')]);
        des = new DeleteEntitySubscription(newRecordsMap);
        ies = new InsertEntitySubscription(newRecordsMap);
        des.execute(null);
        ies.execute(null);

        List<EntitySubscription> subscriptions = [SELECT Id, ParentId, SubscriberId FROM EntitySubscription];
        // System.assertEquals(subscriptions.size(), 50, '');
        Test.stopTest();
    }
}