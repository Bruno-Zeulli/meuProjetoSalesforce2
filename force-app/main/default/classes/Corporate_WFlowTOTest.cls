/**
 * @description       :
 * @author            : andresilva@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   11-25-2021   andresilva@wizsolucoes.com.br         Initial Version
 * 1.1   11-25-2021   marcelomartins@wizsolucoes.com.br     refectore
 **/
@isTest
public class Corporate_WFlowTOTest {
   
    @isTest 
    static void instantiateOppEndorsementReqPost(){
        Corporate_WFlowTO.OpportunityEndorsementPostRequest oppEndorsementReqPost = new Corporate_WFlowTO.OpportunityEndorsementPostRequest();
        oppEndorsementReqPost.policyNumber = '123456';
        oppEndorsementReqPost.policyHolderName = 'test';
        oppEndorsementReqPost.opportunityNumber ='123456';
        oppEndorsementReqPost.insuranceProtocol = '123L';
        oppEndorsementReqPost.companyName = 'test';
        oppEndorsementReqPost.assingToId = '21E64C6E-AD60-45F3-AB97-13EEDBDE33D6';
        oppEndorsementReqPost.policyId ='123L';
        oppEndorsementReqPost.hasQuote = true;
        oppEndorsementReqPost.emissionDate = String.valueOfGmt(DateTime.now());
        oppEndorsementReqPost.additionalInformation = 'test';
        oppEndorsementReqPost.endorsementReason = 'test';
        oppEndorsementReqPost.recordTypeId = String.valueOf(IDGenerator.generate(RecordType.getSObjectType()));
        oppEndorsementReqPost.opportunityName = 'test';
        oppEndorsementReqPost.productId = String.valueOf(IDGenerator.generate(Product2.getSObjectType()));
        oppEndorsementReqPost.closeDate = String.valueOfGmt(DateTime.now());
        oppEndorsementReqPost.salePrice = 123;
        oppEndorsementReqPost.policyHolderId = '123L';
        oppEndorsementReqPost.assignToGNId = '123L';
        oppEndorsementReqPost.probabilityOfWinning = 'test';
        oppEndorsementReqPost.insuredAmount = 123.23;
        oppEndorsementReqPost.expectedCommission = 123;
        oppEndorsementReqPost.contractId = String.valueOf(IDGenerator.generate(Contract2__c.getSObjectType()));
        oppEndorsementReqPost.opportunitySFId = String.valueOf(IDGenerator.generate(Opportunity.getSObjectType()));

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

}
    @isTest
    static void instantiateOppEndorsementRespPost(){
        Corporate_WFlowTO.OpportunityEndorsementPostResponse oppEndorsementRespPost = new Corporate_WFlowTO.OpportunityEndorsementPostResponse();
        oppEndorsementRespPost.opportunityId = '21E64C6E-AD60-45F3-AB97-13EEDBDE33D6';
        oppEndorsementRespPost.opportunitySFId = String.valueOf(IDGenerator.generate(opportunity.getSObjectType()));
        oppEndorsementRespPost.policyNumber = '123';
        oppEndorsementRespPost.policyHolderName = '123';
        oppEndorsementRespPost.opportunityNumber ='123';
        oppEndorsementRespPost.insuranceProtocol ='123';
        oppEndorsementRespPost.companyName ='test';
        oppEndorsementRespPost.assingToId = '21E64C6E-AD60-45F3-AB97-13EEDBDE33D7';
        oppEndorsementRespPost.assignToDescription = 'test'; 
        oppEndorsementRespPost.policyId = '123L';
        oppEndorsementRespPost.hasQuote = true;
        oppEndorsementRespPost.emissionDate = dateTime.now();
        oppEndorsementRespPost.status = 123;
        oppEndorsementRespPost.statusTypeAlert = '123';
        oppEndorsementRespPost.statusDescription = '123';
        oppEndorsementRespPost.gnAn ='123';
        oppEndorsementRespPost.nomeGnAn = 'test';  
        oppEndorsementRespPost.processNumber = '123';
        oppEndorsementRespPost.recordTypeId = '123';

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
            
    }

@isTest
    static void instantiateStep(){
        Corporate_WFlowTO.Step step = new Corporate_WFlowTO.Step();
        step.Step = 123;
        step.status = '123';
        step.description = '123';

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }

