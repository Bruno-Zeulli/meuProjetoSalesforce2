public with sharing class BeeTalkMessageTriggerHandler {
    private boolean isExecuting = false;

    public List<beetalk__Message__c> oldRecordsList = null;
    public List<beetalk__Message__c> newRecordsList = null;
    public Map<Id, beetalk__Message__c> oldRecordsMap = null;
    public Map<Id, beetalk__Message__c> newRecordsMap = null;

    /**
     *@description Construtor que recebe os parametros da Trigger
    *@param isExecuting boolean true para execução
    */

    public BeeTalkMessageTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    public void onAfterInsert(){
        callDistribuite();
    }
    public void onAfterUpdate(){
        callDistribuite();
    }


    public void callDistribuite(){
        User objUser = [SELECT Id, Profile.Name, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        if( (
                objUser.Profile.Name == 'System Administrator' ||
                objUser.Profile.Name == 'Administrador' ||
                objUser.Profile.Name.startsWith('Integrador')
            )
            &&
            (
                objUser.UserRole.Name == '' ||
                objUser.UserRole.Name == null
            )
        ){
            BeeTalkWhatsAppConsoleController.getInstance().DistribuiteCaseToOperador();
        }
    }
}