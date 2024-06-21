global class AccountExpurgoBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query  = Utils.retornarQueryAccountsAnything();
        
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Account> contas){
        List<Account> contasSemVinculo = ExpurgoBO.getInstance().verificarContasSemVinculo(contas);

        contasSemVinculo = ExpurgoBO.getInstance().verificarContatosFilhosPossuiCasosERetirarDaLista(contasSemVinculo);

        delete contasSemVinculo;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('expurgo finalizado com sucesso!');
    }    
}