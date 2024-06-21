@IsTest
private class Conseg_OpportunityBOTest {
    @IsTest
    static void testDistributeOpportunity(){
        // Crie dados de teste - Oportunidades
        List<Opportunity> opportunities = new List<Opportunity>();
        String recordTypeConsegId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Auto').getRecordTypeId();
        User usuarioRenovacao = UserDataFactory.getAdminUser();
        // Crie as oportunidades de teste
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Oportunidade 1';
        opp1.Estrategia5__c = 'Novo Seguro';
        opp1.Estrategia4__c = '3.5';
        opp1.StageName = 'Aberta';
        opp1.CloseDate = Date.today();
        opp1.RecordtypeId = recordTypeConsegId;
        opp1.OwnerId = usuarioRenovacao.id;
        opportunities.add(opp1);

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Oportunidade 2';
        opp2.Estrategia5__c = 'Renovação outra corretora';
        opp2.Estrategia4__c = '7.2';
        opp2.StageName = 'Aberta';
        opp2.CloseDate = Date.today();
        opp2.RecordtypeId = recordTypeConsegId;
        opp2.OwnerId = usuarioRenovacao.id;
        opportunities.add(opp2);

        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Oportunidade 3';
        opp3.Estrategia5__c = 'Renovação da própria corretora';
        opp3.Estrategia4__c = '12.8';
        opp3.StageName = 'Aberta';
        opp3.CloseDate = Date.today();
        opp3.RecordtypeId = recordTypeConsegId;
        opp3.OwnerId = usuarioRenovacao.id;
        opportunities.add(opp3);

        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Oportunidade 3';
        opp4.Estrategia5__c = 'Renovação da própria corretora';
        opp4.Estrategia4__c = '12.8';
        opp4.StageName = 'Aberta';
        opp4.CloseDate = Date.today();
        opp4.RecordtypeId = recordTypeConsegId;
        opp4.OwnerId = usuarioRenovacao.id;
        opportunities.add(opp4);


        // Execute o método que deseja testar
        Test.startTest();
        insert opportunities;
        List<Opportunity> updatedOpportunities = Conseg_OpportunityBO.distributeOpportunity(opportunities, 'Conseg_Renovacao');
        Test.stopTest();

        // Verifique os resultados
        // Adicione aqui as verificações necessárias para garantir que as oportunidades tenham sido distribuídas corretamente

        // Exemplo de verificação simples
        // System.assertEquals(opportunities.size(), updatedOpportunities.size(), 'A lista de oportunidades atualizadas deve ter o mesmo tamanho que a lista de oportunidades de entrada');

        // Exemplo de verificação adicional
        // Adicione aqui verificações personalizadas com base nas regras de distribuição e nos dados de teste

        // Realize mais verificações conforme necessário
    }
}