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
public class BPO_SendHomeIncidentQueueableTest {
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
    public static void testSendIncident(){
        //ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACSuccess());

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        while (count < 4){
            Account acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }
        insert listAccount;

        // COMUNICADO E SINISTRO

        // Contrato e Produto
        Product2 product = ProductDataFactory.createProductHab();
        Contract2__c contract = ContractDataFactory.insertContractHab(listAccount[0].Id, product);

        // Contato do Reclamante
        Account reclamante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[1].Id AND IsPersonAccount = TRUE];
        ContactDetail__c reclamanteContactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(reclamante);

        // Conta do Segurado
        Account segurado = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[2].Id AND IsPersonAccount = TRUE];
        ContactDetail__c seguradaoContactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(segurado);

        // Comunicado
        Case comunicado = CaseDataFactory.insertComunicadoSinistro(segurado.Id, reclamante.PersonContactId, reclamanteContactDetail.Id);

        // Sinistro Habitacional
        Case sinistro = CaseDataFactory.insertSinistro(segurado.Id, comunicado.id, reclamante.PersonContactId, comunicado.ContactDetail__c, contract.Id);

        // Relacionamento do segurado com o reclamante
        CaseContactRelation__c caseRelation = CaseRelationDataFactory.insertCaseRelation(sinistro.id, reclamante.PersonContactId, 'Segurado', 'Contato');
        caseRelation = CaseRelationDataFactory.insertCaseRelation(sinistro.id, reclamante.PersonContactId, 'Segurado', 'Comunicante');

        Test.startTest();
        Object result = System.enqueueJob(new BPO_SendHomeIncidentQueueable(sinistro.Id, 0));
        Test.stopTest();
        System.assert(result != null, 'Incidents must be returned');
    }

    @isTest
    public static void testFailSendIncident(){
        //ExternalAPIDataFactory.insertExternalAPIs();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMACFail());

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        while (count < 4){
            Account acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }

        insert listAccount;

        // COMUNICADO E SINISTRO

        // Contrato e Produto
        Product2 product = ProductDataFactory.createProductHab();
        Contract2__c contract = ContractDataFactory.insertContractHab(listAccount[0].Id, product);

        // Contato do Reclamante
        Account reclamante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[1].Id AND IsPersonAccount = TRUE];
        ContactDetail__c reclamanteContactDetail = ContactDetailDataFactory.insertConciergeFailPersonAccountContactDetail(reclamante);

        // Conta do Segurado
        Account segurado = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[2].Id AND IsPersonAccount = TRUE];
        ContactDetail__c seguradaoContactDetail = ContactDetailDataFactory.insertConciergeFailPersonAccountContactDetail(segurado);

        // Comunicado
        Case comunicado = CaseDataFactory.insertComunicadoSinistro(segurado.Id, reclamante.PersonContactId, reclamanteContactDetail.Id);

        // Sinistro Habitacional
        Case sinistro = CaseDataFactory.insertSinistro(segurado.Id, comunicado.id, reclamante.PersonContactId, comunicado.ContactDetail__c, contract.Id);

        // Relacionamento do segurado com o reclamante
        CaseContactRelation__c caseRelation = CaseRelationDataFactory.insertCaseRelation(sinistro.id, reclamante.PersonContactId, 'Segurado', 'Contato');
        caseRelation = CaseRelationDataFactory.insertCaseRelation(sinistro.id, reclamante.PersonContactId, 'Segurado', 'Comunicante');

        Test.startTest();
        Object result = System.enqueueJob(new BPO_SendHomeIncidentQueueable(sinistro.Id, 4));
        Test.stopTest();
        System.assert(result != null, 'Not must be null');
    }
}