@isTest
public class GenesysInsertTabulacaoTest {
    @TestSetup
    static void setup() {
        
        CallLog__c log = new CallLog__c(
            Message__c = '{"id":"e45b938b-4a3d-493e-9bfc-0c3d8f799228","connectedTime":"2024-01-16T14:51:54.828Z","endTime":"2024-01-16T14:56:45.492Z","phone":"tel:+5561985003975","name":"Customer","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":true,"isDialer":true,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Cliente","recordingState":"none","displayAddress":"","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5561985003975","interactionDurationSeconds":291,"totalAcdDurationSeconds":6,"disposition":"VENDA REALIZADA - RAFAEL","dispositionDurationSeconds":3,"direction":"Outbound","isInternal":false,"startTime":"2024-01-16T14:51:49.282Z","isDialerPreview":true,"dialerContactId":"4be2abae5737bf5cc26c9d2d6e760f8c","dialerContactListId":"eb0fcf62-64ed-470f-9017-87be20b164d6","dialerCampaignId":"56d5e140-90ed-4979-9ede-da769be577f9","callbackNumbers":["+5561985003975","+5561985003975"]}',
            ReferenceId__c = 'conversationIdTeste'
        );
        insert log;
        
        System.debug('1');
        
        DispositionPath__c dispP = new DispositionPath__c(
        	Name = 'CallLogTabulacaoTest',
            Reason__c = 'CallLogTabulacaoTest'
        );
        insert dispP;
        
        System.debug('2');
        
        Lead lead = new Lead();
        lead.var2__c = 'var2';
        lead.var3__c = 'var3';
        lead.var4__c = 'var4';
        lead.var5__c = 'var5';
        lead.var6__c = 'var6';
        lead.LastName = 'leadLastName';
        insert lead;

        System.debug('3');
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

        System.debug('4');
        Campaign campanhaTeste = new Campaign();
        campanhaTeste.Name = 'Campanha teste';
        campanhaTeste.PureCloud_Contact_List_ID__c = 'teste purecloudId';
        campanhaTeste.CTI_Name__c = 'Genesys';
        insert campanhaTeste;

        System.debug('5');
        Contact memberContact = new Contact();
        memberContact.Email = 'teste@gmail.com';
        memberContact.LastName = 'membroteste';
        memberContact.Phone = '11990009999';
        memberContact.MobilePhone = '11990009999';
        memberContact.Account = conta;
        insert memberContact;

        System.debug('6');
        ContactDetail__c detalheContato = new ContactDetail__c();
        detalheContato.MobilePhone__c = '19999415861';
        detalheContato.BestPhone__c = '19999415861';
        detalheContato.Contact__c = memberContact.Id;
        detalheContato.Source__c = 'Conseg';
        insert detalheContato;

        System.debug('7');
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
        CallLog__c call = [
            SELECT Id, Message__c
            FROM CallLog__c
            WHERE ReferenceId__c = 'conversationIdTeste'
            LIMIT 1
        ];
        
        DispositionPath__c disp = [SELECT Id FROM DispositionPath__c WHERE Name = 'CallLogTabulacaoTest' LIMIT 1];
        
        System.debug(disp);
        
        CallLogMessageJson2Apex aux = (CallLogMessageJson2Apex)JSON.deserialize(call.Message__c, CallLogMessageJSON2Apex.class);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        Test.startTest();
        System.debug('8');
            CampaignMember cm = new CampaignMember();
            cm.ReferenceId__c = '4be2abae5737bf5cc26c9d2d6e760f8c';
            cm.ContactId = memberContact.Id;
            cm.WhatId__c = opp.Id;
            cm.CampaignId = campanhaTeste.Id;
            cm.ContactDetail__c = detalheContato.Id;
            insert cm;
            System.enqueueJob(new GenesysInsertTabulacao(aux, disp.Id));
        Test.stopTest();
    }
}