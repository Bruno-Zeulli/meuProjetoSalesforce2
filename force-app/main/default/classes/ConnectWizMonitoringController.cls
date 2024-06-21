/**
 * @description       : Classe responsável por fazer a comunicação com o front end da página de acompanhamento
 * @author            : isaac.terceiros@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 26-11-2022
 * @last modified by  : isaac.terceiros@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   22-02-2021   isaac.terceiros@wizsolucoes.com.br  Initial Version
  */

public without sharing class ConnectWizMonitoringController {

    @AuraEnabled
    public static string validateQuote(String caseId,ConnectWizCMPTO.Proposta proposta){

        if(!String.isEmpty(proposta.dataDeEnvioParaSeguradora)){
            String dataEnvio = proposta.dataDeEnvioParaSeguradora;
            List<String> lstDataEnvio = dataEnvio.split('-' , 3);
            Date dataEnvioQuote = Date.newInstance( Integer.valueOf(lstDataEnvio[0]), Integer.valueOf(lstDataEnvio[1]),Integer.valueOf(lstDataEnvio[2]));
        }

        if(!String.isEmpty(proposta.dataDeRecebimentoDaSeguradora)){
            String dataRecebimento = proposta.dataDeRecebimentoDaSeguradora;
            List<String> lstDataRecebimento = dataRecebimento.split('-' , 3);
            Date dataRecebimentoQuote = Date.newInstance( Integer.valueOf(lstDataRecebimento[0]), Integer.valueOf(lstDataRecebimento[1]),Integer.valueOf(lstDataRecebimento[2]));
        }

        return proposta.seguradora + proposta.premio + proposta.importanciaSegurada + proposta.isValorDetalhado + proposta.isAddValorImportancia + proposta.valorLiquidoPremio +
        proposta.valorIOFPremio + proposta.importanciaSeguradaAdicional + proposta.importanciaSeguradaAdicional2 + proposta.porcentagemComissao +
        proposta.porcentagemAgenciamento + proposta.dataDeEnvioParaSeguradora + proposta.dataDeRecebimentoDaSeguradora + proposta.observacoes + ' 2';
    }

    @AuraEnabled
    public static Boolean insertQuote(String caseId,ConnectWizCMPTO.Proposta proposta){

        Boolean isQuoteInserted = ConnectWizMonitoringBO.insertQuote(caseId,proposta);
        return isQuoteInserted;
    }

    @AuraEnabled
    public static Boolean insertListQuote(String caseId,ConnectWizCMPTO.Proposta proposta){

        Boolean isQuoteInserted = ConnectWizMonitoringBO.insertListQuote(caseId,proposta);
        return isQuoteInserted;
    }

    @AuraEnabled
    public static Boolean updateQuote(ConnectWizCMPTO.Proposta proposta){

        Boolean isQuoteUpdated = ConnectWizMonitoringBO.updateQuote(proposta);
        return isQuoteUpdated;
    }

    @AuraEnabled
    public static Boolean deleteQuote(String quoteId){

        Boolean isQuoteDeleted = ConnectWizMonitoringBO.deleteQuote(quoteId);
        return isQuoteDeleted;
    }

    @AuraEnabled
    public static List<ConnectWizCMPTO.Proposta> retrieveQuotes(Id caseId){

        List<ConnectWizCMPTO.Proposta> lstPropostasToRender = ConnectWizMonitoringBO.retrieveQuotes(caseId);
        return lstPropostasToRender;
    }

    @AuraEnabled
    public static Opportunity getOpportunityByCaseId(Id caseId){
        Opportunity objOpportunity = ConnectWizMonitoringBO.getOpportunityByCaseId(caseId);
        return objOpportunity;
    }

    @AuraEnabled
    public static Case getCaseById(Id caseId){
        Case objCase = ConnectWizMonitoringBO.getCaseById(caseId);
        return objCase;
    }

    @AuraEnabled
    public static List<ConnectWizCMPTO.ContactDetail> getAccountByOpportunityId(Id opportunityId){
        List<ConnectWizCMPTO.ContactDetail> lstResponse = ConnectWizMonitoringBO.getAccountByOpportunityId(opportunityId);
        return lstResponse;
    }

    @AuraEnabled
    public static Boolean emitQuote(Id caseId){
        return ConnectWizMonitoringBO.emitQuote(caseId);
    }

    /**
     * @autor samuelsirkis@wiz.co
     * @descrition adicionando metodo para cancelar cotação
     * @param quotId
     * @return boolean
     */
    @AuraEnabled
    public static Boolean cancelQuote(String quoteId){
        Boolean isQuoteCancelled = ConnectWizMonitoringBO.cancelQuote(quoteId);
        return isQuoteCancelled;
    }
}