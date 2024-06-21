/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-29-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class UserManagementTriggerHandler {
    private boolean isExecuting = false;

    public List<UserManagement__c> oldRecordsList = null;
    public List<UserManagement__c> newRecordsList = null;
    public Map<Id, UserManagement__c> oldRecordsMap = null;
    public Map<Id, UserManagement__c> newRecordsMap = null;

    /**
     *@description Construtor que recebe os parametros da Trigger
    *@param isExecuting boolean true para execução
    */

    public UserManagementTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    public void onAfterInsert(){
        //populateFieldsStandardValues();
    }
    public void onAfterUpdate(){

    }

    public void populateFieldsStandardValues(){
        List<UserManagement__c> lstUpdtUserManagement = new List<UserManagement__c>();
        for(UserManagement__c objUsrM : newRecordsList){
            if(objUsrM.MyCasesToView__c == 0 || objUsrM.MyCasesToView__c == null){
                objUsrM.MyCasesToView__c = 3;
            }
            if(objUsrM.AwaitCasesToView__c == 0 || objUsrM.AwaitCasesToView__c == null){
                objUsrM.AwaitCasesToView__c = 5;
            }
            
            lstUpdtUserManagement.add(objUsrM);
            
            if(lstUpdtUserManagement != newRecordsList){
                update lstUpdtUserManagement;
            }
        }
    }

}