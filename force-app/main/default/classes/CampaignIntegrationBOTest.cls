@isTest
public class CampaignIntegrationBOTest {
    @isTest
    static void test_executeEvent() {

        try{
            List<OlosOrchestrationEvent__c> listevent = new List<OlosOrchestrationEvent__c>();
            listevent.add( OlosOrchestrationBO.getInstance().sObjectEvent( '1', OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), '', false ) );
            CampaignIntegrationBO campBO = new CampaignIntegrationBO();
            campBO.executeEvent(listevent);

        } catch (Exception ex){

        }
    }

    @isTest
    static void test_sendToOlos()
    {
        OlosOrchestrationEvent__c ooe = new OlosOrchestrationEvent__c(
            RecordId__c = '1',
            EventName__c = 'INSERT',
            Payload__c = ''
        );
        insert ooe;

        CampaignIntegrationBO campBO = new CampaignIntegrationBO();
        campBO.callMethodSendOlos(ooe);

    }

    @isTest
    static void test_getInsertRecordDataRequestCampaignMember()
    {
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        Account acc = AccountDataFactory.insertBusinessAccount();

        // Contact contact = [SELECT Id, Name, LeadSource FROM Contact WHERE Id =: acc.PersonContactId LIMIT 1];
        Contact contact = new Contact(
            LastName = 'Test',
            LeadSource = 'Wiz Benefícios',
            AccountId = acc.Id);

        insert contact;

        ContactDetail__c contactDetail = new ContactDetail__c(
            MobilePhone__c = '11947457383',
            Contact__c = contact.Id,
            Source__c = 'CaixaSeguradora'
        );
        // ContactDetail__c contactDetail = [SELECT Id, Name FROM ContactDetail__c WHERE Contact__c =:contact.Id LIMIT 1];

        insert contactDetail;

        List<Campaign> cpLst = new List<Campaign>();
        Campaign camapign = new Campaign(
            Name = 'Campaign Teste',
            Id_Campanha_Olos__c = 4,
            Id_Layout_Mailing_Olos__c = 4,
            Nome_do_Mailing_Olos__c = 'Mailing_teste',
            IDFinalizeDisposition__c = '107'
        );
        cpLst.add(camapign);
        
        Campaign camapign2 = new Campaign(
            Name = 'Campaign Teste 2',
            Id_Campanha_Olos__c = 5,
            Id_Layout_Mailing_Olos__c = 5,
            Nome_do_Mailing_Olos__c = 'Mailing_teste2',
            IDFinalizeDisposition__c = '108'
        );
		cpLst.add(camapign2);
        insert cpLst;

        Opportunity opportunity = OpportunityDataFactory.createOpportunity();
        insert opportunity;

        Case caso = CaseDataFactory.insertCase();
        
        Lead lead = new Lead();
        lead.var2__c = 'var2';
        lead.LastName = 'leadLastName';
        insert lead;

        List<CampaignMember> cmLst = new List<CampaignMember>();
        CampaignMember campaignMember = new CampaignMember(
            CampaignId = camapign.Id,
            ContactId =  contact.Id,
            ContactDetail__c = contactDetail.Id
        );
        cmLst.add(campaignMember);
        CampaignMember campaignMember2 = new CampaignMember(
            CampaignId = camapign2.Id,
            ContactId =  contact.Id,
            ContactDetail__c = contactDetail.Id,
            LeadId = lead.Id
        );
		cmLst.add(campaignMember2);
        insert cmLst;
        
        

        CampaignIntegrationBO.getInsertRecordDataRequestCampaignMember(campaignMember, contact, contactDetail, camapign, opportunity, caso, false, false);
        CampaignIntegrationBO.getInsertRecordDataRequestCampaignMember(campaignMember2, contact, contactDetail, camapign, opportunity, caso, false, false, lead);

        CampaignIntegrationBO.getFinalizeClienteRequestCampaignMember(campaignMember);
    }

}