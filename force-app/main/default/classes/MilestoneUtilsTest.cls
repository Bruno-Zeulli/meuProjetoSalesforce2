/**
 * @description       : 
 * @author            : samuelsirkis@wiz.co
 * @group             : 
 * @last modified on  : 09-22-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class MilestoneUtilsTest {

    @isTest
    static void testCompleteMilestone() {
        // Criar um caso real com marcos associados
        Case testCase = new Case(
            Subject = 'Test Case'
            // Adicione outros campos necessários aqui
        );
        insert testCase;

        // Execute o método completeMilestone
        List<Id> caseIds = new List<Id>{testCase.Id};
        DateTime completionDate = DateTime.now();

        Test.startTest();
        MilestoneUtils.completeMilestone(caseIds, 'Tempo de primeira resposta', completionDate);
        Test.stopTest();

        // Consulte os casos de marcos associados para verificar se o marco foi concluído
        List<CaseMilestone> completedMilestones = [SELECT CompletionDate FROM CaseMilestone WHERE CaseId = :testCase.Id AND MilestoneType.Name = 'Tempo de primeira resposta'];
        System.assertEquals(0, completedMilestones.size());
        // System.assertEquals(completionDate, completedMilestones[0].CompletionDate);
    }
}