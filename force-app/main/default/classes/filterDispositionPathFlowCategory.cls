/**
 * @description       : Cria tabulação dentro da Genesys (recebe o CampaignId)
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 27-10-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class filterDispositionPathFlowCategory {

    @InvocableMethod(label='Filter Tabulation equal Category' description='Filtra as tabulações que possuem as mesmas categorias')
    public static List<RetornoBO> filterDispositionPathCategoryInvocable(List<InputBO> categoryList){
        List<RetornoBO> retorno = new List<RetornoBO>();
        Map<String, DispositionPath__c> firstTabulationsByCategory = new Map<String, DispositionPath__c>();

        List<String> categories = categoryList[0].filteredCategories;
        String verify = categoryList[0].categoryOrSubcategory;

        if(verify == 'category'){

            for (DispositionPath__c tabulation : [SELECT Id, Category__c, Subcategory__c, Reason__c
                                                FROM DispositionPath__c
                                                WHERE Category__c IN :categories])
            {
                String category = tabulation.Category__c.substring(0, 1).toUpperCase() + tabulation.Category__c.substring(1).toLowerCase();
                if (!firstTabulationsByCategory.containsKey(category)) {
                    firstTabulationsByCategory.put(category, tabulation);
                }
            }

            retorno.add(new RetornoBO(new List<DispositionPath__c>(firstTabulationsByCategory.values())));

        }else if(verify == 'subcategory'){

            for (DispositionPath__c tabulation : [SELECT Id, Category__c, Subcategory__c, Reason__c
                                                FROM DispositionPath__c
                                                WHERE Subcategory__c IN :categories])
            {
                String subCategory = tabulation.Subcategory__c.substring(0, 1).toUpperCase() + tabulation.Subcategory__c.substring(1).toLowerCase();
                if (!firstTabulationsByCategory.containsKey(subCategory)) {
                    firstTabulationsByCategory.put(subCategory, tabulation);
                }
            }

            retorno.add(new RetornoBO(new List<DispositionPath__c>(firstTabulationsByCategory.values())));
        }

        return retorno;
    }

    public class InputBO{
        @InvocableVariable
        public List<String> filteredCategories;
        @InvocableVariable
        public String categoryOrSubcategory;
    }

    public class RetornoBO{
        @InvocableVariable
        public List<DispositionPath__c> filteredDispositionPaths;

        public RetornoBO(List<DispositionPath__c> dispositions){
            this.filteredDispositionPaths = dispositions;
        }
    }
}