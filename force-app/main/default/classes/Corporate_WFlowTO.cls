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
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class Corporate_WFlowTO {

    public class OpportunityEndorsementPostRequest{
        public String policyNumber {get; set;}
        public String policyHolderName {get; set;}
        public String opportunityNumber {get; set;}
        public String insuranceProtocol {get; set;}
        public String companyName {get; set;}
        public String assingToId {get; set;}
        public String policyId {get; set;}
        public Boolean hasQuote {get; set;}
        public string emissionDate {get; set;}
        public String additionalInformation {get; set;}
        public String endorsementReason {get; set;}
        public String recordTypeId {get; set;}
        public String opportunityName {get; set;}
        public String productId {get; set;}
        public string closeDate {get; set;}
        public Decimal salePrice {get; set;}
        public String policyHolderId {get; set;}
        public String assignToGNId {get; set;}
        public String probabilityOfWinning {get; set;}
        public Double insuredAmount {get; set;}
        public Double expectedCommission {get; set;}
        public String contractId {get; set;}
        public String opportunitySFId {get; set;}

    }
     

    public class OpportunityEndorsementPostResponse {
        public String opportunityId {get; set;}
        public String opportunitySFId {get; set;}
        public String policyNumber {get; set;}
        public String policyHolderName {get; set;}
        public String opportunityNumber {get; set;}
        public String insuranceProtocol {get; set;}
        public String companyName {get; set;}
        public String assingToId {get; set;}
        public String assignToDescription {get; set;}
        public String policyId {get; set;}
        public Boolean hasQuote {get; set;}
        public Datetime emissionDate {get; set;}
        public Integer status {get; set;}
        public String statusTypeAlert {get; set;}
        public String statusDescription {get; set;}
        public String gnAn {get; set;}
        public String nomeGnAn {get; set;}
        public String processNumber {get; set;}
        public String recordTypeId {get; set;}
        public Step[] steps; 
    }

    public class Step{
        public Integer step {get; set;}
        public String description {get; set;}
        public String status {get; set;}
    }

    public class OpportunitySalesPostRequest{
        public String policyHolderId {get; set;}
        public Integer insuranceType {get; set;}
        public Integer totalItems {get; set;}
        public Decimal insuredAmount {get; set;}
        public Decimal valueOpportunity {get; set;}
        public Boolean riskCheck {get; set;}
        public String gn {get; set;}
        public String assignToId {get; set;}
        public String product2Id {get; set;}
        public String product2Name {get; set;}
        public String probabilityOfWinning {get; set;}
        public String closeDate {get; set;}
        public String commercialType {get; set;}
        public String contract2Id {get; set;}
        public String opportunityId {get; set;}
    }

    public class OpportunitySalesPostResponse{
        public String opportunityId {get; set;}
        public Integer insuranceType {get; set;}
        public Integer modality {get; set;}
        public Integer operation {get; set;}
        public Integer totalItems {get; set;}
        public Decimal insuredAmount {get; set;}
        public Decimal valueOpportunity {get; set;}
        public Boolean riskCheck {get; set;}
        public Integer commercialType {get; set;}
        public String gn {get; set;}  
        public Decimal wizCorporatePercentage {get; set;}
        public Decimal wNetworkPercentage {get; set;}
        public Decimal partnersPercentage {get; set;}
        public String partnerName {get; set;}
        public Decimal partnerPercentage {get; set;}
        public String assignToId {get; set;}
        public Integer status {get; set;}
        public String statusDescription {get; set;}
        public Step[] steps {get; set;}          
    }

    public class OpportunityUpdatePostResponse{
        public String opportunityId {get; set;}
        public Integer insuranceType {get; set;}
        public String insuranceTypeName {get; set;}
        public Integer modality {get; set;}
        public String modalityName {get; set;}
        public Integer operation {get; set;}
        public Integer totalItems {get; set;}
        public Decimal insuredAmount {get; set;}
        public Decimal valueOpportunity {get; set;}
        public Boolean riskCheck {get; set;}
        public Integer commercialType {get; set;}
        public String gn {get; set;}  
        public Decimal wizCorporatePercentage {get; set;}
        public Decimal wNetworkPercentage {get; set;}
        public Decimal partnersPercentage {get; set;}
        public String partnerName {get; set;}
        public Decimal partnerPercentage {get; set;}
        public String assignToId {get; set;}
        public Integer status {get; set;}
        public String statusDescription {get; set;}
        public String identificationNumber {get; set;}
        public Step[] steps {get; set;}          
    }

    public DocumentSendWFlow[] documentSendWFlow;
    public class DocumentSendWFlow{
        public String opportunitySFId {get; set;} 
        public String originalName {get; set;}
        public String extension {get; set;}
        public String url {get; set;}
        public Integer objectType {get; set;}
    }

    public class QuoteApprovalPutRequest{
        public String quoteItemSF {get; set;}
    }

    public class QuoteUpdatePostRequest{
        public String id {get; set;}
    }

}