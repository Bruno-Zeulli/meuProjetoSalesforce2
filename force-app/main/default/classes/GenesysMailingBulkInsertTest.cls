@IsTest
public class GenesysMailingBulkInsertTest {

    public class MockHttpCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
             res.setBody('[{"id":"responseReferenceId","contactListId":"contactlistid"}]');
            return res;
        }
    }

    @IsTest
    static void insertLeadAndCampaignMemberTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());

        GenesysMailingCreation__e event = new GenesysMailingCreation__e();
        event.CampaignId__c = 'campaignId';
        event.UserId__c = UserInfo.getUserId();
        event.RecordTypeId__c = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' LIMIT 1].Id;
        event.Lead__c = JSON.serialize(new Lead(LastName = 'abc'));

        Test.startTest();
            GenesysMailingBulkInsert.insertLeadAndCampaignMember(new List<GenesysMailingCreation__e>{ event });
            EventBus.publish(event);
        Test.stopTest();
    }
}