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
public class ContactDetailDataFactory {
    public static ContactDetail__c createContactDetail(){
        Id recordType = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            //Contact__c = contact.Id,
            MobilePhone__c = '61984609897',
            HomePhone__c = '011556132746636',
            Email__c = 'teste@teste.com',
            Street__c = 'Street',
            District__c = 'District',
            City__c = 'Brasilia',
            State__c = 'DF',
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            RecordTypeId = recordType
        );
        return contactDetail;
    }

    public static ContactDetail__c createConciergePersonAccountContactDetail(Account contact){
        Id recordType = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            Contact__c = contact.PersonContactId,
            MobilePhone__c = '61984609897',
            HomePhone__c = '6132746636',
            OtherPhone__c = '1133451122',
            Email__c = 'teste@gmail.com',
            Street__c = 'Street',
            District__c = 'District',
            City__c = 'Brasilia',
            State__c = 'DF',
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            RecordTypeId = recordType,
            PreferredContactMeans__c = 'TelefoneCelular'
        );
        return contactDetail;
    }

    public static ContactDetail__c insertConciergePersonAccountContactDetail(Account contact){
        ContactDetail__c contactDetail = createConciergePersonAccountContactDetail(contact);
        insert contactDetail;
        return contactDetail;
    }

    public static ContactDetail__c insertContactDetail(){
        ContactDetail__c contactDetail = createContactDetail();
        insert contactDetail;
        return contactDetail;
    }

    public static ContactDetail__c createConciergeFailPersonAccountContactDetail(Account contact){
        Id recordType = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            Contact__c = contact.PersonContactId,
            //MobilePhone__c = '61984609897',
            HomePhone__c = '6132746636',
            OtherPhone__c = '1133451122',
            Email__c = 'teste@gmail.com',
            Street__c = 'Street',
            District__c = 'District',
            City__c = 'Brasilia',
            State__c = 'DF',
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            RecordTypeId = recordType,
            PreferredContactMeans__c = 'TelefoneCelular'
        );
        return contactDetail;
    }

    public static ContactDetail__c insertConciergeFailPersonAccountContactDetail(Account contact){
        ContactDetail__c contactDetail = createConciergeFailPersonAccountContactDetail(contact);
        insert contactDetail;
        return contactDetail;
    }

    public static ContactDetail__c insertContactDetailVIPWithAssistant(String personContactId){
        ContactDetail__c contactDetail = createContactDetailVIP(personContactId, true);
        insert contactDetail;
        return contactDetail;
    }

    public static ContactDetail__c insertContactDetailVIPWithoutAssistant(String personContactId){
        ContactDetail__c contactDetail = createContactDetailVIP(personContactId, false);
        insert contactDetail;
        return contactDetail;
    }

    public static ContactDetail__c createContactDetailVIP(String personContactId, boolean hasAssistant){
        Id recordType = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Caixa').getRecordTypeId();
        ContactDetail__c contactDetail;
        if(hasAssistant == true){
            contactDetail = new ContactDetail__c(
                Name = 'Teste',
                Source__c = 'CaixaSeguradora',
                Contact__c = personContactId,
                MobilePhone__c = '61984609897',
                HomePhone__c = '6132746636',
                Email__c = 'testeasdf@teste.com',
                Street__c = 'Street',
                District__c = 'District',
                City__c = 'Brasilia',
                State__c = 'DF',
                PostalCode__c = '70293050',
                Country__c = 'Brasil',
                DoNotMarketing__c = false,
                ConsentDate__c = System.today(),
                DoNotCall__c = false,
                DoNotSendMessage__c = false,
                HasOptedOutOfEmail__c = false,
                ShouldForget__c = false,
                RecordTypeId = recordType,
                RelationshipGroup__c = 'VIP',
                AssistantName__c = 'Fulaninha',
                AssistantEmail__c = 'fulaninha@gmail.com'
            );
        }else{
            contactDetail = new ContactDetail__c(
                Name = 'Teste',
                Source__c = 'CaixaSeguradora',
                Contact__c = personContactId,
                MobilePhone__c = '61984609897',
                HomePhone__c = '6132746636',
                Email__c = 'testeasdf@teste.com',
                Street__c = 'Street',
                District__c = 'District',
                City__c = 'Brasilia',
                State__c = 'DF',
                PostalCode__c = '70293050',
                Country__c = 'Brasil',
                DoNotMarketing__c = false,
                ConsentDate__c = System.today(),
                DoNotCall__c = false,
                DoNotSendMessage__c = false,
                HasOptedOutOfEmail__c = false,
                ShouldForget__c = false,
                RecordTypeId = recordType,
                RelationshipGroup__c = 'VIP'
            );
        }
        return contactDetail;
    }
}