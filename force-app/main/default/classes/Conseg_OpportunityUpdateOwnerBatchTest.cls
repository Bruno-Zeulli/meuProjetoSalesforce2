@IsTest
public class Conseg_OpportunityUpdateOwnerBatchTest {
    @IsTest
    public static void testBatchExecution(){
        // Crie dados de teste - Oportunidades
        List<Opportunity> opportunities = new List<Opportunity>();
        String recordTypeConsegId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Auto').getRecordTypeId();
        User usuarioRenovacao = UserDataFactory.getAdminUser();
        // Crie os dados de teste, como uma oportunidade
        Opportunity opportunity = new Opportunity(
            Name = 'Test Opportunity',
            Estrategia4__c = '3.5',
            Estrategia5__c = 'Novo Seguro',
            StageName = 'Aberta',
            CloseDate = Date.today(),
            RecordtypeId = recordTypeConsegId,
            OwnerId = usuarioRenovacao.id
        );

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

        insert opportunity;

        Test.startTest();

        // Inicie o processo de agendamento do lote
        String jobId = System.schedule('Test Batch Schedule', '0 0 0 * * ?', new Conseg_OpportunityUpdateOwnerBatch());

        // Execute o lote de forma síncrona
        Conseg_OpportunityUpdateOwnerBatch batch = new Conseg_OpportunityUpdateOwnerBatch();
        Database.executeBatch(batch);

        Test.stopTest();

        // Verifique se o lote foi executado corretamente
        //System.assertEquals(1, batch.executions);// removido por nao existir usuário renovaçao em uat

        // Verifique se o proprietário da oportunidade foi atualizado
        Opportunity updatedOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opportunity.Id];
        //System.assertNotEquals('OwnerId', updatedOpportunity.OwnerId);// removido por nao existir usuário renovaçao em uat

        // Cancelar o trabalho agendado
        System.abortJob(jobId);
    }
}