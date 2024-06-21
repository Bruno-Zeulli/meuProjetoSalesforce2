@isTest
public class SlaCounterControllerTest {
    
    @TestSetup
    static void setup(){
        
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
        
        SlaProcess iSlaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Acessos PPW - Tickets' ORDER BY VersionNumber DESC LIMIT 1];
        Entitlement iEntitlement = new Entitlement();
        iEntitlement.Name = 'Teste Entitlement';
        iEntitlement.StartDate = Date.Today();
        iEntitlement.SlaProcessId = iSlaProcess.Id;
        iEntitlement.AccountId = iAccount.Id;
        insert iEntitlement;
        
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId();
        Case caso = new Case(
            Subject = 'Teste Chat',
            Description = 'Test chat',
            Origin = 'App',
            Type = 'Chat',
            Status = 'Em atendimento',
            Priority = 'High',
            RecordTypeId = recordType,
            EntitlementId = iEntitlement.Id
        );
        insert caso;
    }
    
    @isTest
    static void testVerifySlaEmAtendimento(){
        
        Test.startTest();
        Case iCase = [SELECT Id FROM Case WHERE Subject = 'Teste Chat' LIMIT 1];
        SlaCounterController.getCaseMilestone(iCase.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testVerifySlaResolvido(){
        
        Test.startTest();
        Case iCase = [SELECT Id FROM Case WHERE Subject = 'Teste Chat' LIMIT 1];
        iCase.Status = 'Resolvido';
        update iCase;
        SlaCounterController.getCaseMilestone(iCase.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testVerifySlaReabertoSolicitante(){
        
        Test.startTest();
        Case iCase = [SELECT Id FROM Case WHERE Subject = 'Teste Chat' LIMIT 1];
        iCase.Status = 'Reaberto pelo solicitante ';
        update iCase;
        SlaCounterController.getCaseMilestone(iCase.Id);
        Test.stopTest();
    }
    
}