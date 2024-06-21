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
@isTest
public class SendEmailTest {
    @isTest
    static void testEmailSending(){
        Account acc = AccountDataFactory.insertPersonAccount();
        Contact ct = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        SendEmail se = new SendEmail();
        se.body = 'Teste';
        se.subject = 'Teste';
        se.attachments.put('testFile.txt', Blob.valueOf('testFile'));
        se.toAddresses.add('teste1@teste.com');
        se.toAddressesCC.add('teste2@teste.com');
        se.toAddressesBCC.add('teste3@teste.com');
        se.whatId = acc.Id;
        se.targetID = ct.Id;
        List<Object> result = se.send();

        System.assert(result == null, 'Email sending test successfully');
    }
}