global class ContactDetailExpurgoBatch implements Database.Batchable<sObject> {
        global Database.QueryLocator start(Database.BatchableContext bc){
            String query  = Utils.retornarQueryAccountsAnything();
            
            return Database.getQueryLocator(query);
            
        }
        global void execute(Database.BatchableContext bc, List<account> contas){
            
            List<Account> contasSemVinculo = ExpurgoBO.getInstance().verificarContasSemVinculo(contas);
            List<Contact> contatosSemViculo = ExpurgoBO.getInstance().pegarContatosPorContasIds(contasSemVinculo);
            List<ContactDetail__c> contatosDetalhesSemVinculo = ExpurgoBO.getInstance().pegarContatosDetalhesPorContatosIds(contatosSemViculo);

            delete contatosDetalhesSemVinculo;


        }    
        global void finish(Database.BatchableContext bc){
            System.debug('expurgo finalizado com sucesso!');
            ContactExpurgoBatch batch = new ContactExpurgoBatch();
            Id batchId = Database.executeBatch(batch, 100000);
        }    
}