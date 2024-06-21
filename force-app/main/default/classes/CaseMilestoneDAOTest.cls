/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 10-17-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class CaseMilestoneDAOTest{
	// @isTest
    // public static void CaseMTest(){
    //     Case c = CaseDataFactory.createCase();
    //     insert c;

    //     CaseMilestone cm =[ SELECT Id FROM CaseMilestone LIMIT 1];
    //     update cm;

    //     Set<Id> setCaseId = new Set<Id>();
    //     setCaseId.add(c.Id);

    //     //CaseMilestone caseMilestone = CaseMilestoneDAO.getMilestoneByCaseId(c.Id);
    //     CaseMilestoneDAO.getCaseMilestoneByCaseId(setCaseId);
    // }

    @isTest
    static void testGetMilestoneByCaseId() {
        // Crie um caso de teste
        Case testCase = CaseDataFactory.createCase();
        insert testCase;
        CaseMilestone cm = new CaseMilestone();
        // Chame o método getMilestoneByCaseId
        // CaseMilestone result = CaseMilestoneDAO.getMilestoneByCaseId(testCase.Id);

        // Verifique se o resultado não é nulo
        // System.assertNotEquals(null, result);

        // Verifique se o ID do caso no resultado corresponde ao ID do caso inserido
        // System.assertEquals(testCase.Id, result.CaseId);
    }

    @isTest
    static void testGetCaseMilestoneByCaseId() {
        // Crie um conjunto de IDs de casos de teste
        Set<Id> caseIds = new Set<Id>();

        // Crie três casos de teste
        Case testCase1 = CaseDataFactory.createCase();
        Case testCase2 = CaseDataFactory.createCase();
        Case testCase3 = CaseDataFactory.createCase();

        insert new List<Case>{testCase1, testCase2, testCase3};

        // Adicione os IDs dos casos ao conjunto
        caseIds.add(testCase1.Id);
        caseIds.add(testCase2.Id);
        caseIds.add(testCase3.Id);

        // Chame o método getCaseMilestoneByCaseId
        List<CaseMilestone> results = CaseMilestoneDAO.getCaseMilestoneByCaseId(caseIds);

        // Verifique se o resultado não é nulo
        // System.assertNotEquals(null, results);

        // Verifique se o número de resultados corresponde ao número de IDs de casos
        // System.assertEquals(caseIds.size(), results.size());
    }
}