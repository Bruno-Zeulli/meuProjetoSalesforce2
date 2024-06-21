/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class B2U_AlreadyRenewedCleanUpTest {
    @testSetup
    static void setup(){
        List<RenewalCampaign__c> lCampaigns = RenewalCampaignDataFactory.insertRenewalCampaigns();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Campaign auto = CampaignDataFactory.createCampaign();
        auto.Name = lCampaigns.get(0).CampaignName__c;
        Account customer = AccountDataFactory.insertPersonAccount();
        customer = [SELECT Id, PersonContactId FROM Account WHERE Id = :customer.Id];
        insert auto;

        CampaignMemberDataFactory.insertCampaignMember(auto.Id, customer.PersonContactId);
        Product2 product = ProductDataFactory.insertProductAuto();
        Contract2__c contract = ContractDataFactory.insertContractAuto(customer.Id, product);
    }

    @isTest
    static void testImplementation(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.startTest();
        B2U_AlreadyRenewedCleanUpSchedule.schedule();
        B2U_AlreadyRenewedCleanUpBatch batch = new B2U_AlreadyRenewedCleanUpBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        CampaignMember cm = [SELECT Id, IntegrationStatus__c FROM CampaignMember];
        String expected = 'Retirado';
        String actual = cm.IntegrationStatus__c;
        System.assertEquals(expected, actual, 'Expected integration implementation "Retirado"');
    }
}