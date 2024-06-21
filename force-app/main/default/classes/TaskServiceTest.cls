@isTest
public class TaskServiceTest {
    @TestSetup
    static void setup() {
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;
        
        CallLog__c log = new CallLog__c(
            Message__c = '{"id":"e45b938b-4a3d-493e-9bfc-0c3d8f799228","connectedTime":"2024-01-16T14:51:54.828Z","endTime":"2024-01-16T14:56:45.492Z","phone":"tel:+5561985003975","name":"Customer","isConnected":false,"isDisconnected":true,"isDone":true,"state":"DESCONECTADO","isCallback":true,"isDialer":true,"isChat":false,"isEmail":false,"isMessage":false,"isVoicemail":false,"remoteName":"Cliente","recordingState":"none","displayAddress":"","queueName":"Teste_Dev","ani":"Interno","calledNumber":"+5561985003975","interactionDurationSeconds":291,"totalAcdDurationSeconds":6,"disposition":"VENDA REALIZADA - RAFAEL","dispositionDurationSeconds":3,"direction":"Outbound","isInternal":false,"startTime":"2024-01-16T14:51:49.282Z","isDialerPreview":true,"dialerContactId":"4be2abae5737bf5cc26c9d2d6e760f8c","dialerContactListId":"eb0fcf62-64ed-470f-9017-87be20b164d6","dialerCampaignId":"56d5e140-90ed-4979-9ede-da769be577f9","callbackNumbers":["+5561985003975","+5561985003975"]}',
            ReferenceId__c = 'conversationIdTeste',
            Queue__c = 'Fila Teste',
            Address__c = '+5519999415861'
        );
        insert log;
        
        DispositionPath__c dispP = new DispositionPath__c(
        	Name = 'CallLogTabulacaoTest',
            Reason__c = 'CallLogTabulacaoTest',
            ExternalId__c = '3de172be-4b8b-488c-80fa-46d79663c0ad'
        );
        insert dispP;
        
        Lead lead = new Lead();
        lead.var2__c = 'var2';
        lead.var3__c = 'var3';
        lead.var4__c = 'var4';
        lead.var5__c = 'var5';
        lead.var6__c = 'var6';
        lead.Phone = '19999415861';
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
        campanhaTeste.CTIListName__c = 'Fila Teste';
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
        CallLog__c call = [
            SELECT Id, Message__c
            FROM CallLog__c
            WHERE ReferenceId__c = 'conversationIdTeste'
            LIMIT 1
        ];
        
        DispositionPath__c disp = [SELECT Id, ExternalId__c FROM DispositionPath__c WHERE Name = 'CallLogTabulacaoTest' LIMIT 1];
        
        System.debug(disp);
        
        CallLogMessageJson2Apex aux = (CallLogMessageJson2Apex)JSON.deserialize(call.Message__c, CallLogMessageJSON2Apex.class);
        
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
            CampaignMember cm = new CampaignMember();
            cm.ReferenceId__c = '4be2abae5737bf5cc26c9d2d6e760f8c';
            cm.ContactId = memberContact.Id;
            cm.WhatId__c = opp.Id;
            cm.CampaignId = campanhaTeste.Id;
            cm.ContactDetail__c = detalheContato.Id;
            insert cm;
            TaskService.createTabulationExpiredTask(call.Id);
            TaskService.createTabulationPreviewTask(call.Id, '1.1.1 - Dúvidas gerais');
        Test.stopTest();
    }
}