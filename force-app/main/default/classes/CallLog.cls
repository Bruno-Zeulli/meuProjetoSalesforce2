/**
 * @description       : possui alguns métodos que obtem dados para o CallLog e atualizam ele
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 06-12-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class CallLog {
    @InvocableMethod(
        label='Update call WaitingTime' 
        category='CallLog__c'
    )
    public static void updateCallWaitingTime(List<String> callLogIds){
        CallLog__c call = [SELECT Id, ReferenceId__c, Message__c, TempoDeEspera__c FROM CallLog__c WHERE Id = :callLogIds[0]];       
        CallLogMessageJSON2Apex callObj = (CallLogMessageJson2Apex)JSON.deserialize(call.Message__c, CallLogMessageJSON2Apex.class);
        if(callObj.direction == 'Inbound'){
            CallLog__c callWithWaitingTime = getCallWaitingTime(call);
            update callWithWaitingTime;
        }
    }

    public static CallLog__c getCallWaitingTime(CallLog__c call){
        CallLog__c callWithWaitingTime = call;
        ExternalAPI__c settings = new ExternalAPI__c();


        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GenesysCloudTME');
        }else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.accessToken__c;
        if(accessToken != null){
            String endpoint = 'https://api.' + settings.ComplementUrl__c + '/api/v2/analytics/conversations/aggregates/query';
            String body = getBody(call.ReferenceId__c);

            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'bearer ' + accessToken);
            request.setBody(body);
            request.setMethod('POST');
            request.setEndpoint(endpoint);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                Response conversationMetrics = (Response) JSON.deserialize(response.getBody(), Response.class);
                
                for(Result result : conversationMetrics.results){
                    for(Data data : result.data){
                        for(Metric metric : data.metrics){
                            final Integer ROUNDNESS_ADJUSTMENT = 499;
                            Decimal convertToSeconds = (metric.stats.sum + ROUNDNESS_ADJUSTMENT) / 1000;
                            Integer waitingTimeInSeconds = (Integer) convertToSeconds.round();
                            callWithWaitingTime.TempoDeEspera__c = waitingTimeInSeconds;
                            break;
                        }
                        break;
                    }
                    break;
                }

                return callWithWaitingTime;
            }else{
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }else{
            System.debug('Falha na obtenção do token de acesso');
        }

        return callWithWaitingTime;
    }

    public static String getBody(String conversationId){
        Map<String,Object> body = new Map<String,Object>();
        body.put('filter', new Map<String,Object>{
            'type' => 'and',
            'clauses' => new List<Map<String,Object>>{
                new Map<String,Object>{
                    'type' => 'or',
                    'predicates' => new List<Map<String,Object>>{
                        new Map<String,Object>{
                            'dimension' => 'conversationId',
                            'value' => conversationId
                        }
                    }
                },
                new Map<String,Object>{
                    'type' => 'or',
                    'predicates' => new List<Map<String,Object>>{
                        new Map<String,Object>{
                            'dimension' => 'mediaType',
                            'value' => 'voice'
                        }
                    }
                }
            }
        });
        body.put('metrics', new List<String>{
            'tAcw',
            'tAcd'
        });
        body.put('groupBy', new List<String>{
            'conversationId'
        });
        String startTime = Datetime.newInstance(2022,12,5,0,0,0).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        String endTime = System.now().addHours(3).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        body.put('interval', startTime + '/' + endTime);
        System.debug(JSON.serialize(body));

        return JSON.serialize(body);
    }

    public class Response{
        public List<Result> results;
    }

    public class Result{
        public List<Data> data;
    }

    public class Data{
        public List<Metric> metrics;
    }

    public class Metric{
        public Stats stats;
    }

    public class Stats{
        public Integer max;
        public Integer min;
        public Integer count;
        public Integer sum;
    }
}