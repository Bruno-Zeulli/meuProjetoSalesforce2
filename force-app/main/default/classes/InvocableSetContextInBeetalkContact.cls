global class InvocableSetContextInBeetalkContact {
    @InvocableMethod(label='Set Context Variable In Beetalk Contact' description='Set Context Variable In Beetalk Contact')
    global static List<ParamsResponse> setContextVariableInBeetalkContact(List<ParamsRequests> requests){
        List<ParamsResponse> responses = new List<ParamsResponse>();
        try{
            List<beetalk__Contact__c> beetalkContacts = new List<beetalk__Contact__c>();
            
            for(ParamsRequests req : requests){
                beetalk__Contact__c beetalkContact = req.beetalkContact;
                ParamsResponse response = new ParamsResponse();
                String variableName = req.variableName;
                String variableValue = req.variableValue;
                String actualContextVariables =  beetalkContact.ContextVariables__c;
                Map<String, String> contextVariablesMap = new Map<String, String>();
                
                if(!(String.isBlank(actualContextVariables))){
                    contextVariablesMap = (Map<String, String>) JSON.deserialize(actualContextVariables, Map<String, String>.class);
                }
                contextVariablesMap.put(variableName, variableValue);
                
                beetalkContact.ContextVariables__c = JSON.serialize(contextVariablesMap);
                
                beetalkContacts.add(beetalkContact);
                
                response.variableValue = variableValue;
                response.successfullySet = true;
                responses.add(response);
                
            }
        
            update beetalkContacts;
        }
        catch(Exception ex){
            insert new beetalk__Log__c(
                beetalk__Message__c = 'Beetalk | Erro ao atribuir variável de contexto no contato o beetalk',
                beetalk__Detail__c = ex.getMessage() + '\n\n StrackTrace \n' + ex.getStackTraceString()
                );          
        }
        return responses;
    }
    
    global class ParamsRequests{
        @InvocableVariable(label='Beetalk Contact' description='Beetalk Contact')
        global beetalk__Contact__c beetalkContact;
        
        @InvocableVariable(label='Variable Name' description='Variable Name')
        global String variableName;
        
        @InvocableVariable(label='Variable Value' description='Variable Value')
        global String variableValue;
    }
    global class ParamsResponse{
        @InvocableVariable(label='Successfully Set' description='Successfully Set')
        global boolean successfullySet;
        
        @InvocableVariable(label='Variable Value' description='Variable Value')
        global String variableValue;
    }
}