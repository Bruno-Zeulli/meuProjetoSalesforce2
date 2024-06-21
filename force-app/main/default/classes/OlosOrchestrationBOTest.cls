/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-01-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-01-2021   Samuel SIrkis                        Initial Version
 **/
@isTest
public class OlosOrchestrationBOTest {
    @isTest
    static void createEvent(){
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c(Id = IDGenerator.generate(OlosOrchestrationEvent__c.getSObjectType()));
        OlosOrchestrationBO.getInstance().createEvent(event.EventName__c, event.Payload__c, event.IgnoredByTrigger__c);

        // System.assert(OlosOrchestrationBO.getInstance().createEvent(event.EventName__c, event.Payload__c,event.IgnoredByTrigger__c), false);
    }

    @isTest
    static void sObjectUpdateEvent(){
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c();
        OlosOrchestrationBO.getInstance().sObjectUpdateEvent(event.Id, '');

        // System.assert(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(event.Id, ''),false);
    }

    @isTest
    static void sObjectEvent(){
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c();
        OlosOrchestrationBO.getInstance().sObjectEvent('1', OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), '', false);

        // System.assert(OlosOrchestrationBO.getInstance().sObjectUpdateEvent('1', OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), false));
    }

    @isTest
    static void executeEvent(){
        List<OlosOrchestrationEvent__c> eventToProcessing = new List<OlosOrchestrationEvent__c>();
        OlosOrchestrationBO.getInstance().executeEvent(eventToProcessing);

        // System.assert(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(eventToProcessing));
    }
}