/**
 * @description       : Responsável por atualizar o status e vincular os contratos aos pedidos
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 06-07-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   06-07-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class AssociateContractToOrderBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    /**@description variaveis globais da classe */
    public Integer executions = 0;

    /**
    * @description Define a query e inicia o processamento em lote
    * @param bc
    * @return Database.getQueryLocator(q)
    */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - AssociateContractToOrderBatch ******');
        String q =
            'SELECT  Id, Status, ReferenceId__c, PoNumber, Company__c,OriginalPoNumber__c, EndorsementNumber__c ' +
            'FROM    Order ' +
            'WHERE   Status = \'CarriedOut\' and Contract2__c = null and PoNumber != null ';

        return Database.getQueryLocator(q);
    }
    /**
    * @description Regras de negocios que manipula os registro Order e Contract
    * @param bc
    * @param scope
    */
    public  void execute(Database.BatchableContext bC, List<sObject> scope){
        executions++;
        List<Order> lOrdersUpdate = new List<Order>();
        List<String> lReferenceOrd = new List<String>() ;
        List<Contract2__c> lContracts =  new List<Contract2__c>();
        Map<String, Order> mapOrder = new Map<String,Order>();
        for(sObject sobj  : scope){
            String ordReferenceIdByPoNumber;
            String ordReferenceIdByOriginalPoNumber;
            Order ord = (Order) sobj;
            lReferenceOrd.add(ord.PoNumber);
            if(ord.OriginalPoNumber__c != null){
                if(ord.EndorsementNumber__c == null || ord.EndorsementNumber__c == '-7' || ord.EndorsementNumber__c == '0'){
                    ordReferenceIdByOriginalPoNumber = ord.Company__c + ' | ' + ord.OriginalPoNumber__c;
                }else{
                    ordReferenceIdByOriginalPoNumber = ord.Company__c + ' | ' + ord.OriginalPoNumber__c + ' | ' + ord.EndorsementNumber__c;
                }
                mapOrder.put(ordReferenceIdByOriginalPoNumber, ord);
            }
            if(ord.PoNumber != null){
                if(ord.EndorsementNumber__c == null || ord.EndorsementNumber__c == '-7' || ord.EndorsementNumber__c == '0'){
                    ordReferenceIdByPoNumber = ord.Company__c + ' | ' + ord.PoNumber;
                }else{
                    ordReferenceIdByPoNumber = ord.Company__c + ' | ' + ord.PoNumber + ' | ' + ord.EndorsementNumber__c;
                }
                mapOrder.put(ordReferenceIdByPoNumber, ord);
            }
        }
        System.debug('Pedidos Mapeados: ' + mapOrder);

        lContracts = [
            SELECT  Id, BidNumber__c, BidStatus__c, Company__c, RecordTypeId, EndorsementNumber__c
            FROM    Contract2__c
            WHERE   BidNumber__c IN :lReferenceOrd
            WITH SECURITY_ENFORCED
        ];
        for(Contract2__c ctt : lContracts){
            String cttReferenceId;
            if(ctt.EndorsementNumber__c == null || ctt.EndorsementNumber__c == '-7' || ctt.EndorsementNumber__c == '0'){
                cttReferenceId = ctt.Company__c + ' | ' + ctt.BidNumber__c;
            }else{
                cttReferenceId = ctt.Company__c + ' | ' + ctt.BidNumber__c + ' | ' + ctt.EndorsementNumber__c;
            }
            if(mapOrder.ContainsKey(cttReferenceId)){
                Order ord = mapOrder.get(cttReferenceId);
                if(ctt.BidStatus__c == 'Emitida'){
                    lOrdersUpdate.add(new order (Id = ord.Id, Contract2__c = ctt.Id, Status = 'Confirmed'));
                }else if(ctt.BidStatus__c =='Cancelada' || ctt.BidStatus__c == 'Rejeitada'){
                    lOrdersUpdate.add(new order (Id = ord.Id, Contract2__c = ctt.Id, Status = 'Cancelled'));
                }else{
                    lOrdersUpdate.add(new order (Id = ord.Id, Contract2__c = ctt.Id));
                }
            }
        }
        System.debug('Pedidos Atualizados: ' + lOrdersUpdate);
         try{
            update lOrdersUpdate;
        } catch (Exception e){
            System.debug('Erro: ' + e.getMessage() + ' ' + e.getLineNumber());
            logEDisparaEmail(e.getMessage());
        }
    }
    /**
    * @description Finaliza o processamento em lote
    * @param bc
    */
    public void finish(Database.BatchableContext bc){
        System.debug('***** FINISHING PROCESS - AssociateContractToOrderBatch ******');
        System.debug('Quantidade de execuções totais: ' + executions);
        AssociatePricebookProductToContractBatch batch = new AssociatePricebookProductToContractBatch();
        Database.executeBatch(batch);
    }

    /**
    * @description Dispara o email com o log para o canal Notificações Salesforce da Equipe CRM
    * @param errorMsg Mensagem com o log de erro
    */
    private void logEDisparaEmail(String errorMsg){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

        message.toAddresses = new List<String>{'f03a793d.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms'}; // Assim que o teams finalizar o processo de criação dos emails precisa alterar para o grupo correto
        message.optOutPolicy = 'FILTER';
        message.subject = 'Erro ao atualizar e vincular contratos aos pedidos';
        message.plainTextBody =
        'Houve  ao atualizar e vincular contratos aos pedidos. Mensagem de erro: ' +
        errorMsg;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
        if(!Test.isRunningTest())
        {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if(results[0].success){
                System.debug('Email enviado com sucesso.');
            }else{
                System.debug('Erro ao enviar email: ' + results[0].errors[0].message);
            }
        }

    }

}