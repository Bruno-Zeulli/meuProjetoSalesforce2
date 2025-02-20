/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class sdgObjectEventHandlerTest {

    @isTest
    static void deleteTestUnauthorised(){

        // Setup test data
        // This code runs as the system user

        User u1 = sdgSecurityTest.CreateUser('1');
        user u2 = sdgSecurityTest.CreateUser('2');
        String sdgid = '';

        System.runAs(u1){
            sdgid = sdgTestData.GenerateTestSDG();

        }
        List<sdg__c> sdgs = [select id from sdg__c where id = :sdgid];
        system.assertequals(1,sdgs.size(), 'Should be 1 SDG');

        System.runAs(u2){
            String results = sdgObjectEventHandler.DeleteObject(sdgid);
            system.debug(results);
        }
        sdgs = [select id from sdg__c where id = :sdgid];
        system.assertequals(1,sdgs.size(), 'Should still be 1 SDG as user cannot delete');
        //As original user again
        System.runAs(u1){
            String results2 = sdgObjectEventHandler.DeleteObject(sdgid);
            system.debug(results2);
        }
        sdgs = [select id from sdg__c where id = :sdgid];
        system.assertequals(1,sdgs.size(), 'Should still be 1 SDG as u1 does not have crud rights');

        //Now back as admin
        String results3 = sdgObjectEventHandler.DeleteObject(sdgid);
        system.debug(results3);

        sdgs = [select id from sdg__c where id = :sdgid];
        system.assertequals(0,sdgs.size(), 'Should be 0 SDG as admin has delete all');

    }

    @isTest
    static void deleteTest(){
        //Create records:
        Account a = AccountDataFactory.createPersonAccount();
        a.LastName = 'Account1';
        insert a;
        String aID = a.id;

        //test for it's existence
        List<Account> test1 = [select id from account where id = :aID];
        system.assert(test1.size()==1,'Test account was not created');

        //Now try to delete it:
        String results = sdgObjectEventHandler.DeleteObject(aID);

        //should be deleted
        List<Account> test2 = [select id from account where id = :aID];
        system.assert(test1.size()!=0,'Test account was not deleted');


        //Now test for invalid id (by using same ID again)
        String results2 = sdgObjectEventHandler.DeleteObject(aID);
        system.assert(results2.contains('You do not have permission to delete this record'), 'Should have thrown an error at deleting invalid ID');

    }

    @isTest
    static void recordTypeTest(){
        //Cannot test record types within test classes so simply assert no error:
        try
        {
            String results = sdgObjectEventHandler.GetRecordTypes('Account');
            system.assert(true, 'Test Shold be true');
        }
        catch (exception ex)
        {
            system.assert(false, 'error occurred when retrieving record types');
        }


    }



}