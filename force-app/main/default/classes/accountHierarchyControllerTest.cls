/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-04-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class accountHierarchyControllerTest {
    @isTest
    static void testHierarchy()
    {
        accountHierarchyController.InputVariables ah = new accountHierarchyController.InputVariables();
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ());
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;
        insert acc;

         Account acc2 = new Account(Name = 'Teste 02', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ());
         acc2.CompanyIdentificationNumber__c = acc2.IdentificationNumber__c;
         acc2.ParentId = acc.Id;
        insert acc2;

        Account acc3 = new Account(Name = 'Teste 03', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ());
         acc3.CompanyIdentificationNumber__c = acc3.IdentificationNumber__c;
         acc3.ParentId = acc2.Id;
        insert acc3;

       List<String> lstIdMatriz = new List<String>();
        lstIdMatriz.add(acc.Id);
        ah.IdMatriz = lstIdMatriz;
        List<accountHierarchyController.InputVariables> lstAh = new List<accountHierarchyController.InputVariables>();
        lstAh.add(ah);
        accountHierarchyController.accountHierarchyFilter(lstAh);
    }
}