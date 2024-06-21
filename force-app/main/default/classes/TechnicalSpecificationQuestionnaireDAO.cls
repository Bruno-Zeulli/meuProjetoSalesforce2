public without sharing class TechnicalSpecificationQuestionnaireDAO {

    /**
    * @description busca todos os campos do objeto Technical_Specification_Questionnaire
    * @param whereCondition
    * @return
    */
    /*
    public static Map<Id, Technical_Specification_Questionnaire__c> getMapAllFieldsByWhereCondition(String whereCondition){

        return new Map<Id, Technical_Specification_Questionnaire__c>(
            getListAllFieldsByWhereCondition(whereCondition)
        );


        // Map<Id, Technical_Specification_Questionnaire__c> mapTechnicalSpecificationQuestionnaire = new Map<Id, Technical_Specification_Questionnaire__c>();
        // for(Technical_Specification_Questionnaire__c objTechnicalSpecificationQuestionnaire : getListAllFieldsByWhereCondition(whereCondition)){
        //     mapTechnicalSpecificationQuestionnaire.put(objTechnicalSpecificationQuestionnaire.Id, objTechnicalSpecificationQuestionnaire);

        //     return mapTechnicalSpecificationQuestionnaire;
		// }



	}
    */

    /**
    * @description busca todos os campos do objeto Technical_Specification_Questionnaire
    * @param whereCondition
    * @return
    */
    @SuppressWarnings('PMD.ApexSOQLInjection')
    public static List<Technical_Specification_Questionnaire__c> getListAllFieldsByWhereCondition(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Technical_Specification_Questionnaire__c').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length()-1) + ' FROM Technical_Specification_Questionnaire__c ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    /**
    * @description busca todos os campos do objeto Technical_Specification_Questionnaire
    * @param opportunityId
    * @return
    */

    public static List<Technical_Specification_Questionnaire__c> getTechnicalSpecificationQuestionnairesByOppId(String opportunityId){
        System.debug('Inside');
        return [SELECT
                    Id, Name, toLabel(Status__c), toLabel(Type__c), CreatedDate
                FROM
                    Technical_Specification_Questionnaire__c
                WHERE
                    OpportunityId__c =:opportunityId
                    LIMIT 1
            ];

    }


}