/**
* @description       :
* @author            : Windson Santos
* @group             :
* @last modified on  : 10-18-2023
* @last modified by  : samuelsirkis@wiz.co
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
**/
@isTest
public class CaseTriggerHandlerTest {
    @testSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallSSOSuccess());

        ExternalAPIDataFactory.insertExternalAPIs();
        ContentType__C ct = new ContentType__C();
        ct.Template__c = 'application/x-www-form-urlencoded';
        ct.Name = 'x-www-form-urlencoded';
        ct.Type__c = 'application';
        insert ct;

        String recordTypeIdHabitacional = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
        String recordTypeIdRCPM = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPORcpm').getRecordTypeId();

        Account sinistradoAccount = AccountDataFactory.insertPersonAccount();
        sinistradoAccount = [SELECT Id, PersonContactId FROM Account WHERE Id = :sinistradoAccount.Id];
        Id sinistradoContact = sinistradoAccount.PersonContactId;

        ContactDetail__c sinistradoContactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(sinistradoAccount);

        Product2 productHab = ProductDataFactory.insertProductHab();
        Contract2__c contratoSinistradoHab = ContractDataFactory.insertContractHab(sinistradoAccount.Id, productHab);

        Product2 productPres = ProductDataFactory.createProductPres();
        Contract2__c contratoSinistradoPres = ContractDataFactory.insertContractPres(sinistradoAccount.Id, productPres);

        Product2 productRCPM = ProductDataFactory.insertProductRCPM();
        Contract2__c contratoRCPM = ContractDataFactory.insertContractRCPM(sinistradoAccount.Id, productRCPM);

        Product2 productAgro = ProductDataFactory.insertProductAgro();
        Contract2__c contratoAgro = ContractDataFactory.insertContractAgro(sinistradoAccount.Id, productAgro);

        Case comunicado = CaseDataFactory.insertComunicadoSinistro(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id);
        Case sinistro = CaseDataFactory.insertSinistro(sinistradoAccount.Id, comunicado.Id, sinistradoContact, sinistradoContactDetail.Id, contratoSinistradoHab.Id);

        Case sinistroPres = CaseDataFactory.insertSinistro(sinistradoAccount.Id, comunicado.Id, sinistradoContact, sinistradoContactDetail.Id, contratoSinistradoPres.Id);

        Case sinistroRCPM = CaseDataFactory.insertSinistroRCPM(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id, contratoRCPM.Id);

        Case sinistroAgro = CaseDataFactory.insertSinistroAgro(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id, contratoAgro.Id);

        Campaign campanha = CampaignDataFactory.insertCampaign();
        CampaignMember membro = CampaignMemberDataFactory.insertCampaignMember(campanha.Id, comunicado.ContactId, comunicado.Id);

    }

    @isTest
    static void callMarketingCloudTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());

        String recordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
        Case comunicado = [SELECT Id, RecordTypeId, RecordType.Name, Status FROM Case WHERE RecordTypeId = :recordTypeIdComunicado LIMIT 1];

        comunicado.Status = 'BPO - Em Análise';
        update comunicado;
        System.assertEquals('BPO - Em Análise', comunicado.Status, '');
    }

    @isTest
    static void callMarketingCloudWithoutBPOTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());

        String recordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
        Case comunicado = [SELECT Id, RecordTypeId, RecordType.Name, Status FROM Case WHERE RecordTypeId = :recordTypeIdComunicado LIMIT 1];

        comunicado.Status = 'Em Análise';
        update comunicado;
        System.assertEquals('Em Análise', comunicado.Status, '');
    }

    @isTest
    static void callMarketingCloudRCPMTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());

        String recordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPORcpm').getRecordTypeId();
        Case comunicado = [SELECT Id, RecordTypeId, RecordType.Name, Status FROM Case WHERE RecordTypeId = :recordTypeIdComunicado LIMIT 1];

        comunicado.Status = 'Agendamento de vistoria';
        update comunicado;
        System.assertEquals('Agendamento de vistoria', comunicado.Status, '');
    }

    @isTest
    static void callMarketingCloudAgroTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());

        String recordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOAgro').getRecordTypeId();
        Case comunicado = [SELECT Id, RecordTypeId, RecordType.Name, Status FROM Case WHERE RecordTypeId = :recordTypeIdComunicado LIMIT 1];
        System.assert(comunicado != null, '');
    }


    // @isTest
    // static void removeAtivoTest(){
    //     Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());

    //     String RecordTypeIdComunicado = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
    //     String RecordTypeIdHabitacional = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroHabitacional').getRecordTypeId();

    //     Case comunicado = [SELECT Id, RecordTypeId, RecordType.Name, Status
    //                         from Case
    //                         where RecordTypeId = :RecordTypeIdComunicado Limit 1
    //                         ];
    //     List<Case> sinistros = [SELECT Id, RecordTypeId, RecordType.Name, Status, Concierge_IncidentWorkflowStatus__c
    //                             from Case
    //                             where RecordTypeId = :RecordTypeIdHabitacional Limit 2
    //                             ];

    //     for(Case s: sinistros){
    //         s.Concierge_IncidentWorkflowStatus__c = 'BPO - Não É Cliente da Caixa Seguradora';
    //     }
    //     update sinistros;
    //     List<CampaignMember> membros = [SELECT Id from CampaignMember];

    //     Test.startTest();

    //     system.assertEquals(1, membros.size());

    //     comunicado.Status = 'BPO - Em Análise';
    //     update comunicado;

    //     comunicado.Status = 'BPO - Vistoria';
    //     update comunicado;

    //     Test.stopTest();

    //     membros = [SELECT Id from CampaignMember];
    //     system.assertEquals(0, membros.size());
    // }


    @isTest
    static void testCaseTriggerHandler(){
        Case caseVariable;
        caseVariable = testInsert();
        System.assert(caseVariable != null, '');
        caseVariable = testUpdate(caseVariable);
        System.assert(caseVariable != null, '');
        caseVariable = testDelete(caseVariable);
        System.assert(caseVariable != null, '');
        caseVariable = testUndelete(caseVariable);
        System.assert(caseVariable != null, '');
    }

    @isTest
    static void sharedRecordsTickets(){

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Integrador - PARCEIROS'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Parceiros - Tickets'].Id;

        List<User> iUserList = new List<User>();
        User iUser = new User(
            ProfileId = profileId,
            LastName = 'last',
            Email = 'testEmail@wiz.com',
            Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ',
            Title = 'Usuario WIZ test',
            Alias = 'Wizzer',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser);

        User iUser2 = new User(
            ProfileId = profileId2,
            LastName = 'last2',
            Email = 'testEmail2@wiz.com',
            Username = 'wizeruser0002@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ2',
            Title = 'Usuario WIZ test2',
            Alias = 'Wizzer2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser2);

        insert iUserList;

        Account iAccount = new Account(
            FirstName = 'Conta',
            LastName = 'Segurado',
            IndividualIdentificationNumber__pc = '44154707698',
            PersonEmail = 'teste@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId()
        );
        insert iAccount;

        Contact iContact = new Contact();
        iContact.IndividualIdentificationNumber__c = '47635470866';
        iContact.LastName = 'LastName';
        insert iContact;

        User getUserOne = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com'];
        User getUserTwo = [SELECT Id FROM User WHERE Email = 'testEmail2@wiz.com'];

        Case iCaseToInsert = new Case(RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId(),Description = 'Test Shared',StatusTickets__c = 'Em Atendimento',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = getUserOne.Id);
        insert iCaseToInsert;

        iCaseToInsert.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId();
        iCaseToInsert.ownerId = getUserTwo.Id;
        update iCaseToInsert;

        Test.startTest();
        User userOne = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com'];
        User userTwo = [SELECT Id FROM User WHERE Email = 'testEmail2@wiz.com'];
        Case caseUpdated = [SELECT Id FROM Case WHERE RecordType.DeveloperName LIKE '%_Tkt' LIMIT 1];
        List<CaseShare> lstCaseShare = [SELECT Id, UserOrGroupId, CaseId FROM CaseShare WHERE CaseId =: caseUpdated.Id ORDER BY CaseAccessLevel ASC];

        //System.assertEquals(2, lstCaseShare.size(), 'Erro na lista de Casos compartilhados');
        //System.assertEquals(lstCaseShare[0].UserOrGroupId, userOne.Id);
        //System.assertEquals(lstCaseShare[1].UserOrGroupId, userTwo.Id);

        Test.stopTest();
    }

    @isTest
    public static  void createTaskNotificationTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Administrador'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Corporate - Benefícios - Gerente Regional'].Id;
        Id groupId = [SELECT Id FROM Group WHERE type = 'Queue' LIMIT 1].Id;

        List<User> iUserList = new List<User>();
        User iUser = new User(
            ProfileId = profileId,
            LastName = 'last',
            Email = 'testEmail@wiz.com',
            Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ',
            Title = 'Usuario WIZ test',
            Alias = 'Wizzer',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser);

        User iUser2 = new User(
            ProfileId = profileId2,
            LastName = 'last2',
            Email = 'testEmail2@wiz.com',
            Username = 'wizeruser0002@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ2',
            Title = 'Usuario WIZ test2',
            Alias = 'Wizzer2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser2);

        insert iUserList;

        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Account iAccount = new Account(
                        FirstName = 'Conta',
                        LastName = 'Segurado',
                        IndividualIdentificationNumber__pc = '44154707698',
                        PersonEmail = 'teste@email.com',
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                        .get('PersonAccount')
                        .getRecordTypeId()
                    );
            
            insert iAccount;
            
            

            Contact iContact = new Contact();
            iContact.IndividualIdentificationNumber__c = '47635470866';
            iContact.LastName = 'LastName';
            insert iContact;

            User getUserOne = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com'];
            User getUserTwo = [SELECT Id FROM User WHERE Email = 'testEmail2@wiz.com'];
            Opportunity opp = new Opportunity(Name = 'Teste',StageName = 'Open',Amount = 0,OwnerId = getUserOne.Id,CloseDate = Date.today() + 3);
            insert opp;

            Product2 objProduct = new Product2(name = 'Teste',Family = 'Beneficios',ProductCode = '002');
            insert objProduct;

            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);
            insert objPricebookEntry;

            OpportunityLineItem objOppLineItem = new OpportunityLineItem(Product2Id = objProduct.Id,OpportunityId = opp.Id,Quantity = 2,PricebookEntryId = objPricebookEntry.Id,UnitPrice = 100);
            insert objOppLineItem;

            Case iCaseToInsert = new Case(RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId(),Description = 'Test Shared',Status = 'Novo pedido',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = getUserOne.Id,Opportunity__c = opp.Id);
            //insert iCaseToInsert;

            Case iCaseToInsert2 = new Case(RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId(),Description = 'Test Shared',Status = 'Novo pedido',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = groupId,Opportunity__c = opp.Id);
        }
        //insert iCaseToInsert2;
    }

    @isTest
    public static void changeOpportunityStagePlacementTest (){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Administrador'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Corporate - Benefícios - Gerente Regional'].Id;

        List<User> iUserList = new List<User>();
        User iUser = new User(
            ProfileId = profileId,
            LastName = 'last',
            Email = 'testEmail@wiz.com',
            Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ',
            Title = 'Usuario WIZ test',
            Alias = 'Wizzer',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser);

        User iUser2 = new User(
            ProfileId = profileId2,
            LastName = 'last2',
            Email = 'testEmail2@wiz.com',
            Username = 'wizeruser0002@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ2',
            Title = 'Usuario WIZ test2',
            Alias = 'Wizzer2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser2);

        insert iUserList;

        Account iAccount = new Account(
            FirstName = 'Conta',
            LastName = 'Segurado',
            IndividualIdentificationNumber__pc = '44154707698',
            PersonEmail = 'teste@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId()
        );
        insert iAccount;

        Contact iContact = new Contact(IndividualIdentificationNumber__c = '47635470866',LastName = 'LastName');
        insert iContact;

        SlaProcess slaProcessId = [SELECT Id FROM SlaProcess WHERE Name = 'corporatePlacementSLA' AND IsActive = true LIMIT 1];

        Entitlement entl = new Entitlement(Name='CorporatePlacementEntitlement', AccountId=iAccount.Id, SlaProcessId=slaProcessId.Id);
        insert entl;

        Opportunity opp = new Opportunity(Name = 'Teste',StageName = 'Open',Amount = 0,OwnerId = iUser.Id,CloseDate = Date.today() + 3);
        insert opp;

        Product2 objProduct = new Product2(name = 'Teste',Family = 'Beneficios',ProductCode = '002');
        insert objProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry objPricebookEntry = new PricebookEntry(Product2Id = objProduct.Id,PriceBook2Id = pricebookId,IsActive = true,UnitPrice = 100);

        insert objPricebookEntry;

        OpportunityLineItem objOppLineItem = new OpportunityLineItem(Product2Id = objProduct.Id,OpportunityId = opp.Id,Quantity = 2,PricebookEntryId = objPricebookEntry.Id,UnitPrice = 100);
        insert objOppLineItem;

        
        Case iCaseToInsert = new Case(Routed__c = true, RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Corporate - Célula Técnica').getRecordTypeId(),Description = 'Test Shared',Status = 'Novo pedido',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = iUser.Id,Opportunity__c = opp.Id);
        insert iCaseToInsert;
        


        Test.startTest();
        Case caseUpdated = [SELECT Id FROM Case WHERE RecordType.Name = 'Corporate - Célula Técnica' LIMIT 1];
        if(caseUpdated != null)
        {
            caseUpdated.Status = 'Análise de dados da oportunidade';
            update caseUpdated;
            caseUpdated.Status = 'Com pendência';
            update caseUpdated;
            caseUpdated.Status = 'Aguardando aprovação da cotação';
            update caseUpdated;
        }

        Test.stopTest();
    }

    @isTest
    static void caseMilestoneTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Integrador - PARCEIROS'].Id;
        Id profileId2 = [SELECT Id FROM Profile WHERE Name = 'Parceiros - Tickets'].Id;

        List<User> iUserList = new List<User>();
        User iUser = new User(
            ProfileId = profileId,
            LastName = 'last',
            Email = 'testEmail@wiz.com',
            Username = 'wizeruser000@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ',
            Title = 'Usuario WIZ test',
            Alias = 'Wizzer',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser);

        User iUser2 = new User(
            ProfileId = profileId2,
            LastName = 'last2',
            Email = 'testEmail2@wiz.com',
            Username = 'wizeruser0002@wiz.com' + System.currentTimeMillis(),
            CompanyName = 'WIZ2',
            Title = 'Usuario WIZ test2',
            Alias = 'Wizzer2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        iUserList.add(iUser2);

        insert iUserList;

        Account iAccount = new Account(
            FirstName = 'Conta',
            LastName = 'Segurado',
            IndividualIdentificationNumber__pc = '44154707698',
            PersonEmail = 'teste@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId()
        );
        insert iAccount;

        Contact iContact = new Contact();
        iContact.IndividualIdentificationNumber__c = '47635470866';
        iContact.LastName = 'LastName';
        insert iContact;

        User getUserOne = [SELECT Id FROM User WHERE Email = 'testEmail@wiz.com'];
        User getUserTwo = [SELECT Id FROM User WHERE Email = 'testEmail2@wiz.com'];

        SlaProcess slaProcessId = [SELECT Id FROM SlaProcess WHERE Name = 'Acessos PPW - Tickets' AND IsActive = true LIMIT 1];

        Entitlement entl = new Entitlement(Name='TestEntitlement', AccountId=iAccount.Id, SlaProcessId=slaProcessId.Id);
        insert entl;

        Case iCaseToInsert = new Case(RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId(),Description = 'Test Shared',Status = 'Aguardando atendimento',AccountId = iAccount.Id,ContactId = iContact.Id,OwnerId = getUserOne.Id,EntitlementId = entl.Id);

        insert iCaseToInsert;


        Test.startTest();
        Case caseUpdated = [SELECT Id FROM Case WHERE RecordType.DeveloperName LIKE '%_Tkt' LIMIT 1];
        caseUpdated.Status = 'Closed';
        update caseUpdated;
        Test.stopTest();
    }

    @isTest
    static void testCallDistribuite() {
        Profile profileADM = [SELECT Id FROM Profile WHERE Name = 'Administrador'];

        User userStandard = new User(
            LastName = 'testeadm',
            Email = 'teste123adm@gmail.com',
            Username = 'teste123admadm@gmail.com',
            Alias = 'testa',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = profileADM.Id,
            LanguageLocaleKey = 'pt_BR'
        );
        insert userStandard;


        Test.startTest();
        System.runAs(userStandard) {
            BeeTalkWhatsAppConsoleController.getInstance().DistribuiteCaseToOperador();
        }
        Test.stopTest();
    }


    static Case testInsert(){
        return CaseDataFactory.insertCase();
    }

    static Case testUpdate(Case caseVariable){
        update caseVariable;
        return caseVariable;
    }

    static Case testDelete(Case caseVariable){
        delete caseVariable;
        return caseVariable;
    }

    static Case testUndelete(Case caseVariable){
        undelete caseVariable;
        return caseVariable;
    }
}