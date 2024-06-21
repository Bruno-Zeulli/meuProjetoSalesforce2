public with sharing class GetConsegTabulationFlow {

    @InvocableMethod 
    public static List<VariavelDeRetorno> getTabulacao(List<VariavelDeEntrada> input){
        
        List<VariavelDeRetorno> tabulacaoConsegReturn = new  List<VariavelDeRetorno>();
        VariavelDeRetorno variavelRetorno = new VariavelDeRetorno();

        //Categoria (Category__c)
        if(input.get(0).Categoria.contains('Categoria')){
            Set<String> categoriaAuxSet = new Set<String>();
            List<DispositionPath__c> categoriasToReturn = new List<DispositionPath__c>();
                
            for(DispositionPath__c lstToIterate : [SELECT Category__c FROM DispositionPath__c WHERE UN__c = 'Conseg' AND UNProduct__c = '' ORDER BY Category__c ASC]){
                    if(!categoriaAuxSet.contains(lstToIterate.Category__c)){
                        categoriasToReturn.add(lstToIterate);
                        categoriaAuxSet.add(lstToIterate.Category__c);
                    }                     
            }
            variavelRetorno.tabulacaoRetorno = categoriasToReturn;
        }

        //Tabulação (Name)
        if(input.get(0).Categoria.contains('Tabulacao')){
            Set<String> tabulacaoAuxSet = new Set<String>();
            List<DispositionPath__c> tabulacaoToReturn = new List<DispositionPath__c>();
            String categoria = input.get(0).Tabulacao.get(0);
            system.debug('@BPS categoria: '+input.get(0).Tabulacao.get(0));
                
            for(DispositionPath__c lstToIterate : [SELECT Name FROM DispositionPath__c WHERE UN__c = 'Conseg' AND UNProduct__c = '' AND Category__c =: categoria  ORDER BY Category__c ASC]){
                    if(!tabulacaoAuxSet.contains(lstToIterate.Name)){
                        tabulacaoToReturn.add(lstToIterate);
                        tabulacaoAuxSet.add(lstToIterate.Name);
                    }                     
            }
            variavelRetorno.tabulacaoRetorno = tabulacaoToReturn;
        }

        tabulacaoConsegReturn.add(variavelRetorno);
        return tabulacaoConsegReturn;
    }

    public class VariavelDeRetorno{
        @InvocableVariable
        public List<DispositionPath__c> tabulacaoRetorno;
    }

    public class VariavelDeEntrada{
        @InvocableVariable
       public List<String> Categoria;

        @InvocableVariable
       public List<String> Tabulacao;
    
    }
}