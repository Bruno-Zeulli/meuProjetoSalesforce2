/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class ContactDetailTriggerHandler {
    private boolean isExecuting = false;

    public List<ContactDetail__c> oldRecordsList;
    public List<ContactDetail__c> newRecordsList;
    public Map<Id, ContactDetail__c> oldRecordsMap;
    public Map<Id, ContactDetail__c> newRecordsMap;

    public static final string PARTNERS_RECORD_TYPE_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Parceiros').getRecordTypeId();
    public static final string CAIXA_RECORD_TYPE_ID = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Caixa').getRecordTypeId();

    public ContactDetailTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){
        createReferenceId();
        // updatePhones();
        // callUpdateContactDetailVipFlow();
    }

    public void onAfterInsert(){
        System.debug(LoggingLevel.FINEST, 'On Before Insert');
    }

    public void onBeforeUpdate(){
        createReferenceId();
        // updatePhones();
        // callUpdateContactDetailVipFlow();
    }

    public void onAfterUpdate(){
        updateCTI();
    }

    private void updateCTI(){
        Set<Id> contactDetailsWithUpdatedPhone = new Set<Id>();
        List<String> lstContactId = new List<String>();

        for(ContactDetail__c cd : newRecordsList){
            Id key = cd.Id;
            String contactId = cd.Contact__c;
            if(
                (newRecordsMap.get(key).HomePhone__c != oldRecordsMap.get(key).HomePhone__c) ||
                (newRecordsMap.get(key).MobilePhone__c != oldRecordsMap.get(key).MobilePhone__c) ||
                (newRecordsMap.get(key).OtherPhone__c != oldRecordsMap.get(key).OtherPhone__c)
            ){
                contactDetailsWithUpdatedPhone.add(key);
                lstContactId.add(contactId);
            }
        }

        if(Schema.sObjectType.Opportunity.isAccessible() || !Schema.sObjectType.CampaignMember.isAccessible()){
            System.debug(LoggingLevel.FINEST, 'OBJECT NOT ACCESSIBLE');
        }

        // Verifica se existe opportunidade relacionado ao contato
        List<Opportunity> lstObjOpportunity = [
            SELECT ContactId, RecordType.DeveloperName, StageName
            FROM Opportunity
            WHERE ContactId IN :lstContactId OR Account.PersonContactId IN :lstContactId
        ];

        // lstContactId.clear();

        for(Opportunity objOpp : lstObjOpportunity){
            if(objOpp.RecordType.DeveloperName == 'Conseg' && (objOpp.StageName != 'Aberto' || objOpp.StageName != 'Em tratamento')){
                lstContactId.add(objOpp.ContactId);
            }else if(objOpp.RecordType.DeveloperName != 'Conseg'){
                lstContactId.add(objOpp.ContactId);
            }
        }

        List<CampaignMember> campaignMembersList = [
            SELECT
                Id,
                LeadOrContactId,
                ContactDetail__r.MobilePhone__c,
                ContactDetail__r.HomePhone__c,
                ContactDetail__r.OtherPhone__c,
                ContactDetail__r.BestPhone__c,
                ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                FirstName,
                LastName,
                Campaign.CTIListName__c,
                Campaign.RecordType.DeveloperName,
                MobilePhone,
                Phone,
                Lead.IdentificationNumber__c,
                CampaignId,
                CreatedDate,
                Priority__c,
                Contrato__r.ContractNumber__c,
                Contrato__r.StartDate__c,
                Contrato__r.BidDate__c,
                ContactDetail__r.BestEmail__c
            FROM CampaignMember
            WHERE
                ContactDetail__c IN :contactDetailsWithUpdatedPhone
                AND LeadOrContactId IN :lstContactId
                AND (ContactDetail__r.RecordType.DeveloperName != 'Conseg'
                OR Campaign.RecordType.DeveloperName != 'CONSEGCampaign')
                AND IntegrationStatus__c = 'Enviado'
        ];

        if(!Test.isRunningTest()){
            Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = getCampaignMembersByListMap(campaignMembersList);
            CTIIntegrationQueueable queueable = new CTIIntegrationQueueable(mapCampaignMembersByList, Trigger.OperationType);
            System.enqueueJob(queueable);
        }
    }

    private Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> getCampaignMembersByListMap(List<CampaignMember> lCampaignMembers){
        Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = new Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>();
        for(CampaignMember cm : lCampaignMembers){
            String key = cm.Campaign.CTIListName__c;
            CTIIntegrationQueueable.CTIIntegrationModel ctiModel;
            ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                cm.ContactDetail__r.MobilePhone__c,
                cm.ContactDetail__r.HomePhone__c,
                cm.ContactDetail__r.OtherPhone__c,
                cm.ContactDetail__r.BestPhone__c,
                cm.FirstName,
                cm.LastName,
                cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                cm.LeadOrContactId,
                cm.CreatedDate,
                cm.Priority__c,
                cm.Contrato__r.ContractNumber__c,
                cm.Contrato__r.StartDate__c,
                cm.Contrato__r.BidDate__c,
                cm.ContactDetail__r.BestEmail__c
            );
            if(key != null){
                if(!mapCampaignMembersByList.containsKey(key)){
                    mapCampaignMembersByList.put(key, new List<CTIIntegrationQueueable.CTIIntegrationModel>());
                }
                mapCampaignMembersByList.get(key).add(ctiModel);
            }
        }
        return mapCampaignMembersByList;
    }

    private void updatePhones(){
        System.debug('<---------------------- START UPDATE PHONE NUMBERS ---------------------->');
        List<String> listFields = new List<String>();
        Map<String, String> mapNumbersByValue = new Map<String, String>();
        Map<Id, ContactDetail__c> mapContactDetail = new Map<Id, ContactDetail__c>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('ContactDetail__c').getDescribe().fields.getMap();

        for(String fieldName : fieldMap.keySet()){
            if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.Phone){
                String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                System.debug('### FIELD NAME --> ' + fieldName);
                listFields.add(fieldName);
            }
        }

        for(ContactDetail__c cd : newRecordsList){
            mapContactDetail.put(cd.Id, cd);
            midiaData(listFields, mapContactDetail);
            //   mapNumbersByValue.put(fieldName, phoneNumber);
        }

        //         // if(cd.RecordTypeId == PARTNERS_RECORD_TYPE_ID && cd.Source__c == 'Parceiros'){
        // if(listFields.isEmpty()){

        //         }

        //         }
        // String queryCustom = String.escapeSingleQuotes('SELECT Name, Id,' + String.join(listFields, ',') + ' FROM ContactDetail__c WHERE Id = ');
        // queryCustom += '\'' + cd.Id + '\'';
        // System.debug('### queryCustom => ' + queryCustom);

        // System.debug(record);
        // updateCTI();
        System.debug('<---------------------- FINISH UPDATE PHONE NUMBERS ---------------------->');
        // return record;
    }

    private void midiaData(List<String> listFields, Map<Id, ContactDetail__c> recordMap){
        Map<String, String> mapNumbersByValue = new Map<String, String>();

        for(String item : listFields){
            for(ContactDetail__c record : recordMap.values()){
                String phoneNumber = (String) record.get(item);
                String dddPhone = '';
                String ddrPhone = '';

                if(phoneNumber != null){
                    if(phoneNumber.length() > 11 && phoneNumber.indexOf('01155') >= 0){
                        phoneNumber = phoneNumber.substring(5);
                        brazilPhoneFormat(record, phoneNumber, item);
                    }

                    if((phoneNumber.length() > 11) && (phoneNumber.substring(0, 2) == '55')){
                        phoneNumber = phoneNumber.substring(2, phoneNumber.length());
                        brazilPhoneFormat(record, phoneNumber, item);
                    }

                    if((phoneNumber.length() == 10) && (phoneNumber.substring(2, 3) == '9' || phoneNumber.substring(2, 3) == '8' || phoneNumber.substring(2, 3) == '7')){
                        dddPhone = phoneNumber.substring(0, 2);
                        ddrPhone = phoneNumber.substring(2, phoneNumber.length());
                        phoneNumber = (dddPhone + '9' + ddrPhone);
                        brazilPhoneFormat(record, phoneNumber, item);
                    }

                    if(record.RecordTypeId == PARTNERS_RECORD_TYPE_ID){
                        five9PhoneFormat(record, phoneNumber, item);
                    }

                    dddPhone = phoneNumber.substring(0, 2);
                    ddrPhone = phoneNumber.substring(2, phoneNumber.length());
                    mapNumbersByValue.put(item, dddPhone + ddrPhone);
                }
            }
        }
    }

    private ContactDetail__c brazilPhoneFormat(ContactDetail__c cd, String phoneNumber, String item){
        if(phoneNumber != null && item == 'homephone__c'){
            cd.HomePhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'mobilephone__c'){
            cd.MobilePhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'otherphone__c'){
            cd.OtherPhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'assistantphone__c'){
            cd.AssistantPhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'bestphone__c'){
            cd.BestPhone__c = phoneNumber;
        }
        return cd;
    }

    private ContactDetail__c five9PhoneFormat(ContactDetail__c cd, String phoneNumber, String item){
        if(phoneNumber != null && item == 'homephone__c'){
            phoneNumber = '01155' + phoneNumber;
            cd.HomePhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'mobilephone__c'){
            phoneNumber = '01155' + phoneNumber;
            cd.MobilePhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'otherphone__c'){
            phoneNumber = '01155' + phoneNumber;
            cd.OtherPhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'assistantphone__c'){
            phoneNumber = '01155' + phoneNumber;
            cd.AssistantPhone__c = phoneNumber;
        }
        if(phoneNumber != null && item == 'bestphone__c'){
            phoneNumber = '01155' + phoneNumber;
            cd.BestPhone__c = phoneNumber;
        }
        return cd;
    }

    private void createReferenceId(){
        System.debug('<---------------------- START CREATE REFERENCE ID ---------------------->');

        String referenceId;
        Map<Id, ContactDetail__c> mapContactDetail = new Map<Id, ContactDetail__c>();

        for(ContactDetail__c cd : newRecordsList){
            Id key = cd.Contact__c;
            Contact contact = getContact(key);

            if(cd.Contact__c != null && cd.Source__c != null && contact.AccountId != null && contact.IndividualIdentificationNumber__c != null){
                if(contact.IsPersonAccount){
                    referenceId = (contact.IndividualIdentificationNumber__c + ' | ' + cd.Contact__c + ' | ' + cd.Source__c);
                }else if(contact.Account.CompanyIdentificationNumber__c.length() == 15){
                    referenceId = (contact.Account.CompanyIdentificationNumber__c + ' | ' + cd.Contact__c + ' | ' + cd.Source__c);
                }
            }
            cd.ExternalReferenceId__c = referenceId;
            mapContactDetail.put(cd.Id, cd);
        }

        // cd.ExternalReferenceId__c = referenceId;
        System.debug('### CONTACT DETAIL REFERENCE ID --> ' + referenceId);
        System.debug('<---------------------- FINISH CREATE REFERENCE ID ---------------------->');
    }

    private Contact getContact(Id contactId){
        Contact contact = new Contact();

        if(!Schema.sObjectType.Contact.isAccessible()){
            System.debug(LoggingLevel.FINEST, 'OBJECT NOT ACCESSIBLE');
            return null;
        }
        contact = [SELECT Id, AccountId, IndividualIdentificationNumber__c, IsPersonAccount, Account.CompanyIdentificationNumber__c FROM Contact WHERE Id = :contactId];

        return contact;
    }

    // private void callUpdateContactDetailVipFlow(){
    //     Map<String, Object> params = new Map<String, Object>();
    //     List<ContactDetail__c> contactDetails = new List<ContactDetail__c>();
    //     for(ContactDetail__c cd : newRecordsList){
    //         if(!Test.isRunningTest() && cd.RecordTypeId == CAIXA_RECORD_TYPE_ID){
    //             contactDetails.add(cd);
    //             params.put('ContactDetail__c', contactDetails);
    //             Flow.Interview.UpdateContactDetailVIP flow = new Flow.Interview.UpdateContactDetailVIP(params);
    //             flow.start();
    //         }
    //     }
    // }
}