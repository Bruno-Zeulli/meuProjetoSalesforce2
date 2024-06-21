global class InvocableIsInBusinessHours {
    @InvocableMethod(label='Verificar se está em horario comercial' description='Verifica se está em horario comercial')
    global static List<ParamsResponse> isInBusinessHour(List<ParamsRequests> requests){
        Set<String> businessHoursNames = new Set<String>();
        List<ParamsResponse> responses = new List<ParamsResponse>();
        Map<String, boolean> valueIsInBusinessHour = new Map<String, boolean>();
        
        for(ParamsRequests req : requests){
            businessHoursNames.add(req.businessHoursName);
        }
        for(BusinessHours bh : [SELECT Id, Name FROM BusinessHours WHERE Name IN :businessHoursNames]){
            boolean	inBusinessHourValue = BusinessHours.isWithin(bh.id, System.Now());
            valueIsInBusinessHour.put(bh.Name, inBusinessHourValue);
        }
        for(ParamsRequests req : requests){
            ParamsResponse response = new ParamsResponse();
            response.inBusinessHour = valueIsInBusinessHour.containsKey(req.businessHoursName)? valueIsInBusinessHour.get(req.businessHoursName) : false;
            responses.add(response);
        }
        
        return responses;
    }
    global class ParamsRequests {
        @InvocableVariable(label='business Hours Name' description='business Hours Name')
        global String businessHoursName;
    }
    global class ParamsResponse {
        @InvocableVariable(label='in Business Hour' description='in Business Hour')
        global boolean inBusinessHour;
    }
}