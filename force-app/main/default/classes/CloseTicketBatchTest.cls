@isTest
public class CloseTicketBatchTest 
{
	@isTest
    static void testCloseTicketBatch()
    {
        List<Case> testCase = new List<Case>();
        Case c = new Case();
        c.Status = 'New';
        c.EmResolucao_Tkt__c = true;
        insert c;
        testCase.add(c);
        
        closeTicketBatch batch = new closeTicketBatch();
        Database.BatchableContext bc;
        batch.start(bc);

        // Execute o batch manualmente
        batch.execute(bc, testCase);
    }
}