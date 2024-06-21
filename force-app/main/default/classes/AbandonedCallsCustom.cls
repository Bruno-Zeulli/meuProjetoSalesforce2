/* 
Deletar callLogs de um certo dia:
delete [SELECT Id FROM CallLog__c WHERE CreatedDate > 2024-01-08T00:00:00.000+0000];

Rodar o GET manualmente. Deve ser configurado o custom label com o dia
AbandonedCallsCustom.insertAbandonedCalls();

Codigo para limpar os referenceIds duplicados:
List<CallLog__c> myList = [SELECT Id, ReferenceId__c FROM CallLog__c];
Map<String, CallLog__c> myMap = new Map<String, CallLog__c>();
List<Id> callLogsToDelete = new List<Id>();
for(CallLog__c call : myList)
{
    if(myMap.get(call.ReferenceId__c) != null)
    {
        callLogsToDelete.add(call.Id);
    }else{
        myMap.put(call.ReferenceId__c, call);
    }
    
}

System.debug(callLogsToDelete.size());
//delete [SELECT id FROM CallLog__c WHERE Id IN:callLogsToDelete];
*/
public class AbandonedCallsCustom {
    
    public static Integer MIN_MILLISECONDS_DIFF = 5000;
    public static Integer totalHitsGlobal = 0;
    public static Integer pageNumberGlobal = 1;

    @future(callout=true)
    public static void insertAbandonedCalls(){
        System.debug('@insertAbandonedCalls');
        List<CallLog__c> abandonedCallsToInsert = new List<CallLog__c>();
        CallLogs batch = new CallLogs();
        
        do{
            System.debug('FIM? ' + batch.hasNotFinished);
            batch = getAbandonedCalls(batch.pageNumbers, batch.totalHits);

            if(batch.callLogs != null && !batch.callLogs.isEmpty()){
                abandonedCallsToInsert.addAll(batch.callLogs);
            }

        }while(batch.hasNotFinished);

        Boolean haveAbandonedCalls = !abandonedCallsToInsert.isEmpty();
        if(haveAbandonedCalls){
            upsert abandonedCallsToInsert ReferenceId__c;
        }
    }

