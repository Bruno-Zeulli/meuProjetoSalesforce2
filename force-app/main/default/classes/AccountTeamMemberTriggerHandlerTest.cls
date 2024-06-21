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
public class AccountTeamMemberTriggerHandlerTest {
    @isTest
    static void testAccountTeamMemberTriggerHandler(){
        Account a = new Account();
        a.Name = 'Teste 01';
        a.CompanyIdentificationNumber__c = '54491071000163';
        insert a;

        date myDate = date.newInstance(2050, 11, 21);

        opportunity o = new opportunity();
        o.AccountId = a.Id;
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
        atm.AccountId = a.Id;

        atm = testUpdate(atm);
        System.assert(atm != null, 'On test Insert');

        atm = testDelete(atm);
        System.assert(atm != null, 'On test delete');
    }

    static AccountTeamMember testUpdate(AccountTeamMember acc){
        insert acc;
        return acc;
    }

    static AccountTeamMember testDelete(AccountTeamMember acc){
        delete acc;
        return acc;
    }
}