public class getObjectNameFromId 
{
	@invocableMethod
    public static list<ReturnVariables> getObjectName (List<InputVariables> InputVariables)
    {
        System.debug('InputVariables: '+InputVariables);
        System.debug('InputVariables.get(0): '+InputVariables.get(0));
        System.debug('InputVariables.get(0).recordId.get(0): '+InputVariables.get(0).recordId.get(0));
        
        //Variaveis
        Id recordId = InputVariables.get(0).recordId.get(0);
        String sObjName = '';
        List<String> retornoString = new List<String>();
        
        //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();
        
        //Pegar o nome do Objeto e adiciona na lista
        sObjName = recordId.getSObjectType().getDescribe().getName();
        retornoString.add(sObjName);
        
        retorno.objectName = retornoString;
        
        retornoList.add(retorno);
        return retornoList;
    }
    
    public class InputVariables
    {
        @InvocableVariable
        public List<Id> recordId;
    }

    public class ReturnVariables
    {
        @InvocableVariable
        public List<String> objectName;
    }
    
}