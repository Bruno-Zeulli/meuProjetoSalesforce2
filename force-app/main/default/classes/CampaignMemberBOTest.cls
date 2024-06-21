/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-09-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-09-2022   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public without sharing class CampaignMemberBOTest {
    @isTest
    static void shouldResultInsertCampaignMember(){
        
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;

        
        List<CampaignMember> lInsertCampaignMember = new List<CampaignMember>();     
        
        Id rtContactDetail = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName()
                                                                    .get('Parceiros')
                                                                    .getRecordTypeId();


        Account customer = AccountDataFactory.insertPersonAccount();
        Contact objContact =  ContactDataFactory.insertContact();
        ContactDetail__c objContacDetail = ContactDetailDataFactory.createContactDetail();
        objContacDetail.Contact__c = objContact.Id;
        objContacDetail.RecordTypeId = rtContactDetail;
        objContacDetail.Source__c = 'Parceiros';
        insert objContacDetail;

        Campaign objCampaign = CampaignDataFactory.insertCampaign('PartnerCampaign');
        objCampaign.CTIListName__c = 'PARCEIROS - Retencao CNP';
        update objCampaign;

        lInsertCampaignMember.add(CampaignMemberDataFactory.createCampaignMember(
            objCampaign.Id, 
            objContact.Id, 
            null
        ));

        CampaignMemberBO.getInstance().lstInsertCampaignMember(lInsertCampaignMember);
        Test.stopTest();
    } 
    
    @isTest
    static void shouldResultUpdateCampaignMember(){
        
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ctype = new ContentType__C();
        ctype.Template__c = 'application/x-www-form-urlencoded';
        ctype.Name = 'x-www-form-urlencoded';
        ctype.Type__c = 'application';
        insert ctype;


        List<CampaignMember> lUpdCampaignMember= new List<CampaignMember>();     

        Id rtContactDetail = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName()
                                                                    .get('Parceiros')
                                                                    .getRecordTypeId();


        Account customer = AccountDataFactory.insertPersonAccount();
        Contact objContact =  ContactDataFactory.insertContact();
        ContactDetail__c objContacDetail = ContactDetailDataFactory.createContactDetail();
        objContacDetail.Contact__c = objContact.Id;
        objContacDetail.RecordTypeId = rtContactDetail;
        objContacDetail.Source__c = 'Parceiros';
        insert objContacDetail;

        Campaign objCampaign = CampaignDataFactory.insertCampaign('PartnerCampaign');
        objCampaign.CTIListName__c = 'PARCEIROS - Retencao CNP';
        update objCampaign;
        
        CampaignMember objCampaignMember = CampaignMemberDataFactory.insertCampaignMember(
                                                objCampaign.Id, 
                                                objContact.Id
                                            );

        lUpdCampaignMember.add(objCampaignMember);

        CampaignMemberBO.getInstance().lstUpdCampaignMember(lUpdCampaignMember);
        Test.stopTest();
    }    
}