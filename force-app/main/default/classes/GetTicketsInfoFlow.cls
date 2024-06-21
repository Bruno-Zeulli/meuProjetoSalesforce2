public class GetTicketsInfoFlow 
{
	@InvocableMethod 
    public static List<VariavelDeRetorno> getProdutosTickets(List<VariavelDeEntrada> input)
    {
        List<VariavelDeRetorno> produtosTicketsReturn = new  List<VariavelDeRetorno>();
        VariavelDeRetorno variavelRetorno = new VariavelDeRetorno();
        
        //Produto
        if(input.get(0).flag.contains('Produto'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
                   
                for(DispositionPath__c lstToIterate : [SELECT Product__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Product__c != 'CGI Wimo' ORDER BY Product__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.Product__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.Product__c);
                      }                     
                }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
        	}  
        
         //Bandeira
        if(input.get(0).flag.contains('Bandeira'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
            	String produto = input.get(0).Produto.get(0);
                   
                for(DispositionPath__c lstToIterate : [SELECT UNProduct__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Product__c =: produto ORDER BY UNProduct__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.UNProduct__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.UNProduct__c);
                      }                     
                }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
        	}
        
        //Grupo
        if(input.get(0).flag.contains('Grupo'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
            	String produto = input.get(0).Produto.get(0);
           		String bandeira = input.get(0).Bandeira.get(0);
                   
                for(DispositionPath__c lstToIterate : [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND UNProduct__c =: bandeira AND Product__c =:produto  ORDER BY Group__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.Group__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.Group__c);
                      }                     
                }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
        	} 
        
        //Motivo
        if(input.get(0).flag.contains('Motivo'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
            	String grupo = input.get(0).Grupo.get(0);
           		
                   
                for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:grupo ORDER BY Category__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.Category__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.Category__c);
                      }                     
                }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
        	}
        
        //Tipo
        if(input.get(0).flag.contains('Tipo'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
            	String grupo = input.get(0).Grupo.get(0);
           		String motivo = input.get(0).Motivo.get(0);
           		
                   
                for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c, Disposition__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:grupo AND Category__c =:motivo  ORDER BY Disposition__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.Disposition__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.Disposition__c);
                      }                     
                }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
        	}
        
        //Subtipo
        if(input.get(0).flag.contains('Subtipo'))
        {
            	Set<String> produtoAuxSet = new Set<String>();
        		List<DispositionPath__c> produtosToReturn = new List<DispositionPath__c>();
            	String grupo = input.get(0).Grupo.get(0);
           		String motivo = input.get(0).Motivo.get(0);
            	String tipo = input.get(0).Tipo.get(0);
           		
                   
                for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c, Disposition__c, SpecificReason__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:grupo AND Category__c =:motivo AND Disposition__c =:tipo  ORDER BY Disposition__c ASC])
                {
                      if(!produtoAuxSet.contains(lstToIterate.SpecificReason__c))
                      {
                          produtosToReturn.add(lstToIterate);
                          produtoAuxSet.add(lstToIterate.SpecificReason__c);
                      }                     
                }
            
            String flagSubtipo = 'False';
              List<String> flagSubtipolst =  new List<String>();
            
            if(produtoAuxSet.isEmpty())
            {
                flagSubtipo = 'True';
            }
            
            	 variavelRetorno.produtosDeRetorno = produtosToReturn;
            	flagSubtipolst.add(flagSubtipo);
            variavelRetorno.flagSubtipo = flagSubtipolst;
        	} 
        
       
        produtosTicketsReturn.add(variavelRetorno);
        return produtosTicketsReturn;
    }
    
    public class VariavelDeRetorno
    {
        @InvocableVariable
        public List<DispositionPath__c> produtosDeRetorno;
        
        @InvocableVariable
        public List<String> flagSubtipo;
    }
    
    public class VariavelDeEntrada
    {
        @InvocableVariable
       public List<String> Flag;
        
         @InvocableVariable
       public List<String> Produto;
        
        @InvocableVariable
       public List<String> Bandeira;
        
        @InvocableVariable
       public List<String> Grupo;
        
         @InvocableVariable
       public List<String> Motivo;
        
         @InvocableVariable
       public List<String> Tipo;
    }
}