/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class Corporate_SendOpportunityWFlowController {

    // @AuraEnabled
    // public static Boolean sendOpportunity(String recordId){
    //     Boolean sentToWflow;
    //     if(!DocumentChecklistBO.getInstance().checkPendingMandatoryDocuments(recordId)){
    //         sentToWflow = true;
    //         sendToWFlowService(OpportunityDAO.getInstance().getAllFieldsById(recordId));
    //     }else{
    //         sentToWflow = false;
    //     }
    //     return sentToWflow;
    // }

    @AuraEnabled
    public static String sendOpportunity(String recordId){
        String sentToWflow;
        List<OpportunityLineItem> oppLineItens = [SELECT Id,Product2.Name,Product2.Family FROM OpportunityLineItem WHERE OpportunityId =: recordId];

        for(OpportunityLineItem oli : oppLineItens){
            string productName = oli.Product2.Name;
            string productFamily = oli.Product2.Family;
            if(!DocumentChecklistBO.getInstance().checkPendingMandatoryDocuments(recordId)){
                if(productName.contains('D&O')){
                    sentToWflow = 'Deo';
                    // return sentToWflow;
                }
                if(productName.contains('Sgpe') || productName.contains('Sgto') || productFamily.contains('CAVA')){
                    sentToWflow = 'Mcmv';
                    // return sentToWflow;
                }
                sentToWflow = 'Send';
                sendToWFlowService(OpportunityDAO.getInstance().getAllFieldsById(recordId));
            }else{
                sentToWflow = 'Error';
            }
        }
        return sentToWflow;
    }

    private static void sendToWFlowService(List<Opportunity> lstOpportunity){
        List<Opportunity> lstOpportunityToWflow = new List<Opportunity>();

        for(Opportunity objOpportunity : lstOpportunity){

            if(objOpportunity.Type == 'Endorsement' && objOpportunity.ExternalReferenceId__c == null){

                Corporate_WFlowService.postOpportunityEndorsement(JSON.serialize(objOpportunity));

            }else if((objOpportunity.Type == 'New' || objOpportunity.Type == 'ReNew'|| objOpportunity.Type == 'CrossSell') &&
                       objOpportunity.ExternalReferenceId__c == null
                    ){
                Corporate_WFlowService.postOpportunitySales(JSON.serialize(objOpportunity));
            }
            else if(objOpportunity.ExternalReferenceId__c != null){
                lstOpportunityToWflow.add(objOpportunity);
            }
        }

        if(lstOpportunityToWflow.size() < 50){
            Corporate_WFlowService.updateOpportunityInWFlow(JSON.serialize(lstOpportunityToWflow));
        }
    }
}