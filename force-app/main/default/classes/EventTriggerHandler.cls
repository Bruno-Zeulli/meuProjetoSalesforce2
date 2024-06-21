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
public with sharing class EventTriggerHandler {
  private boolean isExecuting = false;
  public List<Event> oldRecordsList = null;
  public List<Event> newRecordsList = null;
  public Map<Id, Event> oldRecordsMap = null;
  public Map<Id, Event> newRecordsMap = null;

  public EventTriggerHandler(boolean isExecuting){
    this.isExecuting = isExecuting;
  }

  public void onAfterInsert(){
    sendMeetingInvitation();
  }

  public void onBeforeInsert(){
    System.debug(LoggingLevel.FINEST, 'On Before Insert');
  }

  private void sendMeetingInvitation(){
    Id lead2BusinessRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('B2U_Lead2Business')
      .getRecordTypeId();
    Set<Id> whatIdSet = new Set<Id>();
    Set<Id> accountIdSet = new Set<Id>();
    for(Event e : newRecordsList){
      whatIdSet.add(e.WhatId);
    }
    Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
      [SELECT Id, AccountId FROM Opportunity WHERE Id IN :whatIdSet AND RecordTypeId = :lead2BusinessRecordType]
    );
    for(Opportunity opp : oppMap.values()){
      accountIdSet.add(opp.AccountId);
    }
    List<EventWhoRelation> eventWhoRelationList = [
      SELECT RelationId, EventId
      FROM EventWhoRelation
      WHERE EventId IN :newRecordsMap.keySet()
    ];
    Map<Id, List<Id>> eventContactsMap = new Map<Id, List<Id>>();
    Set<Id> contactsSet = new Set<Id>();
    for(EventWhoRelation ewr : eventWhoRelationList){
      Id key = ewr.EventId;
      if(!eventContactsMap.containsKey(key)){
        eventContactsMap.put(key, new List<Id>());
      }
      eventContactsMap.get(key).add(ewr.RelationId);
      contactsSet.add(ewr.RelationId);
    }
    List<ContactDetail__c> contactDetailsList = [
      SELECT Contact__c, CorporateEmail__c, Email__c
      FROM ContactDetail__c
      WHERE Contact__c IN :contactsSet
    ];
    Map<Id, String> contactEmailMap = new Map<Id, String>();
    for(ContactDetail__c cd : contactDetailsList){
      String email = cd.CorporateEmail__c != null ? cd.CorporateEmail__c : cd.Email__c;
      if(email != null){
        contactEmailMap.put(cd.Contact__c, email);
      }
    }
    for(Event e : newRecordsList){
      Id key = e.WhatId;
      if(oppMap.containsKey(key) && !eventContactsMap.isEmpty()){
        Blob meetingInvitation = MeetingInvitationFileFactory.getFile(
          e.StartDateTime,
          e.EndDateTime,
          e.Subject,
          e.Description,
          e.Location,
          contactEmailMap.values()
        );
        SendEmail se = new SendEmail();
        se.attachments.put('invite.ics', meetingInvitation);
        se.toAddresses.add(UserInfo.getUserEmail());
        for(Id contactId : eventContactsMap.get(e.Id)){
          se.toAddresses.add(contactEmailMap.get(contactId));
        }
        se.subject = e.Subject;
        se.body = '';
        if(String.isNotBlank(e.Description)){
          se.body += e.Description;
        }
        se.body += '\r\n' + 'Nossa reunião ficou marcada para ' + DateUtil.datetimeToString(e.StartDateTime);
        if(String.isNotBlank(e.Location)){
          se.body += '\r\n' + 'Local: ' + e.Location;
        }
        se.whatId = key;
        se.send();
      }
    }
  }
}