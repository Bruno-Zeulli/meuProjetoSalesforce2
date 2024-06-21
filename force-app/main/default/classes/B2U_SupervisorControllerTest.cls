/**
 * @description       :
 * @author            : Windson SAntos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-19-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class B2U_SupervisorControllerTest {
    @isTest
    static void testController(){
        User taskOwner = [SELECT Id, UserRoleId, UserRole.Name FROM User WHERE UserRole.Name LIKE '%BPO%' AND IsActive = TRUE LIMIT 1];
        Task t = TaskDataFactory.createCallTask();
        t.CallType = 'Outbound';
        t.OwnerId = taskOwner.Id;
        insert t;
        System.assert(taskOwner != null, 'Expected call type "Outbound"');

        System.runAs(taskOwner){
            B2U_SupervisorController.getRanking();
            B2U_SupervisorController.getTasksList();
            B2U_SupervisorController.hasAccess(t.Id);
        }

        User taskOwner2 = [SELECT Id, UserRoleId, UserRole.Name FROM User WHERE UserRole.Name LIKE '%BPO%' AND IsActive = TRUE LIMIT 1];
        Task t2 = TaskDataFactory.createCallTask();
        t2.CallType = 'Outbound';
        t2.OwnerId = taskOwner.Id;
        insert t2;
        System.assert(taskOwner != null, 'Expected call type "Outbound"');

        System.runAs(taskOwner2){
            B2U_SupervisorController.getRanking();
            B2U_SupervisorController.getTasksList();
            B2U_SupervisorController.hasAccess(t2.Id);
        }
    }
}