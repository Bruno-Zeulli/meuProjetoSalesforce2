@IsTest
public class GenesysIntegrationServiceTest {
    private static final String CONTACT_CREATION_RESPONSE = '[{"id":"9c8cf8c6c76680b9dfdb9faafcaa4fc6","contactListId":"739530ec-5d11-481e-ab91-c1bf7adc90b3","data":{"Nome":"Julio Souza","CPF_CNPJ":"","Email":"","Telefone1":"61982371750","Telefone2":"","Telefone3":"","Telefone4":"","Telefone5":"","WhatId":"","AccountId":"","ContactId":"","ContactDetailId":"","CampaignMemberId":"00v88000000KyckAAC","ContractId":"","AgentId":"","Estrategia1":"","Estrategia2":"","Estrategia3":"","Estrategia4":"","Estrategia5":"","Aux1":"TESTE SEM PARAR","Aux2":"","Aux3":"","Aux4":"","Aux5":"","Aux6":"","Aux7":"","Aux8":"","Aux9":"","DataCarga":"2023-12-12T18:21Z","Prioridade":"","DataAlocacao":"","FusoHorario":"America/Sao_Paulo"},"callable":true,"phoneNumberStatus":{"Telefone1":{"callable":true},"Telefone5":{"callable":true},"Telefone4":{"callable":true},"Telefone3":{"callable":true},"Telefone2":{"callable":true}},"contactableStatus":{"Email":{"contactable":true}},"configurationOverrides":{"priority":false},"dateCreated":"2023-12-14T18:16:29.644Z","selfUri":"/api/v2/outbound/contactlists/739530ec-5d11-481e-ab91-c1bf7adc90b3/contacts/9c8cf8c6c76680b9dfdb9faafcaa4fc6"}]';
    @TestSetup
    static void dataSetup() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout(CONTACT_CREATION_RESPONSE));
        Lead lead = new Lead();
        lead.LastName = 'leadLastName';
        insert lead;

        Campaign campaign = new Campaign();
        campaign.Name = 'Campanha teste';
        campaign.PureCloud_Contact_List_ID__c = 'teste purecloudId';
        campaign.CTI_Name__c = 'Genesys';
        insert campaign;

        CampaignMember campaignMember = new CampaignMember();
        campaignMember.CampaignId = campaign.Id;
        campaignMember.LeadId = lead.Id;
        insert campaignMember;
    }

    public class MockHttpCallout implements HttpCalloutMock {
        private String responseBody;
        public MockHttpCallout(String responseBody) {
            this.responsebody = responsebody;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.responseBody);
            return res;
        }
    }

    @IsTest
    static void getDialerDetailTest() {
        CampaignMember campaignMember = [SELECT Id, LeadId FROM CampaignMember];

        String responseBody = '{ "id": "4d8b424c6f9e6661a51e605e825e326a", "contactListId": "c8540d19-e8cb-420e-bd97-5452e9f24e1f", "data": { "Nome": "Julio Souza", "CPF_CNPJ": "", "Email": "", "Telefone1": "61982371750", "Telefone2": "", "Telefone3": "", "Telefone4": "", "Telefone5": "", "WhatId": "", "AccountId": "", "ContactId": "", "ContactDetailId": "", "CampaignMemberId": "' +
                    campaignMember.Id +
                    '", "ContractId": "", "AgentId": "", "Estrategia1": "", "Estrategia2": "", "Estrategia3": "", "Estrategia4": "", "Estrategia5": "", "Aux1": "TESTE SEM PARAR", "Aux2": "", "Aux3": "", "Aux4": "", "Aux5": "", "FusoHorario": "America/Sao_Paulo" }, "callRecords": { "Telefone1": { "lastAttempt": "2023-12-12T20:41:12.981Z", "lastResult": "ININ-WRAP-UP-TIMEOUT" }, "Telefone5": { "lastAttempt": "2023-12-12T20:38:46.497Z", "lastResult": "ININ-OUTBOUND-INVALID-PHONE-NUMBER" }, "Telefone4": { "lastAttempt": "2023-12-12T20:38:46.497Z", "lastResult": "ININ-OUTBOUND-INVALID-PHONE-NUMBER" }, "Telefone3": { "lastAttempt": "2023-12-12T20:38:46.497Z", "lastResult": "ININ-OUTBOUND-INVALID-PHONE-NUMBER" }, "Telefone2": { "lastAttempt": "2023-12-12T20:38:46.497Z", "lastResult": "ININ-OUTBOUND-INVALID-PHONE-NUMBER" } }, "callable": true, "phoneNumberStatus": { "Telefone1": { "callable": true }, "Telefone5": { "callable": true }, "Telefone4": { "callable": true }, "Telefone3": { "callable": true }, "Telefone2": { "callable": true } }, "contactableStatus": { "Email": { "contactable": true } }, "dateCreated": "2023-12-12T18:00:46.983Z", "selfUri": "/api/v2/outbound/contactlists/c8540d19-e8cb-420e-bd97-5452e9f24e1f/contacts/4d8b424c6f9e6661a51e605e825e326a" }';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout(responsebody));

        Test.startTest();
            String response = GenesysIntegrationService.getDialerDetail('', '');
        Test.stopTest();

        Assert.areEqual(
            '{"objectApiName":"Lead","recordId":"' + campaignMember.LeadId  + '"}',
            response
            );
    }

    @IsTest
    static void createContactsTest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout(CONTACT_CREATION_RESPONSE));

        Test.startTest();
            String response = GenesysIntegrationService.createContacts('', '');
        Test.stopTest();

        Assert.areEqual(
            CONTACT_CREATION_RESPONSE,
            response
            );
    }
}