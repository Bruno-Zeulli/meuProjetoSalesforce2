/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgTest {

    @isTest
    public static void testConstructorNoParms()
    {
        Boolean isError = false;
        try
        {
            SDG s = new SDG();
        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(true, iserror, 'sdgTest:TestConstructorNoParms');

    }
    @isTest
    public static void testConstructorOneParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';
        SDG s;
        try
        {
            s = new SDG(teststring);
        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'sdgTest:TestConstructorOneParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'sdgTest:TestConstructorOneParms:InternalUniqueID missing');

    }
    @isTest
    public static void testConstructorSixParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';

        SDG s;
        try
        {
            s = new SDG('abc', '', 'Account', '', '',teststring);
     		// SDG(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey)

        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'sdgTest:TestConstructorSixParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'sdgTest:TestConstructorSixParms:InternalUniqueID missing');

    }
    @isTest
    public static void testConstructorSevenParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';

        SDG s;
        try
        {
            s = new SDG('abc', '', 'Account', '', '',teststring, false);
     		// SDG(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey)

        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'sdgTest:TestConstructorSevenParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'sdgTest:TestConstructorSevenParms:InternalUniqueID missing');

    }
}