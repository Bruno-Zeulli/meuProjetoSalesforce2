/**
 * @description       : Componente para picklist dependente em fluxo de tela
 * @author            : samuelsirkis@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 13-02-20201
 * @last modified by  : Samuel Sirkis
 * Modifications Log
 * Ver   Date           Author                          Modification
 * 1.0   26-02-20201    Samuel Sirkis                   Initial Version
 **/
public class DependentPicklistController {
    static DependentPicklistSettings__c settings = DependentPicklistSettings__c.getInstance(UserInfo.getUserId());
    private static string baseUrl = system.Url.getOrgDomainUrl().toExternalForm();

    //Wrapper class to return the recordtype object to component
    public class RecordTypeWrapper {
        @AuraEnabled
        public string name { get; set; }
        @AuraEnabled
        public string id { get; set; }
        @AuraEnabled
        public boolean isMaster { get; set; }
        @AuraEnabled
        public boolean incorrectApiName { get; set; }
    }

    /**
     * @description Getting the list of record types accessible to the logged in user
     * @return all Recordtypes list
     * @param objectApiName
     */
    @AuraEnabled
    public static List<RecordTypeWrapper> getRecordTypes(string objectApiName){
        list<RecordTypeWrapper> recordTypeList = new List<RecordTypeWrapper>();
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);

        if(objectType != null){
            for(RecordTypeInfo recordTypeInfo : objectType.getDescribe().getRecordTypeInfos()){
                if(recordTypeInfo.isAvailable() && !recordTypeInfo.isMaster()){
                    RecordTypeWrapper recordType = new RecordTypeWrapper();
                    recordType.name = recordTypeInfo.name;
                    recordType.id = recordTypeInfo.getRecordTypeId();
                    recordType.isMaster = recordTypeInfo.isMaster();
                    recordTypeList.add(recordType);
                }
            }
        }else{
            RecordTypeWrapper recordType = new RecordTypeWrapper();
            recordType.incorrectApiName = true;
            recordTypeList.add(recordType);
        }
        System.debug('recordTypeList => ' + recordTypeList);
        return recordTypeList;
    }

    /**
     * @description Making callout to the UI API to get the list of available picklist values based on the selected recordtype
     * @return Controlling picklist values and Dependente picklist values
     * @param objectApiName
     * @param recordTypeId
     * @param fieldApiName
     */
    @AuraEnabled
    public static Map<String, List<String>> getPicklistValues(string objectApiName, string recordTypeId, string fieldApiName){
        final String ENDPOINT_URL =
            'callout:' +
            settings.Named_Credential__c +
            '/services/data/v' +
            settings.Api_Version__c +
            '/ui-api/object-info/' +
            objectApiName +
            '/picklist-values/' +
            recordTypeId +
            '/' +
            fieldApiName;
        // Call the API in order to get the values
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        // Create the endpoint dynamically for your og
        // string baseUrl = system.Url.getOrgDomainUrl().toExternalForm();

        // Call the API in order to get the values

        request.setMethod('GET');
        request.setEndpoint(ENDPOINT_URL);
        // Since, we can not use the UserInfo.getSessionId() method here, I am using a Visualforce page in order
        // to extract the session id which we can use for making API calls
        // request.setHeader('Authorization', 'Bearer ' + GetSessionIdPage.getSessionIdFromVfPage());
        request.setHeader('Content-Type', 'application/json; charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        if(!Test.isRunningTest()){
            response = http.send(request);
        }else{
            response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(DependentPicklistControllerMock.responseJson);
            response.setStatusCode(200);
        }
        Map<String, String> result = new Map<String, String>();
        Map<String, List<String>> mapControllingWithDependentList = new Map<String, List<String>>();
        Map<Object, String> mapControllingValueWithIndex = new Map<Object, String>();
        Map<String, List<String>> mapPicklistValues = new Map<String, List<String>>();

        System.debug(' Response Body => ' + response.getBody());
         try{
            // Parse the response and build the dependent and controlling picklist values map
            if(response.getStatusCode() == 200){
                System.debug(' Response Body => ' + response.getBody());

                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                // Get all the controlling values from response
                if(root.containsKey('controllerValues')){
                    System.debug('### Root => ' + root.get('controllerValues'));
                    Map<String, Object> controllingValues = (Map<String, Object>) root.get('controllerValues');

                    // Map of all the controlling values with their index
                    for(String controllingValue : controllingValues.keySet()){
                        mapControllingValueWithIndex.put(controllingValues.get(controllingValue), controllingValue);
                    }
                }

                System.debug('mapControllingValueWithIndex => ' + JSON.serializePretty(mapControllingValueWithIndex));
                if(!root.containsKey('values')){
                    return mapControllingWithDependentList;
                }

                // Get all the dependent values from the response returned with the Validfor attribute
                // Each bit in the bitmap indicates whether this dependent picklist value is "valid for" a corresponding controlling field value
                // The value in the validFor member is a Base64-encoded bitmap.
                List<Object> pickilistValues = (List<Object>) root.get('values');
                for(Object pickilistValue : pickilistValues){
                    Map<String, Object> pickilistValueMap = (Map<String, Object>) pickilistValue;
                    result.put((String) pickilistValueMap.get('value'), (String) pickilistValueMap.get('label'));

                    for(Object validfor : (List<Object>) pickilistValueMap.get('validFor')){
                        //Map the dependent Values List with their Controlling Value
                        if(mapControllingValueWithIndex.containsKey(validfor)){
                            if(!mapControllingWithDependentList.containsKey(mapControllingValueWithIndex.get(validfor))){
                                mapControllingWithDependentList.put(mapControllingValueWithIndex.get(validfor), new List<String>());
                            }

                            mapControllingWithDependentList.get(mapControllingValueWithIndex.get(validfor)).add((String) pickilistValueMap.get('label'));
                        }
                    }
                }

                System.debug('mapControllingWithDependentList : ' + JSON.serializePretty(mapControllingWithDependentList));

                //Map all the controlling values
                for(String controllingFields : mapControllingValueWithIndex.Values()){
                    //Map controllingFields which has no dependent values associated to it
                    if(!mapPicklistValues.containsKey(controllingFields)){
                        mapPicklistValues.put(controllingFields, new List<String>());
                    }
                    //Map controllingFields which has dependent values associated to it
                    if(mapPicklistValues.containsKey(controllingFields) && mapControllingWithDependentList.containsKey(controllingFields)){
                        mapPicklistValues.get(controllingFields).addAll(mapControllingWithDependentList.get(controllingFields));
                    }
                }
            }else{
                System.debug('mapPicklistValues : ' + JSON.serializePretty(mapPicklistValues));
            }

            //Return the Map of Controlling fields with the List of Dependent fields on the basis of Record Types
            //System.debug('mapPicklistValues : ' + JSON.serializePretty(mapPicklistValues));

            return mapPicklistValues;
        } catch (Exception ex){
            if(!Test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }else{
                throw ex;
            }
        }
    }
}