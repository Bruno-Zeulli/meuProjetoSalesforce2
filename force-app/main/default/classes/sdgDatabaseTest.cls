/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest

public with sharing class sdgDatabaseTest {
    @isTest
    static void getSDGTest()
    {
       Test.startTest();
        String countQuery = 'select count() from sdg__c';

        Integer countFull = sdgDatabase.CountQuery(countQuery, true);
       Test.stopTest();
    }

    @isTest
    static void getSDGTestFalse()
    {
       Test.startTest();
        String countQuery = 'select count() from sdg__c';

        Integer countFull = sdgDatabase.CountQuery(countQuery, false);
       Test.stopTest();
    }

    @isTest
    static void testQuery()
    {
       Test.startTest();
        SDG__c lSdg = new SDG__c(Name='Cabeçalho', sdg_tag__c = 'Test_Tag', is_valid__c=true, sobjectname__c='Case');
        Database.insert(lSdg);
        String countQuery = 'select id,sdg_tag__c from sdg__c where sdg_tag__c = \'' + lSdg.sdg_tag__c + '\'';

        List<SObject> countFull = sdgDatabase.Query(countQuery, true);
       Test.stopTest();
    }

    @isTest
    static void testQueryFalse()
    {
       Test.startTest();
        SDG__c lSdg = new SDG__c(Name='Cabeçalho', sdg_tag__c = 'Test_Tag', is_valid__c=true, sobjectname__c='Case');
        Database.insert(lSdg);
        String countQuery = 'select id,sdg_tag__c from sdg__c where sdg_tag__c = \'' + lSdg.sdg_tag__c + '\'';

        List<SObject> countFull = sdgDatabase.Query(countQuery, false);
       Test.stopTest();
    }
}