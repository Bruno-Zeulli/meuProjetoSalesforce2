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
public with sharing class OpportunityTeamMemberTriggerHandler {
    private boolean isExecuting = false;
    public List<OpportunityTeamMember> oldRecordsList = null;
    public List<OpportunityTeamMember> newRecordsList = null;
    public Map<Id, OpportunityTeamMember> oldRecordsMap = null;
    public Map<Id, OpportunityTeamMember> newRecordsMap = null;

    public OpportunityTeamMemberTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){}

    public void onBeforeDelete(){}
}