public with sharing class EmailMessageBO {

    private static final EmailMessageBO instance = new EmailMessageBO();

    public static EmailMessageBO getInstance(){
        return instance;
    }


    //REGRA FINALIZAÇÃO DOS MARCOS
    public void completeMilestoneTickets(List<EmailMessage> newRecordsList){
        List<Id> updatePrimeiraResposta = new List<Id>();
        DateTime completionDate = System.now();
        Set<Id> emailMessageIdSet = new Set<Id>();

        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(EmailMessage iEm : newRecordsList){
            emailMessageIdSet.add(iEm.Id);
        }

        List<EmailMessage> lstEmailMessage = [SELECT Id, Parent.RecordTypeId, CreatedById, ParentId, CreatedBy.Profile.Name FROM EmailMessage WHERE Id IN : emailMessageIdSet];

        for(EmailMessage iEm : lstEmailMessage){
            if(rt_map.get(iEm.Parent.RecordTypeId).getDeveloperName().contains('_Tkt') && !iEm.CreatedBy.Profile.Name.contains('Admin')){
                updatePrimeiraResposta.add(iEm.ParentId);
            }
        }
        if(updatePrimeiraResposta != null){
            milestoneUtils.completeMilestone(updatePrimeiraResposta, 'Tempo de primeira resposta', completionDate);
        }
    }

}