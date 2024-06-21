public with sharing class CorporateCustomerDetailView {
    Date dtSystem;
    public CorporateCustomerDetailView(){
        dtSystem = Date.today();
    }
    /**
     * @description Classe interna que retorna as informações para a chamada do componente
     */
    public class customerObjInformation 
    {
        Date dtSystemC;
        /**
         * @description Método construtor
         */
        public customerObjInformation(){
            dtSystemC = Date.today();
        }
        /**
         * @description Método de retorno de nformações de tela do cmp
         */
        @AuraEnabled
        public List<String> contractVincendosSumarizado;
        /**
         * @description Método de retorno de nformações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> customerSummaryzeContracts;
        /**
         * @description Método de retorno de nformações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> customerSummaryzeContractsAVencer;
        /**
         * @description Método de retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> summaryzeCompanies;
        /**
         * @description Método de retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> summaryzeProducts;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<Report> userReportIds;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<String> customerAggregateView;
    }
    /**
     * @description Método de  chamada do cmp para recuperar os ids dos reports
     */
    @AuraEnabled
    public static customerObjInformation getReporIds(){
        customerObjInformation customerInformations = new customerObjInformation();
        List<Report> lstReport = ([ SELECT  id, DeveloperName 
                                    FROM    Report 
                                    WHERE   FolderName = 'Corporate Cockpit' 
                                    AND     DeveloperName IN('Cockpit_Renovacoes')]);
        if(lstReport.size() > 0){
            customerInformations.userReportIds = lstReport;
        }
        return customerInformations;
    }
    /**
     * @description Método de chamada do cmp para as informações dos vencimentos de contratos
     */
    @AuraEnabled
    public static customerObjInformation getVincendosRecordsSumarrized(String strCustomerId){
        customerObjInformation customerInformations = new customerObjInformation();
        
        String customerId = strCustomerId;

        Integer it90 = 0;
        Integer it60 = 0;
        Integer it45 = 0;
        Integer it30 = 0;

        List<Contract2__c> lstVincendoRecords = ([SELECT id, ExpirationDayNumber__c 
                                                FROM    Contract2__c 
                                                WHERE   ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' AND EndDate__c >= TODAY AND Account__c = : customerId]);
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
        
        List<String> lstRecordsSumarrized = new String[4];
        lstRecordsSumarrized[0] = String.valueOf(it90);
        lstRecordsSumarrized[1] = String.valueOf(it60);
        lstRecordsSumarrized[2] = String.valueOf(it45);
        lstRecordsSumarrized[3] = String.valueOf(it30);
        customerInformations.contractVincendosSumarizado = lstRecordsSumarrized;

       
        return customerInformations;
    }
    /**
     * @description Método de chamada do cmp para as informações do contrato/apólices
     */
    @AuraEnabled
    public static customerObjInformation getCustomerContracts(String strCustomerId){
        
        String customerId = strCustomerId;
        customerObjInformation customerObjRecords = new customerObjInformation();

        List<AggregateResult> TotalContracts = ([SELECT COUNT(id)TotalContract, Account__c FROM Contract2__c WHERE Status__c = 'Ativo' AND Account__c = : customerId AND EndDate__c > Today Group By Account__c]);
        customerObjRecords.customerSummaryzeContracts = TotalContracts;

        List<AggregateResult> TotalContractsAVencer = ([SELECT COUNT(id)TotalContract, Account__c FROM Contract2__c WHERE Status__c = 'Ativo' AND Account__c = : customerId AND EndDate__c >= Today AND EndDate__c <= NEXT_N_DAYS:7 GROUP BY Account__c]);
        customerObjRecords.customerSummaryzeContractsAVencer = TotalContractsAVencer;

        List<AggregateResult> TotalContractsCompanies = ([SELECT COUNT(Id)TotalCompany, Company__c  FROM Contract2__c WHERE Account__c = : customerId GROUP BY Company__c ORDER BY COUNT(Id) DESC LIMIT 5]);
        customerObjRecords.summaryzeCompanies = TotalContractsCompanies;

        List<AggregateResult> TotalContractsProduct = ([SELECT Count(Id)TotalProduct, ProductFamily__c  FROM Contract2__c WHERE Account__c = : customerId GROUP BY ProductFamily__c LIMIT 5]);
        customerObjRecords.summaryzeProducts = TotalContractsProduct;
        
       return customerObjRecords;
    }
}