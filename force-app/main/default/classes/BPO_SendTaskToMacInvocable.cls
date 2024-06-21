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

public class BPO_SendTaskToMacInvocable {
  /**
   * @description Bar
   * @return idsTask
   */
  @InvocableMethod
  public static void sendToMAC(List<Id> idsTask){
    for(Id taskId : idsTask){
      System.enqueueJob(new BPO_SendTaskToMacQueueable(taskId, 0));
    }
  }
}