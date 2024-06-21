/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
**/
@isTest
public class OpportunityTeamMemberTriggerHandlerTest {
    @isTest
    static void testOpportunityTeamMemberTriggerHandler(){
        Opportunity opp;
        OpportunityTeamMember oppT;
        oppT = testInsert();
        oppT = testUpdate(oppT);
        oppT = testDeleteCorporateComercial(oppT);
        //oppT = testDelete(oppT);
        //oppT = testUndelete(oppT);
    }

    static OpportunityTeamMember testInsert(){
        Opportunity opp = testInsertCorporateComercial();

        User u1 = [SELECT Id, Name FROM User WHERE SalesUnit__c LIKE '%Partners%' LIMIT 1];

        OpportunityTeamMember oppT = OpportunityDataFactory.createOpportunityTeamMember(opp, u1);

        insert oppT;
        return oppT;
    }

    static Opportunity testInsertCorporateComercial(){
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        opp.AccountId = acc.Id;
        insert opp;
        ord.OpportunityId = opp.Id;
        ord.AccountId = acc.Id;
        insert ord;
        return opp;
    }

    static OpportunityTeamMember testUpdate(OpportunityTeamMember opp){
        update opp;
        return opp;
    }

    static OpportunityTeamMember testDelete(OpportunityTeamMember opp){
        delete opp;
        return opp;
    }

    static OpportunityTeamMember testUndelete(OpportunityTeamMember opp){
        undelete opp;
        return opp;
    }

    static OpportunityTeamMember testDeleteCorporateComercial(OpportunityTeamMember opp){
         try{
            //Profile prof = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1];
            User prof = [SELECT Profile.Name FROM User WHERE SalesUnit__c LIKE '%ASF%' LIMIT 1];

            if(prof.Profile.Name != 'Corporate - Marketing' &&
                !prof.Profile.Name.contains('Administrador') &&
                prof.Profile.Name != 'Integrador - Corporate'
            ){
                delete opp;
            }
        } catch (DMLException ex){
            //System.assert(ex.getMessage().contains(OpportunityTeamMemberTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_TEAM));
            //System.assert(OpportunityTeamMemberTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_TEAM);

            System.debug('The following error has occurred.');
            System.debug('ex: ' + ex.getMessage());
            //System.debug('Fields that affected this error: ' + err.getFields());
        }

        //OpportunityTeamMember oppDel = [SELECT Id, Opportunity.IsDeleted FROM OpportunityTeamMember WHERE Id = : opp.Id];
        //System.assertEquals(oppDel.IsDeleted, FALSE);
        return opp;
    }
}