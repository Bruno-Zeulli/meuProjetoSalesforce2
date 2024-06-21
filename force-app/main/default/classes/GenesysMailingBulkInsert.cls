public class GenesysMailingBulkInsert {
    public static void insertLeadAndCampaignMember(List<GenesysMailingCreation__e>  events) {
        try {
            List<Lead> lstLeads = new List<Lead>();
            List<CampaignMember> lstCampaignMembers = new List<CampaignMember>();
            List<String> lstErrors = new List<String>();

            for(GenesysMailingCreation__e event : events){
                Lead lead =(Lead)JSON.deserialize(event.Lead__c, Lead.class);
                lead.OwnerId = event.UserId__c;
                lead.RecordTypeId = event.RecordTypeId__c;
                lstLeads.add(lead);
            }

            List<Database.SaveResult> lstResults = Database.insert(lstLeads, false);

            for (Database.SaveResult result : lstResults) {
                if(result.isSuccess()){
                    lstCampaignMembers.add(
                        new CampaignMember(
                            LeadId = result.getId(),
                            CampaignId = events[0].CampaignId__c
                        )
                    );
                }
            }

            insert lstCampaignMembers;

            CustomNotificationHandler.notifyUser(
                events[0].UserId__c,
                events[0].CampaignId__c,
                'Processo finalizado - Carga Mailing',
                'Total de linhas processadas: ' + lstLeads.size()
                + '\nRegistros inseridos: ' + lstCampaignMembers.size()
                + '\nRegistros não inseridos: ' + (lstResults.size() - lstCampaignMembers.size())
            );
        } catch (Exception ex) {
            CustomNotificationHandler.notifyUser(
                events[0].UserId__c,
                events[0].CampaignId__c,
                'Erro',
                'Ocorreu um erro inesperado durante a importação de Leads. \nErro: ' + ex.getMessage()
            );
        }
    }
}