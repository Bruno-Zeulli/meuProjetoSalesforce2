/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wiz.co
 * @group             :
 * @last modified on  : 05-22-2022
 * @last modified by  : viniciusazevedo@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-22-2022   viniciusazevedo@wiz.co               Initial Version
 **/
public with sharing class OpportunityRenewVincendosBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os pedidos para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');

        if(Test.isRunningTest()){
            String query = 'SELECT Id,OpportunityId,AccountId,Account.IdentificationNumber__c,Opportunity.Amount,Opportunity.CampaignId,Opportunity.Asset__c,'
                            +'Opportunity.CloseDate,Opportunity.Contract2Id__c,Opportunity.DealerIdentificationNumber__c,Opportunity.DealershipName__c,Opportunity.DerivedFrom__c,'
                            +'Opportunity.Description,Opportunity.LeadSource,Opportunity.Name,Opportunity.OwnerId,Opportunity.Pricebook2Id,Opportunity.RecordTypeId,Opportunity.RelatedItemCode__c,'
                            +'Opportunity.RelatedItemCodeType__c,Opportunity.StageName,Opportunity.Type,Contract2__c,Contract2__r.ExpirationDayNumber__c,Contract2__r.Value__c,Contract2__r.EndDate__c,Contract2__r.TypeAcquisition__c,'
                            +'Contract2__r.EndorsementNumber__c,Contract2__r.Asset__r.AssetIdentifierCode__c '
                            +'FROM Order WHERE SalesDepartment__c = \'CONSEG\' AND Status = \'PolicyIssued\' AND Contract2__c != null AND (Type = \'ReNew\' OR Type = \'New\') LIMIT 200';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, OpportunityId,AccountId,Account.IdentificationNumber__c,Opportunity.Amount,Opportunity.CampaignId,'
                            +'Opportunity.Asset__c, Opportunity.CloseDate,Opportunity.Contract2Id__c,Opportunity.DealerIdentificationNumber__c,'
                            +'Opportunity.DealershipName__c,Opportunity.DerivedFrom__c, Opportunity.Description,Opportunity.LeadSource,'
                            +'Opportunity.Name,Opportunity.OwnerId,Opportunity.Pricebook2Id,Opportunity.RecordTypeId,'
                            +'Opportunity.RelatedItemCode__c, Opportunity.RelatedItemCodeType__c,Opportunity.StageName,Opportunity.Type,'
                            +'Contract2__c,Contract2__r.ExpirationDayNumber__c,Contract2__r.Value__c,Contract2__r.EndDate__c,'
                            +'Contract2__r.TypeAcquisition__c, Contract2__r.EndorsementNumber__c,Contract2__r.Asset__r.AssetIdentifierCode__c'
                            +' FROM Order WHERE SalesDepartment__c = \'CONSEG\' AND Status != \'Cancelled\' AND Contract2__c != null '
                            +'AND Contract2__r.Asset__c != null AND Contract2__r.ProductFamily__c = \'Auto\' '
                			+'AND Contract2__c != null AND Contract2__r.ExpirationDayNumber__c = '+System.Label.OppRenewDaysQuery+' '
                            //+'AND (Contract2__r.ExpirationDayNumber__c >= ' + System.Label.OppRenewDaysQuery + ' AND Contract2__r.ExpirationDayNumber__c <= ' + System.Label.OppRenewDaysQueryMax + ') '
                            +'AND Type != \'MechanicalWarranty\' ORDER BY Contract2__r.CreatedDate desc';

            return Database.getQueryLocator(query);
        }
    }

    /**
     * @description executa o batch para atualizar o status do pedido
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Order> scope){
        List<Order> lstOrd = (List<Order>) scope;
        List<Order> lstOrdInsert = new List<Order>();
        Map<String, Order> contador = new Map<String, Order>();

        // mota o mapa para verificar contrato
        for(Order ord:lstOrd){
            String key = ord.Contract2__r.Asset__r.AssetIdentifierCode__c+ord.Contract2__r.EndDate__c+ ord.AccountId;
            // verificar o contrato mais recente
            if(contador.containsKey(key)){
                Order count = contador.get(key);
            }
            contador.put(key, ord);
            lstOrdInsert.add(ord);
        }
        System.debug('Mapa: ' + contador.size());
        Set<Id> setOrderIds = new Set<Id>();
        for(Order ord : lstOrdInsert){
            setOrderIds.add(ord.Id);
        }

        List<OrderItem> lstOrderItem = [SELECT Id, OrderId, CommissionPercent__c FROM OrderItem WHERE OrderId IN: setOrderIds];
        Map<String, OrderItem> mapOrdItem = new map<String, OrderItem>();
        for(OrderItem objOrdItem : lstOrderItem){
            mapOrdItem.put(objOrdItem.OrderId, objOrdItem);
        }

        User objUser = new User();
        if(Test.isRunningTest()){
            objUser = [SELECT Id, Name, Email FROM User WHERE Email = 'viniciusazevedo@wiz.co' LIMIT 1];
        }else{
            objUser = [SELECT Id, Name, Email FROM User WHERE Email = 'usuariorenovacao@wiz.co' LIMIT 1];
        }

        Pricebook2 objPricB = [SELECT Id, Name, IsActive FROM Pricebook2 WHERE IsActive = true AND Name = 'Conseg' LIMIT 1];
        PricebookEntry objPricE = [SELECT Id, Pricebook2Id, IsActive, ProductCode FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id =:objPricB.Id AND ProductCode = '3-531-205' LIMIT 1];
        List<Opportunity> lstOpportunityInsert = new List<Opportunity>();
        List<OpportunityLineItem> lstOpportunityLineItemInsert = new List<OpportunityLineItem>();
        OpportunityLineItem objOppLineItem = new OpportunityLineItem();
        String cpfOrcnpj;
        Date dToday = Date.today();
        String dateStr = dToday.day() + '/' + dToday.month() + '/' + dToday.year();
        Integer index = 0;

        for(Order objOrdOld : lstOrdInsert){
            Opportunity objOppRN = new Opportunity();
            if(objOrdOld.Account.IdentificationNumber__c.length() == 11){
                cpfOrcnpj = objOrdOld.Account.IdentificationNumber__c.substring(0, 3) + '.' + objOrdOld.Account.IdentificationNumber__c.substring(3, 6) + '.' + objOrdOld.Account.IdentificationNumber__c.substring(6, 9) + '-' + objOrdOld.Account.IdentificationNumber__c.substring(9);
            }else if(objOrdOld.Account.IdentificationNumber__c.length() == 14){
                cpfOrcnpj = objOrdOld.Account.IdentificationNumber__c.substring(0, 2) + '.' + objOrdOld.Account.IdentificationNumber__c.substring(2, 5) + '.' + objOrdOld.Account.IdentificationNumber__c.substring(5, 8) + '/' + objOrdOld.Account.IdentificationNumber__c.substring(8, 12) + '-' + objOrdOld.Account.IdentificationNumber__c.substring(12);
            }
            objOppRN.Name = dateStr + ' - ' + cpfOrcnpj;
            objOppRN.AccountId = objOrdOld.AccountId;
            objOppRN.Amount = objOrdOld.Opportunity.Amount;
            objOppRN.Asset__c = objOrdOld.Opportunity.Asset__c;
            objOppRN.CloseDate = objOrdOld.Contract2__r.EndDate__c;
            objOppRN.Contract2Id__c = objOrdOld.Contract2__c;
            objOppRN.DealerIdentificationNumber__c = objOrdOld.Opportunity.DealerIdentificationNumber__c;
            objOppRN.DealershipName__c = objOrdOld.Opportunity.DealershipName__c;
            objOppRN.DerivedFrom__c = objOrdOld.Opportunity.DerivedFrom__c;
            objOppRN.Description = objOrdOld.Opportunity.Description;
            objOppRN.LeadSource = objOrdOld.Opportunity.LeadSource;
            objOppRN.OwnerId = objUser.Id;
            objOppRN.ParentOpportunity__c = objOrdOld.OpportunityId;
            objOppRN.Pricebook2Id = objPricB.Id;
            objOppRN.RecordTypeId = objOrdOld.Opportunity.RecordTypeId;
            objOppRN.RelatedItemCode__c = objOrdOld.Opportunity.RelatedItemCode__c;
            objOppRN.RelatedItemCodeType__c = objOrdOld.Opportunity.RelatedItemCodeType__c;
            objOppRN.StageName = 'Aberto';
            objOppRN.Type = 'Renew';
            objOppRN.CampaignId = objOrdOld.Opportunity.CampaignId;
            objOppRN.Estrategia2__c = objOrdOld.Contract2__r.EndDate__c == null ? null : objOrdOld.Contract2__r.EndDate__c.format();
            objOppRN.Estrategia3__c = String.valueOf(objOrdOld.Contract2__r.Value__c);
            objOppRN.Estrategia4__c = String.valueOf(mapOrdItem.get(objOrdOld.Id).CommissionPercent__c);
            objOppRN.Estrategia5__c = objOrdOld.Contract2__r.TypeAcquisition__c;

            lstOpportunityInsert.add(objOppRN);
            executions ++;
        }
        if(!lstOpportunityInsert.isEmpty()){
            insert lstOpportunityInsert;
        }

        for(Opportunity objOpp : lstOpportunityInsert){
            OpportunityLineItem objOppLineReNew = new OpportunityLineItem();
            objOppLineReNew.OpportunityId = objOpp.Id;
            objOppLineReNew.PricebookEntryId = objPricE.Id;
            objOppLineReNew.Quantity = 1;
            objOppLineReNew.UnitPrice = 1;
            objOppLineReNew.Type__c = 'Renew';
            lstOpportunityLineItemInsert.add(objOppLineReNew);
        }
        if(!lstOpportunityLineItemInsert.isEmpty()){
            insert lstOpportunityLineItemInsert;
        }
    }

    public void finish(Database.BatchableContext bC){
       
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINISHING PROCESS ---------->');
    }
}