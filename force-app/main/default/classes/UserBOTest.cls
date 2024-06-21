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
private class UserBOTest {

    @testSetup
    static void setup(){
        // Create a new User record
        User user = UserDataFactory.createUser();
        insert user;

        // Create a new group
        Group vGroup = new Group(Name='Test Group', Type = 'Queue');
        insert vGroup;

        // Create test user accounts
        User user1 = new User(LastName='User1',Email='user1@test.com',
                                Alias='user1',
                                ProfileId=[SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                                Username = 'user1@test.com'+ System.currentTimeMillis(),
                                TimeZoneSidKey='America/Los_Angeles',
                                LocaleSidKey='en_US',
                                EmailEncodingKey='UTF-8',
                                LanguageLocaleKey='en_US'
                            );
        User user2 = new User(LastName='User2',Email='user2@test.com',
                                Alias='user2',
                                ProfileId=[SELECT Id FROM Profile WHERE Name = 'Administrador'].Id,
                                Username= 'user2@test.com'+ System.currentTimeMillis(),
                                TimeZoneSidKey='America/Los_Angeles',
                                LocaleSidKey='en_US',
                                EmailEncodingKey='UTF-8',
                                LanguageLocaleKey='en_US'
                            );

        insert new List<User>{user1, user2};

        // Add users to the group
        GroupMember gm1 = new GroupMember(GroupId=vGroup.Id, UserOrGroupId=user1.Id);
        GroupMember gm2 = new GroupMember(GroupId=vGroup.Id, UserOrGroupId=user2.Id);
        insert new List<GroupMember>{gm1, gm2};

        // Get group members
        List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :vGroup.Id];

        // Verify that the expected number of group members were returned
        System.assertEquals(2, groupMembers.size(), 'Incorrect number of group members');

        // Verify that the correct users were added to the group
        System.assertEquals(user1.Id, groupMembers[0].UserOrGroupId, 'Incorrect group member');
        System.assertEquals(user2.Id, groupMembers[1].UserOrGroupId, 'Incorrect group member');
    }

    @isTest
    static void getMapUserNameOrGroupNameByIdsAndQueuesTest(){
        Map<Id, String> mapUserNameOrGroupNameByIds = new Map<Id, String>();
        Test.startTest();
        List<String> lTypeGroup = new List<String>{'Queue'};

        mapUserNameOrGroupNameByIds = UserBO.getInstance().getMapUserNameOrGroupNameByIdsAndQueues(lTypeGroup);
        Test.stopTest();
        //System.assertEquals(!mapUserNameOrGroupNameByIds.isEmpty(), false , 'Teste fail getMapUserNameOrGroupNameByIdsAndQueuesTest');
    }

    @IsTest
    static void getUserOrGroupNamesTest(){
        List<String> lUserOrGroupName = new List<String>();
        Test.startTest();

        lUserOrGroupName = UserBO.getInstance().callGetUserOrGroupNames();
        Test.stopTest();
        System.assertEquals(!lUserOrGroupName.isEmpty(), true , 'Teste fail getUserOrGroupNamesTest');
    }

    @IsTest
    static void getUserOrGroupIdsTest(){
        String testJson= null;
        Test.startTest();

        testJson = UserBO.getInstance().callGetUserOrGroupIds();
        Test.stopTest();
        System.assertEquals(testJson != null , true , 'Teste fail getUserOrGroupIdsTest');

    }

}