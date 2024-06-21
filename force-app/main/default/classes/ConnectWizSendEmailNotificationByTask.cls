/**
 * @description       : Classe responsável enviar emails ao dono do case e da oportunidade para cada nova task criada.
 * @author            : isaac.terceiros@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 26-11-2022
 * @last modified by  : isaac.terceiros@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   22-02-2021   isaac.terceiros@wizsolucoes.com.br  Initial Version
  */
public with sharing class ConnectWizSendEmailNotificationByTask {

    public static void sendEmailNotification(ConnectWizCMPTO.EmailNotification objEmailNotification){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set recipients to two contact IDs.
        // Replace IDs with valid record IDs in your org.
        String[] addresses = new List<String>();
        if(objEmailNotification.caseOwner != objEmailNotification.opportunityOwner &&
            objEmailNotification.taskOwnerId !=objEmailNotification.caseOwner){
                if(objEmailNotification.caseOwner != null && objEmailNotification.caseOwner != ''){
                    addresses.add(objEmailNotification.caseOwner);
                }
                if(objEmailNotification.taskOwnerId !=objEmailNotification.opportunityOwner){
                    if(objEmailNotification.opportunityOwner != null && objEmailNotification.opportunityOwner != ''){
                            addresses.add(objEmailNotification.opportunityOwner);
                        }
                    }
                }else{
                    if(objEmailNotification.taskOwnerId !=objEmailNotification.opportunityOwner){
                        if(objEmailNotification.opportunityOwner != null && objEmailNotification.opportunityOwner != ''){
                            addresses.add(objEmailNotification.opportunityOwner);
                    }
                }
        }
        if(!addresses.isEmpty()){
                message.toAddresses = addresses;
                System.debug('toAddresses' + message.toAddresses);
                message.optOutPolicy = 'SEND';
                message.subject = 'Uma nova atualização foi inserida na oportunidade ' + objEmailNotification.opportunityName;
                message.htmlBody = '<br><b>Nome da Oportunidade:</b> ' + objEmailNotification.opportunityName + '<br>' +
                                    '<b>Número da Oportunidade:</b> ' + objEmailNotification.opportunityNumber +
                                    '<br><b>Autor:</b> '+ objEmailNotification.taskOwner +
                                    '<br><b>Assunto:</b> ' + objEmailNotification.subject +
                                    '<br><b>Descrição:</b> ' + objEmailNotification.description +
                                    '<br><br><b>Link da Oportunidade Salesforce:</b> <a href= https://wiz.my.site.com/wizsales/s/opportunity/' +objEmailNotification.opportunityId+'/view>'+objEmailNotification.opportunityNumber+'</a>';
                if(objEmailNotification.caseId != null){
                    message.htmlBody += '<br><b>Link do Case Placement:</b> <a href= https://wiz.my.site.com/connectatwiz/s/acompanhamento?c__caseId=' +objEmailNotification.caseId+'>Case '+objEmailNotification.caseNumber+'</a>';
                }
                Messaging.SingleEmailMessage[] messages =
                    new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if(results[0].success){
                    System.debug('The email was sent successfully.');
                }else{
                    System.debug('The email failed to send: '
                        + results[0].errors[0].message);
                }
            }

    }
}