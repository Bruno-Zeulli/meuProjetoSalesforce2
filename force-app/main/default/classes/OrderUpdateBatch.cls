/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-20-2022
 * @last modified by  : viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2022   viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
public with sharing class OrderUpdateBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description busca os pedidos para atualização
     * @return query
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('<---------- INITIALIZING PROCESS ---------->');
        String query = 'SELECT Id, Status,(SELECT Id, Product2.Name FROM OrderItems) FROM Order WHERE SalesDepartment__c = \'CONSEG\' AND RecordType.DeveloperName = \'Conseg\' AND Status = \'ReadyToIssue\'' + (Test.isRunningTest()?' LIMIT 20':'');
        return Database.getQueryLocator(query);
    }

    /**
     * @description executa o batch para atualizar o status do pedido
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<Order> scope){
        /** @description upadate order */
        executions++;
        List<Order> lstOrderUpdate = new List<Order>();
        List<Order> lstOrder = (List<Order>) scope;
        for(Order objOrd : lstOrder){
        // Verifique se a Order tem pelo menos um OrderItem associado
        if (objOrd.OrderItems != null && !objOrd.OrderItems.isEmpty()) {
            objOrd.Status = 'PolicyIssued';
            lstOrderUpdate.add(objOrd);
            System.debug('dentro do for ' + objOrd.OrderItems);
        }
    }
        update lstOrderUpdate;
    }

    public void finish(Database.BatchableContext bC){
        System.debug('Quantidade de execuções totais: ' + executions);
        System.debug('<---------- FINISHING PROCESS ---------->');
    }
}