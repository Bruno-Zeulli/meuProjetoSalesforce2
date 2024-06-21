@isTest
public class filterDispositionPathFlowCategoryTest {
    @TestSetup
    static void makeData(){
        DispositionPath__c category1Sub1 = new DispositionPath__c();
        category1Sub1.Name = 'Teste 1';
        category1Sub1.Reason__c = 'Teste 1';
        category1Sub1.Category__c = 'Category 1';
        category1Sub1.Subcategory__c = 'Subcategory 1' ;

        DispositionPath__c category1Sub2 = new DispositionPath__c();
        category1Sub2.Name = 'Teste 2';
        category1Sub2.Reason__c = 'Teste 2';
        category1Sub2.Category__c = 'Category 1';
        category1Sub2.Subcategory__c = 'Subcategory 2' ;

        DispositionPath__c category1Sub3 = new DispositionPath__c();
        category1Sub3.Name = 'Teste 3';
        category1Sub3.Reason__c = 'Teste 3';
        category1Sub3.Category__c = 'Category 1';
        category1Sub3.Subcategory__c = 'Subcategory 2';

        insert new List<DispositionPath__c>{category1Sub1, category1Sub2, category1Sub3};
    }

    @isTest
    public static void filterDispositionPathCategoryInvocableTest(){

        filterDispositionPathFlowCategory.InputBO inputCategory = new filterDispositionPathFlowCategory.InputBO();
        inputCategory.filteredCategories =  new List<String>{'Category 1'};
        inputCategory.categoryOrSubcategory = 'category';

        filterDispositionPathFlowCategory.InputBO inputSubcategory = new filterDispositionPathFlowCategory.InputBO();
        inputSubcategory.filteredCategories =  new List<String>{'Subcategory 2'};
        inputSubcategory.categoryOrSubcategory = 'subcategory';

        Test.startTest();
            List<filterDispositionPathFlowCategory.RetornoBO> retornoCategory =  filterDispositionPathFlowCategory.filterDispositionPathCategoryInvocable(new List<filterDispositionPathFlowCategory.InputBO>{inputCategory});
            List<DispositionPath__c> tabulacoesCategory = retornoCategory[0].filteredDispositionPaths;
            System.assertEquals(false , tabulacoesCategory.isEmpty(), 'A lista retornada veio vazia');
            System.assertEquals(1, tabulacoesCategory.size(), 'Retornou mais de uma tabulação com a mesma categoria');

            List<filterDispositionPathFlowCategory.RetornoBO> retornoSubcategory =  filterDispositionPathFlowCategory.filterDispositionPathCategoryInvocable(new List<filterDispositionPathFlowCategory.InputBO>{inputSubcategory});
            List<DispositionPath__c> tabulacoesSubcategory = retornoSubcategory[0].filteredDispositionPaths;
            System.assertEquals(false , tabulacoesSubcategory.isEmpty(), 'A lista retornada veio vazia');
            System.assertEquals(1, tabulacoesSubcategory.size(), 'Retornou mais de uma tabulação com a mesma subcategoria');
        Test.stopTest();
    }
}