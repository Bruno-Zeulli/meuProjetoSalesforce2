/**
 * @description       : Obtem as chamadas abandonadas no endpoint analytcs da genesys e insere como CallLog no salesforce
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 11-01-2023
 * @last modified by  : joao@beecloud.com.br
 * @last modified on  : 01-08-2024
 * @last modified by  : italosilva.mirante@wiz.co
 * @last modified on  : 01-08-2024
 * @last modified by  : italosilva.mirante@wiz.co
**/
public with sharing class AbandonedCalls {

    public static Integer MIN_MILLISECONDS_DIFF = 5000;
    public static Integer totalHitsGlobal = 0;
    public static Integer pageNumberGlobal = 1;

    @future(callout=true)
    public static void insertAbandonedCalls(){
        List<CallLog__c> abandonedCallsToInsert = new List<CallLog__c>();
        CallLogs batch = new CallLogs();
        
        do{
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

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setBody(body);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Http http = new Http();
            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 200){
                Response conversationHistory = (Response) JSON.deserialize(response.getBody(), Response.class);
                
                if(conversationHistory.totalHits == 0){
                    obtainedAbandonedCalls.hasNotFinished = false;
                    return obtainedAbandonedCalls;
                }
                
                Boolean firstRequest = totalHits == -1;
                Boolean haveMorePages = totalHits > 10;

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

                obtainedAbandonedCalls.callLogs = filterConversationHistory(conversationHistory);
            }else{
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }else{
            System.debug('Falha na obtenção do token de acesso');
        }
        
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
        String startTime = dateTimeISOFormatter(2);
        String endTime = dateTimeISOFormatter(3);
        body.put('interval', startTime + '/' + endTime);

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