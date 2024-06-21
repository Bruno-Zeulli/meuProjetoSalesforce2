public with sharing class ConnectWizCMPTO {

    public QuotesRequestsSendCMP[] QuotesRequestsSendCMP;
    public class QuotesRequestsSendCMP{

        public String caseId {get; set;}
        public String ownerId {get; set;}
        public String ownerName {get; set;}
        public String opportunityId {get; set;}
        public String opportunityOwner {get; set;}
        public String opportunityNumber {get; set;}
        public String accountId {get; set;}
        public String accountName {get; set;}
        public String accountIdentificationNumber {get; set;}
        public String originCase {get; set;}
        public String leadSource {get; set;}
        public String statusCase {get; set;}
        public Date createDate {get; set;}
        public String strCreateDate {get; set;}
        public String lastModifiedDate {get; set;}
        public String lastModifiedName {get; set;}
        public String enterpriseName {get; set;}
        public String comercialName {get; set;}
        public String salesUnit {get; set;}
        public Integer quantityQuoteRequest {get; set;}
        public Integer quantityQuoteReceipt {get; set;}
        public String quoteReceiptAndRequest {get; set;}
        public String documentStatus {get; set;}
        public Integer quantityRequestInsideSLA {get; set;}
        public Integer quantityRequestOutsideSLA {get; set;}
        public Boolean isViolated {get; set;}
        public String productComboName {get; set;}  //TODO remover após ajustes na forma de apresentar os produtos
        public Product[] products;
        public Quote[] quotes;

    }

    public Product[] products;
    public class Product{
        public String productId {get; set;}
        public String productName {get; set;}
        public String productFamily {get; set;}
    }

    public Quote[] quotes;
    public class quote{
        public Date quoteRequestDate {get; set;}
        public Date quoteReceiptDate {get; set;}
        public String insuranceCompany {get; set;}

    }

    public UsersInformationSendCMP[] UsersInformationSendCMP;
    public class UsersInformationSendCMP{
        public String id {get; set;}
        public String userName {get; set;}
    }

    public class Proposta {

        @AuraEnabled public string seguradora{get; set;}
        @AuraEnabled public List<string> seguradoras{get;set;}
        @AuraEnabled public string premio{get; set;}
        @AuraEnabled public string importanciaSegurada{get; set;}
        @AuraEnabled public boolean isValorDetalhado{get; set;}
        @AuraEnabled public boolean isAddValorImportancia{get; set;}
        @AuraEnabled public string valorLiquidoPremio{get; set;}
        @AuraEnabled public string valorIOFPremio{get; set;}
        @AuraEnabled public string importanciaSeguradaAdicional{get; set;}
        @AuraEnabled public string importanciaSeguradaAdicional2{get; set;}
        @AuraEnabled public string porcentagemComissao{get; set;}
        @AuraEnabled public string porcentagemAgenciamento{get; set;}
        @AuraEnabled public string dataDeEnvioParaSeguradora{get; set;}
        @AuraEnabled public string dataDeRecebimentoDaSeguradora{get; set;}
        @AuraEnabled public string observacoes{get; set;}
        @AuraEnabled public string recordTypeId{get; set;}
        @AuraEnabled public string status{get; set;}
        @AuraEnabled public string quoteId{get; set;}
        @AuraEnabled public boolean showDetails{get; set;}
        @AuraEnabled public boolean isSolicitada{get; set;}
        @AuraEnabled public boolean isRecebida{get; set;}
        @AuraEnabled public boolean isEnviada{get; set;}
        @AuraEnabled public boolean isAceita{get; set;}
        @AuraEnabled public String priceBook2{get; set;}
        @AuraEnabled public String produto{get; set;}
        @AuraEnabled public String type{get; set;}
        @AuraEnabled public boolean showSendToComercial{get; set;}
        @AuraEnabled public boolean isNegada{get; set;}
        @AuraEnabled public boolean isCancelled{get; set;}
        @AuraEnabled public boolean showUploadFile{get; set;}
        @AuraEnabled public boolean showViewFiles{get; set;}
    }

    public CaseInformationHeader caseInformationHeader;
    public class CaseInformationHeader {
        public string accountName{get; set;}
        public string ownerName{get; set;}
        public string identificationNumber{get; set;}
        public string caseOrigin{get; set;}
        public string opportunityNumber{get; set;}
        public string opportunityId{get; set;}
        public string contactOrLeadId{get; set;}
        public string accountId{get; set;}
        public string productName{get; set;}
        public Boolean hasForm{get; set;}

    }

    public class ContactDetail{

        @AuraEnabled public Boolean showDetails{get; set;}
        @AuraEnabled public String nome{get; set;}
        @AuraEnabled public String moduloCliente{get; set;}
        @AuraEnabled public String telefone{get; set;}
        @AuraEnabled public String celular{get; set;}
        @AuraEnabled public String email{get; set;}
        @AuraEnabled public String cargo{get; set;}
        @AuraEnabled public String dataDeNascimento{get; set;}
        @AuraEnabled public String timeDoCoracao{get; set;}
        @AuraEnabled public String ordem{get; set;}
        @AuraEnabled public String contatoId{get; set;}
    }

    public class EmailNotification {

        @AuraEnabled public String description{get; set;}
        @AuraEnabled public String subject{get; set;}
        @AuraEnabled public String opportunityNumber{get; set;}
        @AuraEnabled public String caseNumber{get; set;}
        @AuraEnabled public String opportunityName{get; set;}
        @AuraEnabled public String opportunityId{get; set;}
        @AuraEnabled public String caseOwner{get; set;}
        @AuraEnabled public String opportunityOwner{get; set;}
        @AuraEnabled public String taskOwner{get; set;}
        @AuraEnabled public String taskOwnerId{get; set;}
        @AuraEnabled public String caseId{get; set;}
    }

    public class Questionnaire {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Boolean showDetails { get; set; }
        @AuraEnabled public List<QuestionnaireAnswer> answers { get; set; }
    }

    public class QuestionnaireAnswer {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String questionLabel { get; set; }
        @AuraEnabled public String questionType { get; set; }
        @AuraEnabled public String answer { get; set; }
        @AuraEnabled public String comment { get; set; }
    }

    public class PartialQuote {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Boolean integralization { get; set; }
        @AuraEnabled public Date requestDate { get; set; }
        @AuraEnabled public Date receiptDate { get; set; }
        @AuraEnabled public String insuranceCompany { get; set; }
        @AuraEnabled public Decimal insurancePremium { get; set; }
        @AuraEnabled public Decimal amountInsurance { get; set; }
        @AuraEnabled public Boolean detailView { get { return false; } set; }
        @AuraEnabled public Decimal netInsurancePremium { get; set; }
        @AuraEnabled public Decimal taxInsurancePremium { get; set; }
        @AuraEnabled public Decimal comissionValue { get; set; }
        @AuraEnabled public Decimal agencyValue { get; set; }
        @AuraEnabled public String observations { get; set; }
        @AuraEnabled public Boolean isRequested { get; set; }
        @AuraEnabled public Boolean isReceived { get; set; }
        @AuraEnabled public Boolean showDetails { get; set; }
    }

    public class Proposal {
        @AuraEnabled public List<ProposalComposition> composition { get; set; }
        @AuraEnabled public List<PartialQuote> availableQuotes { get; set; }
        @AuraEnabled public PartialQuote compositeQuote { get; set; }
        @AuraEnabled public String observations { get; set; }
    }

    public class ProposalComposition {
        @AuraEnabled public PartialQuote partialQuote { get; set; }
        @AuraEnabled public Boolean isLead { get; set; }
        @AuraEnabled public Decimal amountInsuranceUsed { get; set; }
    }
}