    public static CallLogs getAbandonedCalls(Integer pageNumber, Integer totalHits){
        System.debug('@getAbandonedCalls');
        ExternalAPI__c settings = new ExternalAPI__c();
        CallLogs obtainedAbandonedCalls = new CallLogs();
    
        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GenesysCloudScheduleJobsFromGenesys');
        }else {
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.AccessToken__c;
        if(accessToken != null){
            String endpoint = 'https://api.' + settings.ComplementUrl__c + '/api/v2/analytics/conversations/details/query';
            String body = getBody(pageNumber);

            System.debug(body);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setBody(body);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 200){

                System.debug('Corpo JSON reposta');
                System.debug(response.getBody());

                Response conversationHistory = (Response) JSON.deserialize(response.getBody(), Response.class);
                
                for(Conversation conv : conversationHistory.conversations)
                {
                    System.debug(conv);
                }

                Boolean firstRequest = totalHits == -1;
                Boolean haveMorePages = totalHits > 10;

                System.debug('firstRequest? ' + firstRequest);
                System.debug('haveMorePages? ' + haveMorePages);

                if(firstRequest){
                    totalHitsGlobal = conversationHistory.totalHits - 10;
                    pageNumberGlobal = pageNumberGlobal + 1;
                    obtainedAbandonedCalls.hasNotFinished = true;
                }else if(haveMorePages){
                    totalHitsGlobal = totalHitsGlobal - 10;
                    pageNumberGlobal = pageNumberGlobal + 1;
                    obtainedAbandonedCalls.hasNotFinished = true;
                }else{
                    totalHitsGlobal = totalHitsGlobal - 10;
                    pageNumberGlobal = pageNumberGlobal + 1;
                    obtainedAbandonedCalls.hasNotFinished = false;
                }
                obtainedAbandonedCalls.totalHits = totalHitsGlobal;
                obtainedAbandonedCalls.pageNumbers = pageNumberGlobal;

                System.debug('pageNumber: ' + pageNumberGlobal);

                System.debug('obtainedAbandonedCalls.totalHits: ' + obtainedAbandonedCalls.totalHits);

                obtainedAbandonedCalls.callLogs = filterConversationHistory(conversationHistory);
            }else{
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus() + ' ' + response.getBody());
            }
        }else{
            System.debug('Falha na obtenção do token de acesso');
        }
        
        System.debug('totalHitsGlobal? ' + totalHitsGlobal);
        //Boolean dontHaveMoreConversations = obtainedAbandonedCalls.totalHits <= 0;
        Boolean dontHaveMoreConversations = totalHitsGlobal <= 0;
        if(dontHaveMoreConversations){
            obtainedAbandonedCalls.hasNotFinished = false;
        }
        return obtainedAbandonedCalls;
    }

    public static String getBody(Integer pageNumber){
        Map<String,Object> body = new Map<String,Object>();
        body.put('order', 'desc');
        body.put('orderBy', 'conversationStart');
        body.put('paging', new Map<String, Object>{
            'pageSize' => 10,
            'pageNumber' => pageNumber
        });
        body.put('segmentFilters', new List<Map<String, Object>>{
            new Map<String, Object>{
                'type' => 'or',
                'predicates' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'dimension' => 'mediaType',
                        'value' => 'voice'
                    }
                }
            },
            new Map<String, Object>{
                'type' => 'or',
                'predicates' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'dimension' => 'direction',
                        'value' => 'inbound'
                    }
                }
            }
        });
        body.put('conversationFilters', new List<Object>());
        body.put('evaluationFilters', new List<Object>());
        body.put('surveyFilters', new List<Object>());
        body.put('metrics', new List<Object>());

        String dataCustomLabel = System.Label.startDateBatchGenesys;
        String dataTypeCustomLabel = System.Label.genesysIntervalType;
        Integer genesysAddHourOrDay = Integer.valueOf(System.Label.genesysAddHourOrDay);
        System.debug('Tipo de intervalo: ' + dataTypeCustomLabel);
        //A data de inicio deve estar no CustomLabel startDateBatchGenesys no seguinte formato YYYY-MM-ddTHH:MM:ss
        Datetime dt = (DateTime)JSON.deserialize('"' + dataCustomLabel + '"', DateTime.class);
        String endTime;
        String startTime = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'','GMT');
        if(dataTypeCustomLabel == 'day')
        {
            endTime = dt.addDays(genesysAddHourOrDay).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'','GMT');
        }else if(dataTypeCustomLabel == 'hour'){
            endTime = dt.addHours(genesysAddHourOrDay).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'','GMT');
        }
        body.put('interval', startTime + '/' + endTime);

        System.debug('Corpo JSON request');
        System.debug(JSON.serialize(body));
        return JSON.serialize(body);
    }

    public static String dateTimeISOFormatter(Integer hours){
        return System.now().addHours(hours).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    }


    public static List<CallLog__c> filterConversationHistory(Response conversationHistory){
        List<CallLog__c> logs = new List<CallLog__c>();

        for(Conversation conversation : conversationHistory.conversations){
            System.debug(conversation);
            Boolean tAbandonExists = false;
            Boolean tHandleExistsAbandoned = false;
            Boolean isInCall = false;
            Boolean isTransbordo = false;
            Boolean foundAgentInTheConversation = false;
            Boolean timeSegmentAgent = false;

            for(Participant participant : conversation.participants){
                Boolean isAgent = participant.purpose == 'agent';
                if(isAgent){
                    foundAgentInTheConversation = true;
                    break;
                }
            }

            CallLog__c log = new CallLog__c();
            log.Message__c = JSON.serialize(conversation);
            log.Channel__c = 'Genesys';
            log.ReferenceId__c = conversation.conversationId;
            log.Status__c = 'ABANDONADO';
            log.DivisionId__c = conversation.divisionIds[0];

            for(Participant participant : conversation.participants){
                
                Boolean isQueue = participant.purpose == 'acd';
                Boolean isPathURA = participant.purpose == 'ivr';

                Boolean queueWasNotDefined = String.isBlank(log.Queue__c);
                Boolean pathURAWasNotDefined = String.isBlank(log.CaminhoURA__c);

                if(isQueue && queueWasNotDefined){
                    log.Queue__c = participant.participantName;
                }

                if(isPathURA && pathURAWasNotDefined){
                    log.CaminhoURA__c = participant.participantName;
                }

                if(participant.participantName != null && participant.participantName.toLowerCase().contains('transbordo')){
                    isTransbordo = true;
                }

                Boolean isNotCostumerOrExternal =  participant.purpose != 'external' 
                                                && participant.purpose != 'acd' 
                                                && participant.purpose != 'customer' 
                                                && participant.purpose != 'agent';
                if(isNotCostumerOrExternal){
                    continue;
                }

                for(Session session : participant.sessions){
                    for(Segment segment : session.segments){
                        Boolean isInteraction = segment.segmentType == 'interact' || segment.segmentType == 'alert';
                        System.debug('IsInteract? ' + isInteraction);
                        if(isInteraction){
                            String startTime = segment?.segmentStart?.replace('Z', '').replace('T', ' ');
                            String endTime = segment?.segmentEnd?.replace('Z', '').replace('T', ' ');
                            log.StartTime__c = String.isBlank(startTime) ? null : Datetime.valueOfGmt(startTime);
                            log.EndTime__c = String.isBlank(endTime) ? null : Datetime.valueOfGmt(endTime);  
                        }
                    }
                    if( session.metrics != null )
                    {
                        for(Metric metric : session.metrics){
                            if(participant.purpose == 'acd' && 
                                metric.name == 'tAbandon' && 
                                Math.ceil(Decimal.valueOf(metric.value)) > 0 && 
                                !participant.participantName.contains('Pesquisa')){
                                    tAbandonExists = true;
                            }
                        }
                    }
                }
            }

            if(tAbandonExists){
                System.debug('Adicionado: tAbandonExists');
            }else{
                System.debug('Nao Adicionado'); 
                continue;
            }
            logs.add(log);
        }
        return logs;
    }
    
    public class Response {
        List<Conversation> conversations;
        public Integer totalHits;
    }

    public class Conversation {
        public String conversationId;
        public List<Participant> participants;
        public List<String> divisionIds;
    }

    public class Participant {
        public String purpose;
        public Boolean wrapupRequired;
        public String participantName;
        public List<Session> sessions;
    }

    public class Session {
        public String ani;
        public String direction;
        public List<Segment> segments;
        public List<Metric> metrics;
    }

    public class Metric {
        public String emitDate;
        public String name;
        public String value;
    }

    public class Segment {
        public String segmentType;
        public String segmentStart;
        public String segmentEnd;
    }

    public class CallLogs {
        public List<CallLog__c> callLogs;
        public Integer pageNumbers;
        public Integer totalHits;
        public Boolean hasNotFinished;

        public CallLogs(){
            this.pageNumbers = 1;
            this.totalHits = -1;
        }
    }

}