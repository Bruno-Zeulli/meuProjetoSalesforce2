/**
 * @description Classe para prover informações para a home page de casos do Cockpit
 */
public with sharing class CorporateCaseController {
    Date dtsystem;
    public CorporateCaseController(){
        dtsystem = Date.today();
    }

    public class caseObjInformation 
    {
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> caseTotal;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> casecotacaoTotal;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> caseatrasadoTotal;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> casestatusTotal;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<User> userInformation;
    }
    /**
     * @description Métodos que retornan as informações para a página de oportunidades customizada
     */    
    @AuraEnabled
    public static caseObjInformation getUserCases(){
        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';
        caseObjInformation oppCaseRecords = new caseObjInformation();

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id =:profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional'))
        {
            List<AggregateResult> TotalOpenCase = ([SELECT COUNT(id)TotalCases FROM Case WHERE IsClosed = false AND CreatedById = : userId AND CreatedDate = THIS_YEAR  GROUP BY CreatedById]);
            oppCaseRecords.caseTotal = TotalOpenCase;

            List<AggregateResult> TotalCaseCotacao = ([SELECT COUNT(id)TotalCotacao FROM Case WHERE Subject = 'Cotação CT' AND IsClosed = false AND OwnerId = : userId GROUP BY Subject]);  
            oppCaseRecords.casecotacaoTotal = TotalCaseCotacao;

            List<AggregateResult> TotalCaseAtrasados = ([SELECT COUNT(id)TotalCasesAtrasados FROM Case WHERE CreatedDate < LAST_N_DAYS:5 AND IsClosed = false AND CreatedById = : userId GROUP BY CreatedById]);
            oppCaseRecords.caseatrasadoTotal = TotalCaseAtrasados;

            List<AggregateResult> TotalCaseStatus = ([SELECT COUNT(id)TotalCases, Status FROM Case WHERE CreatedById = : userId AND CreatedDate = THIS_YEAR GROUP BY CreatedById, Status ORDER BY COUNT(id) DESC]);
            oppCaseRecords.casestatusTotal = TotalCaseStatus;
        }
        else
        {   
            List<String> lstUserIds = new List<String>();
            Map<Id, String> mapUser = new Map<Id, String>();
            mapUser.put(userId, userId);
            
            List<User> lstUser = new List<User>([SELECT id FROM User where ManagerId =: userId AND IsActive = TRUE]);
            if(lstUser.size() > 0){
                for(User lpUsr : lstUser){
                    mapUser.put(lpUsr.Id, lpUsr.Id);
                }
            }

            lstUserIds = mapUser.values();

            List<AggregateResult> TotalOpenCase = ([SELECT COUNT(id)TotalCases FROM Case WHERE IsClosed = false AND CreatedDate = THIS_YEAR AND CreatedById IN : lstUserIds GROUP BY CreatedById]);
            oppCaseRecords.caseTotal = TotalOpenCase;

            List<AggregateResult> TotalCaseCotacao = ([SELECT COUNT(id)TotalCotacao FROM Case WHERE Subject = 'Cotação CT' AND IsClosed = false AND OwnerId IN : lstUserIds GROUP BY Subject]);  
            oppCaseRecords.casecotacaoTotal = TotalCaseCotacao;

            List<AggregateResult> TotalCaseAtrasados = ([SELECT COUNT(id)TotalCasesAtrasados FROM Case WHERE CreatedDate < LAST_N_DAYS:5 AND IsClosed = false AND CreatedById IN : lstUserIds GROUP BY CreatedById]);
            oppCaseRecords.caseatrasadoTotal = TotalCaseAtrasados;

            List<AggregateResult> TotalCaseStatus = ([SELECT COUNT(id)TotalCases, Status FROM Case WHERE CreatedById IN : lstUserIds AND CreatedDate = THIS_YEAR GROUP BY CreatedById, Status ORDER BY COUNT(id) DESC]);
            oppCaseRecords.casestatusTotal = TotalCaseStatus;

        }
        /**
         * @description retorna as informações dos casos
         */  
       return oppCaseRecords;
    }

}