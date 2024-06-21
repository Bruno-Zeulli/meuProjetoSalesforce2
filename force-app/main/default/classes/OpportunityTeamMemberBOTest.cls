/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 31-01-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   31-01-2023   samuelsirkis@wiz.co   Initial Version
 **/
@isTest
public class OpportunityTeamMemberBOTest {
    @isTest
    static void opportunityTeamMemberBOTest(){
        // Create a new Opportunity record
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.StageName = 'New';
        opportunity.CloseDate = Datetime.now().date() +3;
        insert opportunity;

        // Create test user accounts
        User user1 = new User(LastName='User1',Email='user1@test.com',Alias='user1',
                                ProfileId=[SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                                Username = 'user1@test.com'+ System.currentTimeMillis(),
                                TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',
                                EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US'
                            );

        User user2 = new User(LastName='User2',Email='user2@test.com',Alias='user2',
                                ProfileId=[SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                                Username= 'user2@test.com'+ System.currentTimeMillis(),
                                TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',
                                EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US'
                            );

        insert new List<User>{user1, user2};

        // Create a new OpportunityTeamMember record
        List<OpportunityTeamMember> lstOppTeamMemberUpdate = new List<OpportunityTeamMember>();
        OpportunityTeamMember teamMember1 = new OpportunityTeamMember();
            teamMember1.OpportunityId = opportunity.Id;
            teamMember1.UserId = user1.Id;

        OpportunityTeamMember teamMember2 = new OpportunityTeamMember();
            teamMember2.OpportunityId = opportunity.Id;
            teamMember2.UserId = user2.Id;
        // teamMember.Role = 'Apoio';
        insert new List<OpportunityTeamMember>{teamMember1,teamMember2};

        lstOppTeamMemberUpdate.add(teamMember1);
        lstOppTeamMemberUpdate.add(teamMember2);

        OpportunityTeamMemberBO.getInstance().updateListOpportunityTeamMember(lstOppTeamMemberUpdate);

    }
}