/**
 * Autor: Samuel da Silva Sirkis
 * Observação: Foi realizado a divisão do método seguinte após analise do PMD.
 */

public with sharing class QuoteTriggerHandlerDiscountCalc {
  // Método para calcular desconto
  public static void calculateDiscount(){
    Map<Id, Quote> newRecordsMap = null;
    List<QuoteLineItem> qliUpdateList = new List<QuoteLineItem>();
    if(newRecordsMap != null){
      List<QuoteLineItem> qliList = new List<QuoteLineItem>();
      if(Schema.sObjectType.QuoteLineItem.isAccessible()){
        qliList = [
          SELECT Id, QuoteId, UnitPrice, DiscountValue__c, Discount
          FROM QuoteLineItem
          WHERE QuoteId IN :newRecordsMap.keySet()
        ];
      }
      calculateDiscountUpdate(qliUpdateList, qliList);
      if(!qliUpdateList.isEmpty()){
        if(Schema.sObjectType.QuoteLineItem.isUpdateable()){
          update qliList;
        }
      }
    }
  }

  //Divisão do método para não estender e gerar uma Warning do PMD
  public static void calculateDiscountUpdate(List<QuoteLineItem> qliUpdateList, List<QuoteLineItem> qliList){
    Map<Id, Quote> oldRecordsMap = null;
    Map<Id, Quote> newRecordsMap = null;
    for(QuoteLineItem qli : qliList){
      if(
        oldRecordsMap.get(qli.QuoteId).IsDiscountApproved__c != newRecordsMap.get(qli.QuoteId).IsDiscountApproved__c
      ){
        if(newRecordsMap.get(qli.QuoteId).IsDiscountApproved__c){
          if(qli.DiscountValue__c != null && qli.UnitPrice != null && qli.UnitPrice != 0){
            qli.Discount = (qli.DiscountValue__c / qli.UnitPrice) * 100;
          }
        }else{
          qli.Discount = null;
        }
        qliUpdateList.add(qli);
      }
    }
  }
}