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
public class RenewalCampaignDataFactory {
  public static List<RenewalCampaign__c> createRenewalCampaigns(){
    List<RenewalCampaign__c> campaigns = new List<RenewalCampaign__c>();
    RenewalCampaign__c auto = new RenewalCampaign__c(
      Name = 'Renovação Auto',
      CampaignName__c = 'AUTO RN MANUAL ATIVO',
      Product__c = 'Auto'
    );
    RenewalCampaign__c residencial = new RenewalCampaign__c(
      Name = 'Renovação Residencial',
      CampaignName__c = 'RESIDENCIAL RN POS VENCIMENTO ATIVO',
      Product__c = 'Residencial'
    );
    campaigns.add(auto);
    campaigns.add(residencial);
    return campaigns;
  }

  public static List<RenewalCampaign__c> insertRenewalCampaigns(){
    List<RenewalCampaign__c> campaigns = createRenewalCampaigns();
    insert campaigns;
    return campaigns;
  }
}