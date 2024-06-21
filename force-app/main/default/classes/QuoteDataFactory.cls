/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class QuoteDataFactory {
    public static Quote createQuote(){
        Quote quoteVariable = new Quote(QuotationNumber__c = '101010', Company__c = 'Caixa Seguradora', Type__c = 'New');
        return quoteVariable;
    }

    private static Id redeVipRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName()
    .get('RedeVIP')
    .getRecordTypeId();

    public static Quote createQuoteVip(){
        Quote quoteVariable = new Quote(
        QuotationNumber__c = '101010',
        Company__c = 'Caixa Seguradora',
        Type__c = 'New',
        Name = 'Teste',
        RecordTypeId = redeVipRecordType
        );
        return quoteVariable;
    }

    private static Id corporateRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName()
    .get('Corporate')
    .getRecordTypeId();

    public static Quote createQuoteCorporate(){
        Quote quoteVariable = new Quote(
        Name = 'dfakdjfkd989324248',
        QuotationNumber__c = '463716487146187346',
        Company__c = 'Caixa Seguradora',
        Type__c = 'New',
        Status = 'Draft',
        RecordTypeId = corporateRecordType
        );
        return quoteVariable;
    }

    private static Id corporatePartialRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName()
    .get('CorporateParcial')
    .getRecordTypeId();
    public static Quote createQuoteCorporatePartial(){
        Quote quoteVariable = new Quote(
            Name = 'dfakdjfkd989324248',
            QuotationNumber__c = '463716487146187346',
            Company__c = 'Caixa Seguradora',
            Type__c = 'New',
            Status = 'Draft',
            RecordTypeId = corporatePartialRecordType
        );
        return quoteVariable;
    }
}