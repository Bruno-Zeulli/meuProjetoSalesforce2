/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver    Date         Author                               Modification
 * 1.0    11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1    11-24-2021  marcelomartins@wizsolucoes.com.br     Inserted Method acceptanceProcess()
 **/
public without sharing class QuoteTriggerHandler {
    private boolean isExecuting = false;
    public List<Quote> oldRecordsList = null;
    public List<Quote> newRecordsList = null;
    public Map<Id, Quote> oldRecordsMap = null;
    public Map<Id, Quote> newRecordsMap = null;
    public static final String SEPARATOR = ' - ';
    public static final String DEFAULT_QUOTE_NAME = 'Cotação';
    public static final String ERROR_MSG_ACCEPTED_QUOTE = 'Só pode haver uma cotação aceita para oportunidade com esse produto.';
    private static Id b2uRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2U').getRecordTypeId();
    private static Id consegRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Conseg').getRecordTypeId();
    private static Id redeVipRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('RedeVIP').getRecordTypeId();
    private static Id corporateRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
    private static Id corporateParcialRecordType = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('CorporateParcial').getRecordTypeId();

    public QuoteTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){
        generateQuoteName();
        generateQuoteDescription();
        changeOportunityStageCorporate();
    }

    public void onBeforeUpdate(){
        generateQuoteName();
        generateQuoteDescription();
        validateAcceptedQuote();
    }

    public void onAfterUpdate(){
       // QuoteTriggerHandlerDiscountCalc.calculateDiscount();
        acceptanceProcess();
        changeOportunityStageCorporate();
        checkResolution382();
    }

    public void generateQuoteName(){
        for(Quote q : newRecordsList){
            if(q.RecordTypeId == b2uRecordType || q.RecordTypeId == consegRecordType){
                generateQuoteNameNormal(q);
            }
            generateQuoteNameIsVip(q);
        }
        generateQuoteNameLoop();
    }

    //Divisão do método para não estender e gerar uma Warning do PMD
    private void generateQuoteNameNormal(Quote q){
        if(q.QuotationNumber__c != null && q.Company__c != null){
            q.Name = q.QuotationNumber__c + SEPARATOR + q.Company__c;
        }else if(q.Company__c != null){
            q.Name = q.Company__c;
        }else if(q.QuotationNumber__c != null){
            q.Name = q.QuotationNumber__c;
        }else{
            q.Name = DEFAULT_QUOTE_NAME;
        }
    }

    // Método para verificar se o Cliente e VIP
    private void generateQuoteNameIsVip(Quote q){
        if(q.RecordTypeId == redeVipRecordType){
            q.Name = q.Company__c + ' | R$ ' + q.PrizeAmount__c.format() + ' | ' + getLabelPicklist(q.Status);
        }
        if(q.RecordTypeId == corporateRecordType){
            q.Name = 'Proposta | ' + q.Company__c + ' | ' + q.QuoteNumber;
        }
        if(q.RecordTypeId == corporateParcialRecordType){
            q.Name = 'Cotação | ' + q.Company__c + ' | ' + q.QuoteNumber;
        }
    }

    // Loop para criar uma lista de produtos
    private void generateQuoteNameLoop(){
        if(newRecordsMap != null){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            if(Schema.sObjectType.QuoteLineItem.isAccessible()){
                qliList = [SELECT Id, Product2.Name, QuoteId, Quote.RecordTypeId FROM QuoteLineItem WHERE QuoteId IN :newRecordsMap.keySet() ORDER BY CreatedDate];
            }
            for(QuoteLineItem qli : qliList){
                if(qli.Quote.RecordTypeId == b2uRecordType || qli.Quote.RecordTypeId == consegRecordType){
                    newRecordsMap.get(qli.QuoteId).Name += SEPARATOR + qli.Product2.Name;
                }
            }
        }
    }

    // Método para gerar descrição
    public void generateQuoteDescription(){
        if(newRecordsMap != null){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            if(Schema.sObjectType.QuoteLineItem.isAccessible()){
                qliList = [
                    SELECT Id, Product2.Name, QuoteId, toLabel(Quote.Type__c), TotalPrice, DiscountValue__c, Quote.RecordTypeId
                    FROM QuoteLineItem
                    WHERE QuoteId IN :newRecordsMap.keySet()
                    ORDER BY CreatedDate
                ];
            }
            generateQuoteDescriptionLoop(qliList);
        }
    }

    //Divisão do método para não estender e gerar uma Warning do PMD
    public void generateQuoteDescriptionLoop(List<QuoteLineItem> qliList){
        for(QuoteLineItem qli : qliList){
            if(qli.Quote.RecordTypeId == b2uRecordType || qli.Quote.RecordTypeId == consegRecordType){
                if(qli.Quote.Type__c != null && qli.Product2.Name != null && qli.TotalPrice != null){
                    generateQuoteDescriptionQuery(qli);
                }
            }
        }
    }

    //Divisão do método para não estender e gerar uma Warning do PMD
    public void generateQuoteDescriptionQuery(QuoteLineItem qli){
        if(newRecordsMap.get(qli.QuoteId).IsDiscountApproved__c && qli.DiscountValue__c != null){
            newRecordsMap.get(qli.QuoteId).Description=qli.Quote.Type__c+' de '+qli.Product2.Name+' no valor de R$'+qli.TotalPrice +' com desconto de R$' + qli.DiscountValue__c;
        }else if(qli.DiscountValue__c != null){
            newRecordsMap.get(qli.QuoteId).Description=qli.Quote.Type__c + ' de '+qli.Product2.Name +' no valor de R$'+qli.TotalPrice+' com desconto solicitado de R$' + qli.DiscountValue__c;
        }else{
            newRecordsMap.get(qli.QuoteId).Description = qli.Quote.Type__c + ' de ' + qli.Product2.Name + ' no valor de R$' + qli.TotalPrice;
        }
    }

    private string getLabelPicklist(string developerName){
        string labelStatus = '';
        List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.Quote.fields.Status.getPicklistValues();
        for(Schema.PicklistEntry ple : picklistEntries){
            if(ple.getValue() == developerName){
                labelStatus = ple.getLabel();
                break;
            }
        }
        return labelStatus;
    }

    // Valida se a cotação da Wiz Corporate pode ter o status definido como "Aceito".
    // Por regra, só pode haver uma cotação aceita por oportunidade.
    // Há exceção para oportunidades do produto "Garantia Judicial Recursal".
    // Para esse produto, pode haver mais de uma cotação aceita por oportunidade.
    // Excluix o status de cancelado para corporate.
    public void validateAcceptedQuote(){
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        if(Schema.sObjectType.QuoteLineItem.isAccessible()){
            qliList = [SELECT Id, Product2.Name, QuoteId, Quote.RecordTypeId, Quote.Opportunity.AcceptedQuoteCount__c FROM QuoteLineItem WHERE QuoteId IN :newRecordsMap.keySet()];
        }
        for(QuoteLineItem qli : qliList){
            if(qli.Quote.RecordTypeId == corporateRecordType &&
                oldRecordsMap.get(qli.QuoteId).Status != 'Accepted' &&
                newRecordsMap.get(qli.QuoteId).Status == 'Accepted' &&
                newRecordsMap.get(qli.QuoteId).Status != 'Cancelled' &&
                !qli.Product2.Name.contains('Recursal') &&
                qli.Quote.Opportunity.AcceptedQuoteCount__c > 0
            ){
                newRecordsMap.get(qli.QuoteId).addError(ERROR_MSG_ACCEPTED_QUOTE);
            }
        }
    }

    // Valida se a cotação da Wiz Corporate está com otatus definido como "Aceito".
    // Dispara o envio essa cotação para o WFlow, chamando o Corporate_WFlowService.sendAprovedQuoteToWFlow
    // Atualiza as demais cotação para NEGADO chamando QuoteBO.updateRemainingQuotes.
    public void acceptanceProcess(){
        Integer NUMBER_REQUEST_FUTURE_ANY_ERROR = 40;

        if(newRecordsList.size() < NUMBER_REQUEST_FUTURE_ANY_ERROR){
            for(Quote record : newRecordsList){
                if(!Test.isRunningTest()){
                    if(oldRecordsMap.get(record.Id).Status != 'Accepted' && newRecordsMap.get(record.Id).Status == 'Accepted' && record.RecordTypeId == corporateRecordType){
                        QuoteBO.getInstance().updateRemainingQuotes(record.OpportunityId, record.Id);
                            Corporate_WFlowService.sendAprovedQuoteToWFlow(JSON.serialize(record));
                    }else if(record.RecordTypeId == corporateRecordType){
                            Corporate_WFlowService.postQuoteUpdateInWFlow(record.Id);
                    }
                }
            }
        }
    }

    public void changeOportunityStageCorporate(){
        List<Opportunity> lOportunities = new List<Opportunity>();
        List<Opportunity> lUpdOportunities = new List<Opportunity>();

        for(Quote newRecord : newRecordsList){

            if(newRecord.RecordTypeId == corporateRecordType &&
                (newRecord.OpportunityId != null || newRecord.OpportunityId != '')
            ){
                lOportunities = OpportunityDAO.getInstance().getAllFieldsById(newRecord.OpportunityId);
                for(Opportunity opp : lOportunities){
                    System.debug('Dentro do for');
                    if(newRecord.Status == 'Draft' && (opp.StageName != 'Em negociação' || opp.StageName != 'Em Emissão') && (opp.StageName != 'Fechado e ganho')){
                        opp.StageName = 'Construção da proposta';
                        lUpdOportunities.add(opp);
                        System.debug('Construção da proposta =>' + opp.StageName);
                        System.debug('Draft ' + newRecord.Status);
                    }
                    if(newRecord.Status == 'Presented' && (opp.StageName != 'Em negociação' || opp.StageName != 'Em Emissão') && (opp.StageName != 'Fechado e ganho')){
                        opp.StageName = 'Em negociação';
                        lUpdOportunities.add(opp);
                        System.debug('Em negociação =>' + opp.StageName);
                        System.debug('Presented ' + newRecord.Status);
                    }
                    if(newRecord.Status == 'Accepted' && (opp.StageName != 'Em negociação' || opp.StageName != 'Em Emissão') && (opp.StageName != 'Fechado e ganho')){
                        opp.StageName = 'Em Emissão';
                        lUpdOportunities.add(opp);
                        System.debug('Em Emissão =>' + opp.StageName);
                        System.debug('Accepted ' + newRecord.Status);
                    }
                }
            }
        }
        if(!lUpdOportunities.isEmpty()){
            OpportunityBO.getInstance().lstUpdOpportunities(lUpdOportunities);
        }
    }

    public void checkResolution382(){
        List<DocumentUpload__c> lDocuments = new List<DocumentUpload__c>();
        List<Opportunity> lOportunities = new List<Opportunity>();
        List<Opportunity> lUpdOportunities = new List<Opportunity>();
        String[] lTypes = new String[]{'25','61','91','69','59'};

        for(Quote newRecord : newRecordsList){

            if(!Test.isRunningTest()){
                lDocuments = DocumentUploadDAO.getInstance().getDocumentUploadBySObjectId(newRecord.Id);
                lOportunities = OpportunityDAO.getInstance().getAllFieldsById(newRecord.OpportunityId);
            }

            if(newRecord.RecordTypeId == corporateRecordType && !lDocuments.isEmpty() && !lOportunities.isEmpty()){
                for(Opportunity opp : lOportunities){

                    for(DocumentUpload__c doc : lDocuments){
                        if(lTypes.contains(doc.DocumentTypeExternalId__c)){
                            opp.HasResolution382__c = true;
                            System.debug('Teste R382' + opp.HasResolution382__c);
                        }
                    }
                    lUpdOportunities.add(opp);
                }
            }
        }
        if(!lUpdOportunities.isEmpty()){
            OpportunityBO.getInstance().lstUpdOpportunities(lUpdOportunities);
        }
    }
}