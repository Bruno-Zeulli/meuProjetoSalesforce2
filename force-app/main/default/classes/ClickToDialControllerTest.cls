/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-09-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class ClickToDialControllerTest {

    @isTest
    static void testGetSObjectInfos() {
        // Crie um registro fictício que corresponda ao objeto que você deseja testar
        Account testAccount = AccountDataFactory.createBusinessAccount();
        insert testAccount;

        // Crie um registro fictício com os detalhes de telefone
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = testAccount.Id,
            Phone = '6132420644',
            MobilePhone = '61987654323'
        );
        insert testContact;

        ContactDetail__c testDetail = new ContactDetail__c(
            Contact__c = testContact.Id,
            Name = testContact.Name,
            Source__c = 'Conseg',
            MobilePhone__c = '61987654323',
            HomePhone__c ='6132420644'
        );
        insert testDetail;

        Contact otherContact = new Contact(
            LastName = 'Dev Marangoni',
            MobilePhone = '19999528465'
        );
        insert otherContact;

        ContactDetail__c otherDetail = new ContactDetail__c(
            Name = 'otherDetail teste',
            Contact__c = otherContact.Id,
            Source__c = 'Conseg',
            MobilePhone__c = '19999528465'
        );
        insert otherDetail;

        Case caso = new Case();
        insert caso;

        Opportunity opp = new Opportunity(
            Name = 'opp teste',
            ContactDetail__c = otherDetail.Id,
            AgentName__c = 'Agente teste',
            StageName = 'Aberto',
            CloseDate = Date.today() + 1
        );
        insert opp;

        // Chame o método getSObjectInfos e verifique se ele retorna os detalhes corretos
        List<ClickToDialControllerTO.ContactToDial> result = ClickToDialController.getSObjectInfos(testContact.Id);

        // Verifique se a lista de resultados não está vazia
        System.assertNotEquals(0, result.size());

        // Verifique se o nome foi retornado corretamente
        System.assertEquals('John Doe', result[0].name);

        // Testando enviar uma opp/caso
        //OPP
        ClickToDialController.getSObjectInfos(opp.Id);
        //CASO
        ClickToDialController.getSObjectInfos(caso.Id);
    }
}