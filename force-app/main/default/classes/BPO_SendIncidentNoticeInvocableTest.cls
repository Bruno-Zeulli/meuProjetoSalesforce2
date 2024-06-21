/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class BPO_SendIncidentNoticeInvocableTest {
    @testSetup
    static void setup(){
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;
    }

    @isTest
    public static void testEnviarComunicado(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreSuccess());

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        while (count < 4){
            Account acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }

        insert listAccount;

        // Sinistro Habitacional
        Product2 product = ProductDataFactory.createProduct();

        Contract2__c contract = ContractDataFactory.insertContractHab(listAccount[0].Id, product);

        Account contact = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[1].Id AND IsPersonAccount = TRUE];

        ContactDetail__c contactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(contact);

        Account comunicante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[2].Id AND IsPersonAccount = TRUE];

        Case c = CaseDataFactory.insertComunicadoSinistro(listAccount[0].Id, contact.PersonContactId, contactDetail.Id);

        Id idComunicado = c.Id;

        c = CaseDataFactory.insertSinistro(listAccount[0].Id, idComunicado, contact.PersonContactId, contactDetail.Id, contract.Id);

        CaseContactRelation__c caseRelation = CaseRelationDataFactory.insertCaseRelation(c.id, contact.PersonContactId, 'Segurado', 'Contato');
        caseRelation = CaseRelationDataFactory.insertCaseRelation(c.id, contact.PersonContactId, 'Segurado', 'Comunicante');
        System.assert(caseRelation != null, '');

        Test.startTest();
        List<Id> listaId = new List<Id>();
        listaId.add(idComunicado);
        BPO_SendIncidentNoticeInvocable.sendSipre(listaId);

        Test.stopTest();
    }
}