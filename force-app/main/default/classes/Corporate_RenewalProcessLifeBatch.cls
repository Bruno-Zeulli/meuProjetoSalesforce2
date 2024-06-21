/**
 * @description       : Agenda quando deve ser executado a rotina que criar as oportunidades de renovação
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 09-19-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   29-12-2022     Marcelo Martins     Initial Version
 **/
public without sharing class Corporate_RenewalProcessLifeBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    public Integer executions = 0;

    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - Corporate_RenewalProcessLifeBatch ******');

        Date dt = System.today().addDays(90);
        Date dateNext90Days = Date.valueOf(String.valueOf(dt).removeEnd(' 00:00:00'));

        // System.debug('Date ' +dateNext90Days);
        String q = 'SELECT Id, AccountId, OpportunityId, OwnerId,  Opportunity.Pricebook2Id, Opportunity.CampaignId, Opportunity.InsuredAmount__c, Opportunity.RecordTypeId, '
                + 'EndDate, Status, Opportunity.Description, TotalAmount, Contract2__c '
                + 'FROM Order '
                + 'WHERE Id IN (SELECT OrderId FROM OrderItem WHERE Product2.Name LIKE \'Vida%\') AND EndDate =: dateNext90Days '
                + 'AND Status != \'Cancelled\' AND RecordType.DeveloperName LIKE \'%Corporate%\'';

        return Database.getQueryLocator(q);
    }

    /**
    * @description
    * @param bc
    * @param scope
    */
    public  void execute(Database.BatchableContext bC, List<sObject> scope){
        executions++;
        List<Order> lOrdersUpdate = new List<Order>();
        List<Opportunity> lOpportunitiesRenewal =  new List<Opportunity>();
        Set<Id> lOppInsertedId = new Set<Id>();
        List<OpportunityLineItem> lOppLineItems = new List<OpportunityLineItem>();
        List<Case> lCases = new List<Case>();
        String currentDate = System.today().format();
        List<Group> lQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Corporate_Beneficios_Renovacao_Vida'];
        Id recordTypeOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
                .get('CorporateBeneficios')
                .getRecordTypeId();
        Id recordTypeCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                .get('CorporateCelulaTecnica')
                .getRecordTypeId();

        Id pricebookTest = IDGenerator.generate(Pricebook2.getSObjectType());

        List<Pricebook2> lPriceBook = [SELECT Id FROM Pricebook2 WHERE Name = 'Benefícios' Limit 1];

        for(sObject sobj  : scope){
            Order objOrder = (Order) sobj;
            Opportunity objOpp = new Opportunity();
            objOpp.AccountId = objOrder.AccountId;
            objOpp.Description = objOrder.Opportunity.Description;
            objOpp.Pricebook2Id = !Test.isRunningTest() ? lPriceBook[0].Id : pricebookTest;
            objOpp.Amount = objOrder.TotalAmount;
            objOpp.RecordTypeId = recordTypeOpportunity;
            objOpp.CampaignId = objOrder.Opportunity.CampaignId;
            objOpp.Type = 'ReNew';
            objOpp.StageName = 'Aberto';
            objOpp.ParentOpportunity__c = objOrder.OpportunityId;
            // objOpp.OwnerId = objOrder.OwnerId;
            objOpp.Contract2Id__c = objOrder.Contract2__c;
            objOpp.ParentOpportunity__c = objOrder.OpportunityId;
            objOpp.Name = 'Renovação - Vida - ' + currentDate;
            objOpp.ProbabilityOfWinning__c = 'Baixo';
            objOpp.Probability = 10;
            objOpp.CloseDate = objOrder.EndDate;
            lOpportunitiesRenewal.add(objOpp);
            objOpp.ParentOrderId__c = objOrder.Id;
        }

        if(!lOpportunitiesRenewal.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srInsertOpp = Database.insert(lOpportunitiesRenewal, false);
                 for(Database.SaveResult sr : srInsertOpp){
                    if(sr.isSuccess()){
                        lOppInsertedId.add(sr.getId());
                    }
                }
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }

        if(!lOppInsertedId.isEmpty()){

            Id pricebookId;

            if(Test.isRunningTest()){
                pricebookId = pricebookTest;
            }else{
                pricebookId = lPriceBook[0].Id;
            }

            PricebookEntry pbEntry = [SELECT Id,Product2Id FROM PricebookEntry WHERE Pricebook2Id =: pricebookId AND IsActive = true AND Product2.Name = 'Vida'];

            for(Opportunity objOpp : [SELECT Id, AccountId,Account.IdentificationNumber__c,Contract2Id__c FROM Opportunity WHERE Id IN: lOppInsertedId]){

                OpportunityLineItem objOppLineItem = new OpportunityLineItem(
                    OpportunityId = objOpp.Id,
                    Product2Id = pbEntry.Product2Id,
                    PricebookEntryId = pbEntry.Id,
                    Quantity = 1,
                    UnitPrice = 1,
                    Type__c = 'ReNew'
                );

                Case objCase = new Case(
                    Subject = 'Renovação - Vida - ' + objOpp.Account.IdentificationNumber__c + ' - ' + currentDate,
                    Status = 'New',
                    AccountId = objOpp.AccountId,
                    Opportunity__c = objOpp.Id,
                    Contract2__c = objOpp.Contract2Id__c,
                    Priority = 'High',
                    Origin = 'Canal',
                    RecordTypeId = recordTypeCase,
                    OwnerId = lQueue[0].Id
                );

                lOppLineItems.add(objOppLineItem);
                lCases.add(objCase);
            }
        }

        Savepoint sp = Database.setSavepoint();
        if(!lOppLineItems.isEmpty()){
            try{
                Database.SaveResult[] srInsertOppLineItem = Database.insert(lOppLineItems, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }

        if(!lCases.isEmpty()){
            try{
                Database.SaveResult[] srInsertCase = Database.insert(lCases, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    /**
    * @description Finaliza o processamento em lote
    * @param bc
    */
    public void finish(Database.BatchableContext bc){
        System.debug('***** FINISHING PROCESS - Corporate_RenewalProcessLifeBatch ******');
        System.debug('Quantidade de execuções totais: ' + executions);
    }

}