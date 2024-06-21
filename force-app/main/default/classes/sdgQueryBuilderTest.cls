/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgQueryBuilderTest {
    @isTest
    static void buildFilterClauseString()
    {
        Test.startTest();
        string result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', '=', '123');
        System.assertEquals(' abc = \'123\' ',result, 'STRING EQUALS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'NOT=', '123');
        System.assertEquals(' abc != \'123\' ',result, ' STRING NOT EQUALS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'CONTAINS', '123');
        System.assertEquals(' abc like \'%123%\' ',result, 'STRING CONTAINS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'NOTCONTAINS', '123');
        System.assertEquals(' (NOT abc like \'%123%\') ',result, 'STRING NOT CONTAINS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'STARTS', '123');
        System.assertEquals(' abc like \'123%\' ', result, 'STRING STARTS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'ENDS', '123');
        System.assertEquals(' abc like \'%123\' ',result, 'STRING ENDS');
        Test.stopTest();
    }
    @isTest
    static void buildFilterClauseNumber()
    {
        Test.startTest();
        string result = sdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', '=', '123');
        System.assertEquals(' abc = 123 ',result, 'NUMBER EQUALS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', 'GT', '123');
        System.assertEquals(' abc > 123 ',result, ' NUMBER GT');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', 'LT', '123');
        System.assertEquals(' abc < 123 ',result, 'NUMBER LT');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', '=', '123.5');
        System.assertEquals(' abc = 123.5 ',result, 'DOUBLE EQUALS');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', 'GT', '123.5');
        System.assertEquals(' abc > 123.5 ',result, ' DOUBLE GT');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', 'LT', '123.5');
        System.assertEquals(' abc < 123.5 ',result, 'DOUBLE LT');

        Test.stopTest();
    }

    @isTest
    static void buildFilterClausePicklist()
    {
        Test.startTest();
        string result = sdgQueryBuilder.BuildFilterClause('abc', 'PICKLIST', '=', 'HAPPY');
        System.assertEquals(' abc = \'HAPPY\' ',result, 'PICKLIST =');

        result = sdgQueryBuilder.BuildFilterClause('abc', 'PICKLIST', '=', '');
        System.assertEquals('  ',result, 'PICKLIST blank');

        Test.stopTest();
    }

    @isTest
    static void processMergeFieldsTest()
    {
        Test.startTest();
        string result = sdgQueryBuilder.ProcessMergeFields('select name from account', '123');
        System.assertEquals('select name from account',result, 'MergeFields No data');

        result = sdgQueryBuilder.ProcessMergeFields('a string #userid# to merge', '123');
        System.assertEquals('a string \'' + userinfo.getUserId() + '\' to merge',result, 'MergeFields userid');

        result = sdgQueryBuilder.ProcessMergeFields('select #Id# from account', '123');
        System.assertEquals('select 123 from account',result, 'MergeFields parentid');

        Test.stopTest();
    }
}