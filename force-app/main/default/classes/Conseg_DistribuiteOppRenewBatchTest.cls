@IsTest
public class Conseg_DistribuiteOppRenewBatchTest{
    @IsTest
    public static void testBatchExecution(){
        // Crie dados de teste - Oportunidades
        List<Opportunity> opportunities = new List<Opportunity>();
        String recordTypeConsegId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Conseg').getRecordTypeId();
        User usuarioRenovacao = UserDataFactory.getAdminUser();
        usuarioRenovacao.BusinessUnit__c = 'CONSEG';
        usuarioRenovacao.CommunityNickname = 'usuarioRenovacao';
        update usuarioRenovacao;
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
        opp1.Type ='ReNew';
        opportunities.add(opp1);

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Oportunidade 2';
        opp2.Estrategia5__c = 'Renovação outra corretora';
        opp2.Estrategia4__c = '7.2';
        opp2.StageName = 'Aberta';
        opp2.CloseDate = Date.today();
        opp2.RecordtypeId = recordTypeConsegId;
        opp2.OwnerId = usuarioRenovacao.id;
        opp2.Type ='ReNew';
        opportunities.add(opp2);

        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Oportunidade 3';
        opp3.Estrategia5__c = 'Renovação da própria corretora';
        opp3.Estrategia4__c = '12.8';
        opp3.StageName = 'Aberta';
        opp3.CloseDate = Date.today();
        opp3.RecordtypeId = recordTypeConsegId;
        opp3.OwnerId = usuarioRenovacao.id;
        opp3.Type ='ReNew';
        opportunities.add(opp3);

        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Oportunidade 3';
        opp4.Estrategia5__c = 'Renovação da própria corretora';
        opp4.Estrategia4__c = '12.8';
        opp4.StageName = 'Aberta';
        opp4.CloseDate = Date.today();
        opp4.RecordtypeId = recordTypeConsegId;
        opp4.OwnerId = usuarioRenovacao.id;
        opp4.Type ='ReNew';
        opportunities.add(opp4);

        insert opportunity;

        Test.startTest();

        // Inicie o processo de agendamento do lote
        String jobId = System.schedule('Test Batch Schedule', '0 0 0 * * ?', new Conseg_DistribuiteOppRenewBatch());

        // Execute o lote de forma síncrona
		Database.executeBatch(new Conseg_DistribuiteOppRenewBatch(), 200);
        Conseg_DistribuiteOppRenewBatch.schedule();
        Test.stopTest();

        // Verifique se o proprietário da oportunidade foi atualizado
        Opportunity updatedOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opportunity.Id];

        // Cancelar o trabalho agendado
        System.abortJob(jobId);
    }
}