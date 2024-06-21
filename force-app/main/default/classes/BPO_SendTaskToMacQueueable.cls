/**
* @description       :
* @author            : Windson Santos
* @group             :
* @last modified on  : 11-05-2023
* @last modified by  : samuelsirkis@wiz.co
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
**/
public class BPO_SendTaskToMacQueueable implements Queueable, Database.AllowsCallouts {
    /*@description atributo idCase*/
    private Id idTask { get; set; }
    /*@description atributo numTentativas*/
    private integer numTentativas { get; set; }
    /*@description atributo NUM_MAXIMO_TENTATIVAS*/
    private static final Integer NUM_MAXIMO_TENTATIVAS = 5;

    /**
    *@description Construtor que recebe os parametros
    *@param idTask Id da task
    *@param numTentativas posição inicial do número de tentativas
    */
    public BPO_SendTaskToMacQueueable(Id idTask, Integer numTentativas){
        this.idTask = idTask;
        this.numTentativas = numTentativas + 1;
        System.debug('Número de tentativa' + numTentativas);
    }

    /**
    *@description Executa o enfileiramento das tasks a serem enviadas à APIMAC;
    *@param context contexto de enfileitamento;
    */
    public void execute(QueueableContext context){
        callMacforTask(this.idTask, this.numTentativas);
    }

    /**
    *@description realiza a chamada do callout, chamada ao endpoint mac/acolhida que recebe os dados das integrações com os clientes
    *@param idTask Id da task
    *@param numTentativas posição inicial do número de tentativas
    */
    @future(callout=true)
    public static void callMacforTask(Id idTask, Integer numTentativas){
        System.debug('------------------------------------------INICIO------------------------------------------');
        BPO_MacNoticeEntity.InputTask taskMAC;
        Map<String, Object> retornoWS;
        if(numTentativas <= NUM_MAXIMO_TENTATIVAS){
            //limita o número de tentativas de integração
            System.debug('BPO_SendTaskToMac - Buscando case.');
             try{
                taskMAC = getTask(idTask);

                if(taskMAC != null){
                    BPO_MacCallRest call = new BPO_MacCallRest();
                    retornoWS = call.PostTaskMACRest(JSON.serialize(taskMAC));
                    System.debug('Json enviado: ' + JSON.serialize(taskMAC));

                    if((String) retornoWS.get('Status') == 'Success'){
                        numTentativas = 5;
                    }
                    if((String) retornoWS.get('Status') != 'Success'){
                        logEDisparaEmail(
                        (String) retornoWS.get('ErrorMessage') +
                        ' Request: ' +
                        JSON.serialize(taskMAC),
                        idTask,
                        numTentativas
                        );
                    }
                }else{
                    System.debug('Comunicado não possui o External Id');
                    //logEDisparaEmail('Sinistro já possui External Workflow Id. Id comunicado: ' + this.idCase);
                }
            } catch (Exception e){
                System.debug('Erro: ' + e.getMessage() + ' ' + e.getLineNumber());
                logEDisparaEmail(e.getMessage() + ' Request: ' + JSON.serialize(taskMAC), idTask, numTentativas);
            }
        }

        System.debug('------------------------------------------FIM------------------------------------------');
    }

    /**
    *@description Instancia os dados a serem enviados ao MAC referente as task libadas ao sinistro
    *@param idTask Id da task
    *@return sinistro
    */
    private static BPO_MacNoticeEntity.InputTask getTask(Id idTask){
        BPO_MacNoticeEntity.InputTask taskToSend = new BPO_MacNoticeEntity.InputTask();
        Case casoSinistro = new Case();

        Task taskSinistro = [
        SELECT CreatedDate, CreatedBy.Name, Disposition__r.Name, Description, ActivityDate, WhatId
        FROM TASK
        WHERE Id = :idTask
        ];

        casoSinistro = [SELECT Id, Contact.Name, ExternalReferenceId__c FROM Case WHERE Id = :taskSinistro.WhatId];

        if(casoSinistro.ExternalReferenceId__c != null){
            taskToSend.CODSF = casoSinistro.Id;
            taskToSend.COMUNICADO = Long.valueOf(
            casoSinistro.ExternalReferenceId__c.right(casoSinistro.ExternalReferenceId__c.length() - 4)
            );
            taskToSend.RECLAMANTE = casoSinistro.Contact.Name;
            taskToSend.NOMEOPERADOR = taskSinistro.CreatedBy.Name;
            taskToSend.TABULACAO = taskSinistro.Disposition__r.Name;
            taskToSend.DESATIVIDADE = taskSinistro.Description;

            if(taskSinistro.ActivityDate != null){
                taskToSend.DATACONTATO = Dateutil.datetimeToString(taskSinistro.CreatedDate).substring(0, 10);
                taskToSend.DATAHORACONTATO = Dateutil.datetimeToString(taskSinistro.CreatedDate);
            }
            return taskToSend;
        }else{
            return null;
        }
    }

    /**
    *@description Processa e envia os logs do processo de integração para o grupo "Wiz BPO Seguros - Canal Integração"
    *
    *@param errorMsg Mensagem do response da chamada da APIMAC
    *@param idTask Id da task
    *@param numTentativas posição inicial do número de tentativas
    */
    private static void logEDisparaEmail(String errorMsg, Id idTask, Integer numTentativas){
        if(numTentativas == 5){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String>{ 'c2f4acc6.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms' };
            message.optOutPolicy = 'FILTER';
            message.subject = 'Erro de integração comunicado de sinistro';
            message.plainTextBody =
            'Houve um erro na integração do comunicado de sinistro. Id Task de Salesforce: ' +
            idTask +
            '. Mensagem de erro: ' +
            errorMsg;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };

            if(!Test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

                if(results[0].success){
                    System.debug('Email enviado com sucesso.');
                }else{
                    System.debug('Erro ao enviar email: ' + results[0].errors[0].message);
                }
            }
        }

        if(!Test.isRunningTest()){
            System.enqueueJob(new BPO_SendTaskToMacQueueable(idTask, numTentativas));
        }
    }
}