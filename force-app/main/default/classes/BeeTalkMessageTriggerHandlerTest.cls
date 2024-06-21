@isTest
private class BeeTalkMessageTriggerHandlerTest {
    @isTest
    static void testCallDistribuite(){

        Profile profileADM = [SELECT Id FROM Profile WHERE Name = 'Administrador'];

        User userStandard = new User(
            LastName = 'testeadm',
            Email = 'teste123adm@gmail.com',
            Username = 'teste123adm@gmail.com',
            Alias = 'testa',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = profileADM.Id,
            LanguageLocaleKey = 'pt_BR'
        );
        insert userStandard;

        // Criação de uma mensagem de teste
        beetalk__Message__c testMessage = new beetalk__Message__c();
        insert testMessage;

        // Inicialização da classe de teste
        BeeTalkMessageTriggerHandler handler = new BeeTalkMessageTriggerHandler(true);

        // Execução do método de teste
        Test.startTest();
        System.runAs(userStandard){
            handler.callDistribuite();
        }
        Test.stopTest();

        // Verificação dos resultados
        // Coloque aqui as asserções relevantes para verificar o comportamento esperado do método callDistribuite()
        // Exemplo:
        // System.assertEquals(expectedValue, actualValue, 'Mensagem de erro caso a asserção falhe');
    }
}