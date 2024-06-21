/**
 * @description       :
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 07-12-2023
 * @last modified by  : joao@beecloud.com.br
 **/
@isTest
public class GenesysAddContactListMemberTest {
    @TestSetup
    static void setup() {
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
        conta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
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

    // Classe de mock para simular a chamada HTTP
    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Crie uma resposta simulada
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(
                '[{"id":"responseReferenceId","contactListId":"contactlistid"}]'
            );
            return res;
        }
    }

    @isTest
    public static void addMemberContactTest() {
        ContactDetail__c detalheContato = [
            SELECT Id
            FROM ContactDetail__c
            WHERE MobilePhone__c = '19999415861'
            LIMIT 1
        ];
        Contact memberContact = [
            SELECT Id
            FROM Contact
            WHERE Name LIKE '%membroteste%'
            LIMIT 1
        ];
        Campaign campanhaTeste = [
            SELECT Id
            FROM Campaign
            WHERE Name LIKE '%Campanha teste%'
            LIMIT 1
        ];
        Lead lead = [
            SELECT Id
            FROM Lead
            WHERE Name LIKE '%leadLastName%'
            LIMIT 1
        ];
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            WHERE Name LIKE '%opp name%'
            LIMIT 1
        ];

        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
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