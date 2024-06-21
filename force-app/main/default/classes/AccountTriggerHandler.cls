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
public class AccountTriggerHandler {
    private boolean isExecuting = false;
    public List<Account> oldRecordsList = null;
    public List<Account> newRecordsList = null;
    public Map<Id, Account> oldRecordsMap = null;
    public Map<Id, Account> newRecordsMap = null;

    /**
    * @description starta a trigger
    * @param isExecuting
    */
    public AccountTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeUpdate(){
        updateOwnerOpp();
        updateOpportunityTeamMemberFromAccount();
    }

    public void onAfterUpdate(){
        updateAccountTeamAfterOwnerChange();
    }

    public void onBeforeDelete(){}

    public void onBeforeInsert(){}

    public void onAfterInsert(){}

    /**
     * @descirption atualiza as oportunidades da conta com os membros do team
     */
    public void updateOpportunityTeamMemberFromAccount(){
        //Variaveis utilizadas
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> idsConta = new List<Id>();
        List<Opportunity> oppsDasContas = new List<Opportunity>();
        List<OpportunityTeamMember> oppToInsert = new List<OpportunityTeamMember>();

        Map<Id,Account> idContaMap = new Map<Id,Account>();
        Map<Id,String> mapAccountPorListaDeAtm = new Map<Id,String>();

        List<AccountTeamMember> listAtmAux = new List<AccountTeamMember>();
        List<OpportunityTeamMember> otmParaExcluir = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> oppParaCriar = new List<OpportunityTeamMember>();
        List<AccountTeamMember> listAtm = new List<AccountTeamMember>();
        List<AccountTeamMember> lstATM = new List<AccountTeamMember>();

        Map<Opportunity,List<OpportunityTeamMember>> otmPorOpp = new Map<Opportunity,List<OpportunityTeamMember>>();

        //Verifica se o que foi alterado foi o Owner das contas, se sim, seta o ID em uma lista
        for(Account newRecord : newRecordsList){
            for(Account oldRecord : oldRecordsList){
                if(newRecord.OwnerId != oldRecord.OwnerId && newRecord.Id == oldRecord.Id){
                    idsConta.add(newRecord.Id);
                }
            }
        }

        //Caso a lista de IDs de conta esteja vazio, pega todas as Opp e os membros de equipe das contas
        if(!idsConta.isEmpty()){
            oppsDasContas = [SELECT Id, OwnerId, AccountId, RecordTypeId FROM Opportunity WHERE AccountId IN :idsConta AND StageName != 'Fechado e ganho' AND StageName != 'Fechado e perdido'];
            listAtm = [SELECT Id, UserId, AccountId, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :idsConta];
        }

        System.debug('listAtm: '+listAtm);
        System.debug('CoppsDasContas: '+oppsDasContas);

        //Gera um mapa contendo todos os ATM separados por conta
        if(!listAtm.isEmpty()){
            for(Id acc : idsConta){
                listAtmAux.clear();
                System.debug('ID conta: '+acc);
                for(AccountTeamMember atm : listAtm){
                    if(acc == atm.AccountId){
                        listAtmAux.add(atm);
                        System.debug('Cada identificador: '+ listAtmAux);
                    }
                }
                System.debug('LISTA FINAL: '+listAtmAux);

                If(!listAtmAux.isEmpty()){
                    mapAccountPorListaDeAtm.put(acc, JSON.serialize(listAtmAux));
                }
            }
        }

        System.debug('MapCompleto: '+mapAccountPorListaDeAtm);
        System.debug('Mapa esta vazio? '+mapAccountPorListaDeAtm.isEmpty());

        //Puxa todos os otm atuais e salva em uma lista, para excluir. Entao cria novos otm baseado no mapa feito anteriormente
        if(!oppsDasContas.isEmpty()){
            otmParaExcluir = [SELECT Id, OpportunityId, UserId FROM OpportunityTeamMember WHERE OpportunityId IN: oppsDasContas];
            if(!mapAccountPorListaDeAtm.isEmpty()){
                for(Opportunity opp : oppsDasContas){
                    System.debug('Lista do mapa: '+mapAccountPorListaDeAtm.get(opp.AccountId));

                    if(mapAccountPorListaDeAtm.get(opp.AccountId) != null){
                        lstATM = (List<AccountTeamMember>) (
                            JSON.deserialize(
                                (String) mapAccountPorListaDeAtm.get(opp.AccountId),
                                List<AccountTeamMember>.class
                                )
                            );
                    }

                    for(AccountTeamMember atm : lstATM){
                        OpportunityTeamMember oppteam = new OpportunityTeamMember();
                        oppteam.OpportunityId = opp.Id;
                        oppteam.UserId = atm.UserId;
                        oppteam.OpportunityAccessLevel = 'Edit';
                        oppteam.TeamMemberRole = atm.TeamMemberRole;
                        oppParaCriar.add(oppteam);
                    }
                }
            }
        }

        System.debug('OTM Para criar: '+ oppParaCriar);
        System.debug('OTM Para Excluir: '+ otmParaExcluir);
        System.debug('OTM Para criar Qtd: '+ oppParaCriar.size());
        System.debug('OTM Para Excluir Qtd: '+ otmParaExcluir.size());
        //Caso as listas nao estejam vazias, insere e deleta
        if(!otmParaExcluir.isEmpty()){
            delete otmParaExcluir;
        }
        if(!oppParaCriar.isEmpty()){
            insert oppParaCriar;
        }
    }

