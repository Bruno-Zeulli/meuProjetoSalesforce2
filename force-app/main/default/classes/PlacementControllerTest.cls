@isTest
public class PlacementControllerTest {
    @testSetup static void setup() {
        
        Group gp = new Group(Name='CORPORATIVO_TEST', Type = 'Queue', DeveloperName='TEST');
        insert gp;
        
        Id p = [SELECT Id FROM Profile WHERE Name='Administrador'].id;
        
        Account ac = new Account(name ='Test Account', CompanyIdentificationNumber__c = '14343271000154') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='Test Contact',AccountId = ac.Id);
        insert con;  
        
        Date dToday = Date.today();
        String dateStr = dToday.year() + '/' + dToday.month() + '/' + dToday.day();
        List<User> users = new List<User>();
        User usuario = new User(alias = 'test123', email='test123@noemail.com',
                                emailencodingkey='UTF-8', firstname='test',  lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p, country='United States',IsActive = true,
                                BusinessUnit__c = 'CORPORATIVO',
                                timezonesidkey='America/Los_Angeles', username='tester'+dateStr+'@wizcorp.com');

        users.add(usuario);

        User testUser = new User(
        Alias = 'testuser',
        Email = 'testuser@wizcorp.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'TestUser',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        Profileid = p,
        IsActive = true,
        BusinessUnit__c = 'CORPORATIVO',
        TimeZoneSidKey = 'America/Los_Angeles',
        UserName = 'testuser@wizcorp.com'
        );
        users.add(testUser);
        
