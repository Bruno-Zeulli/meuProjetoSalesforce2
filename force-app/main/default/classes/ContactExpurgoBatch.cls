global class ContactExpurgoBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
      String query  = Utils.retornarQueryAccountsAnything();
            
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Account> contas){
        List<Account> contasSemVinculo = ExpurgoBO.getInstance().verificarContasSemVinculo(contas);
        List<Contact> contatosSemViculo = ExpurgoBO.getInstance().pegarContatosPorContasIds(contasSemVinculo);

        delete contatosSemViculo;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('expurgo finalizado com sucesso!');
        AccountExpurgoBatch batch = new AccountExpurgoBatch();
        Id batchId = Database.executeBatch(batch, 10000);
    }    
}