    /**
     * @description: atualiza o team member da conta após alteração do propietário da conta
     */
    public void updateAccountTeamAfterOwnerChange(){
        //Variaveis
        List<Id> idsConta = new List<Id>();
        List<Opportunity> oppsDasContas = new List<Opportunity>();
        List<AccountTeamMember> accParaCriar = new List<AccountTeamMember>();
        List<OpportunityTeamMember> listOtm = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> listOtmDeserialize = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> listOtmAux = new List<OpportunityTeamMember>();
        Map<Id,String> otmPorAccountId = new Map<Id,String>();
        Boolean flag = false;
        System.debug('Inicio metodo update ATM');
        //Verifica se o que foi alterado foi o Owner das contas, se sim, seta o ID em uma lista
        for(Account newRecord : newRecordsList){
            for(Account oldRecord : oldRecordsList){
                if(newRecord.OwnerId != oldRecord.OwnerId && newRecord.Id == oldRecord.Id){
                    idsConta.add(newRecord.Id);
                }
            }
        }

        //Caso a lista de IDs de conta esteja vazio, pega todas as Opp
        if(!idsConta.isEmpty()){
            oppsDasContas = [SELECT Id, OwnerId, AccountId, RecordTypeId FROM Opportunity WHERE AccountId IN :idsConta AND StageName != 'Fechado e ganho' AND StageName != 'Fechado e perdido'];
        }
        //Caso encontre oportunidade, pega OTM e guarda em uma lista
        if(!oppsDasContas.isEmpty()){
            listOtm = [SELECT   Id, OpportunityId, UserId, TeamMemberRole, OpportunityAccessLevel FROM OpportunityTeamMember WHERE OpportunityId IN: oppsDasContas];
        }
        // System.debug('otm: '+listOtm);
        // System.debug('Opp: '+oppsDasContas);
        // System.debug('otm Qtd: '+listOtm.size());
        // System.debug('Opp Qtd: '+oppsDasContas.size());
        //Gera um mapa contendo todos os OTM separados por conta
        if(!listOtm.isEmpty()){
            for(Id acc : idsConta){
                listOtmAux.clear();
                flag = false;
                for(Opportunity opp : oppsDasContas){
                    if(acc == opp.AccountId && flag == false){
                        flag = true;

                        for(OpportunityTeamMember otm : listOtm){
                            if(otm.OpportunityId == opp.Id){
                                listOtmAux.add(otm);
                                System.debug('OTM: '+otm);
                            }
                        }
                    }
                }
                otmPorAccountId.put(acc, JSON.serialize(listOtmAux));
            }
        }
        System.debug('Map: '+otmPorAccountId);
        //Caso o mapa nao esteja vazio, ele identifica as contas e cria os ATM baseados no OTM das oportunidades relacionadas a conta
        if(!otmPorAccountId.isEmpty()){
            for(Id acc : idsConta){
                if(otmPorAccountId.get(acc) != null){
                    listOtmDeserialize = (List<OpportunityTeamMember>) (
                    JSON.deserialize(
                            (String) otmPorAccountId.get(acc),
                            List<OpportunityTeamMember>.class
                        )
                    );
                }
                for(OpportunityTeamMember otm : listOtmDeserialize){
                    AccountTeamMember accteam = new AccountTeamMember();

                    accteam.AccountId = acc;
                    accteam.UserId = otm.UserId;
                    accteam.OpportunityAccessLevel = 'Edit';
                    accteam.AccountAccessLevel = 'Edit';
                    accteam.CaseAccessLevel = 'Edit';
                    accteam.TeamMemberRole = otm.TeamMemberRole;

                    accParaCriar.add(accteam);
                }
            }
        }
        // System.debug('Acc para criar: '+ accParaCriar);
        // System.debug('Acc para criar Qtd: '+accParaCriar.size());
        //Caso as listas nao estejam vazias, insere os ATM na base de dados
        if(!accParaCriar.isEmpty()){
            insert accParaCriar;
        }
    }

    /**
     * @description: atualiza o owner das oportunidades
     */
    public void updateOwnerOpp(){
        List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
        List<Id> idsConta = new List<Id>();
        List<Opportunity> oppsDasContas = new List<Opportunity>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<Id,Account> idContaMap = new Map<Id,Account>();

        for(Account newRecord : newRecordsList){
            for(Account oldRecord : oldRecordsList){

                if((newRecord.Id == oldRecord.Id) && (newRecord.OwnerId != oldRecord.OwnerId)){
                    idsConta.add(newRecord.Id);
                    idContaMap.put(newRecord.Id, newRecord);
                }
            }
        }

        if(!idsConta.isEmpty()){
            oppsDasContas = [SELECT Id, OwnerId, AccountId, RecordTypeId FROM Opportunity WHERE AccountId IN :idsConta AND StageName != 'Fechado e ganho' AND StageName != 'Fechado e perdido'];
        }

        if(!oppsDasContas.isEmpty()){
            for(Opportunity opp : oppsDasContas){

                if(lstRecordTypeId.contains(opp.RecordTypeId)){
                    opp.OwnerId = idContaMap.get(opp.AccountId).OwnerId;
                    oppToUpdate.add(opp);
                }
            }
        }

        if(!oppToUpdate.isEmpty()){
            update oppToUpdate;
        }

    }

    /**
     * @descrition: recupera os tipos de registro de Oportunidade que a Wiz Corporate usa.
     */
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