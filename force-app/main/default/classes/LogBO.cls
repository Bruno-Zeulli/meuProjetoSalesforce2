public class LogBO {
    private static final LogBO INSTANCE = new LogBO();
    public static LogBO getInstance(){
        return INSTANCE;
    }

    public void insertErrorOfEvents(List<EventosSalesforce__e> events, String error){
        List<LogIntegracao__c> listLogsError = new List<LogIntegracao__c>();

        for(EventosSalesforce__e event : events){
            LogIntegracao__c logIntegracao = new LogIntegracao__c();
            logIntegracao.Body__c = event.Body__c;
            logIntegracao.Status__c = 'Erro';
            logIntegracao.Error__c = error;

            listLogsError.add(logIntegracao);
        }

        insert listLogsError;
    }


    public void insertErrorOfContactDetailsEvents(List<ContactDetail__c> contactsDetails, String error){
        List<LogIntegracao__c> listLogsError = new List<LogIntegracao__c>();

        for(ContactDetail__c contactDetail : contactsDetails){
            LogIntegracao__c logIntegracao = new LogIntegracao__c();
            logIntegracao.Body__c = JSON.serialize(contactDetail);
            logIntegracao.Status__c = 'Erro';
            logIntegracao.Error__c = error;

            listLogsError.add(logIntegracao);
        }

        insert listLogsError;
    }


     public void insertLogBodyAgricuturalConvert(List<EventoTO.BodyAgro> eventsBodyAgricutural){
        List<LogIntegracao__c> listLogsBodyDeserialize = new List<LogIntegracao__c>();

        for(EventoTO.BodyAgro eventAgricutural : eventsBodyAgricutural){
            LogIntegracao__c logIntegracao = new LogIntegracao__c();
            logIntegracao.Body__c = JSON.serialize(eventAgricutural);
            logIntegracao.Status__c = 'Sucesso';
            //logIntegracao.Error__c = error;

            listLogsBodyDeserialize.add(logIntegracao);
        }

        insert listLogsBodyDeserialize;
    }

    public void insertLogBodyAgricuturalError(List<EventoTO.BodyAgro> eventsBodyAgricutural, String error){
        List<LogIntegracao__c> listLogsBodyDeserialize = new List<LogIntegracao__c>();

        for(EventoTO.BodyAgro eventAgricutural : eventsBodyAgricutural){
            LogIntegracao__c logIntegracao = new LogIntegracao__c();
            logIntegracao.Body__c = JSON.serialize(eventAgricutural);
            logIntegracao.Status__c = 'Erro';
            logIntegracao.Error__c = error;

            listLogsBodyDeserialize.add(logIntegracao);
        }

        insert listLogsBodyDeserialize;
    }
}