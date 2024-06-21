public with sharing class ConnectWizController {
 
    private static Integer QUANTITY_QUOTE_REQUEST;
    private static Integer QUANTITY_QUOTE_RECEIPT;
    private static Integer QUANTITY_REQUEST_INSIDE_SLA;
    private static Integer QUANTITY_REQUEST_OUTSIDE_SLA;
    private static Integer MAX_SIZE_QUOTE_LIST = 150;
    private static String PRODUCT_COMBO_NAME;
    private static String MSG_PRODUCT_NOT_INFORMED = 'Produto não informado';
    private static String MSG_USER_NOT_FOUND = 'Usuário não localizado';

    @AuraEnabled(cacheable=false)
    public static String getQuoteRequests(){
        List<String> lTypeGroup = new List<String>{'Queue'};
        Map<Id, String> mapUserNameOrGroupNameByIds = UserBO.getInstance().getMapUserNameOrGroupNameByIdsAndQueues(lTypeGroup);
        List<Case> lstCasePlacement =   CaseDAO.getInstance().getCasesByOwnerId(mapUserNameOrGroupNameByIds.keySet());
        Set<Id> lstOpportunitiesIds = new Set<Id> ();
        Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId = new Map<Id, List<OpportunityLineItem>>();
        Map<Id, List<Quote>> mapQuoteByOpportunityId = new Map<Id, List<Quote>>();
        List<ConnectWizCMPTO.QuotesRequestsSendCMP> lstQuotesRequestsSendCMP = new List<ConnectWizCMPTO.QuotesRequestsSendCMP>();
        Set<Id> setCaseId = new Set<Id>();
        OpportunityDAO objOppDAO = new OpportunityDAO();

        for(Case objCase : lstCasePlacement){
            lstOpportunitiesIds.add(objCase.Opportunity__c);
            setCaseId.add(objCase.Id);
        }

        Map<Id,String> mapEnterpriseNameByOpportunity = new Map<Id,String>();
        Map<Id,String> mapComercialNameOpportunity = new Map<Id,String>();
        Map<Id,String> mapSalesUnitByOpportunity = new Map<Id,String>();

        for(Opportunity objOpp : objOppDAO.getOpportunitiesByIds(lstOpportunitiesIds)){
            mapEnterpriseNameByOpportunity.put(objOpp.Id,objOpp.EnterpriseName__c);
            mapComercialNameOpportunity.put(objOpp.Id,objOpp.OpportunityOwner__c);
            mapSalesUnitByOpportunity.put(objOpp.Id,objOpp.Owner.SalesUnit__c);
        }
        System.debug('mapEnterpriseNameByOpportunity' + JSON.serializePretty(mapEnterpriseNameByOpportunity));
        System.debug('mapEnterpriseNameByOpportunity' + JSON.serializePretty(mapComercialNameOpportunity));
        System.debug('mapEnterpriseNameByOpportunity' + JSON.serializePretty(mapSalesUnitByOpportunity));

        Map<Id,CaseMilestone> mapCaseMilestoneByCaseId = new Map<Id,CaseMilestone>();
        for(CaseMilestone objCaseMilestone : CaseMilestoneDAO.getCaseMilestoneByCaseId(setCaseId)){
            mapCaseMilestoneByCaseId.put(objCaseMilestone.caseId,objCaseMilestone);
        }

        for(OpportunityLineItem objOpportunityLineItem : OpportunityLineItemDAO.getOppLineItemByListOpportunityId(lstOpportunitiesIds)){

            List<OpportunityLineItem> lstOpportunityLineItem = new List<OpportunityLineItem>();

            if(mapOpportunityLineItemByOpportunityId.containsKey(objOpportunityLineItem.OpportunityId)){
                lstOpportunityLineItem = mapOpportunityLineItemByOpportunityId.get(objOpportunityLineItem.OpportunityId);
                lstOpportunityLineItem.add(objOpportunityLineItem);
                mapOpportunityLineItemByOpportunityId.put(objOpportunityLineItem.OpportunityId, lstOpportunityLineItem);
            }else{
                lstOpportunityLineItem.add(objOpportunityLineItem);
                mapOpportunityLineItemByOpportunityId.put(objOpportunityLineItem.OpportunityId, lstOpportunityLineItem);
            }

            System.debug('lstOpportunityLineItem ==> ' + lstOpportunityLineItem);
        }

        for(Quote objQuote : QuoteDAO.getInstance().getQuoteByOpportunityId(lstOpportunitiesIds)){

            List<Quote> lstQuote= new List<Quote>();

            if(mapQuoteByOpportunityId.containsKey(objQuote.OpportunityId)){
                lstQuote = mapQuoteByOpportunityId.get(objQuote.OpportunityId);
                lstQuote.add(objQuote);
                mapQuoteByOpportunityId.put(objQuote.OpportunityId, lstQuote);
            }else{
                lstQuote.add(objQuote);
                mapQuoteByOpportunityId.put(objQuote.OpportunityId, lstQuote);
            }
        }

        Set<Id> setOpportunitysAdded = new Set<Id>();
        for(Case objCase : lstCasePlacement){
            if(!setOpportunitysAdded.contains(objCase.Opportunity__c)){
                QUANTITY_QUOTE_REQUEST = 0;
                QUANTITY_QUOTE_RECEIPT = 0;
                QUANTITY_REQUEST_INSIDE_SLA = 0;
                QUANTITY_REQUEST_OUTSIDE_SLA = 0;

                ConnectWizCMPTO.QuotesRequestsSendCMP objQuotesRequestsSendCMP = new ConnectWizCMPTO.QuotesRequestsSendCMP();

                objQuotesRequestsSendCMP.caseId = objCase.Id;
                objQuotesRequestsSendCMP.ownerId = objCase.OwnerId;
                
                objQuotesRequestsSendCMP.isViolated = mapCaseMilestoneByCaseId.containsKey(objCase.Id) ? mapCaseMilestoneByCaseId.get(objCase.Id).IsViolated : null;
                mapCaseMilestoneByCaseId.remove(objCase.Id);

                objQuotesRequestsSendCMP.ownerName = mapUserNameOrGroupNameByIds.containsKey(objCase.OwnerId) ?
                                                     mapUserNameOrGroupNameByIds.get(objCase.OwnerId) :
                                                     MSG_USER_NOT_FOUND;
            
                objQuotesRequestsSendCMP.opportunityId = objCase.Opportunity__c;
                objQuotesRequestsSendCMP.opportunityOwner = objCase.OpportunityOwner__c;
                objQuotesRequestsSendCMP.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
                objQuotesRequestsSendCMP.accountId = objCase.AccountId;
                objQuotesRequestsSendCMP.accountName = objCase.Account.Name;
                objQuotesRequestsSendCMP.accountIdentificationNumber = objCase.Account.IdentificationNumber__c;
                objQuotesRequestsSendCMP.originCase = objCase.Origin;
                objQuotesRequestsSendCMP.leadSource = objCase.Opportunity__r.LeadSource;
                objQuotesRequestsSendCMP.statusCase = objCase.Status;
                objQuotesRequestsSendCMP.createDate = objCase.CreatedDate.date();
                objQuotesRequestsSendCMP.strCreateDate = objCase.CreatedDate.date().format();
                objQuotesRequestsSendCMP.lastModifiedName = objCase.LastModifiedBy.Name;
                objQuotesRequestsSendCMP.lastModifiedDate = objCase.LastModifiedDate.date().format();
                objQuotesRequestsSendCMP.products = mapOpportunityLineItemByOpportunityId.containsKey(objCase.Opportunity__c) ?
                                                    getProductsTO(mapOpportunityLineItemByOpportunityId, objCase.Opportunity__c) :
                                                    null;
                objQuotesRequestsSendCMP.productComboName = PRODUCT_COMBO_NAME != null ?  PRODUCT_COMBO_NAME : MSG_PRODUCT_NOT_INFORMED;
                objQuotesRequestsSendCMP.quotes = mapQuoteByOpportunityId.containsKey(objCase.Opportunity__c) ?
                                                  getQuotesTO(mapQuoteByOpportunityId, mapOpportunityLineItemByOpportunityId, objCase.Opportunity__c) :
                                                  null;

                mapOpportunityLineItemByOpportunityId.remove(objCase.Opportunity__c);
            
                objQuotesRequestsSendCMP.quantityQuoteReceipt = QUANTITY_QUOTE_RECEIPT;
                objQuotesRequestsSendCMP.quantityQuoteRequest = QUANTITY_QUOTE_REQUEST;
                objQuotesRequestsSendCMP.quantityRequestInsideSLA = QUANTITY_REQUEST_INSIDE_SLA;
                objQuotesRequestsSendCMP.quantityRequestOutsideSLA = QUANTITY_REQUEST_OUTSIDE_SLA;

                objQuotesRequestsSendCMP.enterpriseName = mapEnterpriseNameByOpportunity.get(objCase.Opportunity__c);
                mapEnterpriseNameByOpportunity.remove(objCase.Opportunity__c);

                objQuotesRequestsSendCMP.comercialName = mapComercialNameOpportunity.get(objCase.Opportunity__c);
                mapComercialNameOpportunity.remove(objCase.Opportunity__c);

                objQuotesRequestsSendCMP.salesUnit = mapSalesUnitByOpportunity.get(objCase.Opportunity__c);
                mapSalesUnitByOpportunity.remove(objCase.Opportunity__c);

                setOpportunitysAdded.add(objCase.Opportunity__c);
                lstQuotesRequestsSendCMP.add(objQuotesRequestsSendCMP);

                if(lstQuotesRequestsSendCMP.size() == MAX_SIZE_QUOTE_LIST)
                {
                    break;
                }
            }
        }

        System.debug('lstQuotesRequestsSendCMP ==> ' + lstQuotesRequestsSendCMP);

        return JSON.serialize(lstQuotesRequestsSendCMP);
    }

    @AuraEnabled(cacheable=true)
    public static String getUsersInfo(){
        List<String> lTypeGroup = new List<String>{'Queue'};
        Map <Id, String> mapUserNameOrGroupNameByIds = UserBO.getInstance().getMapUserNameOrGroupNameByIdsAndQueues(lTypeGroup);
        List<ConnectWizCMPTO.UsersInformationSendCMP> lUserInformation = new  List<ConnectWizCMPTO.UsersInformationSendCMP>();

        for(Id key : mapUserNameOrGroupNameByIds.keySet()){
            ConnectWizCMPTO.UsersInformationSendCMP objUserInfor = new ConnectWizCMPTO.UsersInformationSendCMP();
            objUserInfor.id = key;
            objUserInfor.userName = mapUserNameOrGroupNameByIds.get(key);
            lUserInformation.add(objUserInfor);
        }
        return JSON.serialize(lUserInformation);
    }

    @AuraEnabled(cacheable=false)
    public static Boolean updateOwnerCaseFromPlacement(String caseId, String userId, String status){
         try{
            Case objCase = new Case(
                Id = caseId,
                OwnerId = userId,
                Status = status
            );

            Database.SaveResult srUpdCase= Database.update(objCase, false);
            if(srUpdCase.isSuccess()){
                System.debug('Successfully updated owner case. case id: ' + srUpdCase.getId());
                return srUpdCase.isSuccess();
            }else{
                System.debug('Failed to update owner case error message: ' + srUpdCase.getErrors());
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to update owner case error message: ' + e.getMessage());
            return false;
        }
    }

    private static List<ConnectWizCMPTO.Product> getProductsTO(Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId, String opportunityId){
        List<ConnectWizCMPTO.Product> lProducts = new List<ConnectWizCMPTO.Product>();
        String srtProductName = null;
        PRODUCT_COMBO_NAME = null;

        for(OpportunityLineItem objOpportunityLineItem : mapOpportunityLineItemByOpportunityId.get(opportunityId)){

            ConnectWizCMPTO.Product productTO = new ConnectWizCMPTO.Product();
            productTO.productFamily = objOpportunityLineItem.Product2.Family;
            productTO.productId = objOpportunityLineItem.Product2Id;
            productTO.productName = objOpportunityLineItem.Product2.Name;
            lProducts.add(productTO);
            if(srtProductName == null){
                srtProductName = objOpportunityLineItem.Product2.Name;
            }else if(!srtProductName.contains(objOpportunityLineItem.Product2.Name)){
                srtProductName = srtProductName + ' + ' + objOpportunityLineItem.Product2.Name;
            }
        }

        PRODUCT_COMBO_NAME = srtProductName;

        return lProducts;
    }

    private static final String COMPOSITION_QUOTE_RT_ID = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
    private static List<ConnectWizCMPTO.Quote> getQuotesTO(
        Map<Id, List<Quote>> mapQuoteByOpportunityId,
        Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId,
        String opportunityId
    ){
        List<ConnectWizCMPTO.Quote> lQuotes = new List<ConnectWizCMPTO.Quote>();
        /*List<String> lSrtQuoteRequest = new List<String>();
        List<String> lSrtQuoteReceipt = new List<String>();
        List<String> lSrtRequestInsideSLA = new List<String>();
        List<String> lSrtRequestOutsideSLA  = new List<String>(); */
        Integer referenceSLA = 0;

        List<OpportunityLineItem> lstOpportunityLineItem = mapOpportunityLineItemByOpportunityId.containsKey(opportunityId) ?
                                                            mapOpportunityLineItemByOpportunityId.get(opportunityId) :
                                                            null;
        Integer quoteReturnSLA = lstOpportunityLineItem.size() > 0 ?
                                    Integer.valueOf(lstOpportunityLineItem[0].Product2.QuoteReturnSLA__c) :
                                    null;

        for(Quote objQuote : mapQuoteByOpportunityId.get(opportunityId)){

            ConnectWizCMPTO.Quote quoteTO = new ConnectWizCMPTO.Quote();
                quoteTO.insuranceCompany = objQuote.Company__c;
                quoteTO.quoteReceiptDate = objQuote.QuoteReceiptDate__c;
                quoteTO.quoteRequestDate = objQuote.QuoteRequestDate__c;
            lQuotes.add(quoteTO);

            if(objQuote.QuoteReceiptDate__c != null && objQuote.RecordTypeId == COMPOSITION_QUOTE_RT_ID){
                QUANTITY_QUOTE_RECEIPT++;
            }
            else if(objQuote.QuoteRequestDate__c != null && objQuote.RecordTypeId == COMPOSITION_QUOTE_RT_ID){
                QUANTITY_QUOTE_REQUEST++;
                referenceSLA =  objQuote.QuoteReceiptDate__c != null ?
                                objQuote.QuoteRequestDate__c.daysBetween(objQuote.QuoteReceiptDate__c) :
                                objQuote.QuoteRequestDate__c.daysBetween(date.today());
            }

            if(quoteReturnSLA != null){
                if(quoteReturnSLA >= referenceSLA){
                    QUANTITY_REQUEST_INSIDE_SLA++;
                }else{
                    QUANTITY_REQUEST_OUTSIDE_SLA++;
                }
            }else{
                QUANTITY_REQUEST_INSIDE_SLA++;
            }


        }

        // QUANTITY_REQUEST_INSIDE_SLA
        // QUANTITY_REQUEST_OUTSIDE_SLA
        // QUANTITY_QUOTE_REQUEST = StringUtil.getInstance().getSizeListString(lSrtQuoteRequest);
        // QUANTITY_QUOTE_RECEIPT = StringUtil.getInstance().getSizeListString(lSrtQuoteReceipt);

        return lQuotes;
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> getTaskHistory(String recordId){
        // String recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Connect@Wiz').getRecordTypeId();

        return [SELECT
                        Subject, Owner.Name, Description, CreatedDate, Type, Status
                    FROM
                        Task
                    WHERE
                        WhatId =:recordId
                    ORDER BY CreatedDate desc LIMIT 50
                ];
    }

    @AuraEnabled
    public static List<Case> getCaseStatus(String recordId){
        return [SELECT
                        Status
                    FROM
                        case
                    WHERE
                        id =:recordId
                    ORDER BY CreatedDate desc LIMIT 1
                ];
    }

    @AuraEnabled(cacheable=true)
    public static string getCaseInfo(String recordId){
        List<Case> lstCase = new List<Case>([SELECT
                                                Account.Name,
                                                Account.IdentificationNumber__c,
                                                Owner.Name,Origin, Status,Opportunity__c,
                                                Opportunity__r.OpportunityNumber__c,Opportunity__r.LeadSource,
                                                ContactId, AccountId
                                            FROM
                                                Case
                                            WHERE Id =:recordId LIMIT 1
                                        ]);
        ConnectWizCMPTO.CaseInformationHeader csi = new ConnectWizCMPTO.CaseInformationHeader();

        OpportunityLineItem opportunityProduct = new OpportunityLineItem();
        List<Technical_Specification_Questionnaire__c> lstTechnicalSpecificationQuestionnaire = new List<Technical_Specification_Questionnaire__c>();



        for(case cs : lstCase){

            opportunityProduct = OpportunityLineItemDAO.getOpportunityLineItensByOpportunityId(cs.Opportunity__c);

            lstTechnicalSpecificationQuestionnaire = TechnicalSpecificationQuestionnaireDAO.getTechnicalSpecificationQuestionnairesByOppId(cs.Opportunity__c);


            csi.accountName = cs.Account.Name;
            csi.ownerName = cs.Owner.Name;
            csi.identificationNumber = cs.Account.IdentificationNumber__c;
            csi.caseOrigin = cs.Opportunity__r.LeadSource;
            csi.opportunityNumber = cs.Opportunity__r.OpportunityNumber__c;
            csi.opportunityId = cs.Opportunity__c;
            csi.ContactOrLeadId = cs.ContactId;
            csi.accountId = cs.AccountId;
            csi.productName = opportunityProduct.Product2.Name;
            csi.hasForm = !lstTechnicalSpecificationQuestionnaire.isEmpty() ? true : false;
        }

        return JSON.serialize(csi);
    }

    @AuraEnabled
    public static Task createTaskHistory(String whatId, String whoId, String subject, String description, String type){
         try{
            Task task = new Task(
                Subject = subject,
                OwnerId = UserInfo.getUserId(),
                Status = 'Open',
                Priority = 'Normal',
                Description = description,
                Type = type,
                WhatId = whatId,
                WhoId = whoId,
                RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Connect@Wiz').getRecordTypeId(),
                BusinessUnit__c = 'Wiz Benefícios',
                IsVisibleInSelfService = true
            );
            TaskBO.getInstance().createTaskHistory(
                whatId,
                whoId,
                subject,
                description,
                type,
                task.RecordTypeId,
                'Wiz Benefícios'
            );
            return task;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static Boolean deleteTaskHistory(Id recordId){
         try{
            Database.delete(recordId);
            return true;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        return false;
    }


    @AuraEnabled
    public static Boolean updateCaseFromPlacement(String caseId, String reason, String status){
        Boolean resp= false;
         try{
            Case objCase = new Case(
                Id = caseId,
                Status = status,
                Reason = reason
            );

            Database.SaveResult srUpdCase= Database.update(objCase, false);
            if(srUpdCase.isSuccess()){
                resp = true;
                System.debug('Successfully updated case and opportunity. case id: ' + srUpdCase.getId());
                return resp;
            }else{
                System.debug('Failed to update case error message: ' + srUpdCase.getErrors());
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to update error message: ' + e.getMessage());
            return false;
        }
    }

    @AuraEnabled(cacheable=false)
    public static String getOpportunity(String recordId){
        Opportunity opp = new Opportunity();
         try{
            opp = [SELECT
                        Description, CloseDate, StageName, Type,
                        ProbabilityOfWinning__c, InsuredAmount__c,
                        IsInsuranceRestriction__c, IsOpportunityNomination__c,
                            (SELECT
                                Id, Product2.Name, UnitPrice, ExpectedCommission__c, QuantityOfItems__c
                            FROM OpportunityLineItems
                        )
                    FROM
                        Opportunity
                    WHERE Id =:recordId LIMIT 1
                ];

            return JSON.serialize(opp);

        } catch (Exception e){
            System.debug(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static Boolean updateStageOpportunity(String recordId, String stageName){
             try{
                list<Opportunity> lstUpdOpportunity = new list<Opportunity> { new Opportunity(
                    Id = recordId,
                    StageName = stageName
                )};
                OpportunityBO.getInstance().lstUpdOpportunities(lstUpdOpportunity);
                return true;
            } catch (Exception e){
                System.debug('Failed to update error message: ' + e.getMessage());
                return false;
            }
        }
    
    @AuraEnabled(cacheable=true)
    public static List<ConnectWizCMPTO.Questionnaire> getQuestionnaireAnswers(String recordId){
        
        List<ConnectWizCMPTO.Questionnaire> response = new List<ConnectWizCMPTO.Questionnaire>();
        
        try {
            List<Questionnaire__c> questionnaires = [SELECT Id, Name, (SELECT Id, Question_Label__c, Question_Type__c, Answer__c, Comment__c FROM Questionnaire_Answers__r ORDER BY Questionnaire_Question__r.Order__c) FROM Questionnaire__c WHERE Opportunity__c = :recordId ORDER BY CreatedDate DESC];
            
            for (Questionnaire__c questionnaire : questionnaires){
                ConnectWizCMPTO.Questionnaire q = new ConnectWizCMPTO.Questionnaire();
                q.id = questionnaire.Id;
                q.name = questionnaire.Name;
                q.showDetails = false;
                q.answers = new List<ConnectWizCMPTO.QuestionnaireAnswer>();
                for (Questionnaire_Answer__c answer : questionnaire.Questionnaire_Answers__r){
                    ConnectWizCMPTO.QuestionnaireAnswer a = new ConnectWizCMPTO.QuestionnaireAnswer();
                    a.answer = answer.Answer__c;
                    a.comment = answer.Comment__c;
                    a.id = answer.Id;
                    a.questionLabel = answer.Question_Label__c;
                    a.questionType = answer.Question_Type__c;
                    q.answers.add(a);
                }
                response.add(q);
            }
        } catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return response;
    }

    private static final String PARTIAL_QUOTE_RT_ID = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('CorporateParcial').getRecordTypeId();
    @AuraEnabled(cacheable=true)
    public static List<ConnectWizCMPTO.PartialQuote> getPartialQuotes(String recordId, List<String> openQuotes){
        List<Quote> quoteList = QuoteDAO.getInstance().getPortalQuotesByOppIdAndRecTypeId(recordId, PARTIAL_QUOTE_RT_ID);
        List<ConnectWizCMPTO.PartialQuote> partialQuotes = new List<ConnectWizCMPTO.PartialQuote>();
        for (Quote q: quoteList){
            ConnectWizCMPTO.PartialQuote partialQuote = new ConnectWizCMPTO.PartialQuote();
            partialQuote.id = q.Id;
            partialQuote.name = q.Name;
            partialQuote.integralization = q.InsuredAmount__c < q.Opportunity.InsuredAmount__c;
            partialQuote.requestDate = q.QuoteRequestDate__c;
            partialQuote.receiptDate = q.QuoteReceiptDate__c;
            partialQuote.insuranceCompany = q.Company__c;
            partialQuote.insurancePremium = q.PrizeAmount__c;
            partialQuote.amountInsurance = q.InsuredAmount__c;
            partialQuote.netInsurancePremium = q.QuoteLineItems.get(0)?.PrizeNetValue__c;
            partialQuote.taxInsurancePremium = q.QuoteLineItems.get(0)?.IOFPrizeValue__c;
            partialQuote.comissionValue = q.QuoteLineItems.get(0)?.CommissionPercent__c;
            partialQuote.agencyValue = q.QuoteLineItems.get(0)?.AgencyPercentage__c;
            partialQuote.observations = q.Description;
            partialQuote.isRequested = false;
            partialQuote.isReceived = false;
            if (partialQuote.receiptDate != null){
                partialQuote.isReceived = true;
            } else if (partialQuote.requestDate != null){
                partialQuote.isRequested = true;
            }
            if (openQuotes.contains(partialQuote.id)){
                partialQuote.showDetails = true;
            } else {
                partialQuote.showDetails = false;
            }
            partialQuotes.add(partialQuote);
        }

        return partialQuotes;
    }

    @AuraEnabled
    public static Quote insertPartialQuote(ConnectWizCMPTO.PartialQuote partialQuote, String oppId){
        try{
            Quote quoteToInsert = new Quote();
            quoteToInsert.Company__c = partialQuote.insuranceCompany;
            quoteToInsert.PrizeAmount__c = partialQuote.insurancePremium;
            quoteToInsert.InsuredAmount__c = partialQuote.amountInsurance;
            quoteToInsert.QuoteRequestDate__c = partialQuote.requestDate;
            quoteToInsert.QuoteReceiptDate__c = partialQuote.receiptDate;
            quoteToInsert.Description = partialQuote.observations;
            quoteToInsert.Status = 'Draft';
            quoteToInsert.OpportunityId = oppId;
            quoteToInsert.RecordTypeId = PARTIAL_QUOTE_RT_ID;
            insert quoteToInsert;
            
            QuoteLineItem quoteLineItemToInsert = new QuoteLineItem();
            quoteLineItemToInsert.CommissionPercent__c = partialQuote.comissionValue;
            quoteLineItemToInsert.UnitPrice = partialQuote.insurancePremium == null ? 0 : partialQuote.insurancePremium;
            quoteLineItemToInsert.Quantity = 1;
            quoteLineItemToInsert.PrizeNetValue__c = partialQuote.netInsurancePremium;
            quoteLineItemToInsert.IOFPrizeValue__c = partialQuote.taxInsurancePremium;
            quoteLineItemToInsert.AgencyPercentage__c = partialQUote.agencyValue;
            quoteLineItemToInsert.QuoteId = quoteToInsert.Id;
            
            OpportunityLineItem oppLineItem = OpportunityLineItemDAO.getOpportunityLineItensByOpportunityId(oppId);
            quoteLineItemToInsert.PricebookEntryId = oppLineItem.PricebookEntryId;
            quoteLineItemToInsert.Product2Id = oppLineItem.Product2Id;
            insert quoteLineItemToInsert;

            if (!partialQuote.integralization){
                ConnectWizCMPTO.ProposalComposition composition = new ConnectWizCMPTO.ProposalComposition();
                composition.isLead = true;
                composition.partialQuote = partialQuote;
                composition.partialQuote.id = quoteToInsert.Id;
                composition.amountInsuranceUsed = partialQuote.amountInsurance;

                ConnectWizCMPTO.Proposal proposal = new ConnectWizCMPTO.Proposal();
                proposal.composition = new List<ConnectWizCMPTO.ProposalComposition>{composition};
                proposal.observations = partialQuote.observations;

                insertProposal(proposal, oppId);
            }

            return quoteToInsert;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void updatePartialQuote(ConnectWizCMPTO.PartialQuote partialQuote){
        try {
            Quote quoteToUpdate = new Quote(Id = partialQuote.Id);
            quoteToUpdate.Company__c = partialQuote.insuranceCompany;
            quoteToUpdate.PrizeAmount__c = partialQuote.insurancePremium;
            quoteToUpdate.InsuredAmount__c = partialQuote.amountInsurance;
            quoteToUpdate.QuoteRequestDate__c = partialQuote.requestDate;
            quoteToUpdate.QuoteReceiptDate__c = partialQuote.receiptDate;
            quoteToUpdate.Description = partialQuote.observations;
            update quoteToUpdate;

            QuoteLineItem quoteLineItemToUpdate = QuoteLineItemDAO.getQuoteLineItemByQuoteId(partialQuote.Id);
            quoteLineItemToUpdate.CommissionPercent__c = partialQuote.comissionValue;
            quoteLineItemToUpdate.UnitPrice = partialQuote.insurancePremium == null ? 0 : partialQuote.insurancePremium;
            quoteLineItemToUpdate.PrizeNetValue__c = partialQuote.netInsurancePremium;
            quoteLineItemToUpdate.IOFPrizeValue__c = partialQuote.taxInsurancePremium;
            quoteLineItemToUpdate.AgencyPercentage__c = partialQUote.agencyValue;
            update quoteLineItemToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deletePartialQuote(String quoteId){
        try {
            delete new Quote(Id = quoteId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ConnectWizCMPTO.Proposal> getProposal(String recordId){
        List<ConnectWizCMPTO.PartialQuote> availableQuotes = getPartialQuotes(recordId, new List<String>());
        Map<Id, ConnectWizCMPTO.PartialQuote> availableQuotesMap = new Map<Id, ConnectWizCMPTO.PartialQuote>();
        for (ConnectWizCMPTO.PartialQuote quote : availableQuotes){
            availableQuotesMap.put(quote.id, quote);
        }

        Map<Id, Quote> quoteMap = new Map<Id, Quote>(QuoteDAO.getInstance().getPortalQuotesByOppIdAndRecTypeId(recordId, COMPOSITION_QUOTE_RT_ID));
        List<Quote> quoteList = quoteMap.values();

        List<QuoteIntegralization__c> integralizationList = QuoteIntegralizationDAO.getInstance().getCompositionQuotesByProposal(quoteMap.keySet());
        Map<Id, List<QuoteIntegralization__c>> quoteToCompositionMap = new Map<Id, List<QuoteIntegralization__c>>();
        for (QuoteIntegralization__c i : integralizationList){
            List<QuoteIntegralization__c> iList = quoteToCompositionMap.get(i.IntegralQuote__c);
            if (iList == null){
                iList = new List<QuoteIntegralization__c>();
            }
            iList.add(i);
            quoteToCompositionMap.put(i.IntegralQuote__c, iList);
        }

        List<ConnectWizCMPTO.Proposal> proposalList = new List<ConnectWizCMPTO.Proposal>();
        for (Quote q: quoteList){

            ConnectWizCMPTO.PartialQuote compositeQuote = new ConnectWizCMPTO.PartialQuote();
            compositeQuote.id = q.Id;
            compositeQuote.name = q.Name;
            compositeQuote.integralization = q.InsuredAmount__c < q.Opportunity.InsuredAmount__c;
            compositeQuote.requestDate = q.QuoteRequestDate__c;
            compositeQuote.receiptDate = q.QuoteReceiptDate__c;
            compositeQuote.insuranceCompany = q.Company__c;
            compositeQuote.insurancePremium = q.PrizeAmount__c;
            compositeQuote.amountInsurance = q.InsuredAmount__c;
            compositeQuote.netInsurancePremium = q.QuoteLineItems.get(0)?.PrizeNetValue__c;
            compositeQuote.taxInsurancePremium = q.QuoteLineItems.get(0)?.IOFPrizeValue__c;
            compositeQuote.comissionValue = q.QuoteLineItems.get(0)?.CommissionPercent__c;
            compositeQuote.agencyValue = q.QuoteLineItems.get(0)?.AgencyPercentage__c;
            compositeQuote.observations = q.Description;
            compositeQuote.isRequested = false;
            compositeQuote.isReceived = false;
            
            ConnectWizCMPTO.Proposal p = new ConnectWizCMPTO.Proposal();
            p.availableQuotes = availableQuotes.clone();
            p.compositeQuote = compositeQuote;
            p.observations = compositeQuote.observations;
            p.composition = new List<ConnectWizCMPTO.ProposalComposition>();
            
            List<QuoteIntegralization__c> iList = quoteToCompositionMap.get(q.Id);
            for (QuoteIntegralization__c i : iList){
                ConnectWizCMPTO.ProposalComposition comp = new ConnectWizCMPTO.ProposalComposition();
                comp.partialQuote = availableQuotesMap.get(i.PartialQuote__r.Id);
                comp.isLead = i.PartialQuote__r.Company__c == q.Company__c;
                comp.amountInsuranceUsed = i.InsuredAmount__c;
                p.composition.add(comp);
            }
            proposalList.add(p);
        }
        return proposalList;
    }

    @AuraEnabled
    public static void insertProposal(ConnectWizCMPTO.Proposal proposal, String oppId){
        Quote quoteToInsert = new Quote();
        quoteToInsert.PrizeAmount__c = 0;
        quoteToInsert.InsuredAmount__c = 0;
        quoteToInsert.Description = proposal.observations;
        quoteToInsert.Status = 'Presented';
        quoteToInsert.OpportunityId = oppId;
        quoteToInsert.RecordTypeId = COMPOSITION_QUOTE_RT_ID;
        quoteToInsert.PartialQuoteCount__c = 0;
        quoteToInsert.CoinsuranceCompany__c = '';

        QuoteLineItem quoteLineItemToInsert = new QuoteLineItem();
        quoteLineItemToInsert.CommissionPercent__c = 0;
        quoteLineItemToInsert.UnitPrice = 0;
        quoteLineItemToInsert.Quantity = 1;
        quoteLineItemToInsert.PrizeNetValue__c = 0;
        quoteLineItemToInsert.IOFPrizeValue__c = 0;
        quoteLineItemToInsert.AgencyPercentage__c = 0;
        for (ConnectWizCMPTO.ProposalComposition composition : proposal.composition){
            if (composition.isLead){
                quoteToInsert.Company__c = composition.partialQuote.insuranceCompany;
                quoteToInsert.QuoteRequestDate__c = composition.partialQuote.requestDate;
                quoteToInsert.QuoteReceiptDate__c = composition.partialQuote.receiptDate;
            } else {
                quoteToInsert.CoinsuranceCompany__c += composition.partialQuote.insuranceCompany + ',';
            }
            quoteToInsert.PrizeAmount__c += composition.partialQuote.insurancePremium == null ? 0 : composition.partialQuote.insurancePremium;
            quoteToInsert.InsuredAmount__c += composition.amountInsuranceUsed == null ? 0 : composition.amountInsuranceUsed;
            quoteToInsert.PartialQuoteCount__c += 1;

            quoteLineItemToInsert.CommissionPercent__c += composition.partialQuote.comissionValue == null ? 0 : composition.partialQuote.comissionValue;
            quoteLineItemToInsert.UnitPrice += composition.partialQuote.insurancePremium == null ? 0 : composition.partialQuote.insurancePremium;
            quoteLineItemToInsert.PrizeNetValue__c += composition.partialQuote.netInsurancePremium == null ? 0 : composition.partialQuote.netInsurancePremium;
            quoteLineItemToInsert.IOFPrizeValue__c += composition.partialQuote.taxInsurancePremium == null ? 0 : composition.partialQuote.taxInsurancePremium;
            quoteLineItemToInsert.AgencyPercentage__c += composition.partialQUote.agencyValue == null ? 0 : composition.partialQUote.agencyValue;
        }
        insert quoteToInsert;
        
        quoteLineItemToInsert.QuoteId = quoteToInsert.Id;
        
        OpportunityLineItem oppLineItem = OpportunityLineItemDAO.getOpportunityLineItensByOpportunityId(oppId);
        quoteLineItemToInsert.PricebookEntryId = oppLineItem.PricebookEntryId;
        quoteLineItemToInsert.Product2Id = oppLineItem.Product2Id;
        insert quoteLineItemToInsert;

        List<QuoteIntegralization__c> integralizationList = new List<QuoteIntegralization__c>();
        for (ConnectWizCMPTO.ProposalComposition composition : proposal.composition){
            QuoteIntegralization__c integralization = new QuoteIntegralization__c();
            integralization.PartialQuote__c = composition.partialQuote.id;
            integralization.IntegralQuote__c = quoteToInsert.Id;
            integralization.InsuredAmount__c = composition.amountInsuranceUsed;
            integralization.LeadQuote__c = composition.isLead;
            integralizationList.add(integralization);
        }
        insert integralizationList;
    }

    @AuraEnabled
    public static void updateProposal(ConnectWizCMPTO.Proposal proposal, String compositeQuoteid){
        Quote quoteToUpdate = new Quote(Id = compositeQuoteid);
        quoteToUpdate.PrizeAmount__c = 0;
        quoteToUpdate.InsuredAmount__c = 0;
        quoteToUpdate.Description = proposal.observations;
        quoteToUpdate.PartialQuoteCount__c = 0;
        quoteToUpdate.CoinsuranceCompany__c = '';
        
        QuoteLineItem quoteLineItemToUpdate = QuoteLineItemDAO.getQuoteLineItemByQuoteId(compositeQuoteid);
        quoteLineItemToUpdate.CommissionPercent__c = 0;
        quoteLineItemToUpdate.UnitPrice = 0;
        quoteLineItemToUpdate.PrizeNetValue__c = 0;
        quoteLineItemToUpdate.IOFPrizeValue__c = 0;
        quoteLineItemToUpdate.AgencyPercentage__c = 0;
        
        for (ConnectWizCMPTO.ProposalComposition composition : proposal.composition){
            if (composition.isLead){
                quoteToUpdate.Company__c = composition.partialQuote.insuranceCompany;
                quoteToUpdate.QuoteRequestDate__c = composition.partialQuote.requestDate;
                quoteToUpdate.QuoteReceiptDate__c = composition.partialQuote.receiptDate;
            } else {
                quoteToUpdate.CoinsuranceCompany__c += composition.partialQuote.insuranceCompany + ',';
            }
            quoteToUpdate.PrizeAmount__c += composition.partialQuote.insurancePremium == null ? 0 : composition.partialQuote.insurancePremium;
            quoteToUpdate.InsuredAmount__c += composition.amountInsuranceUsed == null ? 0 : composition.amountInsuranceUsed;
            quoteToUpdate.PartialQuoteCount__c += 1;

            quoteLineItemToUpdate.CommissionPercent__c += composition.partialQuote.comissionValue == null ? 0 : composition.partialQuote.comissionValue;
            quoteLineItemToUpdate.UnitPrice += composition.partialQuote.insurancePremium == null ? 0 : composition.partialQuote.insurancePremium;
            quoteLineItemToUpdate.PrizeNetValue__c += composition.partialQuote.netInsurancePremium == null ? 0 : composition.partialQuote.netInsurancePremium;
            quoteLineItemToUpdate.IOFPrizeValue__c += composition.partialQuote.taxInsurancePremium == null ? 0 : composition.partialQuote.taxInsurancePremium;
            quoteLineItemToUpdate.AgencyPercentage__c += composition.partialQUote.agencyValue == null ? 0 : composition.partialQUote.agencyValue;
        }

        update quoteToUpdate;
        update quoteLineItemToUpdate;

        List<QuoteIntegralization__c> integralizationList = new List<QuoteIntegralization__c>();
        for (ConnectWizCMPTO.ProposalComposition composition : proposal.composition){
            QuoteIntegralization__c integralization = new QuoteIntegralization__c();
            integralization.PartialQuote__c = composition.partialQuote.id;
            integralization.IntegralQuote__c = quoteToUpdate.Id;
            integralization.InsuredAmount__c = composition.amountInsuranceUsed;
            integralization.LeadQuote__c = composition.isLead;
            integralizationList.add(integralization);
        }

        delete QuoteIntegralizationDAO.getInstance().getCompositionQuotesByProposal(new Set<Id>{quoteToUpdate.Id});
        insert integralizationList;
    }

    @AuraEnabled
    public static void deleteProposal(String proposalId){
        try {
            delete new Quote(Id = proposalId);
            delete QuoteIntegralizationDAO.getInstance().getCompositionQuotesByProposal(new Set<Id>{proposalId});
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}