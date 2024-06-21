/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@istest
public class sdgExTest {
public  class NotsdgException extends Exception {}

    @isTest
    private static void raiseNew()
    {
        Boolean needToRaiseNew = false;

        try
        {
            needToRaiseNew = sdgEx.raiseNew(new NotsdgException('test'));

        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
        System.assertEquals(true, needToRaiseNew, 'sdgEx:RaiseNewTrue: Expected to be told to raise sdgException');
    }
    @isTest
    private static void raiseNew2()
    {
        Boolean isError = false;

        try
        {
            sdgEx.raiseNew(new sdgException('test'));

        }
        catch(Exception ex)
        {

                if(ex instanceof sdgException)
                {    isError = true;}
        }
        System.assertEquals(true, isError, 'sdgEx:RaiseNewTrue: Expected sdgException');
    }
}