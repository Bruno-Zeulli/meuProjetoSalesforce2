/**
 * @description Classe para prover informações para a home page de oportunidades do Cockpit
 */
public with sharing class CorporateOpportunityController {
    public CorporateOpportunityController(){
    }
    public class oppObjInformation {
        @AuraEnabled
        public List<AggregateResult> OpportunityTotal;

        @AuraEnabled
        public List<AggregateResult> OpportunityGanho;

        @AuraEnabled
        public List<AggregateResult> OpportunityPerdido;

        @AuraEnabled
        public List<AggregateResult> OpportunityStageTotal;

        @AuraEnabled
        public List<User> userInformation;
    }
    /**
     * @description Métodos que retornan as informações para a página de oportunidades customizada
     */

    @AuraEnabled
    public static oppObjInformation getUserOpportunity(){
        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';
        oppObjInformation oppObjRecords = new oppObjInformation();

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional')){
            List<AggregateResult> TotalOppRecords = ([SELECT COUNT(id) TotalOpp FROM Opportunity WHERE OwnerId = :userId AND CreatedDate = THIS_YEAR]);
            oppObjRecords.OpportunityTotal = TotalOppRecords;

            List<AggregateResult> TotalOppGanhoRecords = ([
                SELECT COUNT(id) TotaOppGanho
                FROM Opportunity
                WHERE StageName IN ('Fechado e ganho') AND CloseDate = THIS_YEAR AND OwnerId = :userId
            ]);
            oppObjRecords.OpportunityGanho = TotalOppGanhoRecords;

            List<AggregateResult> TotalOppPerdidoRecords = ([
                SELECT COUNT(id) TotaOppPerdido
                FROM Opportunity
                WHERE StageName = 'Fechado e perdido' AND CloseDate = THIS_YEAR AND OwnerId = :userId
            ]);
            oppObjRecords.OpportunityPerdido = TotalOppPerdidoRecords;

            List<AggregateResult> TotalOppStageRecords = ([
                SELECT COUNT(id) TotaOppOrigem, StageName
                FROM Opportunity
                WHERE OwnerId = :userId AND RecordType.DeveloperName LIKE '%Corporate%' AND StageName NOT IN ('Fechado e perdido', 'Fechado e ganho') AND CloseDate > TODAY
                GROUP BY StageName
                ORDER BY COUNT(id) DESC
            ]);
            oppObjRecords.OpportunityStageTotal = TotalOppStageRecords;
        }else{
            List<String> lstUserIds = new List<String>();
            Map<Id, String> mapUser = new Map<Id, String>();
            mapUser.put(userId, userId);

            List<User> lstUser = new List<User>([SELECT id FROM User WHERE ManagerId = :userId AND IsActive = TRUE]);
            if(lstUser.size() > 0){
                for(User lpUsr : lstUser){
                    mapUser.put(lpUsr.Id, lpUsr.Id);
                }
            }

            lstUserIds = mapUser.values();

            List<AggregateResult> TotalOppRecords = ([SELECT COUNT(id) TotalOpp FROM Opportunity WHERE OwnerId IN :lstUserIds]);
            oppObjRecords.OpportunityTotal = TotalOppRecords;

            List<AggregateResult> TotalOppGanhoRecords = ([
                SELECT COUNT(id) TotaOppGanho
                FROM Opportunity
                WHERE StageName IN ('Fechado e ganho') AND CloseDate = THIS_YEAR AND OwnerId IN :lstUserIds
            ]);
            oppObjRecords.OpportunityGanho = TotalOppGanhoRecords;

            List<AggregateResult> TotalOppPerdidoRecords = ([
                SELECT COUNT(id) TotaOppPerdido
                FROM Opportunity
                WHERE StageName = 'Fechado e perdido' AND CloseDate = THIS_YEAR AND OwnerId IN :lstUserIds
            ]);
            oppObjRecords.OpportunityPerdido = TotalOppPerdidoRecords;

            List<AggregateResult> TotalOppStageRecords = ([
                SELECT COUNT(id) TotaOppOrigem, StageName
                FROM Opportunity
                WHERE OwnerId IN :lstUserIds AND RecordType.Name NOT IN ('Corporate - Endosso') AND StageName NOT IN ('Fechado e perdido', 'Fechado e ganho') AND CloseDate > TODAY
                GROUP BY StageName
                ORDER BY COUNT(id) DESC
            ]);
            oppObjRecords.OpportunityStageTotal = TotalOppStageRecords;
        }
        return oppObjRecords;
    }

    @AuraEnabled
    public static oppObjInformation fetchUser(){
        oppObjInformation oppObjRecords = new oppObjInformation();
        List<User> lstUser = new List<User>([SELECT id, Name, ProfileId, Profile.Name FROM User WHERE id = :userInfo.getUserId()]);
        oppObjRecords.userInformation = lstUser;
        return oppObjRecords;
    }
}