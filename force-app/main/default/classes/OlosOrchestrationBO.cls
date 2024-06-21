/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-01-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-01-2021   Samuel SIrkis                        Initial Version
 **/
public class OlosOrchestrationBO implements Queueable, Database.AllowsCallouts {
    /**
     *   Singleton
     */
    private static final OlosOrchestrationBO INSTANCE = new OlosOrchestrationBO();

    public static OlosOrchestrationBO getInstance(){
        return INSTANCE;
    }

    /**
     *  @enum para representação dos status da fila
     */
    public enum EventStatus {
        CREATED,
        SUCCESS,
        ERROR
    }

    /**
     * Mapa de eventos e classe de execução
     */
    private static map<String, IOlosExecuteEvent> mapToExecute;
    static {
        mapToExecute = new Map<String, IOlosExecuteEvent>();
        mapToExecute.put(OlosEventNames.INSERT_CAMPAIGN_SF_TO_OLOS.name(), new CampaignIntegrationBO());
        mapToExecute.put(OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), new CampaignIntegrationBO());
        mapToExecute.put(OlosEventNames.UPDATE_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), new CampaignIntegrationBO());
        mapToExecute.put(OlosEventNames.DELETE_CAMPAIGN_MEMBER_SF_TO_OLOS.name(), new CampaignIntegrationBO());

        //mapToExecute.put( OlosEventNames.INSERT_USER_SF_TO_OLOS.name(), new UserIntegrationBO() );
        //mapToExecute.put( OlosEventNames.UPDATE_USER_SF_TO_OLOS.name(), new UserIntegrationBO() );
    }

    /**
     *   Cria fila de processamento
     *   @param eventName string com o nome do evento a ser processado
     *   @param payload string com os JSON do objeto a ser processado
     *   @param ignoredByTrigger boolean para avisar se a fila vai ser executada pela trigger ou outro processo
     */
    public OlosOrchestrationEvent__c createEvent(String eventName, String payLoad, Boolean ignoredByTrigger){
        System.debug('>>>>>>>>>>> createEvent sObjectEvent');
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c();
        event.EventName__c = eventName;
        event.Payload__c = payLoad;
        event.Status__c = EventStatus.CREATED.name();
        event.IgnoredByTrigger__c = ignoredByTrigger;

        insert event;

        System.debug(event);

        return event;
    }

    /**
     *  Monta objeto de fila fila de processamento
     *  @param recordId Id do registro de origem da fila
     *  @param eventName string com o nome do evento a ser processado
     *  @param payload string com os JSON do objeto a ser processado
     *  @param ignoredByTrigger boolean para avisar se a fila vai ser executada pela trigger ou outro processo
     */
    public OlosOrchestrationEvent__c sObjectEvent(String recordId, String eventName, String payLoad, Boolean ignoredByTrigger){
        System.debug('>>>>>>>>>>> sObjectEvent');
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c();
        event.RecordId__c = recordId;
        event.EventName__c = eventName;
        event.Payload__c = payLoad;
        event.Status__c = EventStatus.CREATED.name();
        event.IgnoredByTrigger__c = ignoredByTrigger;

        return event;
    }

    /**
     *  Monta objeto de fila fila de processamento
     *   @param eventId string com o id da fila para atualização
     *   @param dmlExceptionStackTrace string com possivel erro de processamento da fila
     */
    public OlosOrchestrationEvent__c sObjectUpdateEvent(String eventId, String dmlExceptionStackTrace){
        System.debug('>>>>>>>>>>> sObjectUpdateEvent');
        OlosOrchestrationEvent__c event = new OlosOrchestrationEvent__c();
        event.Id = eventId;
        event.Status__c = dmlExceptionStackTrace.equals('') ? EventStatus.SUCCESS.name() : EventStatus.ERROR.name();
        event.ExceptionStackTrace__c = dmlExceptionStackTrace;

        return event;
    }

    /**
     *   Atualiza fila de processamento
     *   @param eventId string com o id da fila para atualização
     *   @param response string com o id da fila para atualização
     *   @param dmlExceptionStackTrace string com possivel erro de processamento da fila
     */
    /**
     * comentado Humoatã, não identicado uso
    public void updateEvent( String eventId, String response, String dmlExceptionStackTrace ){
        OlosOrchestrationEvent__c event                  = new OlosOrchestrationEvent__c();
        event.Id                        = eventId;
        event.Status__c                 = dmlExceptionStackTrace.equals('') ? EventStatus.SUCCESS.name() : EventStatus.ERROR.name();
        event.Response__c               = response;
        event.ExceptionStackTrace__c    = dmlExceptionStackTrace;

        update event;
    }
	 */

    /**
     *   Metodo utilizado pra execução dos eventos em massa
     *   @param context
     */
    public void execute(QueueableContext context){
        System.debug('>>>>>>>>>>> execute');
        List<OlosOrchestrationEvent__c> eventList = [
            SELECT Id, RecordId__c, EventName__c, Payload__c, Status__c, IgnoredByTrigger__c
            FROM OlosOrchestrationEvent__c
            WHERE Status__c = 'CREATED'
            LIMIT 50
        ];

        if(eventList.size() > 0){
            executeEvent(eventList);
        }
    }

    /**
     *   Executa o processamento de eventos
     *   @param eventToProcessing Eventos para processamento
     */
    public void executeEvent(List<OlosOrchestrationEvent__c> eventToProcessing){
        System.debug('>>>>>>>>>>> executeEvent');
        Map<String, List<OlosOrchestrationEvent__c>> mapEvents = new Map<String, List<OlosOrchestrationEvent__c>>();
        for(OlosOrchestrationEvent__c event : eventToProcessing){
            if(mapEvents.containsKey(event.EventName__c)){
                mapEvents.get(event.EventName__c).add(event);
            }else{
                mapEvents.put(event.EventName__c, new List<OlosOrchestrationEvent__c>{ event });
            }
        }

        for(String mapKey : mapEvents.keySet()){
            mapToExecute.get(mapKey).executeEvent(mapEvents.get(mapKey));
        }

        if(!Test.isRunningTest()){
            System.enqueueJob(new OlosOrchestrationBO());
        }
    }
}