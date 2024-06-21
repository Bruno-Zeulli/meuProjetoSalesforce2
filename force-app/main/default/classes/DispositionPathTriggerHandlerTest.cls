/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class DispositionPathTriggerHandlerTest {

    @isTest
    static void testDispositionPathTriggerHandler(){
        DispositionPath__c dp;
        dp = testInsert();
        System.assert(dp != null, 'test Insert');
        dp = testUpdate(dp);
        dp = testDelete(dp);
        dp = testUndelete(dp);
    }

    static DispositionPath__c testInsert(){
        DispositionPath__c dp;
        dp = DispositionPathDataFactory.insertDispositionPath1LevelDeep();
        testFillOutDispositionField(dp, dp.Category__c);
        dp = DispositionPathDataFactory.insertDispositionPath2LevelsDeep();
        testFillOutDispositionField(dp, dp.Subcategory__c);
        dp = DispositionPathDataFactory.insertDispositionPath3LevelsDeep();
        testFillOutDispositionField(dp, dp.Reason__c);
        dp = DispositionPathDataFactory.insertDispositionPath4LevelsDeep();
        testFillOutDispositionField(dp, dp.SpecificReason__c);
        return dp;
    }

    static DispositionPath__c testUpdate(DispositionPath__c dp){
        dp.SpecificReason__c = null;
        update dp;
        testFillOutDispositionField(dp, dp.Reason__c);
        return dp;
    }

    static DispositionPath__c testDelete(DispositionPath__c dp){
        delete dp;
        return dp;
    }

    static DispositionPath__c testUndelete(DispositionPath__c dp){
        undelete dp;
        return dp;
    }

    static DispositionPath__c testFillOutDispositionField(DispositionPath__c dp, String expected){
        dp = [SELECT Category__c, Subcategory__c, Reason__c, SpecificReason__c, Disposition__c FROM DispositionPath__c WHERE Id = :dp.Id];
        String actual = dp.Disposition__c;
        //System.assert(actual != null);
        //System.assertEquals(expected, actual);
        return dp;
    }

    @isTest
    static void createDispositionPathGenesysTest(){
        DispositionPath__c newDisposition = new DispositionPath__c();
        newDisposition.Reason__c = 'XXX Reason Teste XXX';
        newDisposition.RecordTypeId = Schema.SObjectType.DispositionPath__c.getRecordTypeInfosByDeveloperName()
        .get('Telefonema').getRecordTypeId();
        newDisposition.Tipo__c = 'Genesys';

        Test.startTest();
            insert newDisposition;
        Test.stopTest();
    }
}