/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-01-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-01-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   11-01-2021   Samuel SIrkis                        PMD
 **/
@isTest
public class CampaignBOTest {
    @isTest
    static void integrationOlosInsertCampaignMember() {
        Map<Id, CampaignMember> mapCampaignMembers = new Map<Id, CampaignMember>();

        CampaignMember campaignMember = new CampaignMember(
            Id = IDGenerator.generate(CampaignMember.getSObjectType()),
            CampaignId = IDGenerator.generate(Campaign.getSObjectType()),
            ContactId = IDGenerator.generate(Contact.getSObjectType())
        );

        mapCampaignMembers.put(campaignMember.Id, campaignMember);

        CampaignBO camp = CampaignBO.getInstance();
        camp.integrationOlosInsertCampaignMember(mapCampaignMembers, false);

        // System.assert(condition);
    }

    @isTest
    static void integrationOlosInsertCampaignMemberNoCampaign() {
        Map<Id, CampaignMember> mapCampaignMembers = new Map<Id, CampaignMember>();

        CampaignMember campaignMember = new CampaignMember(Id = IDGenerator.generate(CampaignMember.getSObjectType()), ContactId = IDGenerator.generate(Contact.getSObjectType()));

        mapCampaignMembers.put(campaignMember.Id, campaignMember);

        CampaignBO camp = CampaignBO.getInstance();
        camp.integrationOlosInsertCampaignMember(mapCampaignMembers, false);
    }

    @isTest
    static void integrationOlosInsertCampaignMemberNoContact() {
        Map<Id, CampaignMember> mapCampaignMembers = new Map<Id, CampaignMember>();

        CampaignMember campaignMember = new CampaignMember(Id = IDGenerator.generate(CampaignMember.getSObjectType()), ContactId = IDGenerator.generate(Contact.getSObjectType()));

        mapCampaignMembers.put(campaignMember.Id, campaignMember);
        CampaignBO camp = CampaignBO.getInstance();
        camp.integrationOlosInsertCampaignMember(mapCampaignMembers, false);
    }

    @isTest
    static void integrationOlosDeleteCampaignMember() {
        Map<Id, CampaignMember> mapCampaignMembers = new Map<Id, CampaignMember>();

        CampaignMember campaignMember = new CampaignMember(
            Id = IDGenerator.generate(CampaignMember.getSObjectType()),
            CampaignId = IDGenerator.generate(Campaign.getSObjectType()),
            ContactId = IDGenerator.generate(Contact.getSObjectType()),
            IntegrationStatus__c = 'Retirado'
        );

        mapCampaignMembers.put(campaignMember.Id, campaignMember);

        CampaignBO camp = CampaignBO.getInstance();
        camp.integrationOlosDeleteCampaignMember(mapCampaignMembers);
    }
    
    @isTest
    static void integrationOlosInsertCampaignMemberLead() {
        Map<Id, CampaignMember> mapCampaignMembers = new Map<Id, CampaignMember>();

        Campaign campaignRecord = new Campaign(
            Name = 'Campaign Teste',
            Id_Campanha_Olos__c = 4,
            Id_Layout_Mailing_Olos__c = 4,
            Nome_do_Mailing_Olos__c = 'Mailing_teste',
            IDFinalizeDisposition__c = '107'
        );
		insert campaignRecord;

        CampaignMember campaignMember = new CampaignMember(
            Id = IDGenerator.generate(CampaignMember.getSObjectType()),
            CampaignId = campaignRecord.Id,
            ContactId = null
        );

        mapCampaignMembers.put(campaignMember.Id, campaignMember);

        CampaignBO camp = CampaignBO.getInstance();
        camp.integrationOlosInsertCampaignMember(mapCampaignMembers, false);
    }

    //campaignMember.IntegrationStatus__c == 'Retirado'
}