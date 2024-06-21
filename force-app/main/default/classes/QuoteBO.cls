/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class QuoteBO {
    /**
    * @description declaração de variaveis */
    private static final QuoteBO INSTANCE = new QuoteBO();

    /**
    * @description constroi a instancia da classe QuoteBO
    * @return instancia da classe QuoteBO
    */
    public static QuoteBO getInstance(){
        return INSTANCE;
    }

    /**
    * @description realiza a atualizacao das cotações remanecentes em um opp para o status de 'NEGADO'
    * @param opportunityId, quoteIdAccepted
    */
    public void updateRemainingQuotes(String opportunityId, string quoteIdAccepted){
        List<Quote> lstQuoteUpdate = new List<Quote>();
        String msgErrorSubject = 'Erro ao tentar atualizar o status da cotação';
        String whereCondition = 'WHERE opportunityId = \'' + opportunityId + '\' AND Id != \'' + quoteIdAccepted + '\'';

        List<Quote> lstQuote = QuoteDAO.getInstance().getAllFields(whereCondition);

        for(Quote objQuote : lstQuote){
            lstQuoteUpdate.add(new Quote(
                Id = objQuote.Id, 
                Status = 'Denied'
            ));            
        }

        if(!lstQuoteUpdate.isEmpty()){

            Savepoint sp = Database.setSavepoint();

            try{
                Database.SaveResult[] srListFiles = Database.update(lstQuoteUpdate, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstQuoteUpdate);  
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }
}