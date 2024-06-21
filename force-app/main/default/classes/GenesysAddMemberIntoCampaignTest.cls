@IsTest
public class GenesysAddMemberIntoCampaignTest {
    @TestSetup
    static void makeData(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;

        Campaign campanhaInvocable = new Campaign();
        campanhaInvocable.Name = 'Conseg Invocable teste';
        campanhaInvocable.CampaignSource__c = 'Conseg';
        insert campanhaInvocable;

        Contact contato = new Contact();
        contato.LastName = 'contato teste';
        contato.MobilePhone = '11997486238';
        insert contato;

        ContactDetail__c detalhe = new ContactDetail__c();
        detalhe.Name = 'detalhe teste';
        detalhe.MobilePhone__c = '11997486238';
        detalhe.Source__c = 'Conseg';
        detalhe.Contact__c = contato.Id;
        insert detalhe;

        CallLog__c log = new CallLog__c();
        log.Queue__c = 'Conseg teste';
        insert log;

        Campaign campanha = new Campaign();
        campanha.Name = 'Conseg teste';
        campanha.CTIListName__c = log.Queue__c;
        campanha.CampaignSource__c = detalhe.Source__c;
        insert campanha;

        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        Lead lead = new Lead();
        lead.LeadSource = 'Conseg';
        lead.LastName = 'LeadDisparoAtivo ';
        lead.MobilePhone = '11997486238';
        insert lead;

        ContentVersion cv = new ContentVersion();
        cv.Title = 'title';
        cv.VersionData = Blob.valueOf('data');
        cv.PathOnClient = 'file.csv';
        insert cv;
    }

    @isTest
    public static void addContactIntoCampaignTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Id log = [SELECT Id FROM CallLog__c WHERE Queue__c = 'Conseg teste' LIMIT 1].Id;
        Id detalheContato = [SELECT Id FROM ContactDetail__c WHERE Name = 'detalhe teste' LIMIT 1].Id;
        Id campanhaInvocable = [SELECT Id FROM Campaign WHERE Name = 'Conseg Invocable teste' LIMIT 1].Id;
        GenesysAddMemberIntoCampaign.Input input = new GenesysAddMemberIntoCampaign.Input();

        input.campaignId = campanhaInvocable;
        input.leads = new List<Lead>{ new Lead(LastName = 'lead')};
        input.recordTypeId = '';

        Test.startTest();
            GenesysAddMemberIntoCampaign.createLeadsAndCampaignMembers(new List<GenesysAddMemberIntoCampaign.Input>{input});

            // Testar contato
            GenesysAddMemberIntoCampaign.addContactIntoCampaign(log, detalheContato);

            // Testar lead
            GenesysAddMemberIntoCampaign.addLeadIntoCampaign(log, [SELECT Id FROM Lead].Id);
        Test.stopTest();
    }
}