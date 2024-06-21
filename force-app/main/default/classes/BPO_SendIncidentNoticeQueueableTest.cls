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
public class BPO_SendIncidentNoticeQueueableTest {
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
    public static void testSendIncidentNoticeSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreSuccess());

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        while (count < 4){
            Account acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }

        insert listAccount;
        Product2 product = ProductDataFactory.insertProduct();

        Contract2__c contract = ContractDataFactory.insertContractPres(listAccount[0].Id, product);

        Account reclamante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[0].Id AND IsPersonAccount = TRUE];

        ContactDetail__c contactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(reclamante);

        Case c = CaseDataFactory.insertComunicadoSinistroNaoSincronizado(listAccount[0].Id, reclamante.PersonContactId, contactDetail.Id);

        Id idComunicado = c.Id;

        c = CaseDataFactory.insertSinistroPrestamista(listAccount[0].Id, idComunicado, reclamante.PersonContactId, contactDetail.Id, contract.Id);

        CaseContactRelation__c caseRelation = CaseRelationDataFactory.insertCaseRelation(c.id, reclamante.PersonContactId, 'Segurado', 'Beneficiário');

        System.debug('c: ' + c);
        System.debug('idComunicado: ' + idComunicado);

        Test.startTest();
        Object result = System.enqueueJob(new BPO_SendIncidentNoticeQueueable(idComunicado, 0));
        Test.stopTest();
        System.assert(result != null, 'Incident not must be null');
    }

    @isTest
    public static void testSendIncidentNoticeFail(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreSuccess());

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        while (count < 4){
            Account acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }

        insert listAccount;
        Product2 product = ProductDataFactory.insertProduct();

        Contract2__c contract = ContractDataFactory.insertContractPres(listAccount[0].Id, product);

        Account reclamante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[0].Id AND IsPersonAccount = TRUE];

        ContactDetail__c contactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(reclamante);

        Case c = CaseDataFactory.insertComunicadoSinistroNaoSincronizado(listAccount[0].Id, reclamante.PersonContactId, contactDetail.Id);

        Id idComunicado = c.Id;

        c = CaseDataFactory.insertSinistroPrestamista(listAccount[0].Id, idComunicado, reclamante.PersonContactId, contactDetail.Id, contract.Id);

        CaseContactRelation__c caseRelation = CaseRelationDataFactory.insertCaseRelation(c.id, reclamante.PersonContactId, 'Segurado', 'Beneficiário');

        System.debug('c: ' + c);
        System.debug('idComunicado: ' + idComunicado);

        Test.startTest();
        Object result = System.enqueueJob(new BPO_SendIncidentNoticeQueueable(idComunicado, 4));
        Test.stopTest();
        System.assert(result != null, 'Incident must be null');
    }
}