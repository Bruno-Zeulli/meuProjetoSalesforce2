/**
 * @description       : Classe responsável por executar a regra de negócio da página de acompanhamento
 * @author            : isaac.terceiros@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 26-11-2022
 * @last modified by  : isaac.terceiros@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   22-02-2021   isaac.terceiros@wizsolucoes.com.br  Initial Version
  */
public without sharing class ConnectWizMonitoringBO {

    public static Boolean insertListQuote(String caseId,ConnectWizCMPTO.Proposta proposta){

        List<Quote> lstQuoteToInsert = new List<Quote>();

        Opportunity parentOpportunity = OpportunityDAO.getOpportunitiesByCaseId(caseId);
        for(String objSeguradora : proposta.seguradoras){
            System.debug(objSeguradora);
            Quote quoteToInsert = new Quote();
            quoteToInsert.Company__c = objSeguradora;
            quoteToInsert.PrizeAmount__c = String.isEmpty(proposta.premio) ? null :Double.valueOf(proposta.premio);
            quoteToInsert.InsuredAmount__c = String.isEmpty(proposta.importanciaSegurada) ? null :Double.valueOf(proposta.importanciaSegurada);
            quoteToInsert.AdditionalInsuredAmount__c = String.isEmpty(proposta.importanciaSeguradaAdicional) ? null :Double.valueOf(proposta.importanciaSeguradaAdicional);
            quoteToInsert.AdditionalInsuredAmount2__c = String.isEmpty(proposta.importanciaSeguradaAdicional2) ? null :Double.valueOf(proposta.importanciaSeguradaAdicional2);

            if(!String.isEmpty(proposta.dataDeEnvioParaSeguradora)){
                String dataEnvio = proposta.dataDeEnvioParaSeguradora;
                List<String> lstDataEnvio = dataEnvio.split('-' , 3);
                Date dataEnvioQuote = Date.newInstance( Integer.valueOf(lstDataEnvio[0]), Integer.valueOf(lstDataEnvio[1]),Integer.valueOf(lstDataEnvio[2]));
                quoteToInsert.QuoteRequestDate__c = dataEnvioQuote;
            }

            if(!String.isEmpty(proposta.dataDeRecebimentoDaSeguradora)){
                String dataRecebimento = proposta.dataDeRecebimentoDaSeguradora;
                List<String> lstDataRecebimento = dataRecebimento.split('-' , 3);
                Date dataRecebimentoQuote = Date.newInstance( Integer.valueOf(lstDataRecebimento[0]), Integer.valueOf(lstDataRecebimento[1]),Integer.valueOf(lstDataRecebimento[2]));
                quoteToInsert.QuoteReceiptDate__c = dataRecebimentoQuote;
            }
            quoteToInsert.Description = proposta.observacoes;
            quoteToInsert.Status = proposta.status;
            quoteToInsert.OpportunityId = parentOpportunity.Id;
            quoteToInsert.RecordTypeId = proposta.recordTypeId;

            lstQuoteToInsert.add(quoteToInsert);
        }

        List<Id> quotesInsertedId = new List<Id>();
        Database.SaveResult[] srQuote = Database.insert(lstQuoteToInsert, false);
        for(Database.SaveResult sr : srQuote){
            if(sr.isSuccess()){
                System.debug('Successfully inserted Quote. Quote ID: ' + sr.getId());
                quotesInsertedId.add(sr.getId());

            }else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Quote fields that affected this error: ' + err.getFields());
                }
            }
        }
        insertListQuoteLineItem(quotesInsertedId,parentOpportunity.Id,proposta);
        if(quotesInsertedId.size() == lstQuoteToInsert.size()){
            return true;
        }else{
            return false;
        }
    }

    public static Boolean insertListQuoteLineItem(List<Id> lstQuoteId,Id opportunityId,ConnectWizCMPTO.Proposta proposta){

        List<QuoteLineItem> lstQuoteLineItensToInsert = new List<QuoteLineItem>();

        OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();
        objOpportunityLineItem = OpportunityLineItemDAO.getOpportunityLineItensByOpportunityId(opportunityId);

        for(Id quoteId : lstQuoteId){
            QuoteLineItem quoteLineItemToInsert = new QuoteLineItem();

            quoteLineItemToInsert.CommissionPercent__c = String.isEmpty(proposta.porcentagemComissao) ? null : Decimal.valueOf(proposta.porcentagemComissao);
            quoteLineItemToInsert.UnitPrice = String.isEmpty(proposta.premio) ? 0 : Decimal.valueOf(proposta.premio);
            quoteLineItemToInsert.Quantity = 1;
            quoteLineItemToInsert.PrizeNetValue__c = String.isEmpty(proposta.valorLiquidoPremio) ? null : Decimal.valueOf(proposta.valorLiquidoPremio);
            quoteLineItemToInsert.IOFPrizeValue__c = String.isEmpty(proposta.valorIOFPremio) ? null : Decimal.valueOf(proposta.valorIOFPremio);
            quoteLineItemToInsert.AgencyPercentage__c = String.isEmpty(proposta.porcentagemAgenciamento) ? null : Decimal.valueOf(proposta.porcentagemAgenciamento);
            quoteLineItemToInsert.QuoteId = quoteId;
            quoteLineItemToInsert.PricebookEntryId = objOpportunityLineItem.PricebookEntryId;
            quoteLineItemToInsert.Product2Id = objOpportunityLineItem.Product2Id;
            lstQuoteLineItensToInsert.add(quoteLineItemToInsert);
        }

        List<Id> lstInsertedQuoteLineItens = new List<Id>();

        Database.SaveResult [] srQuoteLineItem = Database.insert(lstQuoteLineItensToInsert, false);
        for(Database.SaveResult sr : srQuoteLineItem){
            if(sr.isSuccess()){
                System.debug('Successfully inserted QuoteLineItem. QuoteLineItem ID: ' + sr.getId());
                lstInsertedQuoteLineItens.add(sr.getId());
            }else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('QuoteLineItem fields that affected this error: ' + err.getFields());
                }
            }
        }

        if(lstInsertedQuoteLineItens.size() == lstQuoteId.size()){
            return true;
        }else{
            return false;
        }
    }

    public static Boolean insertQuote(String caseId,ConnectWizCMPTO.Proposta proposta){

        Quote quoteToInsert = new Quote();

        Opportunity parentOpportunity = OpportunityDAO.getOpportunitiesByCaseId(caseId);
        quoteToInsert.Company__c = proposta.seguradora;
        quoteToInsert.Type__c = proposta.type;
        quoteToInsert.PrizeAmount__c = String.isEmpty(proposta.premio) ? null :Double.valueOf(proposta.premio);
        quoteToInsert.InsuredAmount__c = String.isEmpty(proposta.importanciaSegurada) ? null :Double.valueOf(proposta.importanciaSegurada);
        quoteToInsert.AdditionalInsuredAmount__c = String.isEmpty(proposta.importanciaSeguradaAdicional) ? null :Double.valueOf(proposta.importanciaSeguradaAdicional);
        quoteToInsert.AdditionalInsuredAmount2__c = String.isEmpty(proposta.importanciaSeguradaAdicional2) ? null :Double.valueOf(proposta.importanciaSeguradaAdicional2);

        if(!String.isEmpty(proposta.dataDeEnvioParaSeguradora)){
            String dataEnvio = proposta.dataDeEnvioParaSeguradora;
            List<String> lstDataEnvio = dataEnvio.split('-' , 3);
            Date dataEnvioQuote = Date.newInstance( Integer.valueOf(lstDataEnvio[0]), Integer.valueOf(lstDataEnvio[1]),Integer.valueOf(lstDataEnvio[2]));
            quoteToInsert.QuoteRequestDate__c = dataEnvioQuote;
        }

        if(!String.isEmpty(proposta.dataDeRecebimentoDaSeguradora)){
            String dataRecebimento = proposta.dataDeRecebimentoDaSeguradora;
            List<String> lstDataRecebimento = dataRecebimento.split('-' , 3);
            Date dataRecebimentoQuote = Date.newInstance( Integer.valueOf(lstDataRecebimento[0]), Integer.valueOf(lstDataRecebimento[1]),Integer.valueOf(lstDataRecebimento[2]));
            quoteToInsert.QuoteReceiptDate__c = dataRecebimentoQuote;
        }

        quoteToInsert.Description = proposta.observacoes;
        quoteToInsert.Status = proposta.status;
        quoteToInsert.OpportunityId = parentOpportunity.Id;
        quoteToInsert.RecordTypeId = proposta.recordTypeId;

        Database.SaveResult srQuote = Database.insert(quoteToInsert, false);
        if(srQuote.isSuccess()){
            System.debug('Successfully inserted Quote. Quote ID: ' + srQuote.getId());
            Boolean isLineItemCreated = insertQuoteLineItem(srQuote.getId(),parentOpportunity.Id,proposta);
            // if(!isLineItemCreated){
            //     Database.delete(srQuote.getId(),false);
            //     System.debug('Quote deletado pois falhou ao criar Line Item');
            // }
            return srQuote.isSuccess();
        }else{
            System.debug('Failed to insert Quote error message: ' + srQuote.getErrors());
        }
        return false;
    }

    public static Boolean insertQuoteLineItem(Id quoteId,Id opportunityId,ConnectWizCMPTO.Proposta proposta){

        QuoteLineItem quoteLineItemToInsert = new QuoteLineItem();
        OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();

        objOpportunityLineItem = OpportunityLineItemDAO.getOpportunityLineItensByOpportunityId(opportunityId);

        quoteLineItemToInsert.CommissionPercent__c = String.isEmpty(proposta.porcentagemComissao) ? null : Decimal.valueOf(proposta.porcentagemComissao);
        quoteLineItemToInsert.UnitPrice = String.isEmpty(proposta.premio) ? 0 : Decimal.valueOf(proposta.premio);
        quoteLineItemToInsert.Quantity = 1;
        quoteLineItemToInsert.PrizeNetValue__c = String.isEmpty(proposta.valorLiquidoPremio) ? null : Decimal.valueOf(proposta.valorLiquidoPremio);
        quoteLineItemToInsert.IOFPrizeValue__c = String.isEmpty(proposta.valorIOFPremio) ? null : Decimal.valueOf(proposta.valorIOFPremio);
        quoteLineItemToInsert.AgencyPercentage__c = String.isEmpty(proposta.porcentagemAgenciamento) ? null : Decimal.valueOf(proposta.porcentagemAgenciamento);
        quoteLineItemToInsert.QuoteId = quoteId;
        quoteLineItemToInsert.PricebookEntryId = objOpportunityLineItem.PricebookEntryId;
        quoteLineItemToInsert.Product2Id = objOpportunityLineItem.Product2Id;

        Database.SaveResult srQuoteLineItem = Database.insert(quoteLineItemToInsert, false);
        if(srQuoteLineItem.isSuccess()){
            System.debug('Successfully inserted QuoteLineItem. QuoteLineItem ID: ' + srQuoteLineItem.getId());
        }else{
            System.debug('Failed to insert QuoteLineItem error message: ' + srQuoteLineItem.getErrors());
        }
        return srQuoteLineItem.isSuccess();
    }

    public static List<ConnectWizCMPTO.Proposta> retrieveQuotes (String caseId){

        Opportunity parentOpportunity = OpportunityDAO.getOpportunitiesByCaseId(caseId);
        Set<Id> setIdsOpportunities = new Set<Id>{parentOpportunity.Id};
        List<ConnectWizCMPTO.Proposta> lstPropostasToRetrieve = new List<ConnectWizCMPTO.Proposta>();

        List<Quote> lstQuotesToRetrieve = QuoteDAO.getInstance().getQuoteByOpportunityId(setIdsOpportunities);
        Map<Id,Quote> mapQuotesToRetrieve = new Map<Id,Quote>(lstQuotesToRetrieve);
        Set<Id> setIdsQuotes = mapQuotesToRetrieve.keySet();
        Set<Id> setQuotesWithDocument = new Set<Id>();
        List<QuoteLineItem> lstQuoteLineItensToRetrieve= QuoteLineItemDAO.getQuoteLineItensByQuoteId(setIdsQuotes);
        System.debug('lstQuotesToRetrieve' + lstQuotesToRetrieve);
        System.debug('lstQuoteLineItensToRetrieve' + lstQuoteLineItensToRetrieve);
        List<DocumentUpload__c> lstDocuments = [SELECT
                                        Id,
                                        DocumentType__r.Name,
                                        IdObjeto__c
                                        FROM    DocumentUpload__c
                                WHERE   IdObjeto__c IN : setIdsQuotes AND DocumentType__r.Name = 'Proposta de Seguro'];
        System.debug('lstDocuments ' + lstDocuments);
        for(DocumentUpload__c objDoc : lstDocuments){
            setQuotesWithDocument.add(objDoc.IdObjeto__c);
        }
        for(Quote objQuote : lstQuotesToRetrieve){
            ConnectWizCMPTO.Proposta objProposta = new ConnectWizCMPTO.Proposta();
            for(QuoteLineItem objQuoteLineItem : lstQuoteLineItensToRetrieve){
                if(objQuoteLineItem.QuoteId == objQuote.Id){
                    objProposta.porcentagemComissao = String.valueOf(objQuoteLineItem.CommissionPercent__c);
                    objProposta.valorLiquidoPremio = String.valueOf(objQuoteLineItem.PrizeNetValue__c);
                    objProposta.valorIOFPremio = String.valueOf(objQuoteLineItem.IOFPrizeValue__c);
                    objProposta.porcentagemAgenciamento = String.valueOf(objQuoteLineItem.AgencyPercentage__c);
                    objProposta.produto = objQuoteLineItem.Product2.name;
                    if(String.isNotEmpty(objProposta.valorLiquidoPremio) || String.isNotEmpty(objProposta.valorIOFPremio)){
                        objProposta.isValorDetalhado = true;
                    }else{
                        objProposta.isValorDetalhado = false;
                    }
                }
            }
            objProposta.seguradora = objQuote.Company__c;
            objProposta.priceBook2 = objQuote.Pricebook2.Name;
            objProposta.premio = String.valueOf(objQuote.PrizeAmount__c);
            objProposta.importanciaSegurada = String.valueOf(objQuote.InsuredAmount__c);
            objProposta.importanciaSeguradaAdicional = String.valueOf(objQuote.AdditionalInsuredAmount__c);
            objProposta.importanciaSeguradaAdicional2 = String.valueOf(objQuote.AdditionalInsuredAmount2__c);
            if(String.isNotEmpty(objProposta.importanciaSeguradaAdicional) || String.isNotEmpty(objProposta.importanciaSeguradaAdicional)){
                objProposta.isAddValorImportancia = true;
            }else{
                objProposta.isAddValorImportancia = false;
            }
            objProposta.dataDeEnvioParaSeguradora = String.valueOf(objQuote.QuoteRequestDate__c);
            objProposta.dataDeRecebimentoDaSeguradora = String.valueOf(objQuote.QuoteReceiptDate__c);
            objProposta.observacoes = objQuote.Description;
            objProposta.recordTypeId = objQuote.RecordTypeId;
            objProposta.status = objQuote.Status;
            objProposta.quoteId = objQuote.Id;
            objProposta.showDetails = false;
            objProposta.showSendToComercial = true;
            objProposta.isSolicitada = false;
            objProposta.isRecebida = false;
            objProposta.isEnviada = false;
            objProposta.isAceita = false;
            objProposta.isNegada = false;
            if((objProposta.dataDeRecebimentoDaSeguradora == null || objProposta.dataDeRecebimentoDaSeguradora == '')){
                objProposta.isSolicitada = true;
            }else if((objProposta.dataDeRecebimentoDaSeguradora != null && objProposta.dataDeRecebimentoDaSeguradora != '')){
                objProposta.isRecebida = true;
            }if(objProposta.status == 'Presented'){
                objProposta.isEnviada = true;
                objProposta.showSendToComercial = false;
            }else if(objProposta.status == 'Accepted'){
                objProposta.isAceita = true;
                objProposta.showSendToComercial = false;
            }else if(objProposta.status == 'Denied'){
                objProposta.isNegada = true;
            }else if(objProposta.status == 'Cancelled'){
                objProposta.isCancelled = true;
            }
            if(setQuotesWithDocument.contains(objQuote.Id)){
                objProposta.showUploadFile = false;
                objProposta.showViewFiles = true;
            }else{
                objProposta.showUploadFile = true;
                objProposta.showViewFiles = false;
            }
            lstPropostasToRetrieve.add(objProposta);
        }
        System.debug('lstPropostasToRetrieve' + lstPropostasToRetrieve);
        return lstPropostasToRetrieve;
    }

    public static Boolean updateQuote(ConnectWizCMPTO.Proposta proposta){

        Quote quoteToUpdate = QuoteDAO.getQuoteById(proposta.quoteId);
        quoteToUpdate.Company__c = proposta.seguradora;
        quoteToUpdate.PrizeAmount__c = String.isEmpty(proposta.premio) ? null :Decimal.valueOf(proposta.premio);
        quoteToUpdate.InsuredAmount__c = String.isEmpty(proposta.importanciaSegurada) ? null : Decimal.valueOf(proposta.importanciaSegurada);
        quoteToUpdate.AdditionalInsuredAmount__c = String.isEmpty(proposta.importanciaSeguradaAdicional) ? null :Decimal.valueOf(proposta.importanciaSeguradaAdicional);
        quoteToUpdate.AdditionalInsuredAmount2__c = String.isEmpty(proposta.importanciaSeguradaAdicional2) ? null :Decimal.valueOf(proposta.importanciaSeguradaAdicional2);

        if(!String.isEmpty(proposta.dataDeEnvioParaSeguradora)){
            String dataEnvio = proposta.dataDeEnvioParaSeguradora;
            List<String> lstDataEnvio = dataEnvio.split('-' , 3);
            Date dataEnvioQuote = Date.newInstance( Integer.valueOf(lstDataEnvio[0]), Integer.valueOf(lstDataEnvio[1]),Integer.valueOf(lstDataEnvio[2]));
            quoteToUpdate.QuoteRequestDate__c = dataEnvioQuote;
        }

        if(!String.isEmpty(proposta.dataDeRecebimentoDaSeguradora)){
            String dataRecebimento = proposta.dataDeRecebimentoDaSeguradora;
            List<String> lstDataRecebimento = dataRecebimento.split('-' , 3);
            Date dataRecebimentoQuote = Date.newInstance( Integer.valueOf(lstDataRecebimento[0]), Integer.valueOf(lstDataRecebimento[1]),Integer.valueOf(lstDataRecebimento[2]));
            quoteToUpdate.QuoteReceiptDate__c = dataRecebimentoQuote;
        }

        quoteToUpdate.Description = proposta.observacoes;
        quoteToUpdate.Status = proposta.status;
        quoteToUpdate.RecordTypeId = proposta.recordTypeId;

        Database.SaveResult srQuote = Database.update(quoteToUpdate, false);
        if(srQuote.isSuccess()){
            System.debug('Successfully updated Quote. Quote ID: ' + srQuote.getId());
            Boolean isLineItemCreated = updateQuoteLineItem(srQuote.getId(),proposta);
            // if(!isLineItemCreated){
            //     Database.delete(srQuote.getId(),false);
            //     System.debug('Quote deletado pois falhou ao atualizar Line Item');
            // }
            return srQuote.isSuccess();
        }else{
            System.debug('Failed to update Quote error message: ' + srQuote.getErrors());
        }
        return false;
    }

    public static Boolean updateQuoteLineItem(Id quoteId,ConnectWizCMPTO.Proposta proposta){

        QuoteLineItem quoteLineItemToUpdate = QuoteLineItemDAO.getQuoteLineItemByQuoteId(quoteId);

        quoteLineItemToUpdate.CommissionPercent__c = String.isEmpty(proposta.porcentagemComissao) ? null : Decimal.valueOf(proposta.porcentagemComissao);
        quoteLineItemToUpdate.UnitPrice = String.isEmpty(proposta.premio) ? 0 : Decimal.valueOf(proposta.premio);
        quoteLineItemToUpdate.PrizeNetValue__c = String.isEmpty(proposta.valorLiquidoPremio) ? null : Decimal.valueOf(proposta.valorLiquidoPremio);
        quoteLineItemToUpdate.IOFPrizeValue__c = String.isEmpty(proposta.valorIOFPremio) ? null : Decimal.valueOf(proposta.valorIOFPremio);
        quoteLineItemToUpdate.AgencyPercentage__c = String.isEmpty(proposta.porcentagemAgenciamento) ? null : Decimal.valueOf(proposta.porcentagemAgenciamento);

        Database.SaveResult srQuoteLineItem = Database.update(quoteLineItemToUpdate, false);
        if(srQuoteLineItem.isSuccess()){
            System.debug('Successfully updated QuoteLineItem. QuoteLineItem ID: ' + srQuoteLineItem.getId());
        }else{
            System.debug('Failed to update QuoteLineItem error message: ' + srQuoteLineItem.getErrors());
        }
        return srQuoteLineItem.isSuccess();
    }

    public static Boolean deleteQuote(String quoteId){

        Database.DeleteResult srQuote = Database.delete(quoteId, false);
        if(srQuote.isSuccess()){
            System.debug('Successfully deleted Quote. Quote ID: ' + srQuote.getId());
            // Boolean isLineItemCreated = updateQuoteLineItem(srQuote.getId(),proposta);
            // if(!isLineItemCreated){
            //     Database.delete(srQuote.getId(),false);
            //     System.debug('Quote deletado pois falhou ao atualizar Line Item');
            // }
            return srQuote.isSuccess();
        }else{
            System.debug('Failed to delete Quote error message: ' + srQuote.getErrors());
        }
        return false;
    }

    public static Opportunity getOpportunityByCaseId(Id caseId){
        Opportunity objOpportunity = OpportunityDAO.getOpportunitiesByCaseId(caseId);
        return objOpportunity;
    }

    public static List<ConnectWizCMPTO.ContactDetail> getAccountByOpportunityId(Id opportunityId){

        List<ConnectWizCMPTO.ContactDetail> lstContactDetail = new List<ConnectWizCMPTO.ContactDetail>();
        List<Account> lstResponse = AccountDAO.getAccountByOpportunityId(OpportunityId);
        Integer counter = 1;

        if(lstResponse.isEmpty()){
            ConnectWizCMPTO.ContactDetail contactResponse = new ConnectWizCMPTO.ContactDetail();
            contactResponse.showDetails = false;
            contactResponse.moduloCliente = 'Não informado';
            contactResponse.telefone = 'Não informado';
            contactResponse.celular = 'Não informado';
            contactResponse.nome = 'Não informado';
            contactResponse.email = 'Não informado';
            contactResponse.cargo = 'Não informado';
            contactResponse.dataDeNascimento = 'Não informado';
            contactResponse.timeDoCoracao = 'Não informado';
            contactResponse.ordem = '1';
            lstContactDetail.add(contactResponse);
        }else{
            for(Account objAccount : lstResponse){
                for(Integer i =0; i < objAccount.ContactDetails__pr.Size() ; i++){
                    ConnectWizCMPTO.ContactDetail contactResponse = new ConnectWizCMPTO.ContactDetail();
                    contactResponse.showDetails = false;
                    contactResponse.moduloCliente = 'Não Informado';
                    contactResponse.telefone = objAccount.ContactDetails__pr[i].MobilePhone__c  == null ? 'Não Informado' : objAccount.ContactDetails__pr[i].MobilePhone__c;
                    contactResponse.celular = objAccount.ContactDetails__pr[i].MobilePhone__c  == null ? 'Não Informado' : objAccount.ContactDetails__pr[i].MobilePhone__c;
                    contactResponse.nome = objAccount.ContactDetails__pr[i].Name  == null ? 'Não Informado' : objAccount.ContactDetails__pr[i].Name;
                    contactResponse.email = objAccount.ContactDetails__pr[i].Email__c  == null ? 'Não Informado' : objAccount.ContactDetails__pr[i].Email__c ;
                    contactResponse.cargo = 'Não Informado';
                    contactResponse.dataDeNascimento = 'Não Informado';
                    contactResponse.timeDoCoracao = 'Não Informado';
                    contactResponse.ordem = String.valueOf(counter);
                    counter++;
                    contactResponse.contatoId = objAccount.ContactDetails__pr[i].Contact__c;
                    lstContactDetail.add(contactResponse);
                }
                for(Integer j=0; j<objAccount.Contacts.Size(); j++ ){

                    ConnectWizCMPTO.ContactDetail contactResponse = getContact(objAccount.Contacts[j].Id,lstContactDetail);
                    if(contactResponse != null){
                        contactResponse.cargo =  objAccount.Contacts[j].Position__c == null ? 'Não Informado' : objAccount.Contacts[j].Position__c;
                        contactResponse.dataDeNascimento =  objAccount.Contacts[j].Birthdate == null ? 'Não Informado' : String.valueOf(objAccount.Contacts[j].Birthdate);
                        if(objAccount.Contacts[j].Birthdate != null){
                            String dataEnvio = contactResponse.dataDeNascimento;
                            List<String> lstDataNascimento = contactResponse.dataDeNascimento.split('-' , 3);
                            contactResponse.dataDeNascimento = lstDataNascimento[2] + '/' + lstDataNascimento[1] + '/' + lstDataNascimento[0];
                        }
                        contactResponse.timeDoCoracao =  objAccount.Contacts[j].TeamYouCheerFor__c == null ? 'Não Informado' : objAccount.Contacts[j].TeamYouCheerFor__c ;
                    }else{
                        ConnectWizCMPTO.ContactDetail contactResponse2 = new ConnectWizCMPTO.ContactDetail();
                        contactResponse2.cargo =  objAccount.Contacts[j].Position__c == null  ? 'Não Informado' : objAccount.Contacts[j].Position__c;
                        contactResponse2.dataDeNascimento =  objAccount.Contacts[j].Birthdate == null ? 'Não Informado' : String.valueOf(objAccount.Contacts[j].Birthdate);
                        if(objAccount.Contacts[j].Birthdate != null){
                            String dataEnvio = contactResponse2.dataDeNascimento;
                            List<String> lstDataNascimento = contactResponse2.dataDeNascimento.split('-' , 3);
                            contactResponse2.dataDeNascimento = lstDataNascimento[2] + '/' + lstDataNascimento[1] + '/' + lstDataNascimento[0];
                        }
                        contactResponse2.timeDoCoracao =  objAccount.Contacts[j].TeamYouCheerFor__c == null ? 'Não Informado' : objAccount.Contacts[j].TeamYouCheerFor__c ;
                        contactResponse2.nome = objAccount.Contacts[j].Name  == null ? 'Não Informado' : objAccount.Contacts[j].Name;
                        contactResponse2.telefone = objAccount.Contacts[j].MobilePhone == null ?'Não Informado' : objAccount.Contacts[j].MobilePhone;
                        contactResponse2.celular = objAccount.Contacts[j].MobilePhone == null ?'Não Informado' : objAccount.Contacts[j].MobilePhone;
                        contactResponse2.email = objAccount.Contacts[j].Email == null ?'Não Informado' : objAccount.Contacts[j].Email;
                        contactResponse2.moduloCliente = 'Não Informado';
                        contactResponse2.ordem = String.valueOf(counter);
                        counter++;
                        lstContactDetail.add(contactResponse2);
                    }
                }
            }
        }
        return lstContactDetail;
    }

    private static ConnectWizCMPTO.ContactDetail getContact(Id contatoId,List<ConnectWizCMPTO.ContactDetail> lstContactDetail){

        for(ConnectWizCMPTO.ContactDetail objContactDetail : lstContactDetail){
            if(objContactDetail.contatoId == contatoId){
                return objContactDetail;
            }
        }
        return null;
    }

    public static Case getCaseById(Id caseId){
        Case objCase = CaseDAO.getCaseById(caseId);
        return objCase;
    }

    public static Boolean emitQuote(Id caseId){
        Case objCase = CaseDAO.getCaseById(caseId);
        Opportunity objOpportunity = OpportunityDAO.getOpportunitiesByCaseId(caseId);

        objCase.Status = 'Apólice registrada';
        objOpportunity.StageName = 'Fechado e ganho';

        Boolean isCaseUpdated;
        Boolean isOpportunityUpdated;

        Database.SaveResult srCase = Database.update(objCase, false);
        if(srCase.isSuccess()){
            System.debug('Successfully inserted Case. Case ID: ' + srCase.getId());
            isCaseUpdated = srCase.isSuccess();
        }else{
            System.debug('Failed to insert Case error message: ' + srCase.getErrors());
            isCaseUpdated = false;
        }

        Database.SaveResult srOpportunity = Database.update(objOpportunity, false);
        if(srOpportunity.isSuccess()){
            System.debug('Successfully inserted Opportunity. Opportunity ID: ' + srOpportunity.getId());
            isOpportunityUpdated = srOpportunity.isSuccess();
        }else{
            System.debug('Failed to insert Case error message: ' + srOpportunity.getErrors());
            isOpportunityUpdated = false;
        }

        if(isCaseUpdated && isOpportunityUpdated){
            return true;
        }
        return false;
    }

    /**
     * @autor samuelsirkis@wiz.co
     * @descrition adicionando metodo para cancelar cotação
     * @param quotId
     * @return boolean
     */
    public static Boolean cancelQuote(String quoteId){
        Quote quoteToCancel = QuoteDAO.getQuoteById(quoteId);
        quoteToCancel.Status = 'Cancelled';
        Database.SaveResult srQuote = Database.update(quoteToCancel, false);
        if(srQuote.isSuccess()){
            System.debug('Successfully cancel Quote. Quote ID: ' + srQuote.getId());
            return srQuote.isSuccess();
        }else{
            System.debug('Failed to cancel Quote error message: ' + srQuote.getErrors());
        }
        return false;
    }
}