@isTest
public with sharing class DeactivateInactiveUserTest {

    public static String cronEXP = '0 0 5 3 9 ? 2025';

    @TestSetup
    static void setup(){

        String orgId = UserInfo.getOrganizationId();
        String dateString = null;
        Integer randomUniqueName = 0;
        Integer randomPositionList = 0;
        String uniqueName = null;
        List<User> lstInsertUser = new List<User>();

        List<Profile> lstProfiles = [
            SELECT  Id
            FROM    Profile
            WHERE   Name IN ('Administrador', 'Conseg - Consultor')];

        for(Integer i = 0; i < 10; i++){

            dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            randomUniqueName = Integer.valueOf(Math.rint(Math.random()*1000000));
            uniqueName = orgId+dateString+randomUniqueName;
            randomPositionList = Integer.valueOf(Math.random()*1);

            lstInsertUser.add(
                new User(
                    firstname = 'ABC' + i,
                    lastName = 'XYZ' + i,
                    email = uniqueName + '@test' + orgId + '.org',
                    Username = uniqueName + '@test' + orgId + '.org',
                    EmailEncodingKey = 'ISO-8859-1',
                    Alias = uniqueName.substring(18, 23),
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    ProfileId =  lstProfiles[randomPositionList].Id

                )
            );
        }

        insert lstInsertUser;

    }

    @isTest
    static void testImplementationSchedule(){
        // Test.startTest();
        // DeactivateInactiveUserSchedulable.schedule(cronEXP);
        // String jobId = System.schedule('ScheduledApexTest', cronEXP, new DeactivateInactiveUserSchedulable());
        // Test.stopTest();
        // CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // System.assertEquals(cronEXP, ct.CronExpression, 'CronExpression of Scheduling other than of 0 0 5 3 9 ? 2025');
        // System.assertEquals(
        //     '2025-09-03 05:00:00',
        //     String.valueOf(ct.NextFireTime),
        //     'NextFireTime of Scheduling other than 2025-09-03 05:00:00'
        // );
    }

    @isTest
    static void testImplmentationBatch(){

        // List<User> lstUserAdm = new List<User>();

        // Test.startTest();
        // DeactivateUsersBatch batch = new DeactivateUsersBatch();
        // Database.executeBatch(batch);
        // Test.stopTest();

        // List<User> lstUserChanged = [SELECT Id, Profile.Name FROM User WHERE IsActive = false AND LastModifiedDate >= TODAY AND UserType != 'PowerPartner'];

        // for(User objUser : lstUserChanged){
        //     if(objUser.Profile.Name == 'Administrador'){
        //         lstUserAdm.add(objUser);
        //     }
        // }
        // System.debug('lstUserAdm: ' + lstUserAdm);
        // System.assert(lstUserAdm.isEmpty(), 'A lista não deve devolver usuários com perfil Administrador');

    }
}