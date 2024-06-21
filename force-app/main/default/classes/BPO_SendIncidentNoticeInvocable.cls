/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

global class BPO_SendIncidentNoticeInvocable {
    @InvocableMethod
    public static void sendSipre(List<Id> idsComunicado){
        for(Id caso : idsComunicado){
            if(!Test.isRunningTest()){
                System.enqueueJob(new BPO_SendIncidentNoticeQueueable(caso, 1));
            }
        }
    }
}