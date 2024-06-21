/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class AccountTriggerHandlerTest {
    @isTest
    static void testAccountTriggerHandler(){
        Account acc;

        acc = testInsert();
        System.assert(acc != null, 'On test Insert');

        date myDate = date.newInstance(2050, 11, 21);

            opportunity o = new opportunity();
            o.AccountId = acc.Id;
            o.Name = 'Teste';
            o.StageName = 'Aberto';
            o.CloseDate = myDate;
            insert o;

            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.OpportunityId = o.Id;
            otm.UserId = UserInfo.getUserId();
            insert otm;

            AccountTeamMember atm = new AccountTeamMember();
            atm.UserId = UserInfo.getUserId();
            atm.AccountId = acc.Id;
        atm.TeamMemberRole = 'Apoio';
            insert atm;

        acc = testUpdate(acc);
        testUpdateOwner(acc);
        System.assert(acc != null, 'On test Update');
        acc = testDelete(acc);
        System.assert(acc != null, 'On test delete');
        acc = testUndelete(acc);
        System.assert(acc != null, 'On test Undelete ');
    }

    static Account testInsert(){
        Account a = new Account();
        a.OwnerId = UserInfo.getUserId();
        a.Name = 'Teste 01';
        a.CompanyIdentificationNumber__c = '54491071000163';
            insert a;
        return a;
    }

    static Account testUpdate(Account acc){
        update acc;
        return acc;
    }

    static Account testDelete(Account acc){
        delete acc;
        return acc;
    }

    static Account testUndelete(Account acc){
        undelete acc;
        return acc;
    }
    static void testUpdateOwner(Account acc){
        String idUser = UserInfo.getUserId();
        User a = UserDataFactory.getAdminUser();
        acc.OwnerId = a.Id;
        update acc;
    }
}