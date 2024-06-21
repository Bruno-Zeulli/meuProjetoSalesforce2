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

public without sharing class LiveAgentObserverController {
  @AuraEnabled
  public static String getLiveChatTranscriptChannel(Id recordId){
    // if(Schema.SObjectType.LiveChatTranscript.isAccessible()){
    //   LiveChatTranscript lct = [
    //     SELECT LiveChatButton.DeveloperName
    //     FROM LiveChatTranscript
    //     WHERE Id = :recordId
    //     WITH SECURITY_ENFORCED
    //   ];
    //   if(lct.LiveChatButton.DeveloperName.contains('WhatsApp')){
    //     return 'WhatsApp';
    //   }
    //   return 'Chat';
    // }
    return null;
  }
}