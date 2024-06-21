/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-22-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-22-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class AccountDAO {
    /**
    * @description declaração de variaveis */
    private static final AccountDAO INSTANCE = new AccountDAO();
    private static final Map<String, Object> MAP_OBJ_ACCOUNT = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe AccountDAO
    * @return instancia da classe AccountDAO
    */
    public static AccountDAO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca todos os campos do objeto Account
    * @param whereCondition
    * @return mapa Object com key id do tipo string
    */
    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Account objAccount : getAllFields(whereCondition)){
            MAP_OBJ_ACCOUNT.put(objAccount.Id, objAccount);
		}
		return MAP_OBJ_ACCOUNT;
	}

    /**
    * @description busca todos os campos do objeto Account
    * @param whereCondition
    * @return Lista de Account
    */
    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Account> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Account').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM Account ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    public static List<Account> getAccountByOpportunityId(Id opportunityId){
        return [SELECT
        Id,
            (SELECT Id,Birthdate,Position__c,TeamYouCheerFor__c,MobilePhone,Email,Name
                    FROM
                    Contacts WHERE Type__c = ''),
            (SELECT Id,Name,MobilePhone__c,Email__c,Contact__c FROM ContactDetails__pr)
        FROM
        Account
        WHERE Id IN (SELECT AccountId FROM Opportunity Where Id =: opportunityId) LIMIT 1];
    }
}