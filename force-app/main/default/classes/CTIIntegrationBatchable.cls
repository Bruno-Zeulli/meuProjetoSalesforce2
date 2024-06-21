/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

global class CTIIntegrationBatchable implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    global System.TriggerOperation operation;
    global Map<Id, Campaign> mapCampaigns;

    global CTIIntegrationBatchable(Map<Id, Campaign> mapCampaigns, System.TriggerOperation operation){
        this.mapCampaigns = mapCampaigns;
        this.operation = operation;
    }

    global Integer execucoes = 0;

    global Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - CTIIntegrationBatchable ******');
        Set<Id> setCampaignIds = mapCampaigns.keySet();
        String q =
            'SELECT 	Id, LeadOrContactId, ContactDetail__r.MobilePhone__c, ContactDetail__r.HomePhone__c, ContactDetail__r.OtherPhone__c,ContactDetail__r.BestPhone__c,ContactDetail__r.BestEmail__c, ' +
                        'ContactDetail__r.Contact__r.IndividualIdentificationNumber__c, FirstName, LastName, Campaign.CTIListName__c, MobilePhone, ' +
                        'Phone, Lead.IdentificationNumber__c, CampaignId, CreatedDate, Priority__c, Contrato__r.ContractNumber__c, Contrato__r.StartDate__c,Contrato__r.BidDate__c ' +
            'FROM 		CampaignMember ' +
            'WHERE 		CampaignId IN : setCampaignIds AND IntegrationStatus__c != \'Retirado\'' +
            'ORDER BY 	CampaignId';
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext bC, List<sObject> scope){
        Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = getCampaignMembersByListMap(scope);
        CTIIntegrationQueueable queueable = new CTIIntegrationQueueable(mapCampaignMembersByList, operation);
        System.enqueueJob(queueable);
        execucoes++;
    }

    private Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> getCampaignMembersByListMap(List<CampaignMember> lCampaignMembers){
        Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = new Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>();
        for(CampaignMember cm : lCampaignMembers){
            String key = mapCampaigns.get(cm.CampaignId).CTIListName__c;
            String leadOrContactId = cm.LeadOrContactId;
            CTIIntegrationQueueable.CTIIntegrationModel ctiModel;
            if(leadOrContactId.startsWith('003')){
                ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                    cm.ContactDetail__r.MobilePhone__c,
                    cm.ContactDetail__r.HomePhone__c,
                    cm.ContactDetail__r.OtherPhone__c,
                    cm.ContactDetail__r.BestPhone__c,
                    cm.FirstName,
                    cm.LastName,
                    cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                    leadOrContactId,
                    cm.CreatedDate,
                    cm.Priority__c,
                    cm.Contrato__r.ContractNumber__c,
                    cm.Contrato__r.StartDate__c,
                    cm.Contrato__r.BidDate__c,
                    cm.ContactDetail__r.BestEmail__c
                );
            }else{
                ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                    cm.MobilePhone,
                    cm.Phone,
                    null,
                    null,
                    cm.FirstName,
                    cm.LastName,
                    cm.Lead.IdentificationNumber__c,
                    leadOrContactId,
                    cm.CreatedDate,
                    cm.Priority__c,
                    cm.Contrato__r.ContractNumber__c,
                    cm.Contrato__r.StartDate__c,
                    cm.Contrato__r.BidDate__c,
                    null
                );
            }
            if(key != null){
                if(!mapCampaignMembersByList.containsKey(key)){
                    mapCampaignMembersByList.put(key, new List<CTIIntegrationQueueable.CTIIntegrationModel>());
                }
                mapCampaignMembersByList.get(key).add(ctiModel);
            }
        }
        return mapCampaignMembersByList;
    }

    global void finish(Database.BatchableContext bC){
        System.debug('Quantidade de execuções totais: ' + execucoes);
        System.debug('***** FINISHING PROCESS - CTIIntegrationBatchable ******');
    }
}