        insert users;
    }
    
    @isTest
    static void getQuoteRequests()
    {
        
        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];

        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;
        
        Group gp = [SELECT Id, Name FROM Group WHERE Name = 'CORPORATIVO_TEST'];
        GroupMember gpm = new GroupMember(GroupId=gp.Id, UserOrGroupId=usuario.Id);
        insert gpm;
        
        System.runAs(usuario)
        {
                        
            Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;
            
            Product2 prod = new Product2();
            prod.Name = 'Teste';
            prod.Family = 'Garantia';
            prod.ProductCode = '10101010';
            prod.IsActive = true;
            insert prod;
            
            Pricebook2 priceb = new Pricebook2();
            priceb.Name = 'Pricebook Teste';
            priceb.IsActive = true;
            insert priceb;
            
            Id standardPB = Test.getStandardPricebookId();
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.isActive = true;
            pbe.Pricebook2Id = standardPB;
            pbe.Product2Id = prod.Id;
            pbe.UnitPrice = 10;
            insert pbe;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 1;
            oli.TotalPrice = 10;
            oli.PricebookEntryId = pbe.Id;
            insert oli;
            
            Case caso = new Case();
            caso.Status = 'Novo pedido';
            caso.OwnerId = usuario.Id;
            caso.Opportunity__c = opp.Id;
            caso.RecordTypeId = caseRecordTypeId;
            insert caso;
            
            Task t = new Task();
            t.WhatId = caso.Id;
            insert t;
            
            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Name = 'TESTE';
            q.QuoteReceiptDate__c = Date.newInstance(2023, 11, 20);
            q.QuoteRequestDate__c = Date.newInstance(2023, 11, 5);
            insert q;

            Quote q2 = new Quote();
            q2.OpportunityId = opp.Id;
            q2.Name = 'TESTE 2';
            q2.QuoteRequestDate__c = Date.newInstance(2023, 11, 5);
            insert q2;
            
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.Product2Id = prod.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 10;
            qli.PricebookEntryId = pbe.Id;
            insert qli;

            QuoteLineItem qli2 = new QuoteLineItem();
            qli2.QuoteId = q2.Id;
            qli2.Product2Id = prod.Id;
            qli2.Quantity = 1;
            qli2.UnitPrice = 10;
            qli2.PricebookEntryId = pbe.Id;
            insert qli2;
            
            DocumentType__c docType = DocumentTypeDataFactory.insertDocumentType('Teste Type', '0123456');
            DocumentChecklist__c checklist = DocumentChecklistDataFactory.insertDocumentChecklistBeneficios(opp.Id);

            checklist.DocumentType__c = docType.id;
            update checklist;

            DocumentUpload__c docUpload = new DocumentUpload__c(
                Name = 'Teste type.txt',
                Objects__c = 'Opportunity',
                DocumentType__c = docType.id,
                ExternalUrl__c = 'https://wizcorphml001.blob.core.windows.net/documentos/b32b4e3661ba.docx',
                IdObjeto__c = opp.id,
                IsDeleted__c = false,
                Status__c = 'Accepted'
            );
            insert docUpload;
            
            PlacementController.getQuoteRequests();
            /* PlacementController.getUsersInfo();
            PlacementController.updateOwnerCaseFromPlacement(caso.Id, usuario.Id, 'New');
            PlacementController.getCaseStatus(Caso.Id);
            PlacementController.getCaseInfo(Caso.Id);
            PlacementController.getOpportunity(opp.Id);
            PlacementController.updateStageOpportunity(opp.Id, 'Open');
            PlacementController.getTaskHistory(t.WhatId);
            PlacementController.createTaskHistory(null,null,null,null,null);
            PlacementController.deleteTaskHistory(t.Id);
            PlacementController.updateCaseFromPlacement(caso.Id, null, null); */
        }

    }

    @isTest
    static void testUpdateOwnerCaseFromPlacement() {

        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;

        Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = usuario.Id
        );
        insert testCase;

        // Atualização do proprietário do caso
        Boolean result = PlacementController.updateOwnerCaseFromPlacement(testCase.Id, testUser.Id, 'Repique');

        // Verificação do resultado
        System.assertEquals(true, result, 'O método updateOwnerCaseFromPlacement não retornou true');

        // Recuperação do caso atualizado para verificação
        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(testUser.Id, updatedCase.OwnerId, 'O proprietário do caso não foi atualizado corretamente');
    }

    @isTest
    static void testUpdateOwnerCaseFromPlacementError() {

        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;

        Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = usuario.Id
        );
        insert testCase;

        System.debug('testCase abaixo');
        System.debug(testCase);

        // Tentativa de atualização do proprietário do caso com um ID diferente do caso inserido
        Boolean result = PlacementController.updateOwnerCaseFromPlacement(opp.id, testUser.Id, 'erro de status');

        // Verificação do resultado
        System.assertEquals(false, result, 'O método updateOwnerCaseFromPlacement não retornou false quando recebeu um Status de caso inexistente');
    }

    @isTest
    static void testUpdateOwnerCaseFromPlacementHeader() {

        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;

        Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = usuario.Id
        );
        insert testCase;

        // Atualização do proprietário do caso
        Boolean result = PlacementController.updateOwnerCaseFromPlacementHeader(testCase.Id, testUser.Id);

        // Verificação do resultado
        System.assertEquals(true, result, 'O método updateOwnerCaseFromPlacement não retornou true');

        // Recuperação do caso atualizado para verificação
        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(testUser.Id, updatedCase.OwnerId, 'O proprietário do caso não foi atualizado corretamente');
    }


    @isTest
    static void testCreateTaskHistory() {
        
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;

        Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = testUser.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = testUser.Id
        );
        insert testCase;

        // Chamar o método createTaskHistory
        Task createdTask = PlacementController.createTaskHistory(
            testCase.Id, // ID do registro ao qual a tarefa está associada
            testUser.Id, // ID do usuário associado à tarefa
            'Test Task', // Assunto da tarefa
            'This is a test task created for unit testing.', // Descrição da tarefa
            'Pendência' // Tipo da tarefa
        );

        // Verificação do resultado
        System.assertNotEquals(null, createdTask, 'O método createTaskHistory não retornou uma tarefa');
        System.assertEquals('Test Task', createdTask.Subject, 'O assunto da tarefa não foi definido corretamente');
        System.assertEquals(testCase.Id, createdTask.WhatId, 'A tarefa não está associada ao registro correto');
        System.assertEquals(testUser.Id, createdTask.WhoId, 'A tarefa não está associada ao usuário correto');
    }

    @isTest
    static void testUpdateCaseFromPlacement() {

        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;

        Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = usuario.Id
        );
        insert testCase;

        // Atualização do proprietário do caso
        Boolean result = PlacementController.updateCaseFromPlacement(testCase.Id, 'teste', 'Repique');

        // Verificação do resultado
        System.assertEquals(true, result, 'O método UpdateCaseFromPlacement não retornou true');

        // Recuperação do caso atualizado para verificação
        Case updatedCase = [SELECT Status FROM Case WHERE Id = :testCase.Id];
        System.assertEquals('Repique', updatedCase.Status, 'O Status do caso não foi atualizado corretamente');
    }

    @isTest
    static void testGetUserQueueInfo() {

        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];

        Group gp = [SELECT Id, Name FROM Group WHERE Name = 'CORPORATIVO_TEST'];
        GroupMember gpm = new GroupMember(GroupId=gp.Id, UserOrGroupId=testUser.Id);
        insert gpm;

        List<Map<String, String>> queueInfoList = PlacementController.getUserQueueInfo(testUser.Id);

        System.assertNotEquals(0, queueInfoList.size(), 'O usuário não está associado a nenhuma fila.');

        for (Map<String, String> queueInfo : queueInfoList) {
            System.assertNotEquals(null, queueInfo.get('NomeFila'), 'O nome da fila não foi retornado.');
            System.assertNotEquals(null, queueInfo.get('IdFila'), 'O ID da fila não foi retornado.');
        }
    }

    @isTest
    static void testGetUsersFromQueue() {

        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];

        // Recupera o ID de um grupo (fila) que foi criado no método setup()
        Group testQueue = [SELECT Id FROM Group WHERE Name = 'CORPORATIVO_TEST'];
        GroupMember gpm = new GroupMember(GroupId=testQueue.Id, UserOrGroupId=testUser.Id);
        insert gpm;

        // Cria uma lista com o ID da fila para passar como parâmetro para o método getUsersFromQueue
        List<Id> queueIds = new List<Id>{testQueue.Id};

        // Chama o método getUsersFromQueue com a lista de IDs de fila
        Map<String, List<Map<String, String>>> usersFromQueue = PlacementController.getUsersFromQueue(queueIds);

        // Verifica se o mapa retornado não está vazio, indicando que foram encontrados usuários associados à fila
        System.assertNotEquals(0, usersFromQueue.size(), 'Nenhum usuário foi encontrado associado à fila.');

        // Verifica se as informações dos usuários retornadas estão corretas
        // Este é um exemplo de verificação, você pode precisar ajustá-lo de acordo com os dados esperados
        for (String queueName : usersFromQueue.keySet()) {
            List<Map<String, String>> userList = usersFromQueue.get(queueName);
            System.assertNotEquals(0, userList.size(), 'A lista de usuários para a fila ' + queueName + ' está vazia.');

            for (Map<String, String> userInfo : userList) {
                System.assertNotEquals(null, userInfo.get('userId'), 'O ID do usuário não foi retornado.');
                System.assertNotEquals(null, userInfo.get('userName'), 'O nome do usuário não foi retornado.');
            }
        }
    }

    @isTest
    static void testGetInfoForHeader() {

        Account acc = [SELECT id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;
        
        Opportunity opp = new Opportunity(
            Name = 'Teste',
            StageName = 'Open',
            Amount = 0,
            OwnerId = testUser.Id,
            AccountId = acc.Id,
            CloseDate = Date.today() + 3
        );          
        insert opp;

        Product2 prod = new Product2();
        prod.Name = 'Teste';
        prod.Family = 'Garantia';
        prod.ProductCode = '10101010';
        prod.IsActive = true;
        insert prod;
            
        Pricebook2 priceb = new Pricebook2();
        priceb.Name = 'Pricebook Teste';
        priceb.IsActive = true;
        insert priceb;
        
        Id standardPB = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.isActive = true;
        pbe.Pricebook2Id = standardPB;
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 10;
        insert pbe;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 10;
        oli.PricebookEntryId = pbe.Id;
        insert oli;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = testUser.Id
        );
        insert testCase;

        // Chama o método getInfoForHeader com os IDs do caso e da oportunidade
        Map<String, Object> caseInfo = PlacementController.getInfoForHeader(testCase.Id, opp.Id);

        // Verifica se o mapa retornado não está vazio e contém as chaves esperadas
        System.assertNotEquals(0, caseInfo.size(), 'O mapa retornado está vazio.');
        System.assert(caseInfo.containsKey('OwnerName'), 'O mapa não contém a chave OwnerName.');
        System.assert(caseInfo.containsKey('AccountName'), 'O mapa não contém a chave AccountName.');
        System.assert(caseInfo.containsKey('Status'), 'O mapa não contém a chave Status.');
        System.assert(caseInfo.containsKey('CompanyIdentificationNumber'), 'O mapa não contém a chave CompanyIdentificationNumber.');
        System.assert(caseInfo.containsKey('OpportunityNumber'), 'O mapa não contém a chave OpportunityNumber.');
        System.assertEquals('Test Account', caseInfo.get('AccountName'), 'O nome da conta não é o esperado.');
        System.assertEquals('Novo pedido', caseInfo.get('Status'), 'O nome da conta não é o esperado.');
    }

    @isTest
    static void testPostInChatter() {

        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];

        Opportunity opp = new Opportunity(
            Name = 'Teste',
            StageName = 'Open',
            Amount = 0,
            OwnerId = testUser.Id,
            CloseDate = Date.today() + 3
        );          
        insert opp;
        
        String testObservation = 'Esta é uma observação de teste para postar no Chatter.';

        Test.startTest();
        try {
            PlacementController.postInChatter(opp.Id, testObservation);
            System.assert(true, 'O método postInChatter foi chamado sem erros.');
        } catch (Exception e) {
            System.assert(false, 'O método postInChatter lançou uma exceção: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testGetCaseHistoryByIds() {
        
        Account acc = [SELECT id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@wizcorp.com'];
        Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'CorporateCelulaTecnica' LIMIT 1].id;
        
        Opportunity opp = new Opportunity(
            Name = 'Teste',
            StageName = 'Open',
            Amount = 0,
            OwnerId = testUser.Id,
            AccountId = acc.Id,
            CloseDate = Date.today() + 3
        );          
        insert opp;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'Novo pedido',
            RecordTypeId = caseRecordTypeId,
            Opportunity__c = opp.Id,
            OwnerId = testUser.Id
        );
        insert testCase;

        List<CaseHistory> caseHistory = new List<CaseHistory>();
        caseHistory.add(new CaseHistory(CaseId = testCase.id, Field = 'Status'));
        caseHistory.add(new CaseHistory(CaseId = testCase.id, Field = 'Owner', DataType = 'Text'));
        insert caseHistory;

        Task task = new Task(
             Subject = 'testSubject',
             WhatId = opp.Id,
             Type = 'Pendência',
             Priority = 'Normal',
             Status = 'Open'
        );
        insert task;
        
        Test.startTest(); 
        PlacementController.postInChatter(opp.Id, 'Mensagem teste');
        Test.stopTest();

        String caseHistoryJson = PlacementController.getCaseHistoryByIds(testCase.Id, opp.Id);
        System.assertNotEquals(null, caseHistoryJson, 'A string JSON retornada está vazia.');
    }
    @isTest
    static void testgetUserInfos(){
        User usuario = [SELECT Id, FirstName, LastName FROM User WHERE Email = 'test123@noemail.com'];
        String fullName = usuario.FirstName + ' ' + usuario.LastName;
        Map<String, String> userInfos = PlacementController.getUserInfos(usuario.Id);
        
        System.assertEquals(fullName, userInfos.get('Name'));
    }
    
    @isTest
    static void testLogoutUser() {
        String orgUrl = URL.getOrgDomainURL().toExternalForm() + '/secur/logout.jsp';
        String urlReceived = PlacementController.logoutUser();
        Assert.areEqual(orgUrl, urlReceived);
    }

}