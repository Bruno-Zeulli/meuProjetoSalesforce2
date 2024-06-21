@isTest
public with sharing class ChangeOnwerInactiveUserControllerTest {
    @TestSetup
    static void makeData(){
        List<User> usuarios = new List<User>();
        Id profile = [SELECT Id FROM Profile WHERE Name = 'Administrador'].Id;
        for(Integer i = 0; i < 3; i++){
            usuarios.add(new User(
                ProfileId = profile,
                LastName = 'last'+i,
                Email = 'wizeruser000'+i+'@wiz.com',
                Username = 'wizeruser000'+i+'@wiz.com' + System.currentTimeMillis(),
                CompanyName = 'WIZ',
                Title = 'Usuario WIZ test',
                Alias = 'Wizzer'+i,
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            ));
        }
        insert usuarios;
        System.runAs(usuarios[0]){
            List<Account> contas = new List<Account>();
            for(Integer i = 0; i < 10; i++){
                Id recordTypePJ = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PJ').getRecordTypeId();
                String cnpj = PersonalInformationUtil.generateRandomCNPJ();
                contas.add(new Account(name = 'teste'+1, OwnerId = UserInfo.getUserId(), RecordTypeId = recordTypePJ, CompanyIdentificationNumber__c = cnpj, IdentificationNumber__c = cnpj));
            }
            insert contas;
            List<Opportunity> opps = new List<Opportunity>();
            for(Integer i = 0; i < 10; i++){
                opps.add(new Opportunity(
                    Name = 'Test'+i,
                    StageName = 'Aberta',
                    CloseDate = Date.today(), 
                    OwnerId = UserInfo.getUserId()
                ));
            }
            insert opps;
            List<Case> cases = new List<Case>();
            Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOComunicadoDeSinistro').getRecordTypeId();
                for(Integer i = 0; i < 10; i++){
                    cases.add(new Case(
                    Subject = 'Teste'+i,
                    Status = 'Open',
                    RecordTypeId = recordType,
                    OwnerId = UserInfo.getUserId()
                ));
            }
            insert cases;
        }
        
        usuarios[0].isActive = false;
        update usuarios[0];
    }
    @isTest
    public static void testUsuarios(){
        List<User> usuariosAtivos = ChangeOnwerInactiveUserController.obterAtivos();
        System.assertEquals(usuariosAtivos.size() > 0, true, 'Não há usuarios ativos');
        List<User> usuariosInativos = ChangeOnwerInactiveUserController.obterInativos();
        System.assertEquals(usuariosInativos.size() > 0, true, 'Não há usuarios inativos');
    }
    @isTest
    public static void testTransferirContas(){
        List<User> users = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = true];
        Set<id> ids = new Set<id>();
        String lst = '';
        for(User us : users){
            lst += us.Id+',';
            ids.add(us.Id);
        }
        User userInativo = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = false limit 1];

        Integer quantidadeContasTransferidas = ChangeOnwerInactiveUserController.transferirRegistrosInativos(userInativo.Id, lst, true, false, false);
        System.assertEquals(10, quantidadeContasTransferidas, 'Quantidade de contas transferidas errada');

        List<Account> contasTransferidas = [SELECT id,OwnerId, Owner.name from Account where OwnerId =: ids];
        Map<id, List<Account>> contasOwner = new Map<id, List<Account>>();
        for(Account acc : contasTransferidas){
            List<Account> contas = (contasOwner.get(acc.OwnerId) != null) ? contasOwner.get(acc.OwnerId) : new List<Account>();
            contas.add(acc);
            contasOwner.put(acc.OwnerId, contas);
            System.debug(acc.Owner.name);
        }
        System.debug(contasOwner);
        for(Id us : contasOwner.keyset()){
            System.assertEquals(5, contasOwner.get(us).size(), 'Não recebeu 5 contas!');
        }
    }
    @isTest
    public static void testTransferirCasos(){
        List<User> users = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = true];
        String lst = '';
        Set<id> ids = new Set<id>();
        for(Integer i = 0; i < users.size(); i++){
            lst += users[i].Id+',';
        }
        System.debug(lst);
        User userInativo = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = false limit 1];
        Integer quantidadeCasosTransferidas = ChangeOnwerInactiveUserController.transferirRegistrosInativos(userInativo.Id, lst, false, false, true);
        System.assertEquals(10, quantidadeCasosTransferidas, 'Quantidade de casos transferidos errada');

        List<Case> casosTransferidas = [SELECT id,OwnerId from Case where OwnerId =: ids];
        Map<id, List<Case>> casosOwner = new Map<id, List<Case>>();
        for(Case cs : casosTransferidas){
            List<Case> casos = (casosOwner.get(cs.OwnerId) != null) ? casosOwner.get(cs.OwnerId) : new List<Case>();
            casos.add(cs);
            casosOwner.put(cs.OwnerId, casos);
        }
        for(Id us : casosOwner.keyset()){
            System.assertEquals(5, casosOwner.get(us).size(), 'Não recebeu 5 casos!');
        }
    }
    @isTest
    public static void testTransferirOpp(){
        List<User> users = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = true];
        Set<id> ids = new Set<id>();
        String lst = '';
        for(Integer i = 0; i < users.size(); i++){
            lst += users[i].Id+',';
        }
        User userInativo = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = false limit 1];
        Integer quantidadeOppTransferidas = ChangeOnwerInactiveUserController.transferirRegistrosInativos(userInativo.Id, lst, false, true, false);
        System.assertEquals(10, quantidadeOppTransferidas, 'Quantidade de oportunidades transferidas errada');

        List<Opportunity> oppsTransferidas = [SELECT id,OwnerId from Opportunity where OwnerId =: ids];
        Map<id, List<Opportunity>> oppsOwner = new Map<id, List<Opportunity>>();
        for(Opportunity cs : oppsTransferidas){
            List<Opportunity> opps = (oppsOwner.get(cs.OwnerId) != null) ? oppsOwner.get(cs.OwnerId) : new List<Opportunity>();
            opps.add(cs);
            oppsOwner.put(cs.OwnerId, opps);
        }
        for(Id us : oppsOwner.keyset()){
            System.assertEquals(5, oppsOwner.get(us).size(), 'Não recebeu 5 oportunidades!');
        }
    }
    @isTest
    public static void testTransferirTodos(){
        List<User> users = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = true];
        String lst = '';
        for(Integer i = 0; i < users.size(); i++){
            lst += users[i].Id+',';
        }
        User userInativo = [SELECT Id, isActive FROM User WHERE Title = 'Usuario WIZ test' and isActive = false limit 1];

        Integer quantidadeTransferidas = ChangeOnwerInactiveUserController.transferirRegistrosInativos(userInativo.Id, lst, true, true, true);
        System.assertEquals(30, quantidadeTransferidas, 'Quantidade de regitros transferidos errado');
    }
}