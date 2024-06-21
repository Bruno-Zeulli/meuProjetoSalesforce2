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
public without sharing class CampaignActivityBOTest {
    @isTest
    static void shouldResultInsertCampaingActivity(){
        List<CampaignActivity__c> lInsertCampaignActivity = new List<CampaignActivity__c>();

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

        lInsertCampaignActivity.add(
            new CampaignActivity__c(
                AllocationDate__c = date.today(),
                ContactDetail__c = objContacDetail.Id
            )
        );

        Test.startTest();
        CampaignActivityBO.getInstance().lstInsertCampaignActivity(lInsertCampaignActivity);
        Test.stopTest();
    }    
}