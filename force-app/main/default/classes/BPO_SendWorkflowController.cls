/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 * 1.2   06-15-2021   Marcelo Martins                      Ajustes que permitem o componente ser usando para disparar baseado nos sinistros da Account e melhoras as informações do que é disparado para as filas
 **/

public with sharing class BPO_SendWorkflowController {
    /**
     *@description
     *@param recordId
     */
    @AuraEnabled
    public static String sendNotice(Id recordId){
        List<String> listCasePrestamista = new List<String>();
        List<String> listCaseHabitacional = new List<String>();
        List<String> listCaseNotSent = new List<String>();
        Integer totalPrestamista = 0;
        Integer totalHabitacional = 0;
        Integer totalNotSent = 0;
        String msg;

        List<Case> sinistros = [
            SELECT Id, RecordTypeId, Contract2__r.ProductFamily__c, ExternalReferenceId__c, CaseNumber
            FROM Case
            WHERE ParentId = :recordId OR AccountId = :recordId
            WITH SECURITY_ENFORCED
        ];

        for(Case c : sinistros){
            if(c.ExternalReferenceId__c == null){
                if(c.Contract2__r.ProductFamily__c == 'Habitacional'){
                    if(!Test.isRunningTest()){
                        System.enqueueJob(new BPO_SendHomeIncidentQueueable(c.Id, 0));
                    }
                    System.debug('Tentativa de sync habitacional, ID do sinistro: ' + c.Id);
                    listCaseHabitacional.add(c.CaseNumber);
                }else if(c.Contract2__r.ProductFamily__c == 'Prestamista'){
                    if(!Test.isRunningTest()){
                        System.enqueueJob(new BPO_SendIncidentNoticeQueueable(c.Id, 0));
                    }
                    System.debug('Tentativa de sync prestamista, ID do sinistro: ' + C.Id);
                    listCasePrestamista.add(c.CaseNumber);
                }
            }else{
                listCaseNotSent.add(c.CaseNumber);
            }
        }
        totalPrestamista = listCasePrestamista.size();
        totalHabitacional = listCaseHabitacional.size();
        totalNotSent = listCaseNotSent.size();
        msg =
            'Comunicados enviados para fila de processamento. Prestamista: ' +
            totalPrestamista +
            ' ' +
            listCasePrestamista +
            '. Habitacional: ' +
            totalHabitacional +
            ' ' +
            listCaseHabitacional +
            '\n' +
            ' | ' +
            ' Comunicados já criados e integrados ao MAC/Sipre: ' +
            totalNotSent +
            ' ' +
            listCaseNotSent;

        return msg;
    }

    /**
     *@description
     *@param recordId
     */
    @AuraEnabled
    public static Boolean updateNoticeToOpen(Id recordId){
        List<Case> listSinistro = new List<Case>();
        for(Case c : [SELECT Id, Status FROM Case WHERE Id = :recordId OR AccountId = :recordId WITH SECURITY_ENFORCED]){
            System.debug('statusC:' + c);
            if(c.Status == 'BPO - Não Tratado'){
                listSinistro.add(new Case(Id = c.Id, Status = 'BPO - Comunicado Aberto'));
                System.debug('statusC:' + c);
            }
        }
         try{
            if(Schema.sObjectType.Case.isUpdateable()){
                update listSinistro;
            }
        } catch (DmlException e){
            System.debug('Erro ao atualizar registro: ' + e.getMessage() + ' ' + e.getLineNumber());
            return false;
        }
        return true;
    }
}