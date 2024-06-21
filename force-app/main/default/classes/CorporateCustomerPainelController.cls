/**
 * @description Classe para gerar as informações da tela do painel de clientes do usuário do cockpit de clientes
 */
public with sharing class CorporateCustomerPainelController {
    Date dtSystem;
    public CorporateCustomerPainelController(){
        dtSystem = Date.today();
    }
    /**
     * @description Classe interna que retorna as informações para a chamada do componente
     */
    public class homeObjInformation {
        Date dtSystemC;
        /**
         * @description Método construtor
         */
        public homeObjInformation(){
            dtSystemC = Date.today();
        }
        /**
         * @description Método de retorno de nformações de tela do cmp
         */
        @AuraEnabled
        public List<String> contractVincendosSumarizado;
        /**
         * @description Método de retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<Contract2__c> contractVincendosLst;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<User> userInformation;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<Report> userReportIds;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> customerAward;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> customerPotentialConvertion;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<String> customerAggregateView;
    }
    /**
     * @description Método de  chamada do cmp
     */
    @AuraEnabled
    public static homeObjInformation getCustomerAwardAcumulated(){
        homeObjInformation homeInformations = new homeObjInformation();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }

        if(!strPrfName.contains('Gerente Regional')){
            List<AggregateResult> lstCustomerAwardRecords = ([
                SELECT Account__r.Name, Account__c, FORMAT(SUM(Value__c)) TotalPremio
                FROM Contract2__c
                WHERE Value__c != NULL AND StartDate__c >= LAST_YEAR AND EndDate__c > Today AND Account__r.OwnerId = :userId
                GROUP BY Account__r.Name, Account__c
                ORDER BY SUM(Value__c) DESC
                LIMIT 30
            ]);
            if(lstCustomerAwardRecords.size() > 0){
                homeInformations.customerAward = lstCustomerAwardRecords;
            }
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

            List<AggregateResult> lstCustomerAwardRecords = ([
                SELECT id, Account__r.Name, Account__c, FORMAT(SUM(Value__c)) TotalPremio
                FROM Contract2__c
                WHERE Value__c != NULL AND StartDate__c >= LAST_YEAR AND EndDate__c > Today AND Account__r.OwnerId IN :lstUserIds
                GROUP BY id, Account__r.Name, Account__c
                ORDER BY SUM(Value__c) DESC
                LIMIT 30
            ]);
            if(lstCustomerAwardRecords.size() > 0){
                homeInformations.customerAward = lstCustomerAwardRecords;
            }
        }
        /**
         * @description RETORNA AS INFORMAÇÕES PRA HOME DE CLIENTES
         */
        return homeInformations;
    }
    /**
     * @description Método de  chamada do cmp
     */
    @AuraEnabled
    public static homeObjInformation getVincendosRecordsSumarrized(){
        homeObjInformation homeInformations = new homeObjInformation();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';
        Integer it90 = 0;
        Integer it60 = 0;
        Integer it45 = 0;
        Integer it30 = 0;

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional')){
            List<Contract2__c> lstVincendoRecords = ([
                SELECT id, ExpirationDayNumber__c
                FROM Contract2__c
                WHERE ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' AND Account__r.OwnerId = :userId
            ]);
            if(lstVincendoRecords.size() > 0){
                for(Contract2__c lpContract : lstVincendoRecords){
                    if(lpContract.ExpirationDayNumber__c > 60){
                        it90 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 45){
                        it60 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 30){
                        it45 += 1;
                    }else{
                        it30 += 1;
                    }
                }
            }

            List<String> lstRecordsSumarrized = new List<String>(4);
            lstRecordsSumarrized[0] = String.valueOf(it90);
            lstRecordsSumarrized[1] = String.valueOf(it60);
            lstRecordsSumarrized[2] = String.valueOf(it45);
            lstRecordsSumarrized[3] = String.valueOf(it30);
            homeInformations.contractVincendosSumarizado = lstRecordsSumarrized;
            List<Contract2__c> lstContratosVincendos = ([
                SELECT id, BidNumber__c, Account__r.Name, ProductName__c, Format(EndDate__c)
                FROM Contract2__c
                WHERE ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' AND Account__r.OwnerId = :userId
                ORDER BY EndDate__c ASC
                LIMIT 6
            ]);
            if(lstContratosVincendos.size() > 0){
                homeInformations.contractVincendosLst = lstContratosVincendos;
            }
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

            List<Contract2__c> lstVincendoRecords = ([
                SELECT id, ExpirationDayNumber__c
                FROM Contract2__c
                WHERE ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' AND Account__r.OwnerId IN :lstUserIds
            ]);
            if(lstVincendoRecords.size() > 0){
                for(Contract2__c lpContract : lstVincendoRecords){
                    if(lpContract.ExpirationDayNumber__c > 60){
                        it90 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 45){
                        it60 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 30){
                        it45 += 1;
                    }else{
                        it30 += 1;
                    }
                }
            }

            List<String> lstRecordsSumarrized = new List<String>(4);
            lstRecordsSumarrized[0] = String.valueOf(it90);
            lstRecordsSumarrized[1] = String.valueOf(it60);
            lstRecordsSumarrized[2] = String.valueOf(it45);
            lstRecordsSumarrized[3] = String.valueOf(it30);
            homeInformations.contractVincendosSumarizado = lstRecordsSumarrized;
            List<Contract2__c> lstContratosVincendos = ([
                SELECT id, BidNumber__c, Account__r.Name, ProductName__c, Format(EndDate__c)
                FROM Contract2__c
                WHERE ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' AND Account__r.OwnerId IN :lstUserIds
                ORDER BY EndDate__c ASC
                LIMIT 6
            ]);
            if(lstContratosVincendos.size() > 0){
                homeInformations.contractVincendosLst = lstContratosVincendos;
            }
        }

        return homeInformations;
    }
    /**
     * @description Método de  chamada do cmp
     */
    @AuraEnabled
    public static homeObjInformation getCustomerPotentialConvertion(){
        homeObjInformation homeInformations = new homeObjInformation();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional')){
            List<AggregateResult> lstCustomerPotentialdRecords = ([
                SELECT AccountId, Account.Name, ProbabilityOfWinning__c, FORMAT(SUM(Amount)) TotalConversao
                FROM Opportunity
                WHERE OwnerId = :userId AND ProbabilityOfWinning__c != '' AND CloseDate >= Today
                GROUP BY AccountId, Account.Name, ProbabilityOfWinning__c
                ORDER BY SUM(Amount) DESC
                LIMIT 20
            ]);
            if(lstCustomerPotentialdRecords.size() > 0){
                homeInformations.customerPotentialConvertion = lstCustomerPotentialdRecords;
            }
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

            List<AggregateResult> lstCustomerPotentialdRecords = ([
                SELECT AccountId, Account.Name, ProbabilityOfWinning__c, FORMAT(SUM(Amount)) TotalConversao
                FROM Opportunity
                WHERE OwnerId IN :lstUserIds AND ProbabilityOfWinning__c != '' AND CloseDate >= Today
                GROUP BY AccountId, Account.Name, ProbabilityOfWinning__c
                ORDER BY SUM(Amount) DESC
                LIMIT 20
            ]);
            if(lstCustomerPotentialdRecords.size() > 0){
                homeInformations.customerPotentialConvertion = lstCustomerPotentialdRecords;
            }
        }
        /**
         * @description RETORNA AS INFORMAÇÕES PRA HOME DE CLIENTES
         */
        return homeInformations;
    }
    /**
     * @description Método de  chamada do cmp
     */
    @AuraEnabled
    public static homeObjInformation getCustomerAggregateView(){
        homeObjInformation homeInformations = new homeObjInformation();
        List<AggregateResult> lstContractActive = new List<AggregateResult>();
        List<AggregateResult> lstContractInactive = new List<AggregateResult>();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }

        Map<String, String> mapAtiva = new Map<String, String>();
        Map<String, String> mapTotal = new Map<String, String>();
        Integer itAtivos = 0;
        Integer itInativos = 0;
        Integer itTotal = 0;
        if(!strPrfName.contains('Gerente Regional')){
            lstContractActive = ([
                SELECT Account__c, Account__r.Name, Count(Id) TotalRec
                FROM Contract2__c
                WHERE EndDate__c >= Today AND Account__r.OwnerId = :userId AND Status__c = 'Ativo'
                GROUP BY Account__c, Account__r.Name
            ]);
            if(lstContractActive.size() > 0){
                itAtivos = lstContractActive.size();
                for(AggregateResult lpAtivas : lstContractActive){
                    mapAtiva.put(String.valueOf(lpAtivas.get('Account__c')), String.valueOf(lpAtivas.get('Name')));
                }
            }

            lstContractInactive = ([
                SELECT Count(Id), Account__c, Account__r.Name, Account__r.OwnerId
                FROM Contract2__c
                WHERE EndDate__c < Today AND EndDate__c = LAST_N_DAYS:365 AND Account__r.OwnerId = :userId
                GROUP BY Account__c, Account__r.Name, Account__r.OwnerId
            ]);
            if(lstContractInactive.size() > 0){
                for(AggregateResult lpInative : lstContractInactive){
                    if(mapAtiva.get(String.valueOf(lpInative.get('Name'))) == '' || mapAtiva.get(String.valueOf(lpInative.get('Name'))) == null){
                        itInativos++;
                    }
                }
            }

            mapTotal.put('Total', String.valueOf(itAtivos + itInativos));
            mapTotal.put('Ativos', String.valueOf(itAtivos));
            mapTotal.put('Inativos', String.valueOf(itInativos));
            List<String> lstAggregateView = new List<String>();
            lstAggregateView = mapTotal.values();

            homeInformations.customerAggregateView = lstAggregateView;
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

            lstContractActive = ([
                SELECT Account__c, Account__r.Name, Count(Id) TotalRec
                FROM Contract2__c
                WHERE EndDate__c >= Today AND Account__r.OwnerId IN :lstUserIds AND Status__c = 'Ativo'
                GROUP BY Account__c, Account__r.Name
            ]);
            if(lstContractActive.size() > 0){
                itAtivos = lstContractActive.size();
                for(AggregateResult lpAtivas : lstContractActive){
                    mapAtiva.put(String.valueOf(lpAtivas.get('Account__c')), String.valueOf(lpAtivas.get('Name')));
                }
            }

            lstContractInactive = ([
                SELECT Count(Id), Account__c, Account__r.Name
                FROM Contract2__c
                WHERE EndDate__c < Today AND EndDate__c = LAST_N_DAYS:365 AND Account__r.OwnerId IN :lstUserIds
                GROUP BY Account__c, Account__r.Name
            ]);
            if(lstContractInactive.size() > 0){
                for(AggregateResult lpInative : lstContractInactive){
                    if(mapAtiva.get(String.valueOf(lpInative.get('Name'))) == '' || mapAtiva.get(String.valueOf(lpInative.get('Name'))) == null){
                        itInativos++;
                    }
                }
            }

            mapTotal.put('Total', String.valueOf(itAtivos + itInativos));
            mapTotal.put('Ativos', String.valueOf(itAtivos));
            mapTotal.put('Inativos', String.valueOf(itInativos));
            List<String> lstAggregateView = new List<String>();
            lstAggregateView = mapTotal.values();

            homeInformations.customerAggregateView = lstAggregateView;
        }
        /**
         * @description RETORNA AS INFORMAÇÕES PRA HOME DE CLIENTES
         */
        return homeInformations;
    }
    /**
     * @description Método de  chamada do cmp
     */
    @AuraEnabled
    public static homeObjInformation getReporIds(){
        homeObjInformation homeInformations = new homeObjInformation();
        List<Report> lstReport = ([
            SELECT id, DeveloperName
            FROM Report
            WHERE FolderName = 'Corporate Cockpit' AND DeveloperName IN ('Cockpit_Contratos_Vincendos', 'Cockpit_Visao_Geral_da_Carteira')
        ]);
        if(lstReport.size() > 0){
            homeInformations.userReportIds = lstReport;
        }
        /**
         * @description RETORNA AS INFORMAÇÕES DOS REPORTS HOME DE CLIENTES
         */
        return homeInformations;
    }
}