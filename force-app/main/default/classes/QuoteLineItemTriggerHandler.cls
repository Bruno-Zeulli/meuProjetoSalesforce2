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
public without sharing class QuoteLineItemTriggerHandler {
  private boolean isExecuting = false;
  public List<QuoteLineItem> oldRecordsList = null;
  public List<QuoteLineItem> newRecordsList = null;
  public Map<Id, QuoteLineItem> oldRecordsMap = null;
  public Map<Id, QuoteLineItem> newRecordsMap = null;

  public QuoteLineItemTriggerHandler(boolean isExecuting){
    this.isExecuting = isExecuting;
  }

  public void onBeforeInsert(){
    System.debug(LoggingLevel.FINEST, 'On Before Insert');
  }

  public void onAfterInsert(){
    updateQuoteName();
  }

  public void onAfterUpdate(){
    updateQuoteName();
  }

  public void onAfterDelete(){
    updateQuoteName();
  }

  private void updateQuoteName(){
    Set<Id> quoteIdSet = new Set<Id>();
    List<QuoteLineItem> recordsList = newRecordsList != null ? newRecordsList : oldRecordsList;
    for(QuoteLineItem qli : recordsList){
      quoteIdSet.add(qli.QuoteId);
    }

    if(Schema.sObjectType.Quote.isUpdateable()){
      List<Quote> quoteList = [
        SELECT Id
        FROM Quote
        WHERE Id IN :quoteIdSet AND RecordType.Name IN ('B2U', 'Conseg')
        WITH SECURITY_ENFORCED
      ];
      update quoteList;
    }
  }
}