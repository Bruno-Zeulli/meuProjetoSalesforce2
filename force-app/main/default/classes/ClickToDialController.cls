/**
 * @description       :
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 20-09-2023
 * @last modified by  : samuelsirkis@.wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-09-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public without sharing class ClickToDialController {

    private static String verificarTipo(String recordId){
      String objectType = null;

        // Verifique se o ID é válido
        if(recordId != null){
            // Obtenha o prefixo do ID
            String idPrefix = String.valueOf(recordId).substring(0, 3);

            // Consulte o Schema para obter o nome do objeto associado ao prefixo do ID
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for (Schema.SObjectType sObjectType : gd.values()){
                Schema.DescribeSObjectResult objDescribe = sObjectType.getDescribe();
                String prefix = objDescribe.getKeyPrefix();

                if(prefix != null && prefix.equals(idPrefix)){
                    objectType = objDescribe.getName();
                    break;
                }
            }
        }

        System.debug('SObject ' + objectType);
        return objectType;
    }

    @AuraEnabled(cacheable=true)
	public static List<ClickToDialControllerTO.ContactToDial> getSObjectInfos(String recordId){
        String tipoDeRegistro = verificarTipo(recordId);
        List<String>  query = new List<String>();
        List<String> listFields = new List<String>();
        List<ClickToDialControllerTO.ContactToDial> dataList = new List<ClickToDialControllerTO.ContactToDial>();
        ClickToDialControllerTO.ContactToDial data = new ClickToDialControllerTO.ContactToDial();
        data.objectid = recordId;
        data.sobjectname = tipoDeRegistro;

        // Se for opp ou Caso pegar o contato relacionado
        if(tipoDeRegistro == 'Case'){
            try{
                Case caso = [SELECT Id, ContactDetail__c FROM Case WHERE Id = :recordId];

                return getSObjectInfos(caso.ContactDetail__c);
            }catch(Exception e){
                System.debug('Erro: ' + e);
            }
        }else if(tipoDeRegistro == 'Opportunity'){
            try{
                Opportunity opp = [SELECT Id, ContactDetail__c FROM Opportunity WHERE Id = :recordId];

                return getSObjectInfos(opp.ContactDetail__c);
            }catch(Exception e){
                System.debug('Erro: ' + e);
            }
        }

        // Construa a lista de campos de telefone com base no objeto e nos campos disponíveis
        List<String> phoneFields = getPhonefields(data.sobjectname);

        // Construa a string SOQL dinamicamente com base nos campos de telefone
        String soqlQuery = 'SELECT Name, ';
        for(String field : phoneFields){
            soqlQuery += field + ', ';
        }
        soqlQuery += 'Id FROM ' + data.sobjectname + ' WHERE Id = :recordId LIMIT 1';
        try {
            // Execute a consulta SOQL
            SObject record = Database.query(soqlQuery);
            System.debug(record);
            data.name = (String)record.get('Name');
            // Preencha os campos de telefone no objeto de contato com os valores obtidos
            for (String field : phoneFields){
                data = setPhoneField(data, field, (String)record.get(field));
            }
            dataList.add(data); // Adicione o objeto data à lista
        } catch (Exception e){
            System.debug('Erro ao consultar os campos de telefone: ' + e.getMessage());
        }
        System.debug('data ' + data);
        return dataList;
    }

     private static List<String>  getPhonefields(String sobjectname){
        List<String> listFields = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sobjectname).getDescribe().fields.getMap();

        for(String fieldName : fieldMap.keySet()){
            if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.Phone){
                listFields.add(fieldName);

            }
        }
        System.debug('fields' + listFields);
        return listFields;
    }

    private static ClickToDialControllerTO.ContactToDial setPhoneField(ClickToDialControllerTO.ContactToDial data, String fieldName, String phoneValue){
        // Preencha o campo de telefone correspondente no objeto de contato
        if(fieldName == 'mobilephone__c'){
            data.mobilephone = phoneValue;
        }else if(fieldName == 'homephone__c'){
            data.homephone = phoneValue;
        }else if(fieldName == 'otherphone__c'){
            data.otherphone = phoneValue;
        }else if(fieldName == 'assistantphone__c'){
            data.assistantphone = phoneValue;
        }else if(fieldName == 'bestphone__c'){
            data.bestphone = phoneValue;
        }else if(fieldName == 'phone'){
            data.homephone = phoneValue;
        }else if(fieldName == 'mobilephone'){
            data.mobilephone = phoneValue;
        }else if(fieldName == 'homephone'){
            data.homephone = phoneValue;
        }else if(fieldName == 'otherphone'){
            data.otherphone = phoneValue;
        }else if(fieldName == 'assistantphone'){
            data.assistantphone = phoneValue;
        }else if(fieldName == 'personmobilephone'){
            data.mobilephone = phoneValue;
        }else if(fieldName == 'personotherphone'){
            data.otherphone = phoneValue;
        }else if(fieldName == 'personassistantphone'){
            data.assistantphone = phoneValue;
        }else if(fieldName == 'personotherphone'){
            data.bestphone = phoneValue;
        }else if(fieldName == 'personotherphone'){
            data.bestphone = phoneValue;
        }
        System.debug(data);
        return data;
    }

}