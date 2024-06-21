/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

public without sharing class SendEmail {
    public String subject { get; set; }
    public String body { get; set; }
    // Map key: fileName Map value attachment blob
    public Map<String, Blob> attachments { get; set; }
    public List<String> toAddresses { get; set; }
    public List<String> toAddressesCC { get; set; }
    public List<String> toAddressesBCC { get; set; }
    public String templateName { get; set; }
    public Id targetID { get; set; }
    public Id whatId { get; set; }

    public SendEmail(){
        attachments = new Map<String, Blob>();
        toAddresses = new List<String>();
        toAddressesCC = new List<String>();
        toAddressesBCC = new List<String>();
    }

    public List<Messaging.SendEmailResult> send(){
        List<Messaging.SendEmailResult> result;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        for(String attachmentName : attachments.keySet()){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attachmentName);
            efa.setBody(attachments.get(attachmentName));
            efaList.add(efa);
        }

        email.setToAddresses(toAddresses);

        if(templateName == null){
            email.setSubject(subject);
            if(String.isNotBlank(body)){
                email.setPlainTextBody(body);
            }
        }

        if(!toAddressesCC.isEmpty()){
            email.setccAddresses(toAddressesCC);
        }
        if(!toAddressesBCC.isEmpty()){
            email.setBccAddresses(toAddressesBCC);
        }
        if(whatId != null){
            email.setWhatId(whatId);
        }
        if(targetID != null){
            email.setTargetObjectId(targetID);
        }
        if(String.isNotBlank(templateName)){
            email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = :templateName].Id);
        }
        if(!efaList.isEmpty()){
            email.setFileAttachments(efaList);
        }
        email.setSaveAsActivity(true);

        if(!Test.isRunningTest()){
            result = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        }
        System.debug('Test' + result);
        return result;
    }
}