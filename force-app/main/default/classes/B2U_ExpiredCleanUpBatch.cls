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
public with sharing class B2U_ExpiredCleanUpBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
  public Integer executions = 0;

  public Database.QueryLocator start(Database.BatchableContext bC){
    System.debug('***** INITIALIZING PROCESS - ExpiredCleanUpBatch ******');
    Date dateAMonthAgo = System.today().addDays(-30);
    String q =
      'SELECT Id, IntegrationStatus__c FROM CampaignMember ' +
      'WHERE Campaign.RecordType.Name = \'B2U - Campaign\' AND Campaign.Type = \'Call Center Ativo\' AND IntegrationStatus__c = \'Enviado\' AND CreatedDate <= :dateAMonthAgo ';

    return Database.getQueryLocator(q);
  }

  public void execute(Database.BatchableContext bC, List<sObject> scope){
    executions++;
    List<CampaignMember> lCampaignMembers = (List<CampaignMember>) scope;
    for(CampaignMember cm : lCampaignMembers){
      cm.IntegrationStatus__c = 'Retirado';
    }
    update lCampaignMembers;
  }

  public void finish(Database.BatchableContext bC){
    System.debug('***** FINISHING PROCESS - ExpiredCleanUpBatch ******');
    System.debug('Quantidade de execuções totais: ' + executions);
  }
}