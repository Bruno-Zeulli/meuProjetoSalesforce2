/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgFieldTest {

    @isTest
    static void getCreate()
    {
        test.startTest();
        SDGField f = new SDGField();
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest: Expected a SDGField to be created.');

    }
    @isTest
    static void getCreate2()
    {
          test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        SDGField f = new SDGField('1', 'a label', 'Name', 'STRING', '', true, false, opts);
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest:GetCreate2: Expected a rich SDGField to be created.');
        system.assertEquals(true, f.canSort, 'SDGFieldTest:GetCreate2: Expected field to be saved');

   }
   @isTest
   static void getCreate3()
    {
          test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        SDGField f = new SDGField('1', 'a label', 'Name', 'STRING', '', true, false, false, opts, 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest:GetCreate3: Expected a rich SDGField to be created. Not HTML formatted');
        system.assertEquals(true, f.canSort, 'SDGFieldTest:GetCreate3: Expected field to be saved');

   }
   @isTest
   static void getCreateFullDeprecated()
    {
        Boolean isError = false;
        try
        {

            List<AuraSelectOption> opts = new List<AuraSelectOption>();
            SDGField f = new SDGField('1', 'a label', 'STRING', '',  '', false, opts);

        }
        catch(sdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'sdgFieldTest:GetCreateFullDeprecated: Expected sdgDeprecatedException');

    }
    @isTest
    static void getCreateFull()
    {
        test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        SDGField f = new SDGField('1', 'a label', 'STRING', '', '', true, false, opts, 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'SDGFieldTest:GetCreateFull: Expected a rich SDGField to be created.');
        system.assertEquals(true, f.canSort, 'SDGFieldTest:GetCreateFull: Expected field to be saved');
    }
}