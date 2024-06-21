public without sharing class PlacementFollowUpController {

    public class CustomExceptionData {
        public String message;

        public CustomExceptionData(String message) {
            this.message = message;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunityById(String recordId) {
        return [SELECT Id, Name, AccountId, InsuredAmount__c, Amount, StageName, IsOpportunityNomination__c, Description, ProbabilityOfWinning__c, CloseDate, CreatedDate, OpportunityOwner__c, EndDatePolicy__c, Pricebook2Id, HasResolution382__c FROM Opportunity WHERE Id =: recordId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityLineItemByOppId (String recordId) {
        return [SELECT Id, Name, Product2Id, PricebookEntryId, UnitPrice, Quantity, ExpectedCommission__c, NumberOfLifes__c FROM OpportunityLineItem WHERE OpportunityId =: recordId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List <Contact> getContactByAccId(String recordId) {
        return [SELECT Id, Name, AccountId, Phone, MobilePhone, Email, Birthdate, Department, TeamYouCheerFor__c FROM Contact WHERE AccountId =: recordId];
    }

    @AuraEnabled(cacheable=true)
    public static List <Questionnaire__c> getQuestionaryByOppId (String recordId) {
        return [SELECT Id, Name, Questionnaire_Definition__c, Opportunity__c, (SELECT Id, Question_Label__c, Question_Type__c, Answer__c, Comment__c FROM Questionnaire_Answers__r) FROM Questionnaire__c WHERE Opportunity__c =: recordId LIMIT 1];
    }

    
    @AuraEnabled(cacheable=false)
    public static List <Case> getCaseByOpportunityId (String recordId) {
        return [SELECT Status FROM Case WHERE Opportunity__c =: recordId LIMIT 1];
    }
    

    @AuraEnabled(cacheable=false)
    public static List <Quote> getQuotesByOppId (String recordId) {
        return [SELECT Id, QuoteNumber, Company__c, QuoteRequestDate__c, PrizeAmount__c, InsuredAmount__c, Status_Quote_Placement__c, Name, Participation_Percentage__c, Integralization__c FROM Quote WHERE OpportunityId =: recordId AND (PartialQuoteCount__c = null OR PartialQuoteCount__c <= 0)];
    }

    @AuraEnabled(cacheable=false)
    public static List <Quote> getCoinsuranceProposalsByOppId (String recordId) {
        return [SELECT Id, QuoteNumber, Company__c, QuoteRequestDate__c, PrizeAmount__c, InsuredAmount__c, Status_Quote_Placement__c, Name, Participation_Percentage__c, Integralization__c FROM Quote WHERE OpportunityId =: recordId AND PartialQuoteCount__c > 0];
    }

    @AuraEnabled(cacheable=false)
    public static Quote getQuoteById (String recordId) {
        return [SELECT Id, Integralization__c, Quote_Kit__c, Company__c, QuoteRequestDate__c, QuoteReceiptDate__c, PrizeAmount__c, InsuredAmount__c, Net_Prize_Value__c, IOF_Prize_Value__c, PercentCommission__c, Agency_Percentage__c, Description, Status_Quote_Placement__c, Name, Participation_Percentage__c, QuoteNumber FROM Quote WHERE Id =: recordId];
    }


    @AuraEnabled(cacheable=false)
    public static Id deleteQuoteById (String quoteId) {
        try{
            
            if (quoteId != null) {
                delete new Quote(Id = quoteId);
            }

        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return quoteId;
    }

    @AuraEnabled
    public static void updateQuotes(List<Quote> quotesToUpdate) {
        try {
            update quotesToUpdate;
        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }
    }

    @AuraEnabled
    public static Quote getApprovedProposalByOppId(String recordId) {
        return [SELECT Id, Integralization__c, Quote_Kit__c, Company__c, QuoteRequestDate__c, QuoteReceiptDate__c, PrizeAmount__c, InsuredAmount__c, Net_Prize_Value__c, IOF_Prize_Value__c, PercentCommission__c, Agency_Percentage__c, Description, Status_Quote_Placement__c, Name, Participation_Percentage__c, QuoteNumber FROM Quote WHERE OpportunityId =: recordId AND Status = 'Accepted' LIMIT 1];
    }

    @AuraEnabled(cacheable=false) 
    public static List <QuoteIntegralization__c> createQuoteIntegralizations (List<QuoteIntegralization__c> integralizations){

        try{
            if(integralizations.size() > 0) {
                insert integralizations;
                return integralizations;
            } 
        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return integralizations;
    }

    @AuraEnabled(cacheable=false)
    public static List <QuoteIntegralization__c> getIntegralizationsByProposalId (String recordId) {
        return [SELECT PartialQuote__c FROM QuoteIntegralization__c WHERE IntegralQuote__c =: recordId];
    }

    @AuraEnabled(cacheable=false)
    public static List <QuoteIntegralization__c> deleteIntegralizations (List<QuoteIntegralization__c> integralizations) {
        try{
            if(integralizations.size() > 0) {
                delete integralizations;
                return integralizations;
            }
        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return integralizations;
    }


    @AuraEnabled(cacheable=true)
    public static List <DocumentUpload__c> getDocumentsFromOppByOppId (String recordId) {
        return [SELECT Id, Name, Objects__c, IdObjeto__c, Status__c, Path__c, ExternalUrl__c, ExternalReferenceId__c, DocumentType__c, FileExtension__c, ReasonRefusal__c, OwnerId, CreatedDate FROM DocumentUpload__c WHERE IdObjeto__c =: recordId AND IsDeleted__c = false];
    }

    @AuraEnabled(cacheable=false)
    public static DocumentUpload__c updateDocument(DocumentUpload__c document) {
        try {
            update document;
        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }
        
        return document;
    }

    @AuraEnabled (cacheable=true)
    public static List <DocumentUpload__c> getDocumentsSusep382FromOppByOppId (String recordId) {
        return [SELECT Id, Name, Objects__c, IdObjeto__c, Status__c, Path__c, ExternalUrl__c, ExternalReferenceId__c, DocumentType__c, FileExtension__c, ReasonRefusal__c, OwnerId, CreatedDate FROM DocumentUpload__c WHERE IdObjeto__c =: recordId AND DocumentType__r.Name = 'Comprovante da Resolução 382 SUSEP'];
    }

    @AuraEnabled
    public static Opportunity updateOpportunity (Opportunity oppRec) {
        
        try {
            update oppRec;
        } catch (Exception e) {

            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return oppRec;
    }

    @AuraEnabled(cacheable = true)
    public static Id getQuoteRecordTypeId(String recordTypeName) {
        Id recordTypeId;

        try {
            recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            System.debug('RECORD TYPE ID: ' + recordTypeId);
        } catch(Exception e) {
            System.debug('RECORD TYPE ID: ' + e);
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return recordTypeId;
    }

    @AuraEnabled(cacheable = true)
    public static Id getOrderRecordTypeId(String recordTypeName) {
        RecordType recType;
        Id recordTypeId;

        try {
            recType = [SELECT Id FROM RecordType WHERE SobjectType = 'Order' AND DeveloperName =: recordTypeName];
            recordTypeId = recType.Id;
            System.debug('RECORD TYPE ID: ' + recordTypeId);
        } catch(Exception e) {
            System.debug('RECORD TYPE ID: ' + e);
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return recordTypeId;
    }

    @AuraEnabled(cacheable = true)
    public static Id getCaseRecordTypeId(String recordTypeName) {
        RecordType recType;
        Id recordTypeId;

        try {
            recType = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName =: recordTypeName];
            recordTypeId = recType.Id;
            System.debug('RECORD TYPE ID: ' + recordTypeId);
        } catch(Exception e) {
            System.debug('RECORD TYPE ID: ' + e);
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return recordTypeId;
    }

    @AuraEnabled(cacheable = true)
    public static Order getOrderByOppId (String recordId){
        return [SELECT Id, PoNumber FROM Order WHERE OpportunityId =: recordId];
    }

    @AuraEnabled(cacheable = true)
    public static List<DocumentUpload__c> getQuoteDocumentsByQuoteId (String recordId) {
        return [SELECT Id, Name, Objects__c, IdObjeto__c, Status__c, Path__c, ExternalUrl__c, ExternalReferenceId__c, DocumentType__c, FileExtension__c, ReasonRefusal__c, OwnerId, CreatedDate FROM DocumentUpload__c WHERE IdObjeto__c =: recordId AND IsDeleted__c = false];
    }

    @AuraEnabled(cacheable = true)
    public static List<DocumentUpload__c> getApoliceBoletosFromOrderByOrderId (String recordId) {
        return [SELECT Id, Name, Objects__c, IdObjeto__c, Status__c, Path__c, ExternalUrl__c, ExternalReferenceId__c, DocumentType__c, FileExtension__c, ReasonRefusal__c, OwnerId, CreatedDate FROM DocumentUpload__c WHERE IdObjeto__c =: recordId AND IsDeleted__c = false AND (DocumentType__r.Name = 'Boleto' OR DocumentType__r.Name = 'Apólice')];
    }

    @AuraEnabled(cacheable = false)
    public static List<Id> updateCaseAndOppStatus (Opportunity oppRec, Case caseRec){
        List<Id> result = new List<Id>();
        try{
            update oppRec;
            update caseRec;

            result.add(oppRec.Id);
            result.add(caseRec.Id);

        } catch(Exception e){
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return result;
    }

    @AuraEnabled
    public static Id createQuoteWithLineItems(Quote quoteInfo, List<QuoteLineItem> lineItems) {

        Id recordTypeIdCorporateParcial = [SELECT Id FROM RecordType WHERE SobjectType = 'Quote' AND DeveloperName = 'CorporateParcial' LIMIT 1].Id;
        Id recordTypeIdCorporate = [SELECT Id FROM RecordType WHERE SobjectType = 'Quote' AND DeveloperName = 'Corporate' LIMIT 1].Id;

        if(quoteInfo.Integralization__c != null) {
            quoteInfo.RecordTypeId = quoteInfo.Integralization__c ? recordTypeIdCorporateParcial : recordTypeIdCorporate;
        }

        if ((quoteInfo.QuoteRequestDate__c != null) && (quoteInfo.QuoteReceiptDate__c == null)) {
            quoteInfo.Status_Quote_Placement__c = 'Cotação enviada';
        } else if ((quoteInfo.QuoteRequestDate__c != null) && (quoteInfo.QuoteReceiptDate__c != null)) {
            quoteInfo.Status_Quote_Placement__c = 'Cotação recebida';
        }

        if(quoteInfo.Id != null) {
            try{
                update quoteInfo;
            } catch (Exception e) {
                CustomExceptionData data = new CustomExceptionData(e.getMessage());
                throw new AuraHandledException(JSON.serialize(data));
            }
            
        } else {
            try {
                insert quoteInfo;

                if(quoteInfo.Id != null) {
                    for (QuoteLineItem lineItem : lineItems) {
                        lineItem.QuoteId = quoteInfo.Id;
                    }
                    insert lineItems;
                }

            } catch (Exception e) {
                CustomExceptionData data = new CustomExceptionData(e.getMessage());
                throw new AuraHandledException(JSON.serialize(data));
            }
        }

        return quoteInfo.Id;

    }

    @AuraEnabled
    public static Id createOrderWithLineItems(Order orderInfo, List<OrderItem> lineItems) {
        try {
            insert orderInfo;

            if(orderInfo.Id != null) {
                for (OrderItem lineItem : lineItems) {
                    lineItem.OrderId = orderInfo.Id;
                }

                insert lineItems;
            }

        } catch (Exception e) {
            CustomExceptionData data = new CustomExceptionData(e.getMessage());
            throw new AuraHandledException(JSON.serialize(data));
        }

        return orderInfo.Id;
    }

}