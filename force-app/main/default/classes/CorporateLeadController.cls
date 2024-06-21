/**
 * @description Classe para prover informações para a home page de leads
 */
public inherited sharing class CorporateLeadController {
    Date dtsystem;
    /**
     * @description Método construtor
     */
    public CorporateLeadController(){
        dtsystem = Date.today();
    }
    public class leadObjInformation {
        /**
         * @description Método construtor
         */
        public leadObjInformation(){
        }

        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> TotalLeads;

        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> LeadsQualificados;

        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> LeadsContatosRealizados;

        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> LeadOrigemTotal;
    }
    /**
     * @description Métodos que retornan informações da classe interna da leads
     */
    @AuraEnabled
    public static leadObjInformation getUserLeads(){
        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';
        leadObjInformation leadObjRecords = new leadObjInformation();

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional')){
            List<AggregateResult> TotalLeadRecords = ([SELECT COUNT(id) TotalLead FROM Lead WHERE OwnerId = :userId AND CreatedDate = THIS_YEAR]);
            leadObjRecords.TotalLeads = TotalLeadRecords;

            List<AggregateResult> TotalLeadQaRecords = ([SELECT COUNT(id) TotalLeadQa FROM Lead WHERE Status = 'Qualified' AND CreatedDate = THIS_YEAR AND OwnerId = :userId]);
            leadObjRecords.LeadsQualificados = TotalLeadQaRecords;

            List<AggregateResult> TotalLeadContRealRecords = ([
                SELECT COUNT(id) TotalLeadContReal
                FROM Lead
                WHERE Status = 'Unqualified' AND CreatedDate = THIS_YEAR AND OwnerId = :userId
            ]);
            leadObjRecords.LeadsContatosRealizados = TotalLeadContRealRecords;

            List<AggregateResult> TotalLeadOrigemRecords = ([
                SELECT COUNT(id) TotalLeadOrigem, LeadSource
                FROM Lead
                WHERE OwnerId = :userId AND CreatedDate = THIS_YEAR
                GROUP BY LeadSource
                ORDER BY COUNT(id) DESC
                LIMIT 4
            ]);
            leadObjRecords.LeadOrigemTotal = TotalLeadOrigemRecords;
        }else{
            List<AggregateResult> TotalLeadRecords = ([
                SELECT COUNT(id) TotalLead
                FROM Lead
                WHERE CreatedDate = THIS_YEAR AND OwnerId IN (SELECT id FROM User WHERE ManagerId = :userId)
            ]);
            leadObjRecords.TotalLeads = TotalLeadRecords;

            List<AggregateResult> TotalLeadQaRecords = ([
                SELECT COUNT(id) TotalLeadQa
                FROM Lead
                WHERE Status = 'Qualified' AND CreatedDate = THIS_YEAR AND OwnerId IN (SELECT id FROM User WHERE ManagerId = :userId)
            ]);
            leadObjRecords.LeadsQualificados = TotalLeadQaRecords;

            List<AggregateResult> TotalLeadContRealRecords = ([
                SELECT COUNT(id) TotalLeadContReal
                FROM Lead
                WHERE Status = 'Unqualified' AND CreatedDate = THIS_YEAR AND OwnerId IN (SELECT id FROM User WHERE ManagerId = :userId)
            ]);
            leadObjRecords.LeadsContatosRealizados = TotalLeadContRealRecords;

            List<AggregateResult> TotalLeadOrigemRecords = ([
                SELECT COUNT(id) TotalLeadOrigem, LeadSource
                FROM Lead
                WHERE CreatedDate = THIS_YEAR AND OwnerId IN (SELECT id FROM User WHERE ManagerId = :userId)
                GROUP BY LeadSource
                ORDER BY COUNT(id) DESC
                LIMIT 4
            ]);
            leadObjRecords.LeadOrigemTotal = TotalLeadOrigemRecords;
        }
        /**
         * @description RETORNA AS INFORMAÇÕES DO USUÁRIO
         */
        return leadObjRecords;
    }
}