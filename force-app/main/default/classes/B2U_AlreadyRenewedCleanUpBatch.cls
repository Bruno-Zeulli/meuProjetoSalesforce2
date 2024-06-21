/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public class B2U_AlreadyRenewedCleanUpBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
  /** @description */
  public Integer executions = 0;

  /**
   * @description
   * @param bc
   * @return Database.getQueryLocator(q)
   */
  public Database.QueryLocator start(Database.BatchableContext bc){
    System.debug('***** INITIALIZING PROCESS - AlreadyRenewedCleanUpBatch ******');
    List<RenewalCampaign__c> lCampaigns = RenewalCampaign__c.getAll().values();
    Set<String> setCampaignNames = new Set<String>();
    Set<String> setProductNames = new Set<String>();
    Date data20DiasAtras = System.today().addDays(-20);
    Date data20DiasAFrente = System.today().addDays(20);

    for(RenewalCampaign__c rc : lCampaigns){
      setCampaignNames.add(rc.CampaignName__c);
      setProductNames.add(rc.Product__c);
    }
    String q =
      'SELECT Id, Name, AccountId, (SELECT Id, IntegrationStatus__c FROM CampaignMembers WHERE Campaign.Name IN :setCampaignNames AND IntegrationStatus__c = \'Enviado\') ' +
      'FROM Contact ' +
      'WHERE Account.IsPersonAccount = true AND AccountId IN (SELECT Account__c FROM Contract2__c WHERE ProductFamily__c IN :setProductNames AND EndDate__c >= : data20DiasAtras AND EndDate__c <= : data20DiasAFrente AND (IsRenewed__c = true OR IsAutoRenewal__c = true))';
    return Database.getQueryLocator(q);
  }

  /**
   * @description
   * @param bc
   * @param scope
   */
  public void execute(Database.BatchableContext bc, List<sObject> scope){
    executions++;
    List<CampaignMember> lCampaignMembers = new List<CampaignMember>();
    for(sObject sobj : scope){
      Contact ct = (Contact) sobj;
      lCampaignMembers.addAll(ct.CampaignMembers);
    }
    for(CampaignMember cm : lCampaignMembers){
      cm.IntegrationStatus__c = 'Retirado';
    }
    System.debug('lCampaignMembers: ' + lCampaignMembers);
    update lCampaignMembers;
  }

  /**
   * @description
   * @param bc
   */
  public void finish(Database.BatchableContext bc){
    System.debug('***** FINISHING PROCESS - AlreadyRenewedCleanUpBatch ******');
    System.debug('Quantidade de execuções totais: ' + executions);
  }
}