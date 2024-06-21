/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-20-2022
 * @last modified by  : viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2022   viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class OpportunityDeleteBatchTest {

    @isTest
    static void testOpportunityDeletion(){
        Opportunity oppInsert = new Opportunity();
        oppInsert.StageName = 'Aberto';
        oppInsert.Name = 'Test opp 123412412412412412412412';
        oppInsert.Type = 'MechanicalWarranty';
        oppInsert.CloseDate = Date.today().addDays(30);
        oppInsert.CreatedDate = Date.today().addDays(-33);
        oppInsert.LastModifiedDate = Date.today().addDays(-33);
        oppInsert.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Conseg').getRecordTypeId();
        insert oppInsert;

        Date dateTest = Date.today().addDays(-33);

        List<Opportunity> oppteste = new List<Opportunity>([SELECT Id, StageName, Name, CreatedDate, LastModifiedDate FROM Opportunity WHERE Name = 'Test Opp 123412412412412412412412' LIMIT 1]);
        System.debug(oppInsert.CreatedDate);
        System.debug(oppInsert.LastModifiedDate);
        
        // Inicia o processo em lote
        Test.startTest();
        OpportunityDeleteSchedule.schedule();
        OpportunityDeleteBatch batch = new OpportunityDeleteBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        // Verifica se a oportunidade foi excluída
        System.debug(oppteste);

        List<Opportunity> opp = new List<Opportunity>([SELECT Id, StageName FROM Opportunity WHERE RecordType.Name = 'Conseg' AND Type = 'MechanicalWarranty' AND CreatedDate > :dateTest AND LastModifiedDate > :dateTest AND StageName = 'Aberto' LIMIT 1]);
        System.assertEquals(0, opp.size(), 'A oportunidade não foi excluída');
    }
}