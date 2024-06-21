public with sharing class CorporateUserPerformanceController {
    Date dtSystem;
    public CorporateUserPerformanceController(){
        dtSystem = Date.today();
    }

    /**
     * @description Classe interna que retorna as informações para a chamada do componente
     */
    public class performanceObjInformation {
        Date dtSystemC;
        /**
         * @description Método construtor
         */
        public performanceObjInformation(){
            dtSystemC = Date.today();
        }
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> userLeads;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> userOpportunities;

        @AuraEnabled
        public List<Report> userReportIdsRedirect;

        @AuraEnabled
        public List<AggregateResult> opportunitiesConversao;
        /**
         * @description Método de retorno de nformações de tela do cmp
         */
        @AuraEnabled
        public List<String> userMetarealizado;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<Report> userReportIds;
        /**
         * @description Método de retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> summaryzeProductsFamily;
        /**
         * @description Método de retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> projecaoTotalValue;
    }
    /**
     * @description Mé´todo que busca as informações do painel do usuário
     */
    @AuraEnabled
    public static performanceObjInformation getUserInformation(){
        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';

        map<String, String> mapMeta = new Map<String, String>();
        performanceObjInformation performanceObjRecords = new performanceObjInformation();

        List<AggregateResult> totalLeads = ([
            SELECT COUNT(id) TotalLeads, Status
            FROM Lead
            WHERE CreatedDate = THIS_QUARTER AND OwnerId = :userId
            GROUP BY Status
            ORDER BY COUNT(id) DESC
        ]);
        performanceObjRecords.userLeads = totalLeads;

        List<AggregateResult> totalOpps = ([
            SELECT COUNT(id) TotalOpps, StageName
            FROM Opportunity
            WHERE CloseDate = THIS_QUARTER AND OwnerId = :userId
            GROUP BY StageName
            ORDER BY COUNT(id)
        ]);
        performanceObjRecords.userOpportunities = totalOpps;

        List<AggregateResult> realizadoAtual = ([
            SELECT SUM(TotalAmount) TotalOrderActual, OwnerId
            FROM Order
            WHERE OwnerId = :userId AND Status = 'Confirmed' AND CreatedDate = THIS_QUARTER
            GROUP BY OwnerId
        ]);
        if(RealizadoAtual.size() > 0){
            for(AggregateResult metaAtual : realizadoAtual){
                String varactual = String.valueOf(metaAtual.get('TotalOrderActual'));
                mapMeta.put('Atual', '' + varactual);
            }
        }else{
            mapMeta.put('Atual', '0,00');
        }

        List<AggregateResult> realizadoAnterior = ([
            SELECT SUM(TotalAmount) TotalOrderAnterior, OwnerId
            FROM Order
            WHERE OwnerId = :userId AND Status = 'Confirmed' AND CreatedDate = LAST_QUARTER
            GROUP BY OwnerId
        ]);
        if(RealizadoAnterior.size() > 0){
            for(AggregateResult metaAnterior : realizadoAnterior){
                String varanterior = String.valueOf(metaAnterior.get('TotalOrderAnterior'));
                mapMeta.put('Anterior', '' + varanterior);
            }
        }else{
            mapMeta.put('Anterior', '0,00');
        }
        performanceObjRecords.userMetarealizado = mapMeta.values();

        List<AggregateResult> totalConversao = ([
            SELECT Count(id) TotalConversao, StageName
            FROM Opportunity
            WHERE OwnerId = :userId AND CloseDate = THIS_QUARTER AND StageName IN ('Fechado e ganho', 'Fechado e perdido')
            GROUP BY StageName
        ]);
        performanceObjRecords.opportunitiesConversao = totalConversao;

        List<AggregateResult> totalContractsProduct = ([
            SELECT SUM(CommissionValue__c) CommissionValue__c, COUNT(ORDERID) Expression, Product2.Family
            FROM OrderItem
            WHERE Order.OwnerId = :userId AND Order.Status != 'Cancelled' AND order.CreatedDate = THIS_QUARTER
            GROUP BY Product2.Family
            ORDER BY SUM(TotalPrice) DESC
        ]);
        performanceObjRecords.summaryzeProductsFamily = totalContractsProduct;

        List<AggregateResult> totalProjecao = ([
            SELECT SUM(Amount) TotalProjecao, ProbabilityOfWinning__c, CALENDAR_MONTH(CloseDate) StrMes
            FROM OPPORTUNITY
            WHERE OwnerId = :userId AND StageName = 'Fechado e ganho' AND CloseDate = THIS_QUARTER AND ProbabilityOfWinning__c != ''
            GROUP BY ProbabilityOfWinning__c, CALENDAR_MONTH(CloseDate)
        ]);
        performanceObjRecords.projecaoTotalValue = totalProjecao;

        /**
         * @description retorna o objeto da classe de dados
         */
        return performanceObjRecords;
    }

    @AuraEnabled
    public static performanceObjInformation getReporIds(){
        performanceObjInformation homeInformations = new performanceObjInformation();
        List<Report> lstReport = ([SELECT id, DeveloperName FROM Report WHERE FolderName = 'Corporate Cockpit']);
        if(lstReport.size() > 0){
            homeInformations.userReportIdsRedirect = lstReport;
        }
        System.debug('HOME INFO: ' + homeInformations);
        return homeInformations;
    }
}