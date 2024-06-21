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
public with sharing class Contract2DAO {

    /**
    * @description declaração de variaveis */
    private static final Contract2DAO INSTANCE = new Contract2DAO();
    private static final Map<String, Object> MAP_OBJ_CONTRACT2 = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe Contract2DAO
    * @return instancia da classe Contract2DAO
    */
    public static Contract2DAO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca todos os campos do objeto Contract
    * @param whereCondition
    * @return mapa Object com key string
    */
    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Contract2__c objContract2 : getAllFields(whereCondition)){
            MAP_OBJ_CONTRACT2.put(objContract2.Id, objContract2);
		}
		return MAP_OBJ_CONTRACT2;
	}

    /**
    * @description busca todos os campos do objeto Contract
    * @param whereCondition
    * @return lista de Contract
    */
    public List<Contract2__c> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Contract2__c').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM Contract2__c ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }
}