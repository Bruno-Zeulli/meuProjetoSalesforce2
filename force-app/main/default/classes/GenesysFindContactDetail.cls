/**
 * @description       :
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 12-05-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class GenesysFindContactDetail {

    @InvocableMethod(label = 'FindContactDetail' description = 'Busca detalhe de contato do callLog')
    public static List<FlowOutputTO> findContactDetailInvocable(List<String> callLogList){
        List<FlowOutputTO> flowOutputTOList = new List<FlowOutputTO>();
        String callLogId = callLogList[0];

        try {
            Map<String,String> findContact = findContactDetail(callLogId);
            flowOutputTOList.add(new FlowOutputTO(findContact.get('RecordId')));
        } catch (Exception erro){
            System.debug('Erro ocorreu ao buscar contato: ' + erro);
        }

        return flowOutputTOList;
    }

    @AuraEnabled
    public static Map<String,String> findContactDetail(String callLog){
        Map<String,String> returnContactDetail = new Map<String,String>();
        ContactDetail__c detalheContato = new ContactDetail__c();
        Campaign campanha = new Campaign();

        if(String.isBlank(callLog)){
            returnContactDetail.put('blankInput', 'true');
            return returnContactDetail;
        }

        CallLog__c log = [SELECT Id, Address__c, Queue__c FROM CallLog__c WHERE Id =: callLog];
        String phone = String.valueOf(log.Address__c).substring(Math.max(0, String.valueOf(log.Address__c).length() - 11));
        if(phone.startsWith('5')){
            phone = phone.replaceFirst('5', '');
        }

        try {
            campanha = [SELECT Id, CampaignSource__c, Transbordo__c FROM Campaign WHERE CTIListName__c = :log.Queue__c];
        } catch(Exception e){
            System.debug('Campanha não encontrada: ' + e);
        }

        String campaignSource = campanha != null ? campanha.CampaignSource__c : '';
        Boolean isTransbordo = campanha != null ? campanha.Transbordo__c : false;

        try {
            detalheContato = [SELECT Id FROM ContactDetail__c
            WHERE (BestPhone__c LIKE :'%'+phone+'%' OR AssistantPhone__c LIKE :'%'+phone+'%' OR
            HomePhone__c LIKE :'%'+phone+'%' OR MobilePhone__c LIKE :'%'+phone+'%' OR OtherPhone__c LIKE :'%'+phone+'%')
            AND Source__c = :campaignSource
            LIMIT 1];
        } catch(Exception e){
            System.debug('Erro: ' + e);
        }

        System.debug('Contact detail ' + detalheContato);

        if (detalheContato.Id != null && !isTransbordo) {
            String idString = detalheContato.Id;
            String objectName = detalheContato.Id.getSobjectType().getDescribe().getName();
            returnContactDetail.put('RecordId', idString);
            returnContactDetail.put('ObjectApiName', objectName);
            returnContactDetail.put('find', 'true');
        } else {
            returnContactDetail.put('phone', phone);
            returnContactDetail.put('campaignSource', campanha.CampaignSource__c);
            returnContactDetail.put('campaignId', campanha.Id);
            returnContactDetail.put('find', 'false');
        }

        System.debug(returnContactDetail);
        return returnContactDetail;
    }

    public class FlowOutputTO{
        @InvocableVariable
        public String contactDetailId;

        public FlowOutputTO(String contactDetailId){
            this.contactDetailId = contactDetailId;
        }
    }
}