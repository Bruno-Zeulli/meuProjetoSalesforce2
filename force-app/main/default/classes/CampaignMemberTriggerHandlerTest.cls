/**
 * @description       :
 * @author            : WindsonSantos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class CampaignMemberTriggerHandlerTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;
        //Crie seus dados de teste mock aqui
        Contact contact = new Contact(FirstName = 'Mock', LastName = 'Contact');
        insert contact;

        ContactDetail__c contactDetail = new ContactDetail__c(Contact__c = contact.Id, Name = contact.Name, BestPhone__c = contact.MobilePhone, Source__c = 'Parceiros');
        insert contactDetail;

        Campaign campaign = new Campaign(Name = 'CONSORCIO BV PARCEIROS', CTIListName__c = 'CONSORCIO BV PARCEIROS', CTI_Name__c = 'Five9');
        insert campaign;

        CampaignMember campaignMember = new CampaignMember(
            ContactId = contact.Id,
            CampaignId = campaign.Id,
            IntegrationStatus__c = 'Enviado',
            ContactDetail__c = contactDetail.Id
        );
        insert campaignMember;

        Lead lead = new Lead();
        lead.var2__c = 'var2';
        lead.var3__c = 'var3';
        lead.var4__c = 'var4';
        lead.var5__c = 'var5';
        lead.var6__c = 'var6';
        lead.LastName = 'leadLastName';
        insert lead;

        Account conta = new Account();
        conta.LastName = 'conta teste';
        conta.IdentificationNumber__c = '19622742092';
        conta.AccountSource = 'Corporate';
        conta.Gender__pc = 'Masculino';
        conta.IndividualIdentificationNumber__pc = '19622742092';
        conta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        insert conta;

        Campaign campanhaTeste = new Campaign();
        campanhaTeste.Name = 'Campanha teste';
        campanhaTeste.PureCloud_Contact_List_ID__c = 'teste purecloudId';
        campanhaTeste.CTI_Name__c = 'Genesys';
        insert campanhaTeste;

        Contact memberContact = new Contact();
        memberContact.Email = 'teste@gmail.com';
        memberContact.LastName = 'membroteste';
        memberContact.Phone = '11990009999';
        memberContact.MobilePhone = '11990009999';
        memberContact.Account = conta;
        insert memberContact;

        ContactDetail__c detalheContato = new ContactDetail__c();
        detalheContato.MobilePhone__c = '19999415861';
        detalheContato.BestPhone__c = '19999415861';
        detalheContato.Contact__c = memberContact.Id;
        detalheContato.Source__c = 'Conseg';
        insert detalheContato;

        Opportunity opp = new Opportunity();
        opp.AgentName__c = 'Agente teste';
        opp.Estrategia1__c = 'estrategia1';
        opp.Estrategia2__c = 'estrategia2';
        opp.Estrategia3__c = 'estrategia3';
        opp.Estrategia4__c = 'estrategia4';
        opp.Estrategia5__c = 'estrategia5';
        opp.Name = 'opp name';
        opp.StageName = 'Aberto';
        opp.CloseDate = Date.today() + 1;
        insert opp;
    }

    @isTest
    static void testCampaignMemberTriggerHandler(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        CampaignMember cm = testInsert();
        System.assert(cm != null, 'Test Insert');
        cm = testUpdate(cm);
        System.assert(cm.IntegrationStatus__c == 'Enviado', 'Intergration Status must be "Enviado"');
        cm = testDelete(cm);
        System.assert(cm != null, 'Test Delete');
    }

    static CampaignMember testInsert(){
        Contact ct = ContactDataFactory.insertContact();
        Campaign campanha = CampaignDataFactory.insertCampaign();
        CampaignMember membro = new CampaignMember(ContactId = ct.Id, CampaignId = campanha.Id);
        insert membro;
        Lead ld = LeadDataFactory.insertLead();
        CampaignMember membro2 = new CampaignMember(LeadId = ld.Id, CampaignId = campanha.Id);
        insert membro2;
        return membro;
    }

    static CampaignMember testUpdate(CampaignMember cm){
        cm.IntegrationStatus__c = 'Retirado';
        update cm;
        cm.IntegrationStatus__c = 'Enviado';
        update cm;
        return cm;
    }

    static CampaignMember testDelete(CampaignMember cm){
        delete cm;
        return cm;
    }

     @isTest
    static void testGetCampaignMembersByListMap(){
        // Test for the getCampaignMembersByListMap method
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        // Create test data
        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert contact;

        ContactDetail__c contactDetail = new ContactDetail__c(Contact__c = contact.Id, Name = contact.Name, BestPhone__c = contact.MobilePhone, Source__c = 'Parceiros');
        insert contactDetail;

        Campaign campaign = new Campaign(Name = 'Test Campaign', CTIListName__c = 'TestList');
        insert campaign;

        CampaignMember campaignMember = new CampaignMember(
            ContactId = contact.Id,
            CampaignId = campaign.Id,
            IntegrationStatus__c = 'Enviado',
            ContactDetail__c = contactDetail.Id
        );
        insert campaignMember;
    }

    @isTest
    static void testRemoveCampaignMemberOneCampaignForAnotherCampaign() {
        // Crie seus dados de teste aqui (Campaigns, CampaignMembers, etc.)
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact', MobilePhone = '61999875853');
        insert contact;
        ContactDetail__c contactDetail = new ContactDetail__c(Contact__c = contact.Id, Name = contact.Name, BestPhone__c = contact.MobilePhone, Source__c = 'Parceiros');
        insert contactDetail;
        Campaign campaign = new Campaign(Name = 'Test Campaign', CTIListName__c = 'TestList');
        insert campaign;

        CampaignMember campaignMember = new CampaignMember(
            ContactId = contact.Id,
            CampaignId = campaign.Id,
            IntegrationStatus__c = 'Enviado',
            ContactDetail__c = contactDetail.Id
        );
        insert campaignMember;
        // Chame o método que você deseja testar
        Test.startTest();
        // Chamada para o método sendo testado
        campaignMember.IntegrationStatus__c ='Retirado';
        update campaignMember;
        // delete campaignMember;
        Test.stopTest();

        // Realize as verificações/asserts necessárias para verificar se o método funcionou corretamente
        // Exemplo:
        // Verifique se o IntegrationStatus__c dos CampaignMembers foi atualizado para 'Retirado'
        List<CampaignMember> updatedCampaignMembers = [SELECT Id, IntegrationStatus__c FROM CampaignMember WHERE IntegrationStatus__c = 'Retirado'];
        // System.assertEquals(lCampaignMembersRetirar.size(), updatedCampaignMembers.size());
        for (CampaignMember updatedMember : updatedCampaignMembers) {
            System.assertEquals('Retirado', updatedMember.IntegrationStatus__c);
        }
    }

    @isTest 
    public static void callAddContactListMemberTest(){
        ContactDetail__c detalheContato = [SELECT Id FROM ContactDetail__c WHERE MobilePhone__c = '19999415861' LIMIT 1];
        Contact memberContact = [SELECT Id FROM Contact WHERE Name LIKE '%membroteste%' LIMIT 1];
        Campaign campanhaTeste = [SELECT Id FROM Campaign WHERE Name LIKE '%Campanha teste%' LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE Name LIKE '%leadLastName%' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name LIKE '%opp name%' LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
            CampaignMember membroCampanha = new CampaignMember();
            membroCampanha.ContactId = memberContact.Id;
            membroCampanha.CampaignId = campanhaTeste.Id;
            membroCampanha.WhatId__c = opp.Id;
            membroCampanha.LeadId = lead.Id;
            membroCampanha.ContactDetail__c = detalheContato.Id;
            insert membroCampanha;
        Test.stopTest();
    }
}