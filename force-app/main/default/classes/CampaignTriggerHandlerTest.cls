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
public class CampaignTriggerHandlerTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
    }

    @isTest
    static void testCampaignTriggerHandler(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Campaign campanha;
        campanha = testInsert();
        System.assert(campanha != null, 'Test Insert');
        campanha = testUpdate(campanha);
        System.assertEquals('Teste 2', campanha.CTIListName__c, 'Test Update');
        campanha = testDelete(campanha);
        System.assert(campanha != null, 'Test Delete');
        campanha = testUndelete(campanha);
        System.assert(campanha != null, 'Test Delete');
    }

    static Campaign testInsert(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;
        Contact ct = ContactDataFactory.insertContact();
        Campaign campanha = CampaignDataFactory.insertCampaign();
        CampaignMember membro = new CampaignMember(ContactId = ct.Id, CampaignId = campanha.Id);
        insert membro;
        Lead ld = LeadDataFactory.insertLead();
        CampaignMember membro2 = new CampaignMember(LeadId = ld.Id, CampaignId = campanha.Id);
        insert membro2;
        return campanha;
    }

    static Campaign testUpdate(Campaign campanha){
        campanha.CTIListName__c = 'Teste';
        update campanha;
        campanha.CTIListName__c = 'Teste 2';
        update campanha;
        return campanha;
    }

    static Campaign testDelete(Campaign campanha){
        delete campanha;
        return campanha;
    }

    static Campaign testUndelete(Campaign campanha){
        undelete campanha;
        return campanha;
    }
}