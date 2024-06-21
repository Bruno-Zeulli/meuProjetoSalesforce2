@isTest
public class GetConsegTabulationFlowTest {
    
    @isTest
    static void getProdutos()
    {   
        DispositionPath__c tab = new DispositionPath__c();
        tab.UN__c = 'Conseg';
        tab.UNProduct__c = '';
        tab.Category__c = 'Tentativa de Contato';
        tab.Name = 'Jornada automática';
        insert tab;
        
        GetConsegTabulationFlow.VariavelDeEntrada varEntrada = new GetConsegTabulationFlow.VariavelDeEntrada();
        List<String> categoria = new List<String>();
        List<String> tabulacao = new List<String>();
        
        List<GetConsegTabulationFlow.VariavelDeEntrada> varEntradaList = new  List<GetConsegTabulationFlow.VariavelDeEntrada>();
        categoria.add('Categoria');
        categoria.add('Tabulacao');
        
        varEntrada.Categoria = categoria;
        
        tabulacao.add('Tentativa de Contato');
        varEntrada.Tabulacao = tabulacao;
        
        varEntradaList.add(varEntrada);
        
        GetConsegTabulationFlow.getTabulacao(varEntradaList);
    }
    
}