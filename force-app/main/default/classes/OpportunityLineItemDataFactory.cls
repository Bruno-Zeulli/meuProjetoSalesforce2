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
@isTest
public class OpportunityLineItemDataFactory {
  public static OpportunityLineItem createOpportunityLineItem(){
    OpportunityLineItem oli = new OpportunityLineItem(UnitPrice = 1, Quantity = 1);
    return oli;
  }

  public static OpportunityLineItem createOpportunityLineItemCorporate(){
    OpportunityLineItem oli = new OpportunityLineItem(UnitPrice = 1, Quantity = 1, Type__c = 'New');
    return oli;
  }
}