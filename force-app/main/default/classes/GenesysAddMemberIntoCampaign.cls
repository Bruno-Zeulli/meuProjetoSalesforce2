public with sharing class GenesysAddMemberIntoCampaign {
    @InvocableMethod(
        label='Inserir Leads em uma Campanha'
        description='Insere a lista de Leads em uma Campanha'
        category='Lead'
    )
    public static void createLeadsAndCampaignMembers(List<Input> inputs) {
        List<GenesysMailingCreation__e> events = new List<GenesysMailingCreation__e>();
        for (Lead lead : inputs[0].leads) {
            events.add(
                new GenesysMailingCreation__e(
                    CampaignId__c = inputs[0].campaignId,
                    UserId__c = UserInfo.getUserId(),
                    Lead__c = JSON.serialize(lead),
                    RecordTypeId__c = inputs[0].recordTypeId
                )
            );
        }
        EventBus.publish(events);
    }


    @AuraEnabled
    public static void addContactIntoCampaign(
        String callLog,
        String contactDetail
    ) {
        ContactDetail__c detalheContato = new ContactDetail__c();
        CallLog__c log = new CallLog__c();
        Campaign campanha = new Campaign();
        CampaignMember membro = new CampaignMember();
        try {
            detalheContato = [
                SELECT Id, Contact__c, MobilePhone__c, Source__c
                FROM ContactDetail__c
                WHERE Id = :contactDetail
            ];
            log = [SELECT Id, Queue__c FROM CallLog__c WHERE Id = :callLog];
            campanha = [
                SELECT Id, CTIListName__c, CampaignSource__c
                FROM Campaign
                WHERE
                    CTIListName__c = :log.Queue__c
                    AND CampaignSource__c = :detalheContato.Source__c
            ];
            membro = [
                SELECT
                    Id,
                    MobilePhone,
                    ContactDetail__r.MobilePhone__c,
                    Campaign.CampaignSource__c
                FROM CampaignMember
                WHERE
                    (MobilePhone = :detalheContato.MobilePhone__c
                    OR ContactDetail__r.MobilePhone__c = :detalheContato.MobilePhone__c)
                    AND CampaignId = :campanha.Id
                    AND Campaign.CampaignSource__c = :detalheContato.Source__c
            ];
        } catch (Exception e) {
            System.debug('Erro: ' + e);
        }

        if (membro.Id != null) {
            // Atualizar membro da campanha
        } else {
            CampaignMember novoMembro = new CampaignMember();
            novoMembro.CampaignId = campanha.Id;
            novoMembro.ContactDetail__c = detalheContato.Id;
            novoMembro.ContactId = detalheContato.Contact__c;

            insert novoMembro;
        }
    }

    @AuraEnabled
    public static void addLeadIntoCampaign(String callLog, String leadId) {
        Lead lead = new Lead();
        CallLog__c log = new CallLog__c();
        Campaign campanha = new Campaign();
        CampaignMember membro = new CampaignMember();
        try {
            lead = [
                SELECT Id, MobilePhone, LeadSource
                FROM Lead
                WHERE Id = :leadId
            ];
            log = [SELECT Id, Queue__c FROM CallLog__c WHERE Id = :callLog];

            campanha = [
                SELECT Id, CTIListName__c
                FROM Campaign
                WHERE
                    CTIListName__c = :log.Queue__c
                    AND CampaignSource__c = :lead.LeadSource
            ];

            membro = [
                SELECT Id, MobilePhone
                FROM CampaignMember
                WHERE
                    MobilePhone = :lead.MobilePhone
                    AND CampaignId = :campanha.Id
                    AND Campaign.CampaignSource__c = :lead.LeadSource
            ];
        } catch (Exception e) {
            System.debug('Erro: ' + e);
        }

        if (membro.Id != null) {
            // Atualizar membro da campanha
        } else {
            CampaignMember novoMembro = new CampaignMember();
            novoMembro.CampaignId = campanha.Id;
            novoMembro.LeadId = lead.Id;

            insert novoMembro;
        }
    }

    public class Input {
        @InvocableVariable
        public List<Lead> leads;
        @InvocableVariable
        public String campaignId;
        @InvocableVariable
        public String recordTypeId;
    }
}