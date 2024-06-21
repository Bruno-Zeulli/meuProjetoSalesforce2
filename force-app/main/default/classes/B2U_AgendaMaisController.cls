/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public with sharing class B2U_AgendaMaisController {
  //test comment
  @AuraEnabled(cacheable=true)
  public static List<Lead2BusinessDatabase__c> getDatabaseList(){
    List<Lead2BusinessDatabase__c> databaseList = [SELECT Name, DerivedFrom__c FROM Lead2BusinessDatabase__c];
    return databaseList;
  }

  @AuraEnabled(cacheable=true)
  public static List<AggregateResult> getCityList(String db, String stageName){
    String query = 'SELECT BillingCity FROM Account WHERE BillingCity != null AND Id IN (SELECT AccountId FROM Opportunity WHERE RecordType.Name = \'B2U - Lead2Business\'';
    if(String.isNotBlank(db)){
      query += ' AND DerivedFrom__c = :db';
    }
    if(String.isNotBlank(stageName)){
      query += ' AND StageName = :stageName';
    }
    query += ') GROUP BY BillingCity';
    List<AggregateResult> cityList = (List<AggregateResult>) Database.query(query);
    System.debug('cityList: ' + cityList);
    return cityList;
  }

  @AuraEnabled(cacheable=true)
  public static Integer getRecordsCount(String db, String stageName, String city){
    String q = 'SELECT COUNT() FROM Opportunity WHERE RecordType.Name = \'B2U - Lead2Business\'';
    if(String.isNotBlank(db)){
      q += ' AND DerivedFrom__c = :db';
    }
    if(String.isNotBlank(city)){
      q += ' AND Account.BillingCity = :city';
    }
    if(String.isNotBlank(stageName)){
      q += ' AND StageName = :stageName';
    }

    Integer count = Database.countQuery(q);
    return count;
  }
}