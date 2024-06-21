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
public class ContactTriggerHandler {
  private boolean isExecuting = false;
  public List<Contact> oldRecordsList = null;
  public List<Contact> newRecordsList = null;
  public Map<Id, Contact> oldRecordsMap = null;
  public Map<Id, Contact> newRecordsMap = null;

  public ContactTriggerHandler(boolean isExecuting){
    this.isExecuting = isExecuting;
  }

  public void deleteContactsAnyIdenfication(){
    List<Contact> lstContactForDelete = [Select Id, IndividualIdentificationNumber__c from Contact where IndividualIdentificationNumber__c = null AND Email = null AND  Phone = null];
    List<String> lstIdsContact = new List<String>();

    for(Contact contact : lstContactForDelete){
      lstIdsContact.add(contact.Id);
    }

    String strContatosIds = String.join(lstIdsContact, ',');

    List<Case> casosOfContactForDelete = [SELECT Id, ContactId FROM Case WHERE ContactId in (:strContatosIds)];


    for(Case caso : casosOfContactForDelete){
      caso.ContactId = null;
    }
    


    update casosOfContactForDelete;

    if(lstContactForDelete.size() > 0){
      delete lstContactForDelete;
    }
  }
}