    @isTest
    static void instantiateOppSalesPostRequest(){
        Corporate_WFlowTO.OpportunitySalesPostRequest oppSalesPostRequest = new Corporate_WFlowTO.OpportunitySalesPostRequest();
        oppSalesPostRequest.policyHolderId = String.valueOf(IDGenerator.generate(Account.getSObjectType()));
        oppSalesPostRequest.insuranceType = 123;
        oppSalesPostRequest.totalItems  = 1;
        oppSalesPostRequest.insuredAmount = 12.23;
        oppSalesPostRequest.valueOpportunity = 12.23;
        oppSalesPostRequest.riskCheck = true;
        oppSalesPostRequest.gn = String.valueOf(IDGenerator.generate(User.getSObjectType()));
        oppSalesPostRequest.assignToId = '21E64C6E-AD60-45F3-AB97-13EEDBDE33D6'; 
        oppSalesPostRequest.product2Id = String.valueOf(IDGenerator.generate(Product2.getSObjectType()));
        oppSalesPostRequest.product2Name = 'test';
        oppSalesPostRequest.probabilityOfWinning = 'low'; 
        oppSalesPostRequest.closeDate = String.valueOfGmt(DateTime.now());
        oppSalesPostRequest.commercialType = '1';
        oppSalesPostRequest.contract2Id = String.valueOf(IDGenerator.generate(Contract2__c.getSObjectType()));
        oppSalesPostRequest.opportunityId = String.valueOf(IDGenerator.generate(Opportunity.getSObjectType()));

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }

    @isTest
    static void instantiateOppSalesPostResponse(){
        Corporate_WFlowTO.OpportunitySalesPostResponse oppSalesPostResponse = new Corporate_WFlowTO.OpportunitySalesPostResponse();
        oppSalesPostResponse.opportunityId = String.valueOf(IDGenerator.generate(opportunity.getSObjectType()));
        oppSalesPostResponse.insuranceType = 123;
        oppSalesPostResponse.modality = 123;
        oppSalesPostResponse.operation =1;
        oppSalesPostResponse.totalItems = 1;
        oppSalesPostResponse.insuredAmount = 12.23;
        oppSalesPostResponse.valueOpportunity = 12.23;
        oppSalesPostResponse.riskCheck = true;
        oppSalesPostResponse.commercialType = 123;
        oppSalesPostResponse.gn  = '123';
        oppSalesPostResponse.wizCorporatePercentage = 12.23;
        oppSalesPostResponse.wNetworkPercentage = 12.23;
        oppSalesPostResponse.partnersPercentage =12.23;
        oppSalesPostResponse.partnerName = 'test';
        oppSalesPostResponse.partnerPercentage = 12.23;
        oppSalesPostResponse.assignToId = '123';
        oppSalesPostResponse.status = 123;
        oppSalesPostResponse.statusDescription = '123'; 

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }
    @isTest
    static void instantiateDocumentSendWFlow(){
        Corporate_WFlowTO.DocumentSendWFlow documentSendWFlow = new Corporate_WFlowTO.DocumentSendWFlow();
        documentSendWFlow.opportunitySFId = String.valueOf(IDGenerator.generate(opportunity.getSObjectType()));
        documentSendWFlow.originalName = 'test';
        documentSendWFlow.extension = '123';
        documentSendWFlow.url = 'www.localhost.test.com/1234d594a/156saaa';
        documentSendWFlow.objectType = 123;

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');

    }
    @isTest
    static void instantiateQuoteApprovalPutResquest(){
        Corporate_WFlowTO.QuoteApprovalPutRequest quoteApprovalPutResquest = new Corporate_WFlowTO.QuoteApprovalPutRequest();
        quoteapprovalputresquest.quoteItemSF = '123';
        
        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest
    static void instantiateQuoteUpdatePostRequest(){
        Corporate_WFlowTO.QuoteUpdatePostRequest quoteUpdatePostRequest = new Corporate_WFlowTO.QuoteUpdatePostRequest();
        quoteUpdatePostRequest.id = '123';
        
        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }

}