/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class MarketingCloudVIPHandlerTest {
    @testSetup
    static void setup(){

        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        User testUser = UserDataFactory.createUser();
        insert testUser;

        Account testAccount = AccountDataFactory.insertPersonAccount();
        Id testContactId = [SELECT PersonContactId FROM Account WHERE id = :testAccount.Id LIMIT 1].PersonContactId;

        ContactDetail__c testCDetail = ContactDetailDataFactory.insertContactDetailVIPWithAssistant(testContactId);

        Opportunity testOpp = OpportunityDataFactory.insertVIPOpportunity(testUser.Id, testAccount.Id);
        System.debug('testOpp' + testOpp);

        System.debug('testOppId' + testOpp.Id);
        System.debug('testOppName' + testOpp.Name);
        Task testOppTask1 = TaskDataFactory.insertVIPOppTask(testCDetail.Contact__c, testOpp.Id);
        System.debug('testOppTask1' + testOppTask1);
    }
    @isTest
    static void callMarketingCloudVipAccountTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
        User testUser = [SELECT Id, Name FROM User LIMIT 1];

        Task task1 = [SELECT id, Disposition__r.Id, Disposition__r.Name, WhoId, CallDisposition FROM Task LIMIT 1];
        System.debug('task1' + task1);
        MarketingCloudVIPHandler.callMarketingCloudVIPAccount(task1.Id);
        Test.stopTest();
    }
    @isTest
    static void callMarketingCloudVipOpportunityTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
        User testUser = [SELECT Id, Name FROM User LIMIT 1];

        Task task1 = [SELECT id, Disposition__r.Name, WhoId FROM Task LIMIT 1];

        MarketingCloudVIPHandler.callMarketingCloudVIPOpportunity(task1.Id);
        Test.stopTest();
    }
}