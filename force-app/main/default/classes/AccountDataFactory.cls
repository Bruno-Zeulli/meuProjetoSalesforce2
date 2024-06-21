/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-05-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD ...
 **/
@isTest
public class AccountDataFactory {

    static final Id RECORDTYPE_PF = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PF').getRecordTypeId();
    static final Id RECORDTYPE_PJ = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PJ').getRecordTypeId();
    /**
     * @description cria Business Account
     * @return acc
     */
    public static Account createBusinessAccount(){
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ(), RecordTypeId = RECORDTYPE_PJ);
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;
        return acc;
    }

    /**
     * @description insere Business Account
     * @return acc
     */
    public static Account insertBusinessAccount(){
        Account acc = createBusinessAccount();
        if(Schema.sObjectType.Account.isCreateable()){
            insert acc;
            return acc;
        }
        return null;
    }

    /**
     * @description cria Person Account
     * @return acc
     */
    public static Account createPersonAccount(){
        Account acc = new Account(FirstName = 'Primeiro', LastName = 'Último', IdentificationNumber__c = PersonalInformationUtil.generateRandomCPF(), RecordTypeId = RECORDTYPE_PF);
        acc.IndividualIdentificationNumber__pc = acc.IdentificationNumber__c;
        return acc;
    }

    /**
     * @description cria Person Account
     * @return acc
     * @param identificationNumber
     */
    public static Account createPersonAccount(String identificationNumber){
        if(Schema.SObjectType.Account.isAccessible()){
            Account acc = new Account(FirstName = 'Primeiro', LastName = 'Último', IdentificationNumber__c = identificationNumber, RecordTypeId = RECORDTYPE_PF);
            acc.IndividualIdentificationNumber__pc = acc.IdentificationNumber__c;
            return acc;
        }
        return null;
    }

    /**
     * @description insere Person Account
     * @return acc
     */
    public static Account insertPersonAccount(){
        Account acc = createPersonAccount();
        if(Schema.sObjectType.Account.isCreateable()){
            insert acc;
            return acc;
        }
        return null;
    }
}