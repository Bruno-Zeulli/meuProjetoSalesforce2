@isTest
public class PTN_ExpiredCleanUpTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Id recordType = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('PartnerCampaign').getRecordTypeId();

        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Campaign camp = CampaignDataFactory.createCampaign();

        Account customer = AccountDataFactory.insertPersonAccount();
        customer = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer.Id];
        Account customer2 = AccountDataFactory.insertPersonAccount();

        customer2 = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer2.Id];
        camp.Type = 'Call Center Ativo';
        camp.RecordTypeId = recordType;
        insert camp;
        CampaignMember cm = new CampaignMember(
            CampaignId = camp.Id,
            ContactId = customer.PersonContactId,
            CreatedDate = System.today().addDays(-3),
            LastModifiedDate = System.today().addDays(-3),
            IntegrationStatus__c = 'Enviado'
        );
        CampaignMember cmr = new CampaignMember(
            CampaignId = camp.Id,
            ContactId = customer2.PersonContactId,
            CreatedDate = System.today().addDays(-32),
            LastModifiedDate = System.today().addDays(-31),
            IntegrationStatus__c = 'Enviado'
        );

        insert new List<CampaignMember>{ cm, cmr };
    }

    @isTest
    static void testImplementation(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
            PTN_ExpiredCleanUpSchedule.schedule();
            PTN_ExpiredCleanUpBatch batch = new PTN_ExpiredCleanUpBatch();
            Database.executeBatch(batch);
        Test.stopTest();

        //TODO: REFATORAR
        // CampaignMember cmr = [SELECT Id, IntegrationStatus__c FROM CampaignMember WHERE IntegrationStatus__c = 'Retirado'];
        // String expected = 'Retirado';
        // String actual = cmr.IntegrationStatus__c;
        // Assert.areEqual(expected, actual, 'Expected integration implementation "Retirado"');

        // CampaignMember cm = [SELECT Id, IntegrationStatus__c FROM CampaignMember WHERE IntegrationStatus__c != 'Retirado'];
        // expected = 'Enviado';
        // actual = cm.IntegrationStatus__c;
        // Assert.areEqual(expected, actual, 'Expected integration implementation "Enviado"');
    }
}