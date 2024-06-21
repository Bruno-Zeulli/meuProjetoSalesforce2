/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class OrderDAO {
    /**
    * @description declaração de variaveis */
    private static final OrderDAO INSTANCE = new OrderDAO();
    private static final Map<String, Object> MAP_OBJ_ORDER = new Map<String, Object>();

    /**
    * @description constroi a instancia da classe OrderDAO
    * @return instancia da classe OrderDAO
    */
    public static OrderDAO getInstance(){
        return INSTANCE;
    }
    /**
    * @description busca todos os campos do objeto Order
    * @param whereCondition
    * @return mapa Object com key string
    */
    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){

        for(Order objOrder : getAllFields(whereCondition)){
            MAP_OBJ_ORDER.put(objOrder.Id, objOrder);
		}
		return MAP_OBJ_ORDER;
	}

    /**
    * @description busca todos os campos do objeto Order
    * @param whereCondition
    * @return list Order
    */
    @SuppressWarnings('PMD.ApexSOQLInjection')
    public List<Order> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Order').getDescribe().fields.getMap();
        
        String query = 'SELECT ';
        
        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }
        
        query = query.substring(0, query.length()-1) + ' FROM Order ' + whereCondition;
        
        System.debug('@@@ getAllFields query: ' + query);
        
        return Database.query(query);
    }
}