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

public without sharing class CreateUmbrellaOppController {
  @AuraEnabled
  public static ID createUmbrellaOpportunity(List<Id> childrenOpportunitiesId){
    Map<Id, Opportunity> childrenOpportunities = new Map<Id, Opportunity>();
    Id recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('Guarda_chuva')
      .getRecordTypeId();
    Opportunity opp;
     try{
      opp = new Opportunity(
        Name = 'Guarda-chuva ' + DateUtil.datetimeToString(System.now()),
        CloseDate = Date.today().addMonths(1),
        OwnerId = UserInfo.getUserId(),
        RecordTypeId = recordType,
        StageName = 'Fechado e ganho'
      );
      if(Schema.sObjectType.Opportunity.isCreateable()){
        insert opp;
      }
      for(Id childId : childrenOpportunitiesId){
        childrenOpportunities.put(childId, new Opportunity(Id = childId, ParentOpportunity__c = opp.Id));
      }
      update childrenOpportunities.values();
    } catch (Exception e){
      System.debug(e);
      return null;
    }
    return opp.Id;
  }

  @AuraEnabled
  public static List<Option> getOptions(){
    List<Order> orders = [
      SELECT Id, PoNumber, OpportunityId
      FROM Order
      WHERE OwnerId = :UserInfo.getUserId() AND Opportunity.ParentOpportunity__c = NULL
      ORDER BY CreatedDate DESC
      LIMIT 300
    ];
    List<Option> options = new List<Option>();
    for(Order order : orders){
      Option opt = new Option(order.OpportunityId, String.valueOf(Decimal.valueOf(order.PoNumber)));
      options.add(opt);
    }
    return options;
  }

  public class Option {
    @AuraEnabled
    public String value { get; set; }
    @AuraEnabled
    public String label { get; set; }

    public Option(String value, String label){
      this.value = value;
      this.label = label;
    }
  }
}