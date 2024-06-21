/**
 * @description       :
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 12-04-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class GenesysFindContactDetailTest {
    @TestSetup
    static void makeData(){
        Campaign campanhaTesteTransbordo = new Campaign();
        campanhaTesteTransbordo.Name = 'Campanha teste transbordo';
        campanhaTesteTransbordo.PureCloud_Contact_List_ID__c = 'teste purecloudId';
        campanhaTesteTransbordo.CTIListName__c = 'campanha teste transbordo';
        campanhaTesteTransbordo.CampaignSource__c = 'Conseg';
        campanhaTesteTransbordo.Transbordo__c = true;
        insert campanhaTesteTransbordo;

        Account contaTransbordo = new Account();
        contaTransbordo.LastName = 'contaTransbordo teste';
        contaTransbordo.Phone = '19999215544';
        contaTransbordo.IdentificationNumber__c = '99999999999';
        contaTransbordo.AccountSource = 'Conseg';
        contaTransbordo.Gender__pc = 'Masculino';
        contaTransbordo.IndividualIdentificationNumber__pc = '99999999999';
        contaTransbordo.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        insert contaTransbordo;

        CallLog__c logTransbordo = new CallLog__c();
        logTransbordo.Address__c = '8671385519999215544';
        logTransbordo.Queue__c = 'campanha teste transbordo';
        insert logTransbordo;

        Campaign campanhaTeste = new Campaign();
        campanhaTeste.Name = 'Campanha teste';
        campanhaTeste.PureCloud_Contact_List_ID__c = 'teste purecloudId';
        campanhaTeste.CTIListName__c = 'campanha teste';
        campanhaTeste.CampaignSource__c = 'Conseg';
        insert campanhaTeste;

        Account conta = new Account();
        conta.LastName = 'conta teste';
        conta.IdentificationNumber__c = '19622742092';
        conta.AccountSource = 'Corporate';
        conta.Gender__pc = 'Masculino';
        conta.IndividualIdentificationNumber__pc = '19622742092';
        conta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        insert conta;

        Contact contact = new Contact();
        contact.Email = 'teste@gmail.com';
        contact.LastName = 'membroteste';
        contact.Phone = '11990009999';
        contact.MobilePhone = '11990009999';
        contact.Account = conta;
        insert contact;

        ContactDetail__c detalheContato = new ContactDetail__c();
        detalheContato.MobilePhone__c = '19999415861';
        detalheContato.BestPhone__c = '19999415861';
        detalheContato.Source__c = 'Conseg';
        detalheContato.Contact__c = contact.Id;
        insert detalheContato;

        CallLog__c log = new CallLog__c();
        log.Address__c = '8671385519999415861';
        log.Queue__c = 'campanha teste';
        insert log;

        CallLog__c log2 = new CallLog__c();
        log2.Address__c = 'INVALIDADDRESS';
        log2.Queue__c = 'campanha teste';
        insert log2;
    }

    @isTest
    public static void findContactDetailTest(){
        ContactDetail__c detalheParam = [SELECT Id, BestPhone__c FROM ContactDetail__c WHERE BestPhone__c = '19999415861' LIMIT 1];
        CallLog__c log = [SELECT Id, Address__c FROM CallLog__c WHERE Address__c = '8671385519999415861' LIMIT 1];
        CallLog__c log2 = [SELECT Id, Address__c FROM CallLog__c WHERE Address__c = 'INVALIDADDRESS' LIMIT 1];
        CallLog__c logTransbordo = [SELECT Id, Address__c FROM CallLog__c WHERE Queue__c = 'campanha teste transbordo' LIMIT 1];

        Test.startTest();
            Map<String,String> transbordo = GenesysFindContactDetail.findContactDetail(logTransbordo.Id);
            System.assertEquals('19999215544', transbordo.get('phone'), 'O phone retornado não bate');
            System.assertEquals('Conseg', transbordo.get('campaignSource'), 'O CampaignSource não bate com esperado');

            Map<String,String> retornoContactDetail = GenesysFindContactDetail.findContactDetail(log.Id);
            System.assertEquals(String.valueOf(detalheParam.Id), retornoContactDetail.get('RecordId'), 'O id retornado não bate com o esperado');
            System.assertEquals('ContactDetail__c', retornoContactDetail.get('ObjectApiName'), 'O ObjectApiName não bate com esperado');
            System.assertEquals('true', retornoContactDetail.get('find'), 'Resultado do find não bate');

            Map<String,String> retornoVoidContactDetail = GenesysFindContactDetail.findContactDetail('');
            System.assertEquals('true', retornoVoidContactDetail.get('blankInput'), 'O blankInput deveria ser true');

            Map<String,String> retornoPhone = GenesysFindContactDetail.findContactDetail(log2.Id);
            System.assertEquals('ALIDADDRESS', retornoPhone.get('phone'), 'O phone retornado não bate');
            System.assertEquals('Conseg', retornoPhone.get('campaignSource'), 'O CampaignSource não bate com esperado');

            List<GenesysFindContactDetail.FlowOutputTO> flowOutput = GenesysFindContactDetail.findContactDetailInvocable(new List<String>{log.Id});
            System.assertEquals(String.valueOf(detalheParam.Id), flowOutput[0].contactDetailId, 'O id do contato do detalhe retornado pro flow não bate');
        Test.stopTest();
    }
}