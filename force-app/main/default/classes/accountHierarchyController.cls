public class accountHierarchyController
{
    @invocableMethod
    public static list<ReturnVariables> accountHierarchyFilter (List<InputVariables> InputVariables)
    {
     	 //Listas
        List<Account> accountFiliais = new List<Account>();
        List<Account> accountFiliaisDeFiliais = new List<Account>();
        List<Account> allAccounts = new List<Account>();
        List<String> accountFiliaisIds = new List<String>();
         List<String> lstTextoFormatado = new List<String>();

        //Variaveis
        String idMatriz = InputVariables.get(0).IdMatriz.get(0);
        Account matriz = new Account();
        String textoFormatado;
        //
         //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();

        matriz = [SELECT Id, ParentId, Name, IdentificationNumber__c	 FROM Account WHERE Id =: idMatriz LIMIT 1];
        accountFiliais = [SELECT Id, ParentId, Name, IdentificationNumber__c	 FROM Account WHERE ParentId =: idMatriz];

        allAccounts.add(matriz);

        for(Account ac : accountFiliais)
        {
            accountFiliaisIds.add(ac.Id);
            allAccounts.add(ac);
        }

        if(!accountFiliaisIds.isEmpty())
        {
            accountFiliaisDeFiliais = [SELECT Id, ParentId, Name, IdentificationNumber__c	 FROM Account WHERE ParentId IN : accountFiliaisIds];
        }

         if(!accountFiliaisDeFiliais.isEmpty())
        {
        	    for(Account ac : accountFiliaisDeFiliais)
                {
                    allAccounts.add(ac);
                }
        }

        textoFormatado = 'Matriz: ' + matriz.Name + ' - CNPJ: ' + matriz.IdentificationNumber__c;

       textoFormatado += '\n\n';

        for(Account ac_filho : accountFiliais)
        {
            textoFormatado += 'Filial: ' + ac_filho.Name + ' - CNPJ: ' + ac_filho.IdentificationNumber__c ;
            for(Account ac_neto : accountFiliaisDeFiliais)
            {
                if(ac_neto.ParentId == ac_filho.Id)
                {
                    textoFormatado += '\n\t - ' + ac_neto.Name + ' - CNPJ: ' + ac_neto.IdentificationNumber__c;
                }
            }
            textoFormatado += '\n\n';
        }




     	 lstTextoFormatado.add(textoFormatado);

        retorno.textoFormatado = lstTextoFormatado;
        retorno.accountsReturn = allAccounts;

        retornoList.add(retorno);
        return retornoList;
    }

    public class InputVariables
    {
        @InvocableVariable
        public List<String> IdMatriz;
    }

    public class ReturnVariables
    {
        @InvocableVariable
        public List<String> textoFormatado;

        @InvocableVariable
        public List<Account> accountsReturn;
    }
}