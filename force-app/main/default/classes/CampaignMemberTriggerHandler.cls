public without sharing class CampaignMemberTriggerHandler {
    private boolean isExecuting = false;
    public List<CampaignMember> oldRecordsList = null;
    public List<CampaignMember> newRecordsList = null;
    public Map<Id, CampaignMember> oldRecordsMap = null;
    public Map<Id, CampaignMember> newRecordsMap = null;

    public CampaignMemberTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onAfterInsert(){
        sendToCTI();
        insertToOlosCTI();
        sendMemberToGenesys(newRecordsMap);
    }

    public void onAfterUpdate(){
        sendToCTI();
        updateToOlosCTI();

        Map<Id, CampaignMember> newRecordsMapFiltered = new Map<Id, CampaignMember>();
        for(String cmId : newRecordsMap.keySet()){
            if(newRecordsMap.get(cmId).IntegrationStatus__c == 'ENVIADO' && oldRecordsMap.get(cmId).IntegrationStatus__c == 'RETIRADO'){
                newRecordsMapFiltered.put(cmId, newRecordsMap.get(cmId));
            }
        }
        if(!newRecordsMapFiltered.isEmpty()){
           sendMemberToGenesysUpdateContext(newRecordsMapFiltered);
        }
    }

    public void onBeforeDelete(){
        sendToCTI();
    }

    private void sendToCTI(){
        Map<Id, CampaignMember> mapCampaignMembers = newRecordsMap != null ? newRecordsMap : oldRecordsMap;
        Map<String, Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>> mapCampaignMembersByListStatus = getCampaignMembersByListMap(mapCampaignMembers);

        for(String integrationStatus : mapCampaignMembersByListStatus.keySet()){
            if(!mapCampaignMembersByListStatus.get(integrationStatus).isEmpty()){
                CTIIntegrationQueueable queueable;
                if(integrationStatus == 'Retirado'){
                    queueable = new CTIIntegrationQueueable(mapCampaignMembersByListStatus.get(integrationStatus), System.TriggerOperation.BEFORE_DELETE);
                }else{
                    queueable = new CTIIntegrationQueueable(mapCampaignMembersByListStatus.get(integrationStatus), Trigger.operationType);
                }
                System.enqueueJob(queueable);
            }
        }
    }

    private Map<String, Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>> getCampaignMembersByListMap(Map<Id, CampaignMember> mapCampaignMembers){
        Map<String, Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>> mapCampaignMembersByList = new Map<String, Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>>();

        if(!Schema.sObjectType.CampaignMember.isUpdateable()){
            return null;
        }
        List<CampaignMember> lCampaignMembers = [
            SELECT
                Id,
                LeadOrContactId,ContactDetail__r.MobilePhone__c,ContactDetail__r.HomePhone__c,ContactDetail__r.OtherPhone__c,ContactDetail__r.BestPhone__c,
                ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,FirstName,
                LastName,Campaign.CTIListName__c,IntegrationStatus__c,MobilePhone,Phone,
                Lead.IdentificationNumber__c,CreatedDate,
                Priority__c,Contrato__r.ContractNumber__c,Contrato__r.StartDate__c,Contrato__r.BidDate__c,ContactDetail__r.BestEmail__c,Campaign.Name
            FROM CampaignMember
            WHERE Id IN :mapCampaignMembers.keySet()
        ];

        for(CampaignMember cm : lCampaignMembers){
            String key = cm.IntegrationStatus__c;
            String key2 = cm.Campaign.CTIListName__c;
            String leadOrContactId = cm.LeadOrContactId;
            CTIIntegrationQueueable.CTIIntegrationModel ctiModel;
            if(leadOrContactId.startsWith('003') && cm.Campaign.Name == 'CONSORCIO BV PARCEIROS'){
                if (cm.ContactDetail__r.BestPhone__c == null) {
                    ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                        cm.ContactDetail__r.MobilePhone__c,cm.ContactDetail__r.HomePhone__c,
                        cm.ContactDetail__r.OtherPhone__c,cm.ContactDetail__r.BestPhone__c,cm.FirstName,cm.LastName,cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                        leadOrContactId,cm.CreatedDate,cm.Priority__c,cm.Contrato__r.ContractNumber__c,cm.Contrato__r.StartDate__c,cm.Contrato__r.BidDate__c,cm.ContactDetail__r.BestEmail__c
                    );
                }else{
                    ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                        cm.ContactDetail__r.MobilePhone__c,cm.ContactDetail__r.BestPhone__c,cm.ContactDetail__r.HomePhone__c,
                        cm.ContactDetail__r.OtherPhone__c,cm.FirstName,cm.LastName,
                        cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                        leadOrContactId,cm.CreatedDate,cm.Priority__c,cm.Contrato__r.ContractNumber__c,
                        cm.Contrato__r.StartDate__c,cm.Contrato__r.BidDate__c,cm.ContactDetail__r.BestEmail__c
                    );
                }
            }else if(leadOrContactId.startsWith('003')){
                ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                    cm.ContactDetail__r.MobilePhone__c,cm.ContactDetail__r.HomePhone__c,cm.ContactDetail__r.OtherPhone__c,cm.ContactDetail__r.BestPhone__c,cm.FirstName,cm.LastName,
                    cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,leadOrContactId,cm.CreatedDate,cm.Priority__c,cm.Contrato__r.ContractNumber__c,cm.Contrato__r.StartDate__c,cm.Contrato__r.BidDate__c,cm.ContactDetail__r.BestEmail__c
                );
            }else{
                ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                    cm.MobilePhone,cm.Phone,null,null,cm.FirstName,cm.LastName,cm.Lead.IdentificationNumber__c,leadOrContactId,
                    cm.CreatedDate,cm.Priority__c,cm.Contrato__r.ContractNumber__c,cm.Contrato__r.StartDate__c,cm.Contrato__r.BidDate__c,null
                );
            }
            if(key != null && !mapCampaignMembersByList.containsKey(key)){
                mapCampaignMembersByList.put(key, new Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>());
            }
            if(key2 != null){
                if(!mapCampaignMembersByList.get(key).containsKey(key2)){
                    mapCampaignMembersByList.get(key).put(key2, new List<CTIIntegrationQueueable.CTIIntegrationModel>());
                }
                mapCampaignMembersByList.get(key).get(key2).add(ctiModel);
            }
        }
        return mapCampaignMembersByList;
    }

    private void insertToOlosCTI(){
        CampaignBO.getInstance().integrationOlosInsertCampaignMember(newRecordsMap, false);
    }

    private void updateToOlosCTI(){
        CampaignBO.getInstance().integrationOlosDeleteCampaignMember(newRecordsMap);
        CampaignBO.getInstance().integrationOlosInsertCampaignMember(newRecordsMap, true);
    }

    private static List<CampaignMember> getCampaignMembers(String leadOrContactId, String filaAtual){
        List<CampaignMember> campaignMembers = [
            SELECT Id, Name, IntegrationStatus__c
            FROM CampaignMember
            WHERE LeadOrContactId = :leadOrContactId AND Campaign.Name != :filaAtual AND Campaign.RecordType.Name = 'BPO - Campaign' AND IntegrationStatus__c = 'Enviado'
        ];
        return campaignMembers;
    }

    public static void sendMemberToGenesys(Map<Id, CampaignMember> newRecordsMap){
        System.enqueueJob(new GenesysAddContactListMember(newRecordsMap.keySet()));
    }

    public static void sendMemberToGenesysUpdateContext(Map<Id, CampaignMember> newRecordsMap){
        System.enqueueJob(new GenesysAddContactListMember(newRecordsMap.keySet(), true));
    }
}