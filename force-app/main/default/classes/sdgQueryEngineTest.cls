/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgQueryEngineTest {



    @isTest
    static void testBooleanFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag ='CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'TestBooleanFilter: Expected rowcount=2 from load');

        //create a filter for TRUE:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='true';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getResult(req);
        System.assertEquals(2, result2.FullQueryCount,'TestBooleanFilter: Expected rowcount=2 from is is_valid__c filter');
        System.assertEquals(false, result2.isError,'TestBooleanFilter: Expected no error with  boolean=true filter');

        //create a filter for FALSE:
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='false';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getResult(req);
        System.assertEquals(0, result3.FullQueryCount,'TestBooleanFilter: Expected rowcount=0 from is is_valid=false filter');
        System.assertEquals(false, result3.isError,'TestBooleanFilter: Expected no error with  boolean=false filter');

        //invalid value
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='teapot';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result4 = getResult(req);
        System.assertEquals(true, result4.isError,'TestBooleanFilter: Expected error with invalid boolean filter');


        Test.stopTest();
    }
    @isTest
    static void testPicklistFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'TestPicklistFilter: Expected rowcount=2 from load');
        System.assertEquals(false, result.isError,'TestPicklistFilter: No error expected');

        //create a filter
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Prospecting';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getresult(req);
        System.assertEquals(0, result2.FullQueryCount,'TestPicklistFilter: Expected rowcount=0 from picklist filter=prospecting');
        System.assertEquals(false, result2.isError,'TestPicklistFilter: No error expected filter = prospecting');
        sdg_field__c f = [select id, field_style__c from sdg_field__c where sdg__r.id = :testdata limit 1];
        f.field_style__c = 'Age';
        update f;
        //test with a filter that returns 1 row:
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Age';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getresult(req);
        System.assertEquals(1, result3.FullQueryCount,'TestPicklistFilter: Expected rowcount=1 from filter=Age');
        System.assertEquals(false, result3.isError,'TestPicklistFilter: No error expected: filter=Age lost');

        Test.stopTest();
    }
    @isTest
    static void testDateFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String datetimefield = sdgTestData.GenerateTestSDGFieldDateTime(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter that forces zero rows:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='=';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getresult(req);
        System.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from date filter');

        //filter with thisweek
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='=';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getresult(req);
        System.assertEquals(false, result3.isError,'Date filter this week: ' + result3.ErrorMessage);
        System.assertEquals(2, result3.FullQueryCount,'Expected rowcount=2 from filter');

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result4 = getresult(req);
        System.assertEquals(false, result4.isError,'Date filter today: ' + result4.ErrorMessage);
        // System.assertEquals(2, result4.FullQueryCount,'Date filter today: mismatch');

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        date d2 = DAte.today().addDays(-1);
        String sd2 = d2.year() + '-' + d2.month() + '-' + d2.day() ;

        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result5 = getresult(req);
        System.assertEquals(0, result5.FullQueryCount,'Expected rowcount=0 from date filter yesterday');

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result6 = getresult(req);
        System.assertEquals(2, result6.FullQueryCount,'Expected rowcount=2 from date filter greater than yesterday');

        //Less than test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result7 = getresult(req);
        System.assertEquals(0, result7.FullQueryCount,'Expected rowcount=0 from date filter less than yesterday');

        //Invalid date
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='an invalid date';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result8 = getresult(req);
        System.assertEquals(true, result8.isError, 'expected error for invalid date format' );


        Test.stopTest();
    }

    @isTest
    static void testDateTimeFilter()
    {
        //generate test data of: one sdg, with two columns - name and [namespace]apiname
        String testdata= sdgTestData.GenerateTestSampleData();
        //Generate the querying sdg
        STring erlid = sdgTestData.GenerateTestSDG();
        sdgTestData.GenerateTestSDGFieldString(erlid);
        sdgTestData.GenerateTestSDGFieldDate(erlid);
        String datetimefield = sdgTestData.GenerateTestSDGFieldDateTime(erlid);
        sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a literal filter:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='ABC';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getresult(req);
        System.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from datetime filter last week');

        //filter with thisweek
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='DEF';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getresult(req);
        System.assertEquals(2, result3.FullQueryCount,'Expected rowcount=2 from filter this week');

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result4 = getresult(req);
        System.assertEquals(false, result4.isError,'Expected no error from date filter today: ' + result4.ErrorMessage);
        // System.assertEquals(2, result4.FullQueryCount,'Expected rowcount=2 from date filter today');

        //GT
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result5 = getresult(req);
        System.assertEquals(false, result5.isError,'Expected no error from datetime GT ' + result4.ErrorMessage);
        // System.assertEquals(0, result5.FullQueryCount,'Expected rowcount=2 from datetime GT ');

        //LT
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result6 = getresult(req);
        System.assertEquals(false, result6.isError,'Expected no error from LT datetime filter ' + result4.ErrorMessage);
        System.assertEquals(0, result6.FullQueryCount,'Expected rowcount=2 from LT datetime filter ');


        Test.stopTest();
    }

    @isTest
    static void testDefaultFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();

        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);

        Test.startTest();

        //Generate a request:
        SDGRequest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;
        req.sortOrder='A';
        req.sortColumn=stringfield;

        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount, 'expected two rows in results');

        //Now add a server side filter
        sdg__c sdg2 = [select id, name, filter__c from sdg__c where id=:erlid];

        sdg2.filter__c = 'apiname__c like \'na%\'';
        update sdg2;
        SDGResult result2 = getresult(req);
        System.assertEquals(1, result2.FullQueryCount, 'Server side filter');

        TEst.stopTest();

    }
    @isTest
    static void testFilterCacheing()
    {
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGRequest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter for =:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sdgNamespaceUtility.GetNamespace() + 'APIName__c';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getResult(req);
        System.assertEquals(1, result2.FullQueryCount,'Expected rowcount=1 from = filter');

        //Filter should now be cached - so try and do a normal load and count the results:
        String results3 = sdgController.GetSDGInitialLoad(testdata, 'CustomObject:' + sdgTestDAta.TestSDGName, '', '',10);

        SDGInitialLoad initial2 = (SDGInitialLoad)JSON.deserialize(results3, SDGInitialLoad.class);
        System.debug(initial2.Results.query);
        System.assertEquals(false, initial2.Results.isError,'Should be able to execute.');

        Test.stopTest();

    }
    @isTest
    static void testStringFilter()
    {
        //Generate test data:
        //one sdg, with two columns - name and [namespace]apiname
        String testdata=sdgTestData.GenerateTestSampleData();
        //String s2 = sdgTestData.GenerateTestSDGFieldString(testdata);
        //String n2 = sdgTestData.GenerateTestSDGFieldStringName(testdata);

        //and the filterer
        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String namefield = sdgTestData.GenerateTestSDGFieldStringName(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Load with no filter');

        //create a filter for =:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Name';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getResult(req);
        System.assertEquals(1, result2.FullQueryCount,'Query with = filter');

        //Invalid filter test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = 'an invalid value';
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result31 = getresult(req);
        System.assertEquals(true, result31.isError,'Expected error with invalid filter field specified');


        //NOT= test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result32 = getresult(req);
        System.assertEquals(2, result32.FullQueryCount,'not= filter');


        //STARTS test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield; //apiname
        newfilter.FilterOperator='STARTS';
        newfilter.filtervalue='Na';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getresult(req);
        System.debug('zzzzzzz');
        System.debug(result3.query);
        System.debug(result3.errormessage);
        System.assertEquals(1, result3.FullQueryCount,'Starts with filter');

        //ENDS test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='ame';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result35 = getresult(req);
        System.assertEquals(1, result35.FullQueryCount,'Expected rowcount=1 from ends filter');

        //ENDS test #2
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='__c';
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result36 = getresult(req);
        System.assertEquals(1, result36.FullQueryCount,'Expected rowcount=1 from ends filter');


        //Contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='ame'; //part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result4 = getresult(req);
        System.assertEquals(2, result4.FullQueryCount,'Expected rowcount=1 from contains filter');

        //2nd test for contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='APIN'; // not part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result5 = getresult(req);
        System.assertEquals(1, result5.FullQueryCount,'Expected rowcount=1 from  contains filter');

        // test for NOT contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='elephant'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result6 = getresult(req);
        System.assertEquals(2, result6.FullQueryCount,'Expected rowcount=2 from notcontains filter');

        // negative test for NOT contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='__c'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result7 = getresult(req);
        System.assertEquals(1, result7.FullQueryCount,'Expected rowcount=1 from negative notcontains filter');


        Test.stopTest();
    }


    @isTest
    static void testAllRows()
    {
        String testdata= sdgTestData.GenerateTestSampleData();

        String erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);

        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;

        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //Now delete a row and try again:
        SDG_Field__c row1 = [select id from sdg_field__c where sdg__c = :testdata limit 1];
        delete row1;

        SDGResult result2 = getResult(req);
        System.assertEquals(1, result2.FullQueryCount,'Expected rowcount=1 with deleted row');
        System.assertEquals(false, result2.isError,'Expected no error with deleted row');

        //Now set All_Rows = true and try again
        sdg__c erl = [select id, All_rows__c from sdg__c where id = :erlid limit 1];
        erl.all_rows__c = true;
        update erl;

        SDGResult result3 = getResult(req);
        System.assertEquals(2, result3.FullQueryCount,'Expected rowcount=1 with deleted row');
        System.assertEquals(false, result3.isError,'Expected no error with deleted row');

        Test.stopTest();
    }
    @isTest
    static void testNumberFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        string numberfield = sdgTestData.GenerateTestSDGFieldNumber(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter for TRUE:
        List<SDGFilter> filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='5';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result2 = getResult(req);
        System.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from fieldorder=number filter');
        System.assertEquals(false, result2.isError,'Expected no error with  fieldorder=number filter');

        //create a filter for FALSE:
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue='1';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result3 = getResult(req);
        System.assertEquals(1, result3.FullQueryCount,'Expected rowcount=1 from is fieldorder>1 filter');
        System.assertEquals(false, result3.isError,'Expected no error with  fieldorder>1 filter');


        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='10';
        filters.add(newfilter);
        req.filters = filters;

        SDGResult result4 = getResult(req);
        System.assertEquals(2, result4.FullQueryCount,'Expected rowcount=2 from is fieldorder<10 filter');
        System.assertEquals(false, result4.isError,'Expected no error with  amount<10 filter');


        Test.stopTest();
    }

    static SDGResult getResult(SDGRequest req)
    {
        String results = sdgController.getSDGResult(JSON.serialize(req));
        SDGResult result = (SDGResult)JSON.deserialize(results, SDGResult.class);
        return result;

    }
}