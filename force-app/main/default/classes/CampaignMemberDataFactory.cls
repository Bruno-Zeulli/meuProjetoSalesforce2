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
public class CampaignMemberDataFactory {
    public static CampaignMember createCampaignMember(Id campaignId, Id contactid, Id caseId){
        CampaignMember cm = new CampaignMember(CampaignId = campaignId, ContactId = contactId, Concierge_Case__c = caseId);
        return cm;
    }

    public static CampaignMember insertCampaignMember(Id campaignId, Id contactId){
        CampaignMember cm = createCampaignMember(campaignId, contactId, null);
        insert cm;
        return cm;
    }

    public static CampaignMember insertCampaignMember(Id campaignId, Id contactId, Id caseId){
        CampaignMember cm = createCampaignMember(campaignId, contactId, caseId);
        insert cm;
        return cm;
    }
}