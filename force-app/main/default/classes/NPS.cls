/**
 * @description       : 
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 08-12-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class NPS {
    public static void setNPS(List<CallLog__c> callsWithoutNPS){
        List<CallLog__c> callsWithNPSToUpdate = new List<CallLog__c>();

        for(CallLog__c call : callsWithoutNPS){
            CallLog__c callWithNPS = getNPS(call);
            callsWithNPSToUpdate.add(callWithNPS);
        }

        update callsWithNPSToUpdate;
    }

    public static CallLog__c getNPS(CallLog__c callWithoutNPS){
        ExternalAPI__c settings = new ExternalAPI__c();
        CallLog__c callWithNPS = callWithoutNPS;

        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GenesysCloudScheduleJobsFromGenesys');
        }else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        String accessToken = settings.accessToken__c;
        if(accessToken != null){
            String endpoint = 'https://api.' + settings.ComplementUrl__c + '/api/v2/conversations/' + callWithoutNPS.ReferenceId__c;

            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'bearer ' + accessToken);
            request.setMethod('GET');
            request.setEndpoint(endpoint);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                Response conversationHistory = (Response) JSON.deserialize(response.getBody(), Response.class);
                for(Participant participant : conversationHistory.participants){
                    Boolean isTransferedToNPS = participant?.purpose == 'ivr' && participant?.name.contains('Pesquisa de Satisfação');
                    if(isTransferedToNPS){
                        callWithNPS.TransferidoParaNPS__c = true;
                        break;
                    }

                    Boolean isNotCustomerOrExternal = participant?.purpose != 'customer' && participant?.purpose != 'external';
                    if(isNotCustomerOrExternal){
                        continue;
                    }
                    Attribute attributesNPS = participant?.attributes;
                    Boolean callNotHaveCaminhoURA = String.isBlank(callWithNPS.CaminhoURA__c);
                    if(callNotHaveCaminhoURA){
                        callWithNPS.CaminhoURA__c = String.isBlank(attributesNPS?.caminhoURA) ? null : attributesNPS?.caminhoURA;
                    }
                    
                    Boolean npsHasAlreadyBeenConsulted = false;
                    if(!npsHasAlreadyBeenConsulted){
                        callWithNPS.NPS_Nota1__c = String.isBlank(attributesNPS?.NPS_Nota1) ? null : attributesNPS?.NPS_Nota1;
                        callWithNPS.NPS_Nota2__c = String.isBlank(attributesNPS?.NPS_Nota2) ? null : attributesNPS?.NPS_Nota2;
                        callWithNPS.NPS_Nota3__c = String.isBlank(attributesNPS?.NPS_Nota3) ? null : attributesNPS?.NPS_Nota3;
                        callWithNPS.NPS_Nota4__c = String.isBlank(attributesNPS?.NPS_Nota4) ? null : attributesNPS?.NPS_Nota4;
                        callWithNPS.NPS_Nota5__c = String.isBlank(attributesNPS?.NPS_Nota5) ? null : attributesNPS?.NPS_Nota5;
                        callWithNPS.NPS_Nota6__c = String.isBlank(attributesNPS?.NPS_Nota6) ? null : attributesNPS?.NPS_Nota6;
                        callWithNPS.NPS_Nota7__c = String.isBlank(attributesNPS?.NPS_Nota7) ? null : attributesNPS?.NPS_Nota7;
                        callWithNPS.NPS_Nota8__c = String.isBlank(attributesNPS?.NPS_Nota8) ? null : attributesNPS?.NPS_Nota8;
                        callWithNPS.NPS_Nota9__c = String.isBlank(attributesNPS?.NPS_Nota9) ? null : attributesNPS?.NPS_Nota9;
                        callWithNPS.NPS_Nota10__c = String.isBlank(attributesNPS?.NPS_Nota10) ? null : attributesNPS?.NPS_Nota10;
                        callWithNPS.NPSConsultado__c = true;
                        npsHasAlreadyBeenConsulted = true;
                    }
                }
            }else{
                System.debug('Erro na chamada à API: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }else{
            System.debug('Falha na obtenção do token de acesso');
        }

        return callWithNPS;
    }

    public class Response{
        List<Participant> participants;
    }

    public class Participant{
        public String purpose;
        public String name;
        public Attribute attributes;
    }

    public class Attribute{
        public String caminhoURA;
        public String NPS_Nota1;
        public String NPS_Nota2;
        public String NPS_Nota3;
        public String NPS_Nota4;
        public String NPS_Nota5;
        public String NPS_Nota6;
        public String NPS_Nota7;
        public String NPS_Nota8;
        public String NPS_Nota9;
        public String NPS_Nota10;
    }
}