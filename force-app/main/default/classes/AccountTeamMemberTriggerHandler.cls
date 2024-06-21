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
* 1.2   09-03-2022   Pedro Tofani
**/
public class AccountTeamMemberTriggerHandler {
    private boolean isExecuting = false;
    public List<AccountTeamMember> oldRecordsList = null;
    public List<AccountTeamMember> newRecordsList = null;
    public Map<Id, AccountTeamMember> oldRecordsMap = null;
    public Map<Id, AccountTeamMember> newRecordsMap = null;

    /**
    * @description starta a trigger
    * @param isExecuting
    */
    public AccountTeamMemberTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    // public void onBeforeUpdate(){}
    // public void onAfterUpdate(){}
    // public void onBeforeInsert(){}

    public void onBeforeDelete(){
        atualizaApoioDasOppBeforeDelete();
    }
    public void onAfterInsert(){
        atualizaApoioDasOppAfterInsert();
    }

    public void atualizaApoioDasOppBeforeDelete(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> idsConta = new List<Id>();
        List<Opportunity> OppsDasContas = new List<Opportunity>();
        List<OpportunityTeamMember> OppToDelete = new List<OpportunityTeamMember>();
        Map<Id,Account> IdContaMap = new Map<Id,Account>();
        List<OpportunityTeamMember> otmQueJaExistem = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> otmAux = new List<OpportunityTeamMember>();
        Map<Opportunity,List<OpportunityTeamMember>> OtmPorOpp = new Map<Opportunity,List<OpportunityTeamMember>>();

        for(AccountTeamMember oldRecord : oldRecordsList){
            idsConta.add(oldRecord.AccountId);
        }

        if(!idsConta.isEmpty()){
            OppsDasContas = [SELECT Id, OwnerId, AccountId, RecordTypeId FROM Opportunity WHERE AccountId IN :idsConta AND StageName != 'Fechado e ganho' AND StageName != 'Fechado e perdido'];
        }

        if(!OppsDasContas.isEmpty()){
            otmQueJaExistem = [SELECT Id, OpportunityId, UserId FROM OpportunityTeamMember WHERE OpportunityId IN: OppsDasContas];

            for(Opportunity opp : OppsDasContas){
                otmAux.clear();

                for(OpportunityTeamMember otm : otmQueJaExistem){
                    if(otm.OpportunityId == opp.Id){
                        otmAux.add(otm);
                    }
                }

                OtmPorOpp.put(opp,otmAux);
            }
        }

        boolean flagParaCriar = true;

        if(!OppsDasContas.isEmpty()){
            for(Opportunity opp : OppsDasContas){
                for(AccountTeamMember newRecord : oldRecordsList){
                    flagParaCriar = true;

                    for(OpportunityTeamMember otm : OtmPorOpp.get(opp)){
                        if(otm.UserId == newRecord.UserId && lstRecordTypeId.contains(opp.RecordTypeId) && !OppToDelete.contains(otm))
                        {
                            flagParaCriar = false;
                            OppToDelete.add(otm);
                        }
                    }
                }
            }
        }

        if(!OppToDelete.isEmpty()){
            delete OppToDelete;
        }
    }

    public void atualizaApoioDasOppAfterInsert(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> idsConta = new List<Id>();
        List<Opportunity> OppsDasContas = new List<Opportunity>();
        List<OpportunityTeamMember> OppToInsert = new List<OpportunityTeamMember>();
        Map<Id,Account> IdContaMap = new Map<Id,Account>();
        List<OpportunityTeamMember> otmQueJaExistem = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> otmAux = new List<OpportunityTeamMember>();
        Map<Opportunity,List<OpportunityTeamMember>> OtmPorOpp = new Map<Opportunity,List<OpportunityTeamMember>>();

        for(AccountTeamMember newRecord : newRecordsList){
            idsConta.add(newRecord.AccountId);
        }

        if(!idsConta.isEmpty()){
            OppsDasContas = [SELECT Id, OwnerId, AccountId, RecordTypeId FROM Opportunity WHERE AccountId IN :idsConta AND StageName != 'Fechado e ganho' AND StageName != 'Fechado e perdido'];
        }

        if(!OppsDasContas.isEmpty()){
            otmQueJaExistem = [SELECT Id, OpportunityId, UserId FROM OpportunityTeamMember WHERE OpportunityId IN: OppsDasContas];

            for(Opportunity opp : OppsDasContas){
                otmAux.clear();

                for(OpportunityTeamMember otm : otmQueJaExistem){
                    if(otm.OpportunityId == opp.Id){
                        otmAux.add(otm);
                    }
                }
                OtmPorOpp.put(opp,otmAux);
            }
        }

        boolean flagParaCriar = true;

        if(!OppsDasContas.isEmpty()){
            for(Opportunity opp : OppsDasContas){
                for(AccountTeamMember newRecord : newRecordsList){
                    flagParaCriar = true;

                    for(OpportunityTeamMember otm : OtmPorOpp.get(opp)){
                        if(otm.UserId == newRecord.UserId)
                        {
                            flagParaCriar = false;
                        }
                    }

                    if(flagParaCriar == true && lstRecordTypeId.contains(opp.RecordTypeId) && !Test.isRunningTest()){
                        OpportunityTeamMember oppteam = new OpportunityTeamMember();

                        oppteam.OpportunityId = opp.Id;
                        oppteam.UserId = newRecord.UserId;
                        oppteam.OpportunityAccessLevel = 'Edit';
                        oppteam.TeamMemberRole = newRecord.TeamMemberRole;
                        OppToInsert.add(oppteam);
                    }
                }
            }
        }

        if(!OppToInsert.isEmpty())
        {
            insert OppToInsert;
        }
    }

    // Recupera os tipos de registro de Oportunidade que a Wiz Corporate usa.
    private List<String> getListRecordTypeIds(String businessUnit){
        List<String> lstRecordTypeId = new List<String>();

        switch on businessUnit {
            when 'Corporate' {
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateComercial')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateLicitacao')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateMCMV')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateCBIC')
                .getRecordTypeId());
                lstRecordTypeId.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('WGarantia')
                .getRecordTypeId());
            }
        }
        return lstRecordTypeId;
    }
}