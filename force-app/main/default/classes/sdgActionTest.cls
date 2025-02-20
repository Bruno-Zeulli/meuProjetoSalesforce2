/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgActionTest {


    @isTest
    static void getCreate()
    {
        test.startTest();
        SDGAction f = new SDGAction();
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGActionTest: Expected a SDGAction to be created.');

    }

    @isTest
    static void getCreateFull()
    {
        test.startTest();
        SDGAction f = new SDGAction('1', 'a label', 'an event', 'STRING', '[]', 'iconname', 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest:GetCreateFull: Expected a rich SDGField to be created.');
        system.assertEquals('iconname', f.icon, 'SDGActionTest:GetCreateFull: Expected action to be saved');
    }
    @isTest
    static void getCreateNoOrder()
    {
        test.startTest();
        SDGAction f = new SDGAction('2', 'first item', 'an event', 'STRING', '[]', 'iconname',1);
        SDGAction f2 = new SDGAction('1', 'second item', 'an event', 'STRING', '[]', 'iconname');
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest:GetCreateNoOrder: Order in constructor: Expected a rich SDGField to be created.');
        system.assertNotEquals(null,f2, 'SDGFieldTest:GetCreateNoOrder:  No Order in constructore: Expected a rich SDGField to be created.');
        system.assertEquals('iconname', f.icon, 'SDGActionTest:GetCreateNoOrder: Expected action to be saved');
    }

}