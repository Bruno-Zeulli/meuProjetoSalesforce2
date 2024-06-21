/**
 * @description       : Reponsável pelos acionamentos quando o objeto Contract2__c é criado, alterado ou deletado
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 15-03-2021
 * @last modified by  : Lucas Moro
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD | Removendo métodos vazios |
 */
public with sharing class ContractTriggerHandler {
    /** @description declaração de variáveis */
    private boolean isExecuting = false;
    public List<Contract2__c> oldRecordsList = null;
    public List<Contract2__c> newRecordsList = null;
    public Map<Id, Contract2__c> oldRecordsMap = null;
    public Map<Id, Contract2__c> newRecordsMap = null;

    static final Id RT_SEGURO_CORPORATE = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('SeguroCorporate').getRecordTypeId();
    static final Id RT_SEGURO_WGARANTIA = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('SeguroGarantia').getRecordTypeId();
    /**
     * @description instancia a variável isExecuting
     * @param isExecuting
     */
    public ContractTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }
    /**
     * @description aciona os métodos antes de inserir o registro
     */
    public void onBeforeInsert(){
        makeBidNumber20Characters();
        createReferenceId();
        processarContractNumber();
    }

    public void onBeforeUpdate(){
        //makeBidNumber20Characters();
        //createReferenceId();
        //processarContractNumber();
    }

    public void onAfterInsert(){
        // callAssociateContractToOrderFlow();
    }

    public void onAfterUpdate(){
        // callAssociateContractToOrderFlow();
    }

    /**
     * @description Verifica se o registro Contract2__c pertence à Corporate e chama a classe que valida o número da apolice corporte
     */
    public void processarContractNumber(){
        for(Contract2__c ctr : newRecordsList){
            if(ctr.RecordTypeId == RT_SEGURO_CORPORATE){
                Corporate_ContractBO.processarContractNumber(ctr);
            }
        }
    }
    /**
     * @description Verifica se o registro Contract2__c pertence à Corporate e chama a classe que valida o número da apolice corporte
     */
    public void callAssociateContractToOrderFlow(){
        Map<String, Object> params = new Map<String, Object>();

        for(Contract2__c ctr : newRecordsList){
            if(ctr.RecordTypeId == RT_SEGURO_CORPORATE){

                params.put('ContractID', ctr.Id);
                Flow.Interview.AssociateContractToOrder flow = new Flow.Interview.AssociateContractToOrder(params);
                flow.start();
            }
        }
    }

	private void createReferenceId(){
        System.debug('<---------------------- START CREATE REFERENCE ID ---------------------->');

        String referenceId;
        Map<Id, Contract2__c> mapContracts = new Map<Id, Contract2__c>();

        for(Contract2__c ctr : newRecordsList)
        {
            if(ctr.Company__c != null && ctr.BidNumber__c != null &&
                ctr.EndorsementNumber__c == null &&
                ctr.ProductFamily__c != null
            ){
                referenceId = (ctr.Company__c + ' | ' + ctr.ProductFamily__c + ' | ' + ctr.BidNumber__c);
            }
            else if(ctr.Company__c != null &&
                    ctr.BidNumber__c != null &&
                    ctr.EndorsementNumber__c != null &&
                    ctr.ProductFamily__c != null
                    ){
                referenceId = (ctr.Company__c + ' | ' + ctr.ProductFamily__c + ' | ' + ctr.BidNumber__c + ' | ' + ctr.EndorsementNumber__c);
            }
            ctr.ExternalReferenceId__c = referenceId;
        }


        System.debug('<---------------------- FINISH CREATE REFERENCE ID ---------------------->');
	}
    /**
     * @description Cria o PONumber com 25 caracteres
     */
    private void makeBidNumber20Characters(){
        System.debug('<---------------------- START MAKE PONUMBER 20 CHARACTERS ---------------------->');

        List<Contract2__c> contracts = new List<Contract2__c>();

        for(Contract2__c crt : newRecordsList){
            String key;
            if(crt.BidNumber__c != null && (
                crt.RecordTypeId == RT_SEGURO_WGARANTIA ||
                crt.RecordTypeId == RT_SEGURO_CORPORATE)
                )
            {
                key = crt.BidNumber__c;

            }else if(crt.BidNumber__c != null){
                key = crt.BidNumber__c;

                if(crt.BidNumber__c.length() < 20){
                    key = crt.BidNumber__c.leftPad(20, '0');
                    // System.debug('Contrato 20 caracteres => ' +key);
                }
                // key = crt.BidNumber__c;
            }
            crt.BidNumber__c = key;
        }
        System.debug('<---------------------- FINISH MAKE PONUMBER 20 CHARACTERS ---------------------->');
    }
}