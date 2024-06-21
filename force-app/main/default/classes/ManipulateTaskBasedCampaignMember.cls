/**
 * @description       : Manipula o membro da campanha baseado nas tasks
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 04-04-2021
 * @last modified by  : samuelsirkis@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   04-03-2021     Marcelo Martins     Initial Version
 **/
public with sharing class ManipulateTaskBasedCampaignMember {
    /**
     * @description metodo para realizar o update do Campaign Member da Campanha CONSORCIO BV PARCEIROS
     * @param taskId obj da task
     */
    public static void removeCampaignMemberIntagrationStatus(Task taskId){
        System.debug('***** Inicio remover o Membro da Campanha PARCEIROS *****');

        /** @description declaração das variaveis **/
        Task task = new Task();
        CampaignMember campaignMemberUpdate = new CampaignMember();
        Id contactId = null;

        /** @description Realiza tentativa de update da Integrations Status **/
         try{
            if(!Schema.sObjectType.Task.isUpdateable()){
                System.debug('***** Task is not updateable *****');
            }
            // Seleciona task enviado pela Trigger
            task = [SELECT Id, Subcategory__c, WhoId, WhatId FROM Task WHERE Id = :taskId.Id];
            if(task != null){
                // Verifica se o contato pertence a campanha 'PARCEIROS - WELCOME'
                contactId = task.WhoId;
                campaignMemberUpdate = [
                    SELECT Id, CampaignId, ContactId, IntegrationStatus__c
                    FROM CampaignMember
                    WHERE ContactId = :contactId AND Campaign.Name = 'CONSORCIO BV PARCEIROS' AND IntegrationStatus__c != 'Retirado'
                    WITH SECURITY_ENFORCED
                ];
                // Realiza do update do CampaignMember
                if(campaignMemberUpdate != null && !Schema.sObjectType.CampaignMember.isUpdateable()){
                    // Make sure we can update the database before even trying
                    campaignMemberUpdate.IntegrationStatus__c = 'Retirado';
                    update campaignMemberUpdate;
                }
            }

            /**
             * @description Excepions caso haja algum erro
             * @return debug mensagem de erro
             **/
        } catch (Exception e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    /**
     * @description metodo que busca as tasks de agendamento de contato com mais de 2
     * dias a contar da data do agendamento, não concluidas ou não tratadas para
     * enviadas novamente para a fila do CTI.
     **/
    public static void getTaskSchedulingContact(){
        System.debug('***** Inicio buscas tarefas com agendamento não tratado *****');
        /**@description declaração das variáveis*/
        DateTime dateTwoDayAgo = System.today().addDays(-2);
        List<String> recordTypeIdList = new List<String>();
        List<Id> contactIdList = new List<Id>();
        if(!Schema.sObjectType.Task.isUpdateable()){
            System.debug('***** Task is not updateable *****');
        }
        /* Busca as tasks de agendamento não concluidas com mais de 2 dias */
        List<Task> tasksList = [
            SELECT WhoId
            FROM Task
            WHERE Disposition__r.Disposition__c = '1.2.18 Agendamento de retorno' AND Status != 'Completed' AND ContactSchedulingDate__c <= :dateTwoDayAgo
        ];

        /* Percore a lista de objetos task e atribui a uma lista do tipo Id do contato para buscar o detalhe de contato na query  */
        for(Task tk : tasksList){
            Id key = tk.WhoId;
            contactIdList.add(key);
        }

        /* Busca a informação do Id do record type do contact details e atribui a uma lista para ser buscado na query que trás o contact details  */
        recordTypeIdList.add(Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Multiseguradora').getRecordTypeId());
        if(!Schema.sObjectType.ContactDetail__c.isUpdateable()){
            System.debug('***** ContactDetail__c is not updateable *****');
        }
        /* Busca o contact detail baseado no id do contact e do recordtype listado */
        List<ContactDetail__c> lContactDetail = [SELECT Id FROM ContactDetail__c WHERE Contact__c IN :contactIdList AND RecordTypeId IN :recordTypeIdList];

        System.debug('ContactDetails encontrados: ' + lContactDetail);

        /* Chama o método responsável por buscar o membro de campanha e envia-lo ao CTI */
        sendToCTI(lContactDetail);
    }

    /**
     * @description método responsável por buscar o membro de campanha e envia-lo ao CTI
     * @param conDetailsIds recebe uma lista de Ids do objeto contactDetails
     */
    private static void sendToCTI(List<ContactDetail__c> lConDetailsIds){
        /**@description declaração das variáveis*/
        Set<Id> conDetailScheduling = new Set<Id>();

        /* Percore a lista de objetos contactDetail e atribui a uma lista do tipo Id para buscar o membro de campanha na query  */
        for(ContactDetail__c cd : lConDetailsIds){
            Id key = cd.Id;
            conDetailScheduling.add(key);
        }
        if(!Schema.sObjectType.CampaignMember.isUpdateable()){
            System.debug('***** ContactDetail__c is not updateable *****');
        }
        /* Busca o membro de campanha baseado no id do contact detail */
        List<CampaignMember> campaignMembersList = [
            SELECT
                Id,
                LeadOrContactId,
                ContactDetail__r.MobilePhone__c,
                ContactDetail__r.HomePhone__c,
                ContactDetail__r.OtherPhone__c,
                ContactDetail__r.BestPhone__c,
                ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                FirstName,
                LastName,
                Campaign.CTIListName__c,
                MobilePhone,
                Phone,
                Lead.IdentificationNumber__c,
                CampaignId,
                CreatedDate,
                Priority__c,
                Contrato__r.ContractNumber__c,
                Contrato__r.StartDate__c,
                Contrato__r.BidDate__c,
                ContactDetail__r.BestEmail__c
            FROM CampaignMember
            WHERE ContactDetail__c IN :conDetailScheduling AND IntegrationStatus__c = 'Enviado'
        ];

        System.debug('CM encontrados: ' + campaignMembersList);

        /* Chama o método responsável por montar a DTO que será enviada ao CTI */
        Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = getCampaignMembersByListMap(campaignMembersList);
        /* Chama estancia do enfileiramento que envia ao CTI */
        CTIIntegrationQueueable queueable = new CTIIntegrationQueueable(mapCampaignMembersByList, Trigger.OperationType);
        /* Chama e executa do enfileiramento que envia ao CTI */
        System.enqueueJob(queueable);
    }
    /**
     * @description método responsável por montar a DTO que será enviada ao CTI
     * @param lCampaignMembers recebe uma lista de objetos CampaignMembers
     * @return Retorna uma lista contendo o DTO a ser enviado ao CTI
     */
    private static Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> getCampaignMembersByListMap(List<CampaignMember> lCampaignMembers){
        /**@description declaração das variáveis*/
        Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>> mapCampaignMembersByList = new Map<String, List<CTIIntegrationQueueable.CTIIntegrationModel>>();
        /* Percore a lista de objetos CampaignMembers, monta o ctiModel (DTO) e atribui a uma lista para ser enviado ao CTI  */
        for(CampaignMember cm : lCampaignMembers){
            String key = cm.Campaign.CTIListName__c;
            CTIIntegrationQueueable.CTIIntegrationModel ctiModel;
            ctiModel = new CTIIntegrationQueueable.CTIIntegrationModel(
                cm.ContactDetail__r.MobilePhone__c,
                cm.ContactDetail__r.HomePhone__c,
                cm.ContactDetail__r.OtherPhone__c,
                cm.ContactDetail__r.BestPhone__c,
                cm.FirstName,
                cm.LastName,
                cm.ContactDetail__r.Contact__r.IndividualIdentificationNumber__c,
                cm.LeadOrContactId,
                cm.CreatedDate,
                cm.Priority__c,
                cm.Contrato__r.ContractNumber__c,
                cm.Contrato__r.StartDate__c,
                cm.Contrato__r.BidDate__c,
                cm.ContactDetail__r.BestEmail__c
            );
            if(key != null){
                if(!mapCampaignMembersByList.containsKey(key)){
                    mapCampaignMembersByList.put(key, new List<CTIIntegrationQueueable.CTIIntegrationModel>());
                }
                mapCampaignMembersByList.get(key).add(ctiModel);
            }
        }
        return mapCampaignMembersByList;
    }
}