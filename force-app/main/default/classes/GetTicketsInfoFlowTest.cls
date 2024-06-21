@isTest
public class GetTicketsInfoFlowTest 
{
	@isTest
    static void getProdutos()
    {   
        DispositionPath__c tab = new DispositionPath__c();
        tab.UN__c = 'Parceiros';
        tab.Product__c = 'Consórcio';
        tab.UNProduct__c = 'CNP';
        tab.Group__c = 'Qualidade';
        tab.Category__c = 'Elogio';
        insert tab;
        
        GetTicketsInfoFlow.VariavelDeEntrada varEntrada = new GetTicketsInfoFlow.VariavelDeEntrada();
        List<String> produto = new List<String>();
        List<String> produto2 = new List<String>();
        List<String> bandeira = new List<String>();
        List<String> grupo = new List<String>();
         List<String> motivo = new List<String>();
         List<String> tipo  = new List<String>();
        
       List< GetTicketsInfoFlow.VariavelDeEntrada> varEntradaList = new  List<GetTicketsInfoFlow.VariavelDeEntrada>();
        produto.add('Produto');
        produto.add('Bandeira');
       produto.add('Grupo');
        produto.add('Motivo');
        produto.add('Tipo');
        produto.add('Subtipo');
        
        varEntrada.Flag = produto;
        
		produto2.add('Consórcio');
        varEntrada.Produto = produto2;
        
        bandeira.add('CNP');
         varEntrada.Bandeira = bandeira;
        
       grupo.add('Qualidade');
        varEntrada.Grupo = grupo;
                
        motivo.add('Elogio');
        varEntrada.Motivo = motivo;
        
       tipo.add('Elogio Atendimento');
        varEntrada.Tipo = tipo;
        
        varEntradaList.add(varEntrada);
               
        GetTicketsInfoFlow.getProdutosTickets(varEntradaList);
    }
}