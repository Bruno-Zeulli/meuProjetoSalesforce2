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
public class BPO_SendWorkflowControllerTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        List<Account> listAccount = new List<Account>();
        Integer count = 1;

        Account acc = new Account(
            FirstName = 'Conta',
            LastName = 'Segurado',
            IndividualIdentificationNumber__pc = '44154707698',
            PersonEmail = 'teste@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId()
        );

        listAccount.add(acc);
        while (count < 4){
            acc = AccountDataFactory.createPersonAccount();
            listAccount.add(acc);

            count++;
        }

        insert listAccount;

        Product2 produto = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista');
        insert produto;

        Contract2__c contractHab = new Contract2__c(
            Name = 'Habitacional',
            Account__c = listAccount[0].Id,
            Company__c = 'CAIXA Seguradora',
            StartDate__c = System.today(),
            EndDate__c = System.today(),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '873465874',
            CertificateNumber__c = '873465874',
            BidNumber__c = '873423465874',
            ProductCode__c = produto.ProductCode,
            ProductName__c = produto.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Habitacional',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = false,
            RecordTypeId = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId()
        );
        insert contractHab;

        Contract2__c contractHPrest = new Contract2__c(
            Name = 'Prestamista',
            Account__c = listAccount[0].Id,
            Company__c = 'CAIXA Seguradora',
            StartDate__c = System.today(),
            EndDate__c = System.today(),
            InsuredAmount__c = 4500.00,
            ContractNumber__c = '8730005874',
            CertificateNumber__c = '870005874',
            BidNumber__c = '8734600074',
            ProductCode__c = produto.ProductCode,
            ProductName__c = produto.Name,
            Status__c = 'Ativo',
            ProductFamily__c = 'Prestamista',
            BidStatus__c = 'Emitida',
            IsAutoRenewal__c = false,
            RecordTypeId = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId()
        );
        insert contractHPrest;

        Account contact = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[1].Id AND IsPersonAccount = TRUE];

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            Contact__c = contact.PersonContactId,
            MobilePhone__c = '61999999999',
            Email__c = 'teste@teste.com',
            Street__c = 'Street',
            City__c = 'Brasilia',
            State__c = 'DF',
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            District__c = '123',
            RecordTypeId = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId()
        );
        insert contactDetail;

        Account comunicante = [SELECT Id, PersonContactId FROM Account WHERE Id = :listAccount[2].Id AND IsPersonAccount = TRUE];

        Case c = new Case(
            Subject = 'Comunicado de Sinistro - Alana Alves',
            Description = 'Descrição da ocorrência',
            Origin = 'BPO - Concierge',
            Type = 'BPO - MIP - Imóvel construído',
            Status = 'BPO - Não Tratado',
            Reason = 'BPO - Vendaval',
            Priority = 'Medium',
            AccountId = listAccount[0].Id,
            ContactId = contact.PersonContactId,
            ContactDetail__c = contactDetail.Id,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId(),
            ExternalReferenceId__c = (listAccount[0].Id + ' | ' + contact.PersonContactId  + ' | ' + contactDetail.Id)
        );
        insert c;

        Id idComunicado = c.Id;

        c = new Case(
            Concierge_IncidentCode__c = '0123456',
            Subject = 'Sinistro',
            Origin = 'BPO - Concierge',
            RequestDate__c = Date.valueOf('2019-06-06'),
            InspectionDate__c = System.today(),
            Type = 'BPO - DFI - Imóvel construído',
            Status = 'BPO - Não Tratado',
            Reason = 'BPO - Incêndio, Raio e Explosão',
            ParentId = idComunicado,
            AccountId = listAccount[0].Id,
            ContactId = contact.PersonContactId,
            Contract2__c = contractHab.Id,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroHabitacional').getRecordTypeId(),
            ExternalReferenceId__c = (listAccount[0].Id + ' | ' + contact.PersonContactId  + ' | ' + contractHab.Id)
        );
        insert c;

        CaseContactRelation__c caseRelation = new CaseContactRelation__c(
            Case__c = c.id,
            Contact__c = contact.PersonContactId,
            Kinship__c = 'Segurado',
            Relationship__c = 'Contato'
        );
        insert caseRelation;

        caseRelation = new CaseContactRelation__c(Case__c = c.id, Contact__c = comunicante.PersonContactId, Kinship__c = 'Segurado', Relationship__c = 'Comunicante');
        insert caseRelation;

        c = new Case(
            Subject = 'Sinistro',
            RequestDate__c = Date.valueOf('2019-06-06'),
            Contract2__c = contractHPrest.Id,
            ParentId = idComunicado,
            Type = 'BPO - MIP - IPD',
            Status = 'BPO - Não Tratado',
            AccountId = listAccount[0].Id,
            ContactId = contact.PersonContactId,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroPrestamista').getRecordTypeId(),
            ExternalReferenceId__c = (listAccount[0].Id + ' | ' + contact.PersonContactId  + ' | ' + contractHPrest.Id)
        );
        insert c;

        caseRelation = new CaseContactRelation__c(Case__c = c.Id, Contact__c = contact.PersonContactId, Kinship__c = 'Segurado', Relationship__c = 'Reclamante');
        insert caseRelation;
    }

    @isTest
    static void sendWorkflowController(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSipreSuccess());
        Case comunicado = [SELECT Id, Status FROM Case WHERE Account.IndividualIdentificationNumber__pc = '44154707698' AND Subject LIKE '%Comunicado%' LIMIT 1];
        System.debug('status do comunicado:' + comunicado);

        BPO_SendWorkflowController.sendNotice(comunicado.Id);
        Boolean result = BPO_SendWorkflowController.updateNoticeToOpen(comunicado.Id);
        System.assertEquals(true, result, 'Update case status');
    }
}