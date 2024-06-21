@isTest
public with sharing class TicketsControllerTest {
      @testSetup
    static void setup(){
      Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId();
        Case caso = new Case(
            Subject = 'Teste Chat',
            Description = 'Test chat',
            Origin = 'App',
            Type = 'Chat',
            Status = 'Comunicado Aberto',
            Priority = 'High',
            RecordTypeId = recordType
        );

        insert caso;
        
        DispositionPath__c iDispositionPath1 = new DispositionPath__c();
        iDispositionPath1.Product__c = 'UN';
        iDispositionPath1.UNProduct__c = 'Tickets';
        iDispositionPath1.UN__c = 'Parceiros';
        iDispositionPath1.Group__c = 'Pagamentos / Cobranças';
        iDispositionPath1.Category__c = 'Reclamação';
        iDispositionPath1.Disposition__c = 'Aumento de Parcela';
        iDispositionPath1.Name = 'Aumento de Parcela';
        iDispositionPath1.Reason__c = 'Aumento de Parcela';
        iDispositionPath1.SpecificReason__c = 'Discordancia nos valores ajustados';
        
        insert iDispositionPath1;
        
        Id recordTypePJ = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PJ').getRecordTypeId();
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ(), RecordTypeId = recordTypePJ);
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;

        insert acc;
        
        Contact contato = new Contact();
        contato.LastName = 'Teste Contact';
        contato.AccountId = acc.Id;
        insert contato;

        Id recordTypeContact = Schema.SObjectType.ContactDetail__c.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

        ContactDetail__c contactDetail = new ContactDetail__c(
            Name = 'Teste',
            Source__c = 'Concierge',
            //Contact__c = contact.Id,
            MobilePhone__c = '61984609897',
            HomePhone__c = '6132746636',
            Email__c = 'teste@teste.com',
            Street__c = 'Street',
            District__c = 'District',
            City__c = 'Brasilia',
            State__c = 'DF',
            Contact__c = contato.Id,
            PostalCode__c = '70293050',
            Country__c = 'Brasil',
            DoNotMarketing__c = false,
            ConsentDate__c = System.today(),
            DoNotCall__c = false,
            DoNotSendMessage__c = false,
            HasOptedOutOfEmail__c = false,
            ShouldForget__c = false,
            RecordTypeId = recordTypeContact
        );

        insert contactDetail;
        

    }

    @isTest
    static void testGetCase(){
        Test.startTest();
             String ticketStr = TicketsController.getTickets();
        Test.stopTest();

        System.assert(ticketStr != null, true);

    }

    @isTest
    static void getUserOrGroupIdsTest(){
       Test.startTest();
             String userOrGroups = TicketsController.getUserOrGroupIds();
        Test.stopTest();

        System.assert(userOrGroups != null, true);
    }

    @isTest
    static void getRecordTypeTicketlistTest(){
       Test.startTest();
             List<RecordType> lstRecordTypes = TicketsController.getRecordTypeTicketlist();
        Test.stopTest();

        System.assert(lstRecordTypes != null, true);
    }

    @isTest
    static void getRecordTypeIdByGrupoNameTest(){
       Test.startTest();
             String recordTypeSpecific = TicketsController.getRecordTypeIdByGrupoName('Acessos PPW');
        Test.stopTest();

        System.assert(recordTypeSpecific != null, true);
    }
    
    @isTest
    static void updateRecordTypeTest(){
        Case iCaseToUpdate = [SELECT Id, RecordTypeId FROM Case WHERE Subject = 'Teste Chat'];
        Id recordTypeIdToUpdate = TicketsController.getRecordTypeIdByGrupoName('PPW');
        Test.startTest();
        TicketsController.updateRecordType(recordTypeIdToUpdate, iCaseToUpdate.Id);
        Case iCaseToVerify = [SELECT Id, RecordTypeId FROM Case WHERE Subject = 'Teste Chat'];
        Test.stopTest();
        
        System.assertEquals(iCaseToVerify.RecordTypeId, recordTypeIdToUpdate);
    }
    
    @isTest
    static void getRecordTypeNameTest(){
        Case iCaseToVerify = [SELECT Id, RecordTypeId FROM Case WHERE Subject = 'Teste Chat'];
        String recordTypeSpecific = TicketsController.getRecordTypeIdByGrupoName('Acessos PPW');
        Test.startTest();
        TicketsController.getRecordTypeName(iCaseToVerify.Id);
        Test.stopTest();
        
        System.assertEquals(iCaseToVerify.RecordTypeId, recordTypeSpecific);
    }
    
    @isTest
    static void getProdutoOptionsTest(){
        Test.startTest();
        TicketsController.getProdutoOptions();
        Test.stopTest();
        
        System.assertNotEquals(null, [SELECT Product__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Product__c ASC]);
        
    }
    
    @isTest
    static void getBandeiraOptionsTest(){
        String produtoSelected = [SELECT Product__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Product__c ASC LIMIT 1].Product__c;
        Test.startTest();
        TicketsController.getBandeiraOptions(produtoSelected);
        Test.stopTest();
        
        System.assertNotEquals(null, [SELECT UNProduct__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY UNProduct__c ASC]);
        
    }
    
    @isTest
    static void getGroupOptionsTest(){
        String produtoSelected = [SELECT Product__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Product__c ASC LIMIT 1].Product__c;
        String bandeiraSelected = [SELECT UNProduct__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY UNProduct__c ASC LIMIT 1].UNProduct__c;
        Test.startTest();
        TicketsController.getGroupOptions(produtoSelected, bandeiraSelected);
        Test.stopTest();
        
        System.assertNotEquals(null, [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Group__c ASC]);
        
    }
    
    @isTest
    static void getMotivoOptionsTest(){
        String groupSelected = [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Group__c ASC LIMIT 1].Group__c;
        Test.startTest();
        TicketsController.getMotivoOptions(groupSelected);
        Test.stopTest();
    }
    
    @isTest
    static void getTipoOptionsTest(){
        String groupSelected = [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Group__c ASC LIMIT 1].Group__c;
        String motivoSelected = [SELECT Category__c, Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupSelected ORDER BY Category__c ASC LIMIT 1].Category__c;
        Test.startTest();
        TicketsController.getTipoOptions(groupSelected, motivoSelected);
        Test.stopTest();
    }
    
    @isTest
    static void getSubtipoOptionsTest(){
        String groupSelected = [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' ORDER BY Group__c ASC LIMIT 1].Group__c;
        String motivoSelected = [SELECT Category__c, Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupSelected ORDER BY Category__c ASC LIMIT 1].Category__c;
        String tipoSelected = [SELECT Category__c, Group__c, Disposition__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupSelected AND Category__c =:motivoSelected  ORDER BY Disposition__c ASC LIMIT 1].Disposition__c;
        Test.startTest();
        TicketsController.getSubtipoOptions(groupSelected, motivoSelected, tipoSelected);
        Test.stopTest();
    }
    
    @isTest
    static void createTaskTest(){
        Case iCaseToVerify = [SELECT Id FROM Case WHERE Subject = 'Teste Chat'];
        Contact iContactToVerify = [SELECT Id FROM Contact WHERE LastName = 'Teste Contact'];
		Test.startTest();
        TicketsController.createTask(iContactToVerify.Id, iCaseToVerify.Id, 'Case Test', 'Aumento de Parcela', 'Pagamentos / Cobranças', 'Reclamação', 'Discordancia nos valores ajustados', 'Consórcio', 'CNP');
        Test.stopTest();
    }
    
    @isTest
    static void verifyTasksTest(){
        Case iCaseToVerify = [SELECT Id FROM Case WHERE Subject = 'Teste Chat'];
		Test.startTest();
        TicketsController.verifyTasks(iCaseToVerify.Id);
        Test.stopTest();
    }
    
    @isTest
    static void getTicketsAtribuicaoTest(){
		Test.startTest();
        TicketsController.getTicketsAtribuicao(UserInfo.getUserId());
        Test.stopTest();
    }
    
    @isTest
    static void atribuirTicketsTest(){
        List<Case> caseToAtribuition = [SELECT Id, OwnerId FROM Case WHERE Subject = 'Teste Chat'];
        List<String> lstCase = new List<String>();
        for(Case iCaseToAtribuition : caseToAtribuition){
            lstCase.add(iCaseToAtribuition.Id);
        }
        Test.startTest();
        TicketsController.atribuirTickets(lstCase, UserInfo.getUserId());
        Test.stopTest();
    }
    
}