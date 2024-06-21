public class beetalk_calculateBusinessHours_contact
{
    @invocableMethod
    public static list<ReturnVariables> calculateBusinessHours(List<InputVariables> InputVariables)
    {
        //Listas
        List<Boolean> flagUltrapassouOlimite = new List<Boolean>();
     
        //Variaveis
        Datetime endDate = Datetime.now();
        Datetime startDate = Datetime.now();
        Timezone tz = Timezone.getTimeZone('GMT-3');
        Long bsHours = 0;
        boolean ultrapassouOLimite = false;
        
        //Query 
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Chatbot Encerramento de Caso'];
        
        //Calcula o EndDate 
        endDate = endDate.addSeconds(tz.getOffset(endDate) / 1000);
        
        //Calcula a diferenca do BH
        bsHours = BusinessHours.diff(bh.Id, InputVariables.get(0).dateMessage.get(0), endDate);
        
        //Verifica se a data esta correta
        if(bsHours > 28800000)
        {
        	ultrapassouOLimite = true;
        }
        
        flagUltrapassouOlimite.add(ultrapassouOLimite);

        //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();

        //Preencher variaveis de retorno
        retorno.ultrapassouOLimite = flagUltrapassouOlimite;

        retornoList.add(retorno);
        return retornoList;
    }

    public class InputVariables
    {
   		@InvocableVariable
        public List<Datetime> dateMessage;
    }

    public class ReturnVariables
    {
         @InvocableVariable
        public List<Boolean> ultrapassouOLimite;
    }
}