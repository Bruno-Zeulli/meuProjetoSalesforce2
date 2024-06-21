/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 07-24-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver	Date         Author                             	Modification
 * 1.0	11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc		Initial Version
 * 2.0	07-24-2022   marcelomartins@wizsolucoes.com.br		incluso novo metódo que realiza o enriquecimentos de leads do grupo Wiz, mas implemetado apenas para a WizCorporate.
 **/
	public without sharing class LeadTriggerHandler {
	private boolean isExecuting = false;
	public List<Lead> oldRecordsList = null;
	public List<Lead> newRecordsList = null;
	public Map<Id, Lead> oldRecordsMap = null;
	public Map<Id, Lead> newRecordsMap = null;
	public static final String MSG_ERROR_CREATING_LEAD_CORPORATE_WHEN_IS_CUSTOMER = 'Não é possível cadastrar um Lead Corporate, pois já existe conta cadastrada.';
	public static final Integer LIMIT_FOR_FUTURE_METHOD_REQUEST = 49;

	public LeadTriggerHandler(boolean isExecuting){
		this.isExecuting = isExecuting;
	}

	public void onBeforeInsert(){
		validateIfIsAlreadyCustomerCorporate();
	}

	public void onAfterInsert(){
		sendLeadToEnrichmentDataByDiretrix();
	}

	private void validateIfIsAlreadyCustomerCorporate(){
		Set<String> setIdentificationNumber = new Set<String>();
		List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');

		for(Lead objLeadNewRecord : newRecordsList){
			if(
				String.isNotEmpty(objLeadNewRecord.IdentificationNumber__c) &&
				lstRecordTypeId.contains(objLeadNewRecord.RecordTypeId)
			){
				setIdentificationNumber.add(objLeadNewRecord.IdentificationNumber__c);
			}
		}

		if(!setIdentificationNumber.isEmpty()){
			List<Account> lstAccounts = new List<Account>();
			if(Schema.sObjectType.Account.isAccessible()){
				lstAccounts = [
					SELECT 	IdentificationNumber__c
					FROM 	Account
					WHERE 	IdentificationNumber__c IN :setIdentificationNumber
				];
			}
			Set<String> setAccountIds = new Set<String>();
			for(Account objAccount : lstAccounts){
				setAccountIds.add(objAccount.IdentificationNumber__c);
			}
			for(Lead objLeadNewRecord : newRecordsList){
				if(setAccountIds.contains(objLeadNewRecord.IdentificationNumber__c)){
					objLeadNewRecord.addError(MSG_ERROR_CREATING_LEAD_CORPORATE_WHEN_IS_CUSTOMER);
				}
			}
		}
	}

	/**
    * @description Filtra e acionta os leads PJs que necessitam de enriquecimento via Diretrix.
    */
	private void sendLeadToEnrichmentDataByDiretrix(){
		Set<Id> setLeadId = new Set<Id>();
		List<Lead> lstLeads = new List<Lead>();
		List<String> lstRecordTypeId = getListRecordTypeIds('Corporate');
		String strIdentificationNumber = null;

		for(Lead objLeadNewRecord : newRecordsList){

			strIdentificationNumber = objLeadNewRecord.IdentificationNumber__c;

			if(
				strIdentificationNumber != null &&
				strIdentificationNumber.length() == 14 &&
				lstRecordTypeId.contains(objLeadNewRecord.RecordTypeId)
			){
				setLeadId.add(objLeadNewRecord.Id);
			}
		}

		if(!setLeadId.isEmpty() && setLeadId.size() < LIMIT_FOR_FUTURE_METHOD_REQUEST){
			LeadBO.updateLeadDataThroughDiretrix(setLeadId);
		}
	}

	// Recupera os tipos de registro de Lead por Unidade de Negócio.
	private List<String> getListRecordTypeIds(String businessUnit){
		List<String> lstRecordTypeId = new List<String>();

		switch on businessUnit {
			when 'Corporate' {
				lstRecordTypeId.add(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName()
					.get('CorporateCBIC')
					.getRecordTypeId());
				lstRecordTypeId.add(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName()
					.get('CorporateLicitacao')
					.getRecordTypeId());
				lstRecordTypeId.add(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName()
					.get('CorporateComercial')
					.getRecordTypeId());
			}
		}

		return lstRecordTypeId;
	}
}