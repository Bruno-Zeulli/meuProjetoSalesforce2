/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-22-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0  11-22-2021  marcelomartins@wizsolucoes.com.br   Initial Version
 * 1.1  26-11-2021  marcelomartins@wizsolucoes.com.br   test erro recompilation
 **/
@SuppressWarnings('PMD.ApexSOQLInjection')
public with sharing class DocumentChecklistDAO {
    /**
    * @description declaração de variaveis */
    private static final DocumentChecklistDAO INSTANCE = new DocumentChecklistDAO();

    /**
    * @description constroi a instancia da classe DocumentChecklistDAO
    * @return instancia da classe DocumentChecklistDAO
    */
    public static DocumentChecklistDAO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca todos os campos do objeto DocumentChecklist
    * @param recorId
    * @return list DocumentChecklist
    */
    public List<DocumentChecklist__c> getDocumentsChecklistBySObject(String recordId){
        String objeto = String.valueOf(Id.valueOf(recordId).getsobjecttype());

        List<DocumentChecklist__c> docsChecklist = [
            SELECT  Id,
                    Name,
                    DocumentRequirement__c,
                    DocumentType__c,
                    DocumentType__r.Name,
                    ObjectRecordType__c,
                    ObjectTypeValue__c,
                    ComplementaryParameter__c,
                    ComplementaryParameterObject__c,
                    Object__c
            FROM    DocumentChecklist__c 
            WHERE   Object__c = :objeto
        ];

        return docsChecklist;

    } 
    
    /**
    * @description busca todos os campos do objeto DocumentChecklist
    * @param whereCondition
    * @return list DocumentChecklist
    */
    public List<DocumentChecklist__c> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('DocumentChecklist__c').getDescribe().fields.getMap();
        
        String query = 'SELECT ';
        
        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM DocumentChecklist__c ' + whereCondition;
        
        System.debug('@@@ getAllFields query: ' + query);
        
        return Database.query(query);
    } 
    
    /**
    * @description busca os campos do objeto DocumentChecklist passados como param no selecFields
    * @param whereCondition,selecFields 
    * @return list DocumentChecklist
    */
    public List<DocumentChecklist__c> getDocumentsChecklistByWhereCondition(String selecFields, String whereCondition){
        
        String query =  'SELECT ' + 
                        selecFields +
                        ' FROM DocumentChecklist__c ' +
                        whereCondition;
        
        return Database.query(query);
    }
}