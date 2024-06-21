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

public without sharing class FollowCreatedCasesSchedule implements Schedulable {
    private static final String CRON_EXP = '0 0 22 * * ? *'; // Todos os dias às 10 horas da noite
    public final static Integer MAX_ENTITY_SUBSCRIPTIONS = 500;

    public static void schedule(){
        System.schedule('Seguir casos criados hoje ' + Datetime.now(), CRON_EXP, new FollowCreatedCasesSchedule());
    }

    public void execute(SchedulableContext ctx){
        Map<Id, Case> newRecordsMap = new Map<Id, Case>(
            [SELECT Id, CreatedById FROM Case WHERE CreatedDate = TODAY AND (NOT CreatedBy.Profile.Name LIKE '%Integrador%') ORDER BY CreatedDate DESC]
        );

        DeleteEntitySubscription des = new DeleteEntitySubscription(newRecordsMap);
        if(!Test.isRunningTest()){
            System.enqueueJob(des);
        }
    }
}