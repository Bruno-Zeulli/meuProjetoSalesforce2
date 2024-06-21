public without sharing class OpportunityCorporateHelper {
    
    private static final String STATUS_EM_EMISSAO = 'Em Emissão';
    private static final String STATUS_CANCELADA = 'Cancelada';
    private static final String STATUS_EM_ANALISE = 'Em Análise';
    private static final String STATUS_VIGENTE = 'Vigente';
    private static final String STATUS_RENOVADA = 'Renovada';
    private static final String STATUS_EM_RENOVACAO_VIGENTE = 'Em Renovação - Vigente';
    private static final String STATUS_EM_RENOVACAO_EXPIRANDO = 'Em Renovação - A Expirar';
    private static final String STATUS_EM_RENOVACAO_VENCIDA = 'Em Renovação - Vencida';
    private static final String STATUS_VENCIDA = 'Vencida';
    private static final String STATUS_EXPIRANDO = 'A Expirar';
    private static final String STATUS_ENDOSSO_EMITIDO = 'Endosso Emitido';
    private static final String STATUS_ENDOSSO_EM_EMISSAO = 'Endosso Em Emissão';
    private static final Set<String> VIGENTES = new Set<String>{STATUS_VIGENTE,STATUS_EXPIRANDO,STATUS_EM_EMISSAO,STATUS_EM_RENOVACAO_VIGENTE,STATUS_EM_RENOVACAO_EXPIRANDO};

    public static void updateParentOpportunity(Map<Id,Opportunity> oppIdToOppMap){

        List<Opportunity> parentOpps = [SELECT Id, Latest_Child_Opportunity__c FROM Opportunity WHERE Latest_Child_Opportunity__c IN :oppIdToOppMap.keySet()];
        for(Opportunity opp:parentOpps){
            opp.Latest_Child_Opportunity_Status_Portal__c = oppIdToOppMap.get(opp.Latest_Child_Opportunity__c).Status_Portal__c;
        }
        if(!parentOpps.isEmpty()){
            OpportunityBO.getInstance().lstUpdOpportunities(parentOpps);
        }
    }

    public static String getStatusPortal(Opportunity opp){
        
        if(opp.StageName == 'Fechado e Perdido'){
            return 'Indefinido - Fechado e Perdido';
        }
        if(opp.Product_Name__c == null){
            return 'Indefinido - Sem Produto';
        }
        if(opp.Latest_Child_Opportunity__c != null && opp.Latest_Order__c == null){
            return 'Indefinido - Pai sem Order';
        }
        if(opp.Latest_Order__c!=null && opp.Type == 'Endorsement'){
            return STATUS_ENDOSSO_EMITIDO;
        }
        if(opp.Latest_Order__c!=null && opp.Latest_Order_EndDate__c == null){
            return 'Indefinido - Order sem EndDate';
        }
        if(opp.Latest_Child_Opportunity__c != null && opp.Latest_Child_Opportunity_Status_Portal__c == STATUS_EM_ANALISE && (opp.Product_Renewal_Start_Date__c > System.Today() || (opp.Product_Renewal_Start_Date__c == null && opp.Latest_Order_EndDate__c > System.Today().addDays(120)))){
            return STATUS_EM_RENOVACAO_VIGENTE;
        }
        if(opp.Latest_Child_Opportunity__c != null && opp.Latest_Child_Opportunity_Status_Portal__c == STATUS_EM_ANALISE && opp.Latest_Order_EndDate__c < System.Today()){
            return STATUS_EM_RENOVACAO_VENCIDA;
        }
        if(opp.Latest_Child_Opportunity__c != null && opp.Latest_Child_Opportunity_Status_Portal__c == STATUS_EM_ANALISE){
            return STATUS_EM_RENOVACAO_EXPIRANDO;
        }
        if(opp.Latest_Child_Opportunity__c != null && opp.Latest_Child_Opportunity_Status_Portal__c != STATUS_CANCELADA && opp.Latest_Child_Opportunity_Status_Portal__c != null && !opp.Latest_Child_Opportunity_Status_Portal__c.contains('Indefinido')){
            return STATUS_RENOVADA;
        }
        if(opp.Latest_Order__c==null && opp.Type == 'Endorsement' && (opp.StageName == 'Em Emissão' || opp.StageName =='Fechado e Ganho')){
            return STATUS_ENDOSSO_EM_EMISSAO;
        }
        if(opp.Latest_Order__c==null && (opp.StageName == 'Em Emissão' || opp.StageName =='Fechado e Ganho')){
            return STATUS_EM_EMISSAO;
        }
        if(opp.Latest_Order__c==null && opp.Portal_Visible__c == true){
            return STATUS_EM_ANALISE;
        }
        if(opp.Latest_Order__c!=null && opp.Latest_Order_Status__c == 'Cancelled'){
            return STATUS_CANCELADA;
        }
        if(opp.Latest_Order__c!=null && (opp.Product_Renewal_Start_Date__c > System.Today() || (opp.Product_Renewal_Start_Date__c == null && opp.Latest_Order_EndDate__c > System.Today().addDays(120)))){
            return STATUS_VIGENTE;
        }
        if(opp.Latest_Order__c!=null && opp.Latest_Order_EndDate__c < System.Today()){
            return STATUS_VENCIDA;
        }
        if(opp.Latest_Order__c!=null){
            return STATUS_EXPIRANDO;
        }
        return 'Indefinido';
    }

    public static void updateProductCount(Set<Id> accSetIds){
        List<String> lstRecordTypeId = new OpportunityTriggerHandler(true).getListRecordTypeIdsCorporate();
        
        AggregateResult[] groupedResults = [SELECT COUNT(Id), AccountId, Product_Name__c 
                                            FROM Opportunity 
                                            WHERE AccountId IN :accSetIds
                                            AND RecordTypeId IN :lstRecordTypeId
                                            AND Status_Portal__c IN :VIGENTES
                                            GROUP BY AccountId, Product_Name__c];
        Map<Id,Map<String,Integer>> accIdToProdCount = new Map<Id,Map<String,Integer>>();
        for(AggregateResult ar:groupedResults){
            Id accId = Id.valueOf(String.valueOf(ar.get('AccountId')));
            String prodName = String.valueOf(ar.get('Product_Name__c'));
            Integer countProd = Integer.valueOf(ar.get('expr0'));
            if(!accIdToProdCount.containsKey(accId)){
                accIdToProdCount.put(accId,new Map<String,Integer>());
            }
            accIdToProdCount.get(accId).put(prodName,countProd);		
        }    
        List<Account> accsToUpdate = new List<Account>();
        if(!accIdToProdCount.isEmpty()){
            for(Id accId:accIdToProdCount.keySet()){
                Account acc = new Account(Id=accId,Product_Count_JSON__c=JSON.serialize(accIdToProdCount.get(accId)));
                accsToUpdate.add(acc);
            }
        }
        if(!accsToUpdate.isEmpty()){
            update accsToUpdate;
        }    
    }
}