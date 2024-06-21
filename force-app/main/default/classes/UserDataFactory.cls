/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class UserDataFactory {
    // Create a new User record
    public static User createUser(){
        User user = new User(
                        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                        LastName = 'Test',
                        FirstName = 'User',
                        Email = 'wizeruser000@wiz.com',
                        Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
                        CompanyName = 'WIZ',
                        Title = 'Usuario WIZ',
                        Alias = 'Wizzer',
                        TimeZoneSidKey = 'America/Los_Angeles',
                        EmailEncodingKey = 'UTF-8',
                        LanguageLocaleKey = 'en_US',
                        LocaleSidKey = 'en_US'
        );

        return user;
    }

    public static User getAdminUser(){
        User user = createUser();
        insert user;
        return user;
    }

    public static User createVIPUser(){
        User user = [SELECT
                        id
                    FROM
                        User
                    WHERE
                        UserRole.Name LIKE '%VIP - Atendimento%' AND Name LIKE '%joyce%'
                        LIMIT 1
                ];
        return user;
    }
}