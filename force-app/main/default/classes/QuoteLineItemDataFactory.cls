/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class QuoteLineItemDataFactory {
  public static QuoteLineItem createQuoteLineItem(){
    QuoteLineItem qli = new QuoteLineItem(UnitPrice = 1, Quantity = 1);
    return qli;
  }
}