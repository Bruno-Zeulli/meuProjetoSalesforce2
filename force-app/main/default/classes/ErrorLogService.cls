/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/

public with sharing class ErrorLogService {
    /**
    * @description declaração de variaveis */
    private static final ErrorLogService INSTANCE = new ErrorLogService();

    /**
    * @description constroi a instancia da classe ErrorLogService
    * @return instancia da classe ErrorLogService
    */
    public static ErrorLogService getInstance(){
        return INSTANCE;
    }

    /**
    * @description verificar o resultado do database delete e envia o log error.
    * @param drList, msgErrorSubject, lstSobjeto
    */
    public void deleteResult(List<Database.DeleteResult> drList, String msgErrorSubject, List<SObject> lstSobjeto){
        List<String> lstErrorLog = new List<String>();

        for(Database.DeleteResult dr : drList){
            Integer idx = 0;
            if(!dr.isSuccess()){
                String msg = '';
                for(Database.Error err : dr.getErrors()){
                    msg += '\n Error: ' + err.getStatusCode() + ': ' + err.getMessage() + '\n';
                    msg += 'Fields: ' + err.getFields() + '\n';
                }
                String id = (String)(lstSobjeto[idx]).get('Id');
                lstErrorLog.add(
                    'Object Id: '
                    + id
                    + ' '
                    + msg
                );
            }
            idx++;
        }
        if(!lstErrorLog.isEmpty()){
            logEDisparaEmail(lstErrorLog, msgErrorSubject);
        }
    }

    /**
    * @description verificar o resultado do database uptade ou insert e envia o log error.
    * @param drList, msgErrorSubject, lstSobjeto
    */
    public void saveResult(List<Database.SaveResult> srList, String msgErrorSubject, List<SObject> lstSobjeto){
        List<String> lstErrorLog = new List<String>();

        for(Database.SaveResult sr : srList){
            Integer idx = 0;
            if(!sr.isSuccess()){
                String msg = '';
                for(Database.Error err : sr.getErrors()){
                    msg += '\n Error: ' + err.getStatusCode() + ': ' + err.getMessage() + '\n';
                    msg += 'Fields: ' + err.getFields() + '\n';
                }
                String id = (String)(lstSobjeto[idx]).get('Id');
                lstErrorLog.add(
                    'Object Id: '
                    + id
                    + ' '
                    + msg
                );
            }
            idx++;
        }
        if(!lstErrorLog.isEmpty()){
            logEDisparaEmail(lstErrorLog, msgErrorSubject);
        }

    }

    /**
    * @description dispara notificação com o LogError ao time de desenvolvedores
    * @param errorMsg, msgErrorSubject
    */
    public void logEDisparaEmail(List<String> errorMsg, String msgErrorSubject){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new List<String>{'f03a793d.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms'}; // Assim que o teams finalizar o processo de criação dos emails precisa alterar para o grupo correto
        message.optOutPolicy = 'FILTER';
        message.subject = msgErrorSubject;
        message.plainTextBody = msgErrorSubject + ': ' + errorMsg;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };

        if(!Test.isRunningTest())
        {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if(results[0].success){
                System.debug('Email enviado com sucesso.');
            }else{
                System.debug('Erro ao enviar email: ' + results[0].errors[0].message);
            }
        }

    }


}