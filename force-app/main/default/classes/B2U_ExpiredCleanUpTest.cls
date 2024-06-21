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
public class B2U_ExpiredCleanUpTest {
    @testSetup
    static void setup(){
        Id recordType = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('B2UCampaign').getRecordTypeId();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Campaign camp = CampaignDataFactory.createCampaign();
        Account customer = AccountDataFactory.insertPersonAccount();
        customer = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer.Id];
        camp.Type = 'Call Center Ativo';
        camp.RecordTypeId = recordType;
        insert camp;
        CampaignMember cm = new CampaignMember(CampaignId = camp.Id, ContactId = customer.PersonContactId, CreatedDate = System.today().addDays(-31));
        insert cm;
    }

    @isTest
    static void testImplementation(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
        B2U_ExpiredCleanUpSchedule.schedule();
        B2U_ExpiredCleanUpBatch batch = new B2U_ExpiredCleanUpBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        CampaignMember cm = [SELECT Id, IntegrationStatus__c FROM CampaignMember];
        String expected = 'Retirado';
        String actual = cm.IntegrationStatus__c;
        System.assertEquals(expected, actual, 'Expected integration implementation "Retirado"');
    }
}