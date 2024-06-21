/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class Corporate_WFlowService {

    
    //monta a TO com os dados e atualizar o referenceId com os dados do response além de atualizar os dados da opp
    public static void postOpportunitySales(String serializedOpportunity){
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        String oppStageName = 'Cotação';
  
        Opportunity objOpportunity = (Opportunity) (
                                            JSON.deserialize(
                                                    (String) serializedOpportunity, 
                                                    Opportunity.class
                                                )
                                            );
        String msgErrorSubject = 'Error ao atualizar Oportunidade de venda' + objOpportunity.Id + 'após enviar ao WFlow';
        
        Corporate_WFlowTO.OpportunitySalesPostRequest oppPostRequest =  setOpportunitySales(objOpportunity);    

        Map<String, Object> mapReturnJson = (Map<String, Object>) 
                                    IntegrationAPIWFlow.getInstance().postOpportunitySales(JSON.serialize(oppPostRequest));

        System.debug('MAP Return : ' + mapReturnJson);
        if(mapReturnJson.containsKey('Retorno')){
            
            Corporate_WFlowTO.OpportunitySalesPostResponse oppResponse = (Corporate_WFlowTO.OpportunitySalesPostResponse) (
                                                                        JSON.deserialize(
                                                                            (String) mapReturnJson.get('Retorno'), 
                                                                            Corporate_WFlowTO.OpportunitySalesPostResponse.class
                                                                        )
                                                                    );
            System.debug('@@@ oppResponse : ' + oppResponse);

            lstOpportunities.add(new Opportunity (
                Id = objOpportunity.Id,
                ExternalReferenceId__c = oppResponse.opportunityId,
                StageName = oppStageName
            ));
    
        }

        if(!lstOpportunities.isEmpty()){    
           
            String msgType = 'OpportuntySendedWFlow';              
            ChatterUtils.getInstance().makeMessagePostChatters(msgType, lstOpportunities, null);
            Savepoint sp = Database.setSavepoint();
             try{
                Database.SaveResult[] srListFiles = Database.update(lstOpportunities, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstOpportunities);  
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }

        if(mapReturnJson.containsKey('Retorno')){   
            sendDocumentsToWFlow(serializedOpportunity);
        }
    }

    public static void postOpportunityEndorsement(String serializedOpportunity){
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        String oppStageName = 'Cotação';
        
        Opportunity objOpportunity = (Opportunity) (            
                                            JSON.deserialize(
                                                    (String) serializedOpportunity, 
                                                    Opportunity.class
                                                )
                                            );    
        String msgErrorSubject = 'Error ao atualizar Oportunidade de endosso' + objOpportunity.Id + 'após enviar ao WFlow';    
        
        Corporate_WFlowTO.OpportunityEndorsementPostRequest oppPostRequest = setOpportunityEndorsement(objOpportunity);   

        Map<String, Object> mapReturnJson = (Map<String, Object>) 
                                    IntegrationAPIWFlow.getInstance().postOpportunityEndorsement(JSON.serialize(oppPostRequest));

        System.debug('MAP Return : ' + mapReturnJson);
        if(mapReturnJson.containsKey('Retorno')){            
            Corporate_WFlowTO.OpportunityEndorsementPostResponse oppResponse = (Corporate_WFlowTO.OpportunityEndorsementPostResponse) (
                                                                        JSON.deserialize(
                                                                            (String) mapReturnJson.get('Retorno'), 
                                                                            Corporate_WFlowTO.OpportunityEndorsementPostResponse.class
                                                                        )
                                                                    );
            System.debug('@@@ oppResponse : ' + oppResponse);

            lstOpportunities.add(new Opportunity (
                Id = objOpportunity.Id,
                ExternalReferenceId__c = oppResponse.opportunityId, 
                StageName = oppStageName
            ));    
        }

        if(!lstOpportunities.isEmpty()){

            List<Opportunity> lstOportunittyForPostChatter = new List<Opportunity>();
            lstOportunittyForPostChatter.add(objOpportunity);

            String msgType = 'OpportuntySendedWFlow';              
            ChatterUtils.getInstance().makeMessagePostChatters(msgType, lstOportunittyForPostChatter, null);
            Savepoint sp = Database.setSavepoint();
             try{
                Database.SaveResult[] srListFiles = Database.update(lstOpportunities, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstOpportunities);  
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        } 
        if(mapReturnJson.containsKey('Retorno')){   
            sendDocumentsToWFlow(serializedOpportunity);
        }
    }

    @future(callout=true)
    public static void updateOpportunityInWFlow(String lstSerializedOpportunityWflow){
        List<Opportunity> lstOpportunityWflow = (List<Opportunity>) JSON.deserialize(lstSerializedOpportunityWflow, List<Opportunity>.class);
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        String msgErrorSubject = 'Error ao atualizar a Oppotunidade no WFlow';
        List<String> errorMsg = new List<String>();
        
          if(!Test.isRunningTest()){

            for(Opportunity objOpportunity : lstOpportunityWflow){

                Map<String, Object> mapReturnJson = (Map<String, Object>) 
                                                IntegrationAPIWFlow.getInstance().opportunityUpdateInWFlow(objOpportunity.Id);

                        System.debug('MAP Return : ' + mapReturnJson);
                        if(mapReturnJson.containsKey('Retorno')){            
                            Corporate_WFlowTO.OpportunityUpdatePostResponse oppResponse = (Corporate_WFlowTO.OpportunityUpdatePostResponse) (
                                                                                        JSON.deserialize(
                                                                                            (String) mapReturnJson.get('Retorno'), 
                                                                                            Corporate_WFlowTO.OpportunityUpdatePostResponse.class
                                                                                        )
                                                                                    );
                            System.debug('@@@ oppResponse : ' + oppResponse);
                            if(objOpportunity.ExternalReferenceId__c == null){
                                lstOpportunities.add(new Opportunity (
                                    Id = objOpportunity.Id,
                                    ExternalReferenceId__c = oppResponse.opportunityId
                                ));

                                String serializedOpportunity = JSON.serialize(objOpportunity);

                                sendDocumentsToWFlow(serializedOpportunity);
                            }
                                
                        }

                        if(!lstOpportunities.isEmpty()){

                            Savepoint sp = Database.setSavepoint();

                            try{
                                Database.SaveResult[] srListFiles = Database.update(lstOpportunities, false);
                                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstOpportunities);  
                            } catch (Exception e){
                                System.Debug(e);
                                Database.rollback(sp);
                            }
                        }   

            }
                
            
        }


    }

    @future(callout=true)
    public static void postQuoteUpdateInWFlow(String quoteId){
        String msgErrorSubject = 'Error ao atualizar a Quote no WFlow';
        List<String> errorMsg = new List<String>();
        String formData;

        
        Corporate_WFlowTO.QuoteUpdatePostRequest quoteUpdatePostRequest = new Corporate_WFlowTO.QuoteUpdatePostRequest();
        quoteUpdatePostRequest.id = quoteId;

        Map<String, Object> mapReturnJson = (Map<String, Object>) 
                                        IntegrationAPIWFlow.getInstance().postQuoteUpdateInWFlow(JSON.serialize(quoteUpdatePostRequest));

        System.debug('MAP Return : ' + mapReturnJson);
        if(mapReturnJson.containsKey('ErrorMessage')){
            errorMsg.add((String) mapReturnJson.get('ErrorMessage'));                    

            ErrorLogService.getInstance().logEDisparaEmail(errorMsg, msgErrorSubject);

        }
    }

    public static void sendDocumentsToWFlow(String serializedOpportunity){
        List<String> errorMsg = new List<String>();
        Map<String, Object> mapReturnJson = new Map<String, Object>();

        Opportunity objOpportunity = (Opportunity) (            
                                            JSON.deserialize(
                                                    (String) serializedOpportunity, 
                                                    Opportunity.class
                                                )
                                            );

        String msgErrorSubject = 'Error ao enviar os documentos da oportunidade ' + objOpportunity.Id + ' ao WFlow';

        List<Corporate_WFlowTO.DocumentSendWFlow> lstDocumentSendWFlow = setDocumentOppSendWFlow(objOpportunity);

        if(!lstDocumentSendWFlow.isEmpty()){
            mapReturnJson = (Map<String, Object>) 
                                    IntegrationAPIWFlow.getInstance().postDocument(JSON.serialize(lstDocumentSendWFlow));
        }
        
        System.debug('MAP Return : ' + mapReturnJson);
        if(mapReturnJson.containsKey('ErrorMessage')){
            
            errorMsg.add((String) mapReturnJson.get('ErrorMessage'));                    

            ErrorLogService.getInstance().logEDisparaEmail(errorMsg, msgErrorSubject);

        }

    }
    @future(callout=true)
    public static void sendAprovedQuoteToWFlow(String serializedQuoteAccepted){
        List<String> errorMsg = new List<String>();

        Quote objQuote = (Quote) (     
                            JSON.deserialize(
                                    (String) serializedQuoteAccepted, 
                                    Quote.class
                                )
                            );

        String msgErrorSubject = 'Error ao enviar a cotação aprovada da oportunidade: ' + objQuote.OpportunityId + ' ao WFlow';

        Corporate_WFlowTO.QuoteApprovalPutRequest quoteApproval = new Corporate_WFlowTO.QuoteApprovalPutRequest();
        quoteApproval.quoteItemSF = objQuote.Id;

        Map<String, Object> mapReturnJson = (Map<String, Object>) 
                                    IntegrationAPIWFlow.getInstance().putQuoteApproval(JSON.serialize(quoteApproval));

        if(mapReturnJson.containsKey('Retorno')){   
            
            List<Opportunity> lstOpportunities = OpportunityDAO.getInstance().getAllFieldsById(objQuote.OpportunityId);
            String msgType = 'ApprovedQuoteSendedWFlow';
            String msgComplementary = '\n';
            msgComplementary += 'A Cotação: ' + objQuote.Name + '\n';
            msgComplementary += 'Seguradora: ' + objQuote.Company__c + '\n';
            msgComplementary += 'Valor R$: ' + objQuote.TotalPrice + '\n';
            ChatterUtils.getInstance().makeMessagePostChatters(msgType, lstOpportunities, msgComplementary);
        }
    }

    private static Corporate_WFlowTO.OpportunitySalesPostRequest setOpportunitySales(Opportunity objOpportunity){

        OpportunityLineItem objOppLineItem = [SELECT    Id, 
                                                        ExpectedCommission__c, 
                                                        Product2Id, 
                                                        Product2.Name,
                                                        Quantity
                                              FROM      OpportunityLineItem
                                              WHERE     OpportunityId =: objOpportunity.Id
                                              Limit     1];

        Corporate_WFlowTO.OpportunitySalesPostRequest oppSalesPost = new Corporate_WFlowTO.OpportunitySalesPostRequest();
        oppSalesPost.policyHolderId = objOpportunity.AccountId;
        oppSalesPost.insuranceType = objOpportunity.Type == 'New' ? 1 : 
                                     objOpportunity.Type == 'ReNew' ? 2 :
                                     objOpportunity.Type == 'CrossSell' ? 3 : null;
        oppSalesPost.totalItems = Integer.valueOf(objOppLineItem.Quantity);
        oppSalesPost.insuredAmount = objOpportunity.InsuredAmount__c;
        oppSalesPost.valueOpportunity = objOpportunity.Amount;
        oppSalesPost.riskCheck = false;
        oppSalesPost.gn = objOpportunity.OwnerId;
        oppSalesPost.product2Id = objOppLineItem.Product2Id;
        oppSalesPost.product2Name = objOppLineItem.Product2.Name;
        oppSalesPost.probabilityOfWinning = objOpportunity.ProbabilityOfWinning__c;
        oppSalesPost.closeDate = String.valueOfGmt(objOpportunity.CloseDate);
        oppSalesPost.commercialType = objOpportunity.LeadSource;
        oppSalesPost.contract2Id = objOpportunity.Contract2Id__c;  
        oppSalesPost.opportunityId = objOpportunity.Id;      

        return oppSalesPost;

    }
    private static Corporate_WFlowTO.OpportunityEndorsementPostRequest setOpportunityEndorsement(Opportunity objOpportunity){

        String company = null;
        DateTime startDate = null;

        OpportunityLineItem objOppLineItem = [SELECT    Id, 
                                                        ExpectedCommission__c, 
                                                        Product2Id
                                              FROM      OpportunityLineItem
                                              WHERE     OpportunityId =: objOpportunity.Id
                                              Limit     1];

        if(objOpportunity.Contract2Id__c!=null){
            Contract2__c objContract = [SELECT  Id, 
                                            BidNumber__c, 
                                            Company__c,
                                            StartDate__c
                                    FROM    Contract2__c
                                    WHERE   Id =: objOpportunity.Contract2Id__c];
            company = objContract.Company__c;
            startDate = objContract.StartDate__c;

        }
 
        Corporate_WFlowTO.OpportunityEndorsementPostRequest oppEndorsementPost = new Corporate_WFlowTO.OpportunityEndorsementPostRequest();
        oppEndorsementPost.opportunitySFId = objOpportunity.Id;
        oppEndorsementPost.policyHolderId = objOpportunity.AccountId;
        oppEndorsementPost.policyHolderName = objOpportunity.Account.Name;
        oppEndorsementPost.opportunityNumber = objOpportunity.OpportunityNumber__c;
        oppEndorsementPost.opportunityName = objOpportunity.Name;
        oppEndorsementPost.assignToGNId = objOpportunity.OwnerId;
        oppEndorsementPost.hasQuote = objOpportunity.SyncedQuoteId != null ? true : false;
        oppEndorsementPost.additionalInformation = objOpportunity.Description;
        oppEndorsementPost.recordTypeId = objOpportunity.RecordTypeId;
        oppEndorsementPost.productId = objOppLineItem.Product2Id;
        oppEndorsementPost.closeDate = String.valueOfGmt(objOpportunity.CloseDate);
        oppEndorsementPost.salePrice = objOpportunity.Amount;
        oppEndorsementPost.probabilityOfWinning = objOpportunity.ProbabilityOfWinning__c;
        oppEndorsementPost.insuredAmount = objOpportunity.InsuredAmount__c;
        oppEndorsementPost.expectedCommission = objOppLineItem.ExpectedCommission__c;
        oppEndorsementPost.contractId = objOpportunity.Contract2Id__c;
        oppEndorsementPost.companyName = company;
        oppEndorsementPost.emissionDate = String.valueOfGmt(startDate);

        System.debug('@@@ oppEndorsementPost : ' + oppEndorsementPost);

        return oppEndorsementPost;        
    }

    private static List<Corporate_WFlowTO.DocumentSendWFlow> setDocumentOppSendWFlow(Opportunity objOpportunity){
        List<Corporate_WFlowTO.DocumentSendWFlow> lstDocumentOppSendWFlow = new List<Corporate_WFlowTO.DocumentSendWFlow>();
        List<String> lstObjectIds = new List<String>();
        
        lstObjectIds.add(objOpportunity.AccountId);
        lstObjectIds.add(objOpportunity.Id);

        List<DocumentUpload__c> lstDocUpload = DocumentUploadDAO.getInstance().getDocumentUploadByListSObjectId(lstObjectIds);

        for(DocumentUpload__c objDocUplaod : lstDocUpload){
            
            Corporate_WFlowTO.DocumentSendWFlow documentOppSendWFlow = new Corporate_WFlowTO.DocumentSendWFlow();
            documentOppSendWFlow.objectType =   objDocUplaod.Objects__c == 'Opportunity' ? 1 :
                                            objDocUplaod.Objects__c == 'Account' ? 1 :
                                            objDocUplaod.Objects__c == 'Order' ? 2 :
                                            objDocUplaod.Objects__c == 'Quote' ? 3 : null;
            documentOppSendWFlow.opportunitySFId = objOpportunity.Id;
            documentOppSendWFlow.originalName = objDocUplaod.Name;
            documentOppSendWFlow.extension = objDocUplaod.FileExtension__c;
            documentOppSendWFlow.url = objDocUplaod.ExternalUrl__c;
            
            lstDocumentOppSendWFlow.add(documentOppSendWFlow);
        }        

        return lstDocumentOppSendWFlow;
    }
    
}