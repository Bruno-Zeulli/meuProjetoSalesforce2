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
public class ContactDetailTriggerHandlerTest {
    static final string PARTNERS_RECORD_TYPE_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Parceiros').getRecordTypeId();
    static final string CAIXA_RECORD_TYPE_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Caixa').getRecordTypeId();

    static ContactDetail__c testInsert(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Id personContactId = [SELECT PersonContactId FROM Account WHERE Id = :acc.Id].PersonContactId;

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunityWithRecordType(acc.Id, 'Conseg');
        objOpportunity.StageName = 'Aberto';
        update objOpportunity;

        Opportunity objOpportunity2 = OpportunityDataFactory.createOpportunityWithRecordType(acc.Id, 'Conseg');
        objOpportunity2.StageName = 'Fechado e ganho';
        update objOpportunity2;

        Opportunity objOpportunity3 = OpportunityDataFactory.createOpportunityWithRecordType(acc.Id, 'B2U_Direct2Sales');
        objOpportunity3.StageName = 'Aberto';
        update objOpportunity3;

        ContactDetail__c contactDetail = ContactDetailDataFactory.createContactDetail();
        contactDetail.Contact__c = personContactId;
        insert contactDetail;

        ContactDetail__c contactDetail2 = ContactDetailDataFactory.createContactDetail();
        contactDetail2.Contact__c = personContactId;
        contactDetail2.RecordTypeId = PARTNERS_RECORD_TYPE_ID;
        contactDetail2.Source__c = 'Parceiros';
        contactDetail2.otherphone__c = '1132147896';
        insert contactDetail2;

        ContactDetail__c contactDetail3 = ContactDetailDataFactory.createContactDetail();
        contactDetail3.Contact__c = personContactId;
        contactDetail3.RecordTypeId = CAIXA_RECORD_TYPE_ID;
        contactDetail3.Source__c = 'CaixaSeguradora';
        contactDetail3.RelationshipGroup__c = 'VIP';
        insert contactDetail3;

        Campaign camp = CampaignDataFactory.insertCampaign();
        CampaignMember cm = CampaignMemberDataFactory.insertCampaignMember(camp.Id, personContactId);
        cm.ContactDetail__c = contactDetail.Id;
        update cm;
        return contactDetail;
    }

    static ContactDetail__c testUpdate(ContactDetail__c contactDetail){
        contactDetail.HomePhone__c = '551132147896';
        contactDetail.otherphone__c = '011551132147896';
        contactDetail.assistantphone__c = '1132147896';
        update contactDetail;
        return contactDetail;
    }

    static ContactDetail__c testDelete(ContactDetail__c contactDetail){
        delete contactDetail;
        return contactDetail;
    }

    static ContactDetail__c testUndelete(ContactDetail__c contactDetail){
        undelete contactDetail;
        return contactDetail;
    }

    @isTest
    static void testContactDetailTriggerHandler(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ContactDetail__c contactDetail;
        contactDetail = testInsert();
        System.assert(contactDetail != null, 'test Insert');
        contactDetail = testUpdate(contactDetail);
        contactDetail = testDelete(contactDetail);
        contactDetail = testUndelete(contactDetail);
    }

    private static Id getRecordTypeId(String rtDeveloperName){
        return Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get(rtDeveloperName).getRecordTypeId();
    }
}