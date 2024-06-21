/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class CampaignDataFactory {
  public static Campaign insertCampaign(){
    Campaign campanha = createCampaign();
    insert campanha;
    return campanha;
  }

  public static Campaign insertCampaign(String rtDeveloperName){
    Campaign objCampaign = createCampaign();
    objCampaign.RecordTypeId = getRecordTypeId(rtDeveloperName);
    insert objCampaign;
    return objCampaign;
  }

  public static Campaign createCampaign(){
    Campaign campanha = new Campaign(Name = 'Teste', CTIListName__c = 'Teste');
    return campanha;
  }

  private static Id getRecordTypeId(String rtDeveloperName){
    return Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(rtDeveloperName).getRecordTypeId();
  }
}