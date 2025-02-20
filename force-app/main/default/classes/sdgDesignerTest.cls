/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgDesignerTest {
    @isTest
    static void getSObjectFieldsTest(){
        test.startTest();

        List<AuraFieldSelectOption> results = sdgDesigner.GetSObjectFields('Account', '');
        system.assertNotEquals(0, results.size(), 'Expecting multiple fields');

        test.stopTest();
    }

    @isTest
    static void getNamespaceTest(){
        test.startTest();

        string results = sdgDesigner.GetNamespace();
        system.assertEquals(sdgNamespaceUtility.getNamespace(), results, 'Expecting namespace');

        test.stopTest();
    }
    @isTest
    static void getNewFieldOrderTest()
    {
        Id sdgid = sdgTestData.GenerateTestSampleData();
        test.startTest();
        integer result = sdgDesigner.GetNewFieldOrder(sdgid);
        system.assertEquals(3, result, 'Expecting new field order');
        sdgTestData.GenerateTestSDGFieldString(sdgid, 'name', 5);
        integer result2 = sdgDesigner.GetNewFieldOrder(sdgid);
        system.assertEquals(6, result2, 'Expecting new field order - 5+1');
        test.stopTest();

    }

    @isTest
    static void getSObjectFieldsIDTest(){
        Id recordId = sdgTestData.GenerateTestSDG();
        test.startTest();

        List<AuraFieldSelectOption> sdgresults = sdgDesigner.GetSObjectFields('SDG__c', '');
        //system.debug(sdgresults.size());
        List<AuraFieldSelectOption> fieldresults = sdgDesigner.GetSObjectFields('SDG_Field__c', '');
        //system.debug(fieldresults.size());
        List<AuraFieldSelectOption> sdgbyIDresults = sdgDesigner.GetSObjectFields('', recordId);
        //system.debug(sdgbyIDresults.size());
        system.assert(sdgresults.size()>10, 'Expecting multiple fields');
        system.assert(fieldresults.size()>10, 'Expecting multiple sObjectTypes');

        //test data has a sObjectName of sdg_field__c
        system.assertEquals(fieldresults.size(), sdgbyIDresults.size(), 'Expecting same data from both object name and id');

        test.stopTest();
    }

}