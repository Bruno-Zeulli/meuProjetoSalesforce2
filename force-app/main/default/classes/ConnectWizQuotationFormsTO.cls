public with sharing class ConnectWizQuotationFormsTO {

    public SimpleQuoteform [] SimpleQuoteform;
    public class SimpleQuoteform{
        public String formId {get; set;}
        public String type {get; set;}
        public InsuranceInformation[] InsuranceInformation;
    }

    public QuotationForms[] QuotationForms;
    public class QuotationForms{
        public String formId {get; set;}
        public Decimal accidentalDeathPercent {get; set;}
        public String accountId {get; set;}
        public Decimal affFamilyFuneralAssistancePercent {get; set;}
        public Decimal afiIndividualFuneralAssistancePercent {get; set;}
        public Boolean aggregated {get; set;}
        public Boolean areForHeritageProtectionPurposes {get; set;}
        public Decimal averageTradedVolumePerDay {get; set;}
        public Decimal basketBasicPercent {get; set;}
        public String branchOfActivity {get; set;}
        public Boolean bidderFollowingInvestmentPolicy {get; set;}
        public Boolean bidderHasFormalPolicy {get; set;}
        public Decimal capitalAmount {get; set;}
        public String capitalModel {get; set;}
        public String caseId {get; set;}
        public Boolean changeInCorporateName {get; set;}
        public Boolean changeInMajorityPartner {get; set;}
        public Boolean childrenOver24YearsOfAge {get; set;}
        public Boolean chronicCases {get; set;}
        public String companyIdentificationNumber {get; set;}
        public Boolean contractingProponentOfInsurance {get; set;}
        public Decimal coverageForDrunkennessPercent {get; set;}
        public String covid19AdoptedProcedures {get; set;}
        public String covid19BusinessContinuityPlan {get; set;}
        public String covid19Remote {get; set;}
        public String createdById {get; set;}
        public Date dateOf1stOffer {get; set;}
        public String descriptionOfCapital {get; set;}
        public Boolean disabilityRetirees {get; set;}
        public Boolean dismissedByLaw {get; set;}
        public Boolean dismissedRetired {get; set;}
        public Decimal ditTemporaryDisabilityDailyPercent {get; set;}
        public Decimal dmhHospitalDoctorExpensesPercent {get; set;}
        public Boolean expectationRegardingJudicialDemands {get; set;}
        public Decimal firstOfferPrice {get; set;}
        public Boolean formalPolicyForTradingShares {get; set;}
        public Decimal funeralAidPercent {get; set;}
        public Boolean hasAClaimReport {get; set;}
        public Boolean hasDerivativeOperations {get; set;}
        public Decimal highestPriceIn1Year {get; set;}
        public Boolean homecare {get; set;}
        public Boolean hospitalizationsInProgress {get; set;}
        public Decimal iacAutomaticInclusionOfSpousePercent {get; set;}
        public Decimal iafAutomaticInclusionOfChildrenPercent {get; set;}
        public Decimal ifpdTotalPartialDisabilityDiseasePercent {get; set;}
        public Boolean injunctions {get; set;}
        public Decimal invoiceEstimate {get; set;}
        public Decimal invoiceForecast {get; set;}
        public Decimal ipaTotalOrPartialDisabilityByAccPercent {get; set;}
        public Boolean judicialOrExtrajudicialClaims {get; set;}
        public String lastModifiedById {get; set;}
        public String leadId {get; set;}
        public Decimal lowestPriceIn1Year {get; set;}
        public Boolean mergerAcquisitionOrPurchase {get; set;}
        public Decimal naturalDeathPercent {get; set;}
        public Decimal noOfShareholdersMeetings {get; set;}
        public Decimal numberOfAuditBoardMeetings {get; set;}
        public Decimal numberOfDirectors {get; set;}
        public Decimal numberOfFiscalCouncilors {get; set;}
        public Decimal numberOfMembersOnTheBoardOfDirectors {get; set;}
        public Boolean pregnants {get; set;}
        public Decimal priceWhenFillingInTheQuestionnaire {get; set;}
        public Decimal profitLossPerShare {get; set;}
        public Decimal ratePerThousand {get; set;}
        public Decimal readjustmentForecast {get; set;}
        public String reasonForQuotation {get; set;}
        public String recordTypeId {get; set;}
        public String requester {get; set;}
        public Boolean Redeemed {get; set;}
        public Boolean retired {get; set;}
        public Decimal seriousDiseasesPercent {get; set;}
        public Boolean serviceProviders {get; set;}
        public Boolean sharesTradedOutsideTheBrMarket {get; set;}
        public Decimal terminationPenaltyOutsideTheTerm {get; set;}
        public Decimal tradingCode {get; set;}
        public String type {get; set;}
        public String warrantyLimit {get; set;}
        public Decimal otherWarrantyLimit {get; set;}
        public String generalObservation {get; set;}
        public String descriptionGoverLevel {get; set;}
        public Boolean theCompanyGetSomeLevelOfGovernanca {get; set;}
        public Decimal marketcap {get; set;}
        public InsuranceInformation[] InsuranceInformations;
        public ControlledCompany[] ControlledCompanies;
        public Shareholder[] Shareholders;
    }

    public InsuranceInformation[] InsuranceInformations;
    public class InsuranceInformation{
        public String insuranceInformationId {get; set;}
        public String company {get; set;}
        public String termOfContractStr {get; set;}
        public Date termOfContractDate {get; set;}
        public String technicalSpecificationQuestionnaireId {get; set;}
        public Decimal numberOfLives {get; set;}
        public String hiringModel {get; set;}
        public Decimal indemnitiesPaid {get; set;}
        public Decimal limitOfLiability {get; set;}
        public Integer countPosition {get; set;}
        public CurrentPlan[] CurrentPlans;
    }

    public CurrentPlan[] CurrentPlans;
    public class CurrentPlan{
        public String currentPlanId {get; set;}
        public String currentPlanName {get; set;}
        public String company {get; set;}
        public String positionEligibility {get; set;}
        public String insuranceInformationId {get; set;}
        public Decimal numberOfLives {get; set;}
        public Decimal cost {get; set;}
        public Decimal reimbursement {get; set;}
        public Decimal contributionHolder {get; set;}
        public Decimal contributionDependent {get; set;}
        public Decimal coparticipation {get; set;}
        public Integer countPosition {get; set;}
        public InsuranceSuggestion[] InsuranceSuggestions;

    }

    public InsuranceSuggestion[] InsuranceSuggestions;
    public class InsuranceSuggestion{
        public String insuranceSuggestionId {get; set;}
        public String suggestionPlan {get; set;}
        public String currentPlan {get; set;}
        public String currentPlanId {get; set;}
        public String suggestionCompany {get; set;}
        public Integer countPosition {get; set;}
    }

    public ControlledCompany[] ControlledCompanies;
    public class ControlledCompany{
        public String controlledCompanyId {get; set;}
        public String technicalSpecificationQuestionnaireId {get; set;}
        public String controlledCompanyName {get; set;}
        public String activity {get; set;}
        public String countryOfOrigin {get; set;}
        public Decimal participationPercentage {get; set;}
        public Boolean isControlled {get; set;}
        public Integer countPosition {get; set;}
    }

    public Shareholder[] Shareholders;
    public class Shareholder{
        public String shareholderId {get; set;}
        public String technicalSpecificationQuestionnaireId {get; set;}
        public String nameOfShareholderPartner {get; set;}
        public String countryOfOrigin {get; set;}
        public Decimal percentageOfTotalShares {get; set;}
        public Decimal percentageOfPreferredShares {get; set;}
        public Decimal percentageOfCommonShares {get; set;}
        public Integer countPosition {get; set;}
    }

}