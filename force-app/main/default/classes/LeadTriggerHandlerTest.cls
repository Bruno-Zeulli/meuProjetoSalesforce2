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
public class LeadTriggerHandlerTest {
    @TestSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
    }

    @isTest
    static void testLeadTriggerHandler(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Lead ld;
        ld = testInsert();
        System.assert(ld != null, 'test Insert');
        ld = testUpdate(ld);
        ld = testDelete(ld);
        ld = testUndelete(ld);
    }

    static Lead testInsert(){
        Lead ld;
        ld = LeadDataFactory.insertLead();
        ld = testValidateIfIsAlreadyClient(ld);
        return ld;
    }

    static Lead testUpdate(Lead ld){
        update ld;
        return ld;
    }

    static Lead testDelete(Lead ld){
        ld = LeadDataFactory.insertLead();
        delete ld;
        return ld;
    }

    static Lead testUndelete(Lead ld){
        undelete ld;
        return ld;
    }

    static Lead testValidateIfIsAlreadyClient(Lead ld){
        Lead ldErro = ld.clone();
         try{
            insert ldErro;
        } catch (DMLException ex){
            System.assert(ex.getMessage().contains(LeadTriggerHandler.MSG_ERROR_CREATING_LEAD_CORPORATE_WHEN_IS_CUSTOMER), '');
        }
        List<Lead> lLeads = [SELECT Id FROM Lead WHERE IdentificationNumber__c = :ld.IdentificationNumber__c];
        return ld;
    }
}