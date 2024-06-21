/**
 * @description       :
 * @author            : marcelomartins@wizsoluceos.com.br
 * @group             :
 * @last modified on  : 10-29-2022
 * @last modified by  : marcelomartins@wizsoluceos.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   10-29-2022   marcelomartins@wizsoluceos.com.br    Initial Version
 **/
public with sharing class PTN_RetentionCampaignLoadingBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{
    // variável que recebe a quantidade de execuções
    public Integer executions = 0;

    /**
     * @description Busca campaing members
     * @return all campaing member CONSORCIOS BV PARCEIROS
     * @param bC
     */
    public Database.QueryLocator start(Database.BatchableContext bC){
        System.debug('***** INITIALIZING PROCESS - PTN_RetentionCampaignLoadingBatch ******');

        Integer valueDay = Date.today().day();
        String productName;

        Date datainicio;
        Date datafinal;

        if(valueDay == 4 ){
            productName = 'Consórcio Auto';
        }else if(valueDay == 1 || valueDay == 2 ){
            productName = 'Consórcio Imobiliário';
        }else if(Test.isRunningTest()){
            productName = 'Consórcio Auto';
        }

        if(productName == 'Consórcio Auto')
        {
            datainicio = Date.newInstance(Date.today().year(), Date.today().month(), 16);
            datainicio = datainicio.addMonths(-2);

            datafinal = Date.newInstance(Date.today().year(), Date.today().month(), 15);
            datafinal = datafinal.addMonths(-1);
        }
        else
        {
            datainicio = Date.newInstance(Date.today().year(), Date.today().month(), 11);
            datainicio = datainicio.addMonths(-2);

            datafinal = Date.newInstance(Date.today().year(), Date.today().month(), 10);
            datafinal = datafinal.addMonths(-1);
        }

        String q =
        'SELECT Id, Account__c, Contact__c, Contact__r.FirstName,  Contact__r.LastName, StartDate__c, SalesAgency__c, ProductName__c ' +
        'FROM Contract2__c ' +
        'WHERE SalesBusinessUnity__c = \'PARCEIROS\' AND PaymentStatus__c != \'Inadimplente\' AND NumberOfInstallments__c = \'1\' AND RecordType.DeveloperName = \'Consortium\' AND StartDate__c >= :datainicio AND StartDate__c < :datafinal AND ProductName__c =:productName AND SalesAgency__c != null AND Status__c = \'Ativo\' AND Company__c = \'Caixa Consorcios S.A.\' ' +
        'Order by Contact__c, StartDate__c';

        return Database.getQueryLocator(q);
    }

    /**
     * @description executa o batch para atualizar o integration status
     * @param bC
     * @param scope
     */
    public void execute(Database.BatchableContext bC, List<sObject> scope){

        String ctiListName = 'PARCEIROS - Retencao CNP';
        String businessUnit = 'PARCEIROS';
        String statusSend = 'Enviado';
        String statusClosed = 'Closed';

        Id rtCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName()
                                                        .get('PartnerCampaign')
                                                        .getRecordTypeId();
        Id rtContactDetail = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName()
                                                                    .get('Parceiros')
                                                                    .getRecordTypeId();

        List<Contract2__c> lContract2 = (List<Contract2__c>) scope;
        List<CampaignMember> lUpdateCampaignMember = new List<CampaignMember>();
        List<CampaignMember> lInsertCampaignMember = new List<CampaignMember>();
        List<CampaignActivity__c> lInsertCampaignActivity = new List<CampaignActivity__c>();
        Set<Id> sContactId = new Set<Id>();
        Map<String, Decimal> mPriority = new Map<String, Decimal>();
        Map<Id, Id> mContactDetailsByContactId = new Map<Id, Id>();
        Map<Id, CampaignMember> mCampaignMemberByContactId = new Map<Id, CampaignMember>();
        Map<Id, Contract2__c> mContractByContactId =  new Map<Id, Contract2__c>();

        executions++;

        for(Contract2__c objContract : lContract2){
            sContactId.add(objContract.Contact__c);
            mContractByContactId.put(objContract.Contact__c, objContract);
        }

        for(ContactDetail__c objContactDetail : [  SELECT  Id, Contact__c
                                                    FROM    ContactDetail__c
                                                    WHERE   Contact__c IN: sContactId
                                                    AND     RecordTypeId =: rtContactDetail])
        {
            mContactDetailsByContactId.put(objContactDetail.Contact__c, objContactDetail.Id);
        }


        List<Campaign> lCampaignId = [ SELECT  Id
                                FROM    Campaign
                                WHERE   CTIListName__c =: ctiListName
                                AND     RecordTypeId =: rtCampaign];


        for(CampaignMember objCampaignMember : [   SELECT  Id, ContactId
                                                    FROM    CampaignMember
                                                    WHERE   ContactId IN: sContactId
                                                    AND     CampaignId =: lCampaignId[0].Id]
        ){
            mCampaignMemberByContactId.put(objCampaignMember.ContactId, objCampaignMember);
        }

        for(DialingStrategy__c objDialingStrategy : [  SELECT  Name, Priority__c
                                                        FROM    DialingStrategy__c
                                                        WHERE   CTIListName__c =: ctiListName
                                                        AND     BusinessUnit__c =: businessUnit]
        ){
            mPriority.put(objDialingStrategy.Name, objDialingStrategy.Priority__c);
        }

        for(Contract2__c objContract : mContractByContactId.values()){

            if(mCampaignMemberByContactId.containsKey(objContract.Contact__c)){

                lUpdateCampaignMember.add(
                    new CampaignMember(
                        Id = mCampaignMemberByContactId.get(objContract.Contact__c).Id,
                        Status = statusSend,
                        Priority__c = mPriority.containsKey(objContract.SalesAgency__c) ? mPriority.get(objContract.SalesAgency__c) : 5
                    )
                );

            }else if(mContactDetailsByContactId.containsKey(objContract.Contact__c)){

                lInsertCampaignMember.add(
                    new CampaignMember(
                        Status = statusSend,
                        CampaignId = lCampaignId[0].Id,
                        ContactId = objContract.Contact__c,
                        ContactDetail__c = mContactDetailsByContactId.get(objContract.Contact__c),
                        Priority__c = mPriority.containsKey(objContract.SalesAgency__c) ? mPriority.get(objContract.SalesAgency__c) : 5
                    )
                );
            }

            if(mContactDetailsByContactId.containsKey(objContract.Contact__c)){

                lInsertCampaignActivity.add(
                    new CampaignActivity__c(
                        AllocationDate__c = objContract.StartDate__c,
                        Campaign__c = lCampaignId[0].Id,
                        Contact__c = objContract.Contact__c,
                        ContactDetail__c = mContactDetailsByContactId.get(objContract.Contact__c),
                        Contrato__c = objContract.Id,
                        Status__c = statusClosed
                    )
                );
            }
        }

        if(!lUpdateCampaignMember.IsEmpty()){
            CampaignMemberBO.getInstance().lstUpdCampaignMember(lUpdateCampaignMember);
        }
        if(!lInsertCampaignMember.IsEmpty()){
            CampaignMemberBO.getInstance().lstInsertCampaignMember(lInsertCampaignMember);
        }
        if(!lInsertCampaignActivity.IsEmpty()){
            CampaignActivityBO.getInstance().lstInsertCampaignActivity(lInsertCampaignActivity);
        }
    }

    /**
     * @description log debug para informar finalizar a execução
     * @param bC
     */
    public void finish(Database.BatchableContext bC){
        System.debug('***** FINISHING PROCESS - RetentionCampaignLoadingBatch ******');
        System.debug('Quantidade de execuções totais: ' + executions);
    }
}