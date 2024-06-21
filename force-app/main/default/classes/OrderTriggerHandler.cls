/**
* @description       : Reponsável pelos acionamentos quando o objeto order é criado, alterado ou deletado
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-04-2021
* @last modified by  : Marcelo Martins
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD | Removendo métodos vazios |
**/
public with sharing class OrderTriggerHandler {
    /** @description declação de variáveis */
    private boolean isExecuting = false;
    public List<Order> oldRecordsList = null;
    public List<Order> newRecordsList = null;
    public Map<Id, Order> oldRecordsMap = null;
    public Map<Id, Order> newRecordsMap = null;

    public static final String ERROR_MSG_DELETE_ORDER_WITH_ENDORSEMENTS_CORPORATE = 'Esta apólice não pode ser excluída, pois, possui endosso(s) vinculado(s).';
    public static final String ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CORPORATE = 'Esta apólice não pode ser excluída, pois, já foi realizada a conciliação com os dados da seguradora.';
    public static final String ERROR_MSG_DELETE_ENDORSEMENTS_WITH_CONTRACT_CORPORATE = 'Este endosso não pode ser excluído, pois, já foi realizada a conciliação com os dados da seguradora.';
    public static final String ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CONSEG = 'Este pedido não pode ser excluído, pois, já foi realizada a conciliação com os dados da seguradora.';

    /**
     * @description Obtém os recordtypes de Apólice, Endosso e Contrato da Corporate.
     */
    static final Id RECORDTYPE_CORPORATE_APOLICE = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateApolice').getRecordTypeId();
    static final Id RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoMovimentaoPremio').getRecordTypeId();
    static final Id RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoNeutro').getRecordTypeId();
    static final Id RECORDTYPE_CONSEG = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();
    static final Id RECORDTYPE_WGARANTIA = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('WGarantia').getRecordTypeId();
    static final Id RECORDTYPE_SUBCONTRATOBENEFICIOS = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateBeneficiosSubcontrato').getRecordTypeId();
    static final Id RECORDTYPE_ENDOSSO_WGARANTIA = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Endosso_WGarantia').getRecordTypeId();
    static final Id RECORDTYPE_CORRETORA_EXTERNA = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Corretora_Externa').getRecordTypeId();

    /**
     * @description instancia a variável isExecuting
     * @param isExecuting
     */
    public OrderTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    /** @description aciona os métodos antes de inserir o registro */
    public void onBeforeInsert(){
        populateOriginalPONumber();
        createReferenceId();
        processarPoNumber();
        makePoNumber25Characters();
        populateOriginalPONumberWithoutBook();
        updateEndDateOnBeforeInsert();
    }
    /** @description aciona os métodos antes de atualizar o registros */
    public void onBeforeUpdate(){
        populateOriginalPONumber();
        //createReferenceId();
        processarPoNumber();
        makePoNumber25Characters();
        populateOriginalPONumberWithoutBook();
        updateEndDateOnBeforeUpdate();
    }
    /** @description aciona os métodos depois de inserir o registro */
    public void onAfterInsert(){
        insertPreContratoCorporate();
        updateParentOpportunityOnInsert();
        updateParentOrderOnAfterInsert();
    }
    /** @description aciona os métodos depois de atualizar o registro */
    public void onAfterUpdate(){
        updateParentOpportunityOnUpdate();
        //createPreContratoCorporate();
        updateParentOrderOnAfterUpdate();
    }
    /** @description aciona os métodos antes de remover o registro */
    public void onBeforeDelete(){
        checkOrderAndContractCorporate();
    }

    public void onAfterDelete(){
        updateParentOpportunityOnDelete();
    }

    /** @description Impede a exclusão de Apólice da Wiz Corporate que possua Endosso(s) ou Contrato vinculado(s); ou,
     * de Endosso da Wiz Corporate que possua Contrato vinculado.
     */
    @SuppressWarnings('PMD.CognitiveComplexity')
    public void checkOrderAndContractCorporate(){

        Set<Id> apolicesIds = new Set<Id>();

        for(Order ord : oldRecordsList){
            // Somente para Apólices do bulk...
            if(ord.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE){
                // Verifica se a Apólice possui Contrato vinculado. Havendo, impede a exclusão.
                if(ord.Contract2__c != null){
                    ord.AddError(ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CORPORATE);
                }

                // Obtém os números de Apólices da Corporate do bulk.
                apolicesIds.add(ord.Id);
                continue;
            }

            // Somente para Endossos do bulk...
            if(ord.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO ||
                ord.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                ord.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS){
                // Verifica se o Endosso possui Contrato vinculado. Havendo, impede a exclusão.
                if(ord.Contract2__c != null){
                    //ord.AddError(ERROR_MSG_DELETE_ENDORSEMENTS_WITH_CONTRACT_CORPORATE);
                }
            }

            if(ord.RecordTypeId == RECORDTYPE_CONSEG){
                if(ord.Contract2__c != null){
                    ord.AddError(ERROR_MSG_DELETE_ORDER_WITH_CONTRACT_CONSEG);
                }
            }
        }

        // Recupera os Endossos vinculados às Apólices do bulk.
        List<Order> endorsements = new List<Order>([SELECT Id, ParentId__c FROM Order WHERE ParentId__c = :apolicesIds
                                                    AND EndorsementNumber__c != NULL
                                                    AND (RecordTypeId = :RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO
                                                    OR RecordTypeId = :RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO
                                                    OR RecordTypeId = :RECORDTYPE_SUBCONTRATOBENEFICIOS)
                                                    ]);

        // Para cada Apólice do bulk, verifica se há Endosso vinculado e impede a exclusão da Apólice, em caso positivo.
        for(Order record : oldRecordsList){
            if(record.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE){
                for(Order endorsement : endorsements){
                    if(endorsement.ParentId__c == record.Id){
                        record.addError(ERROR_MSG_DELETE_ORDER_WITH_ENDORSEMENTS_CORPORATE);
                    }
                }
            }
        }
    }

    /**
     * @description Verifica se o registro order pertence à Corporate e chama a classe que valida o número da apolice corporte
     */
    public void processarPoNumber(){
        System.debug('<---------------------- START PROCESSAR PONUMBER CORPORATE ---------------------->');

        for(Order newOrder : newRecordsList){

            if(newOrder.PoNumber != null &&
                newOrder.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE ||
                newOrder.RecordTypeId == RECORDTYPE_WGARANTIA ||
                newOrder.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS ||
                newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                newOrder.RecordTypeId == RECORDTYPE_ENDOSSO_WGARANTIA ||
                newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO)
            {
                Corporate_OrderBO.processarPoNumber(newOrder);
            }
        }
        System.debug('<---------------------- FINISH PROCESSAR PONUMBER CORPORATE ---------------------->');
    }
    /**
     * @description
     */
	private void insertPreContratoCorporate(){
        System.debug('<---------------------- START CREATE CONTRACT CORPORATE ---------------------->');
        List<Order> newCorporateOrders = new List<Order>();

        for(Order newOrder : newRecordsList){
            if((newOrder.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE ||
                        newOrder.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS ||
                        newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                        newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO) &&
                        newOrder.PoNumber != null &&
                        newOrder.Contract2__c == null
                )
            {
                newCorporateOrders.add(newOrder);
            }
        }
        if(newCorporateOrders.size() > 0){

            Corporate_ContractBO.insertContratosCorporate(newCorporateOrders);
        }

        System.debug('<---------------------- FINISH CREATE CONTRACT CORPORATE ---------------------->');
	}

    /**
     * @description
     */
    private void createPreContratoCorporate(){
        System.debug('<---------------------- START CREATE CONTRACT CORPORATE ---------------------->');
        List<Order> newCorporateOrders = new List<Order>();
        Map<Id, Order> oldCorporateOrdersByContractId = new Map<Id, Order>();

        for(Order newOrder : newRecordsList){
            Contract2__c ctr = new Contract2__c();
            if(oldRecordsMap.containsKey(newOrder.Id) && newOrder.Contract2__c == null && newOrder.ReferenceId__c != null){
                ctr = shearchContract(newOrder.ReferenceId__c);

                            if(ctr != null){
                                oldCorporateOrdersByContractId.put(ctr.Id,newOrder);
                            }
            }
            if(oldRecordsMap.containsKey(newOrder.Id) && newOrder.Contract2__c != null){
                for(Order oldOrder : oldRecordsList){

                    if((newOrder.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE ||
                            newOrder.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS ||
                            newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                            newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO) &&
                            newOrder.PoNumber != null &&
                            newOrder.PoNumber != oldOrder.PoNumber && oldOrder.Contract2__c != null
                    ){
                        oldCorporateOrdersByContractId.put(oldOrder.Contract2__c,newOrder);
                    }
                }
            }
            else if((newOrder.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE ||
                        newOrder.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS ||
                        newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                        newOrder.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO) &&
                        newOrder.PoNumber != null &&
                        newOrder.Contract2__c == null &&
                        ctr == null)
            {
                newCorporateOrders.add(newOrder);
            }
        }
        if(newCorporateOrders.size() > 0){

            Corporate_ContractBO.insertContratosCorporate(newCorporateOrders);
        }
        if(oldCorporateOrdersByContractId.size() > 0){

            Corporate_ContractBO.updateContratosCorporate(oldCorporateOrdersByContractId);
        }

        System.debug('<---------------------- FINISH CREATE CONTRACT CORPORATE ---------------------->');
    }

    /**
     * @description Cria o PONumber com 25 caracteres
     */
    private void makePoNumber25Characters(){
        System.debug('<---------------------- START MAKE PONUMBER 25 CHARACTERS ---------------------->');

        List<Order> orders = new List<Order>();

        for(Order order : newRecordsList){
            String key;
            if(order.PoNumber != null &&
                order.RecordTypeId == RECORDTYPE_CORPORATE_APOLICE ||
                order.RecordTypeId == RECORDTYPE_SUBCONTRATOBENEFICIOS ||
                order.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO ||
                order.RecordTypeId == RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO ||
                order.RecordTypeId == RECORDTYPE_ENDOSSO_WGARANTIA ||
                order.RecordTypeId == RECORDTYPE_WGARANTIA)
            {
                key = order.PoNumber;

            }else if(order.PoNumber != null){
                key = order.PoNumber.leftPad(20, '0');
            }
            order.PoNumber = key;
        }
        System.debug('<---------------------- FINISH MAKE PONUMBER 25 CHARACTERS ---------------------->');
    }

	private void populateOriginalPONumber(){
        System.debug('<---------------------- START POPULATE ORIGINAL PONUMBER ---------------------->');

        for(Order newOrder : newRecordsList){

                      if(newOrder.PoNumber != null){
                            if(oldRecordsMap != null){
                                if(oldRecordsMap.containsKey(newOrder.Id)){
                                    Order oldOrder = oldRecordsMap.get(newOrder.Id);
                                    String newPoNumber = newOrder.PoNumber;
                                    if(newOrder.PoNumber != oldOrder.PoNumber &&
                                        ((oldOrder.OriginalPONumber__c != null &&
                                            newPoNumber.length() == oldOrder.OriginalPONumber__c.length()) ||
                                            oldOrder.OriginalPONumber__c == null)
                                    ){
                                        newOrder.OriginalPONumber__c = newOrder.PoNumber;
                                    }
                                }
                            }
                            else if(newOrder.OriginalPONumber__c == null){
                                newOrder.OriginalPONumber__c = newOrder.PoNumber;
                            }
                        }


        }
        System.debug('<---------------------- FINISH POPULATE ORIGINAL PONUMBER ---------------------->');
	}

    private void populateOriginalPONumberWithoutBook(){
        System.debug('<---------------------- START POPULATE ORIGINAL PONUMBER WITHOUT BOOK---------------------->');

        for(Order newOrder : newRecordsList){

                      if (!Corporate_OrderBO.verifyOrderInBook(newOrder)) {
                        newOrder.OriginalPONumber__c = newOrder.PoNumber;
                      }
        }
        System.debug('<---------------------- FINISH POPULATE ORIGINAL PONUMBER WITHOUT BOOK---------------------->');
	}

	private Contract2__c shearchContract(String orderName){
        if(!Schema.SObjectType.Contract2__c.isAccessible()){
            return null;
        }
        List<Contract2__c> contracts = [SELECT Id, Name FROM Contract2__c WHERE Name=:orderName LIMIT 1];
        if(contracts.size()>0){

            return contracts[0];
        }

		return null;
	}

    private void createReferenceId(){
        System.debug('<---------------------- START CREATE REFERENCE ID ---------------------->');
        String referenceId;
        Map<Id, Order> mapOrders = new Map<Id, Order>();
        for(Order ord : newRecordsList){
            // if(oldRecordsMap.get(ord.Id).OriginalPONumber__c != ord.OriginalPONumber__c){
                if(ord.Company__c != null && ord.OriginalPONumber__c != null && ord.EndorsementNumber__c == null){
                    referenceId = (ord.Company__c + ' | ' + ord.OriginalPONumber__c);
                }else if(ord.Company__c != null && ord.OriginalPONumber__c != null && ord.EndorsementNumber__c != null){
                    referenceId = (ord.Company__c + ' | ' + ord.OriginalPONumber__c + ' | ' + ord.EndorsementNumber__c);
                }
                ord.ReferenceId__C = referenceId;
            }
        System.debug('<---------------------- FINISH CREATE REFERENCE ID ---------------------->');
    }

    private void updateParentOpportunityOnInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            Map<Id,Opportunity> lstOpportunities = new Map<Id,Opportunity>();
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            List<Id> listRecordTypeIdsEndosso = getListRecordTypeIdsEndosso();
            Map<Id,Opportunity> oppsEndorsement = new Map<Id,Opportunity> ([SELECT Id FROM Opportunity WHERE Type = 'Endorsement' AND ParentOrderId__c IN (SELECT ParentId__c FROM Order WHERE Id IN :newRecordsList)]);
            for(Order newOrder: newRecordsList){
                if(newOrder.ParentId__c == null && newOrder.OpportunityId!=null && listRecordTypeIds.contains(newOrder.RecordTypeId)){
                    Opportunity oppToUpdate = new Opportunity(Id = newOrder.OpportunityId,
                                                            Latest_Order__c = newOrder.Id,
                                                            Latest_Order_Status__c = newOrder.Status,
                                                            Latest_Order_EndDate__c = newOrder.EndDate_Compiled__c);
                    lstOpportunities.put(newOrder.OpportunityId,oppToUpdate);
                }else if(newOrder.ParentId__c != null && oppsEndorsement.keySet().contains(newOrder.OpportunityId) && listRecordTypeIdsEndosso.contains(newOrder.RecordTypeId)){
                    Opportunity oppToUpdate = new Opportunity(Id = newOrder.OpportunityId,
                                                            Latest_Order__c = newOrder.Id,
                                                            Latest_Order_Status__c = newOrder.Status,
                                                            Latest_Order_EndDate__c = newOrder.EndDate_Compiled__c);
                    lstOpportunities.put(newOrder.OpportunityId,oppToUpdate);
                }
            }
            if(!lstOpportunities.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(lstOpportunities.values());
            }
        }
    }

    private void updateParentOpportunityOnDelete(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            Set<Id> oppIdsToFilter = new Set<Id>();
            for(Order order:oldRecordsList){
                if(listRecordTypeIds.contains(order.RecordTypeId) && order.OpportunityId!=null && order.ParentId__c == null){
                    oppIdsToFilter.add(order.OpportunityId);
                }
            }
            List<Opportunity> oppsToUpdate = [SELECT Id FROM Opportunity WHERE Id IN :oppIdsToFilter AND Latest_Order__c = NULL AND Latest_Order_Status__c != null];
            for(Opportunity opp : oppsToUpdate){
                opp.Latest_Order_Status__c = null;
                opp.Latest_Order_EndDate__c = null;
            }
            if(!oppsToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppsToUpdate);
            }
        }
    }

    private void updateParentOpportunityOnUpdate(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            Set<Id> orderIdsToFilter = new Set<Id>();
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();   
            for(Order newOrder: newRecordsList){
                if(newOrder.ParentId__c == null &&
                  newOrder.OpportunityId!=null && 
                  listRecordTypeIds.contains(newOrder.RecordTypeId) &&
                  (newOrder.Status != oldRecordsMap.get(newOrder.Id).Status ||
                   newOrder.EndDate_Compiled__c != oldRecordsMap.get(newOrder.Id).EndDate_Compiled__c))
                {
                    orderIdsToFilter.add(newOrder.Id);
                }
            }
            List<Opportunity> parentOpps = [SELECT Id, Latest_Order__c FROM Opportunity WHERE Latest_Order__c IN :orderIdsToFilter];
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            for(Opportunity opp:parentOpps){
                opp.Latest_Order_Status__c = newRecordsMap.get(opp.Latest_Order__c).Status;
                opp.Latest_Order_EndDate__c = newRecordsMap.get(opp.Latest_Order__c).EndDate_Compiled__c;
                oppListToUpdate.add(opp);
            }
            if(!oppListToUpdate.isEmpty()){
                OpportunityBO.getInstance().lstUpdOpportunities(oppListToUpdate);
            }
        }
    }

    private void updateEndDateOnBeforeInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            listRecordTypeIds.addAll(getListRecordTypeIdsEndosso());
            for(Order ord:newRecordsList){
                if(ord.EndDate!=null && listRecordTypeIds.contains(ord.RecordTypeId)){
                    ord.EndDate_Compiled__c = ord.EndDate;
                }
            }
        }
    }

    private void updateEndDateOnBeforeUpdate(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            listRecordTypeIds.addAll(getListRecordTypeIdsEndosso());
            for(Order ord:newRecordsList){
                if(ord.EndDate!=oldRecordsMap.get(ord.Id).EndDate && listRecordTypeIds.contains(ord.RecordTypeId)){
                    ord.EndDate_Compiled__c = ord.EndDate;
                }
            }
        }
    }
    
    private void updateParentOrderOnAfterInsert(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            listRecordTypeIds.addAll(getListRecordTypeIdsEndosso());
            Map<Id,Order> ordersToUpdate = new Map<Id,Order>();
            for(Order ord:newRecordsList){
                if(ord.ParentId__c != null && ord.Status != 'Cancelled' && ord.EndDate_Compiled__c != null && listRecordTypeIds.contains(ord.RecordTypeId)) {
                    ordersToUpdate.put(ord.ParentId__c,new Order(Id = ord.ParentId__c, EndDate_Compiled__c = ord.EndDate_Compiled__c));
                }
            }
            if(!ordersToUpdate.isEmpty()){
                update ordersToUpdate.values();
            }
        }
    }

    private void updateParentOrderOnAfterUpdate(){
        if(Opportunities_Automations_Portal__c.getInstance()?.Is_Active__c || Test.isRunningTest()){
            List<Id> listRecordTypeIds = getListRecordTypeIdsCorporate();
            listRecordTypeIds.addAll(getListRecordTypeIdsEndosso());
            List<Order> ordersToUpdate = new List<Order>();
            Set<Id> parentIdsChildChanged = new Set<Id>();
            
            for(Order ord:newRecordsList){
                if(ord.ParentId__c != null && (ord.Status != oldRecordsMap.get(ord.Id).Status || ord.EndDate_Compiled__c != oldRecordsMap.get(ord.Id).EndDate_Compiled__c) && listRecordTypeIds.contains(ord.RecordTypeId)){
                    parentIdsChildChanged.add(ord.ParentId__c);		
                }
            }
            if(!parentIdsChildChanged.isEmpty()){
                List<Order> parentAndLastChildOrder = [SELECT Id, EndDate, EndDate_Compiled__c, (SELECT Id, EndDate_Compiled__c FROM Pedidos__r WHERE Status != 'Cancelled' AND EndDate_Compiled__c!=null ORDER BY CreatedDate DESC LIMIT 1) FROM Order WHERE Id IN :parentIdsChildChanged];
                for(Order parentOrder:parentAndLastChildOrder){
                    if(!parentOrder.Pedidos__r.isEmpty() && parentOrder.EndDate_Compiled__c != parentOrder.Pedidos__r.get(0).EndDate_Compiled__c){
                        parentOrder.EndDate_Compiled__c = parentOrder.Pedidos__r.get(0).EndDate_Compiled__c;
                        ordersToUpdate.add(parentOrder);	
                    }else if(parentOrder.Pedidos__r.isEmpty() && parentOrder.EndDate_Compiled__c != parentOrder.EndDate){
                        parentOrder.EndDate_Compiled__c = parentOrder.EndDate;
                        ordersToUpdate.add(parentOrder);
                    }
                }
            }
            if(!ordersToUpdate.isEmpty()){
                update ordersToUpdate;
            }
        }
    }

    private List<Id> getListRecordTypeIdsCorporate(){
        List<Id> listToReturn = new List<Id>();
        listToReturn.add(RECORDTYPE_CORPORATE_APOLICE);
        listToReturn.add(RECORDTYPE_WGARANTIA);
        listToReturn.add(RECORDTYPE_SUBCONTRATOBENEFICIOS);
        listToReturn.add(RECORDTYPE_CORRETORA_EXTERNA);
        return listToReturn;
    }

     private List<Id> getListRecordTypeIdsEndosso(){
        List<Id> listToReturn = new List<Id>();
        listToReturn.add(RECORDTYPE_CORPORATE_ENDOSSO_NEUTRO);
        listToReturn.add(RECORDTYPE_CORPORATE_ENDOSSO_MOVIMENTACAO);
        listToReturn.add(RECORDTYPE_ENDOSSO_WGARANTIA);
        return listToReturn;
    }
}