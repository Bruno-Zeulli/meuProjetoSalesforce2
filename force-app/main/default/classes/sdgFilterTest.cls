/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgFilterTest {

    @isTest
    static void getCreate()
    {
       Test.startTest();
        SDGFilter f = new SDGFilter();
       Test.stopTest();
        System.assertNotEquals(null,f, 'SDGFilterTest: Expected a SDGFilter to be created.');

    }

    @isTest
    static void getCreateFull()
    {
       Test.startTest();
        SDGFilter f = new SDGFilter('1', '=', 'APPLE');
       Test.stopTest();
        System.assertNotEquals(null,f, 'SDGFilterTest:GetCreateFull: Expected a rich SDGFilter to be created.');
        System.assertEquals('=', f.filterOperator, 'SDGFilterTest:GetCreateFull: Expected filteroperator to be saved ');
        System.assertEquals('APPLE', f.filterValue, 'SDGFilterTest:GetCreateFull: Expected filtervalue to be saved ');
    }
}