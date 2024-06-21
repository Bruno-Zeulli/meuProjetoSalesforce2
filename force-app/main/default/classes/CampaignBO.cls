/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 11-01-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   11-01-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class CampaignBO {
    /**
    * Singleton
    */
    private static final CampaignBO INSTANCE = new CampaignBO();
    public static CampaignBO getInstance() {
        return INSTANCE;
    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param campaignMemberIndexById Lista com o objeto de campaign
    * @param isUpdate
    */
    public void integrationOlosInsertCampaignMember(Map<Id, CampaignMember> campaignMemberIndexById, Boolean isUpdate) {
        List<OlosOrchestrationEvent__c> eventToInsert = new List<OlosOrchestrationEvent__c>();
        System.debug('### integrationOlosInsertCampaignMember =>> ' + campaignMemberIndexById);
        Set<String> campaignsIds = new Set<String>();
        Set<String> contactsIds = new Set<String>();
        Set<String> contactsDetailIds = new Set<String>();
        Set<String> whatIds = new Set<String>();
        Set<String> leadsIds = new Set<String>();

        for (CampaignMember campaignMember : campaignMemberIndexById.values()) {
            campaignsIds.add(campaignMember.CampaignId);
            contactsIds.add(campaignMember.ContactId);
            contactsDetailIds.add(campaignMember.ContactDetail__c);
            leadsIds.add(campaignMember.LeadId);
            if (campaignMember.WhatId__c != null && campaignMember.WhatId__c.startsWith('006')) {
                whatIds.add(campaignMember.WhatId__c);
            }
            if (campaignMember.WhatId__c != null && campaignMember.WhatId__c.startsWith('500')) {
                whatIds.add(campaignMember.WhatId__c);
            }
        }

        Map<String, Campaign> campaignIndexedById = getCampaign2Olos(campaignsIds);
        Map<String, Contact> contactsByIndex = getContact2Olos(contactsIds);
        Map<String, ContactDetail__c> contactsDetailsByIndex = getContactDetail2Olos(contactsDetailIds);
        Map<String, Opportunity> opportunitiesByIndex = getOpportunity2Olos(whatIds);
        Map<String, Lead> leadByIndex = getLead2Olos(leadsIds);
        Map<String, Case> caseByIndex = getCase2Olos(whatIds);

        for (CampaignMember campaignMember : campaignMemberIndexById.values()) {
            ContactDetail__c contactDetail = contactsDetailsByIndex.get(campaignMember.ContactDetail__c);
            Campaign campanha = campaignIndexedById.get(campaignMember.CampaignId);
            Contact contact = contactsByIndex.get(campaignMember.ContactId);
            Lead lead = leadByIndex.get(campaignMember.LeadId);
            Opportunity opp;
            Case cs;

            if (campaignMember.WhatId__c != null && campaignMember.WhatId__c.startsWith('006')) {
                opp = opportunitiesByIndex.get(campaignMember.WhatId__c);
            }
            if (campaignMember.WhatId__c != null && campaignMember.WhatId__c.startsWith('500')) {
                cs = caseByIndex.get(campaignMember.WhatId__c);
            }
             
            if(campanha != null && campanha.ID_Campanha_Olos__c != null && campanha.ID_Campanha_Olos__c != 0 && campaignMember.ContactDetail__c == null && campaignMember.ContactId == null && campaignMember.IntegrationStatus__c != 'Retirado'){
                String jsonRequest = CampaignIntegrationBO.getInsertRecordDataRequestCampaignMember(campaignMember, contact, contactDetail, campanha, opp, cs, isUpdate, true, lead);
                eventToInsert.add(OlosOrchestrationBO.getInstance().sObjectEvent(campaignMember.Id, OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), jsonRequest, false));
            }else if (
                campanha != null &&
                campanha.ID_Campanha_Olos__c != null &&
                campanha.ID_Campanha_Olos__c != 0 &&
                campaignMember.ContactDetail__c != null &&
                campaignMember.ContactId != null &&
                campaignMember.IntegrationStatus__c != 'Retirado'
            ) {
                String jsonRequest = CampaignIntegrationBO.getInsertRecordDataRequestCampaignMember(campaignMember, contact, contactDetail, campanha, opp, cs, isUpdate, true);
                eventToInsert.add(OlosOrchestrationBO.getInstance().sObjectEvent(campaignMember.Id, OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), jsonRequest, false));
            }
        }
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.OlosOrchestrationEvent__c.isCreateable()) {
            System.debug('=>> OlosOrchestrationEvent__c is not createable. <<=');
        }

        if(!eventToInsert.IsEmpty()){
            insert eventToInsert;
            System.enqueueJob(new OlosOrchestrationBO());
        }

    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param campaignMemberIndexById Lista com o objeto de campaign
    */
    public void integrationOlosDeleteCampaignMember(Map<Id, CampaignMember> campaignMemberIndexById) {
        List<OlosOrchestrationEvent__c> eventToDelete = new List<OlosOrchestrationEvent__c>();
        System.debug('## integrationOlosDelete =>> ' + campaignMemberIndexById);
        Set<String> campaignsIds = new Set<String>();
        for (CampaignMember campaignMember : campaignMemberIndexById.values()) {
            campaignsIds.add(campaignMember.CampaignId);
        }
        Map<String, Campaign> campaignIndexedById = getCampaign2Olos(campaignsIds);
        for (CampaignMember campaignMember : campaignMemberIndexById.values()) {
            Campaign campanha = campaignIndexedById.get(campaignMember.CampaignId);
            if (campanha != null && campanha.ID_Campanha_Olos__c != null && campaignMember.IntegrationStatus__c == 'Retirado') {
                String jsonRequest = CampaignIntegrationBO.getFinalizeClienteRequestCampaignMember(campaignMember);
                System.debug('### jsonRequest =>> ' + jsonRequest);
                eventToDelete.add(OlosOrchestrationBO.getInstance().sObjectEvent(campaignMember.Id, OlosEventNames.DELETE_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), jsonRequest, true));
            }
        }

        if(!eventToDelete.IsEmpty()){
            insert eventToDelete;
            System.enqueueJob(new OlosOrchestrationBO());
        }

    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param campaignId Lista com o objeto de campaign
    */
    private static Map<String, Campaign> getCampaign2Olos(Set<String> campaignId) {
        List<Campaign> campanhas = [
            SELECT Id, Nome_do_Mailing_Olos__c, Id_Campanha_Olos__c, Id_Layout_Mailing_Olos__c, IDFinalizeDisposition__c, Name
            FROM Campaign
            WHERE Id IN :campaignId
        ];

        Map<String, Campaign> mapCampaign = new Map<String, Campaign>();
        for (Campaign campaign : campanhas) {
            mapCampaign.put(campaign.Id, campaign);
        }
        return mapCampaign;
    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param contactsIds Lista com o objeto de campaign
    */
    private static Map<String, Contact> getContact2Olos(Set<String> contactsIds) {
        List<Contact> contatos = [
            SELECT Id, Name, IndividualIdentificationNumber__c, Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone, AccountId
            FROM Contact
            WHERE Id IN :contactsIds
        ];

        Map<String, Contact> mapContact = new Map<String, Contact>();
        for (Contact contato : contatos) {
            mapContact.put(contato.Id, contato);
        }
        return mapContact;
    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param contactsDetailIds Lista com o objeto de campaign
    */
    private static Map<String, ContactDetail__c> getContactDetail2Olos(Set<String> contactsDetailIds) {
        List<ContactDetail__c> contactDetail = [
            SELECT Id, Name, HomePhone__c, MobilePhone__c, OtherPhone__c, AssistantPhone__c, BestPhone__c
            FROM ContactDetail__c
            WHERE Id IN :contactsDetailIds
        ];

        Map<String, ContactDetail__c> mapContactDetail = new Map<String, ContactDetail__c>();

        for (ContactDetail__c contatoDetail : contactDetail) {
            mapContactDetail.put(contatoDetail.Id, contatoDetail);
        }

        return mapContactDetail;
    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param opportuntitiesIds Lista com o objeto de campaign
    */
    private static Map<String, Opportunity> getOpportunity2Olos(Set<String> opportuntitiesIds) {
        List<Opportunity> oppotunities = [
            SELECT Id, Name, AgentName__c, Estrategia1__c, Estrategia2__c, Estrategia3__c, Estrategia4__c, Estrategia5__c
            FROM Opportunity
            WHERE Id IN :opportuntitiesIds
        ];

        Map<String, Opportunity> mapOpportunity = new Map<String, Opportunity>();

        for (Opportunity opp : oppotunities) {
            mapOpportunity.put(opp.Id, opp);
        }

        return mapOpportunity;
    }
    
        /**
    * Cria a fila de integração para envio ao Olos
    * @param leadsIds Lista com o objeto de campaign
    */
    private static Map<String, Lead> getLead2Olos(Set<String> leadsIds) {
        List<Lead> leads = [
            SELECT Id, Name, Owner.Name, Email, Phone, LeadSource, Description, Status, MobilePhone, Fax
            FROM Lead
            WHERE Id IN :leadsIds
        ];

        Map<String, Lead> mapLead = new Map<String, Lead>();

        for (Lead ld : leads) {
            mapLead.put(ld.Id, ld);
        }

        return mapLead;
    }
    /**
    * Cria a fila de integração para envio ao Olos
    * @param caseIds Lista com o objeto de casos
    * @return mapCases
    */
    private Map<String,Case> getCase2Olos(Set<String> caseIds){
        List<Case> cases = [
            SELECT Id, CreatedBy.Name,Owner.Name,Description, Status, Subject,Concierge_IncidentWorkflowStatus__c,RequestStatus__c,Reason,Origin
            FROM Case
            WHERE Id IN :caseIds
        ];

        Map<String, Case> mapCases = new Map<String, Case>();

        for (Case cs : cases) {
            mapCases.put(cs.Id, cs);
        }

        return mapCases;
    }
}