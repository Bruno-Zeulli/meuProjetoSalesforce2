global class InvocableGetContextInBeetalkContact {
    @InvocableMethod(label='Get Context Variable In Beetalk Contact' description='Get Context Variable In Beetalk Contact')
    global static List<ParamsResponse> getContextVariableInBeetalkContact(List<ParamsRequests> requests){
        List<ParamsResponse> responses = new List<ParamsResponse>();
        try{
            for(ParamsRequests req : requests){
                beetalk__Contact__c beetalkContact = req.beetalkContact;
                String variableName = req.variableName;
                String actualContextVariables = beetalkContact.ContextVariables__c;
                ParamsResponse response = new ParamsResponse();

                if(!(String.isBlank(actualContextVariables))){
                    Map<String, String> contextVariablesMap = new Map<String, String>();
                    try{
                        contextVariablesMap = (Map<String, String>) JSON.deserialize(actualContextVariables, Map<String, String>.class);
                        response.variableValue = contextVariablesMap.get(variableName);
                        response.findVariable = true;
                    }
                    catch(Exception ex){
                        response.findVariable = false;
                    }
                }else{
                    response.findVariable = false;
                }
                
                responses.add(response);
            }
        }
        catch(Exception ex){
            insert new beetalk__Log__c(
                beetalk__Message__c = 'Beetalk | Erro ao obter variável de contexto no contato o beetalk',
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
    }
    global class ParamsResponse{
        @InvocableVariable(label='Variable Value' description='Variable Value')
        global String variableValue;

        @InvocableVariable(label='Find Variable?' description='Find Variable?')
        global boolean findVariable;
    }
}