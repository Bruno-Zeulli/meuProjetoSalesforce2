@isTest
public class ConnectWizQuotationFormsTOTest
{
	@isTest
    static void ConnectWizQuotationFormsTOTestetodoTest()
    {
        ConnectWizQuotationFormsTO.SimpleQuoteform sq = new ConnectWizQuotationFormsTO.SimpleQuoteform();
        sq.FormId = 'Teste';
        sq.type = 'Teste';
        sq.InsuranceInformation = null;

        // Create a QuotationForms object
		ConnectWizQuotationFormsTO.QuotationForms quotationForm = new ConnectWizQuotationFormsTO.QuotationForms();

        // Set properties for QuotationForms
        quotationForm.formId = 'Teste';
        quotationForm.accidentalDeathPercent = 0.0; // Set the Decimal properties as needed
        quotationForm.accountId = 'AccountId';
        quotationForm.affFamilyFuneralAssistancePercent = 0.0;
        quotationForm.afiIndividualFuneralAssistancePercent = 0.0;
        quotationForm.aggregated = false; // Set Boolean properties
        quotationForm.areForHeritageProtectionPurposes = false;
        quotationForm.averageTradedVolumePerDay = 0.0;
        quotationForm.basketBasicPercent = 0.0;
        quotationForm.branchOfActivity = 'Branch';
        quotationForm.bidderFollowingInvestmentPolicy = false;
        quotationForm.bidderHasFormalPolicy = false;
        quotationForm.capitalAmount = 0.0;
        quotationForm.capitalModel = 'Capitalodel';
        quotationForm.caseId = 'CaseId';
        quotationForm.changeInCorporateName = false;
        quotationForm.changeInMajorityPartner = false;
        quotationForm.childrenOver24YearsOfAge = false;
        quotationForm.chronicCases = false;
        quotationForm.companyIdentificationNumber = 'CompanyID';
        quotationForm.contractingProponentOfInsurance = false;
        quotationForm.coverageForDrunkennessPercent = 0.0;
        quotationForm.covid19AdoptedProcedures = 'Covid19Procedures';
        quotationForm.covid19BusinessContinuityPlan = 'Covid19BusinessPlan';
        quotationForm.covid19Remote = 'Covid19Remote';
        quotationForm.createdById = 'CreatedById';
        quotationForm.descriptionOfCapital = 'CapitalDescription';
        quotationForm.disabilityRetirees = false;
        quotationForm.dismissedByLaw = false;
        quotationForm.dismissedRetired = false;
        quotationForm.ditTemporaryDisabilityDailyPercent = 0.0;
        quotationForm.dmhHospitalDoctorExpensesPercent = 0.0;
        quotationForm.expectationRegardingJudicialDemands = false;
        quotationForm.firstOfferPrice = 0.0;
        quotationForm.formalPolicyForTradingShares = false;
        quotationForm.funeralAidPercent = 0.0;
        quotationForm.hasAClaimReport = false;
        quotationForm.hasDerivativeOperations = false;
        quotationForm.highestPriceIn1Year = 0.0;
        quotationForm.homecare = false;
        quotationForm.hospitalizationsInProgress = false;
        quotationForm.iacAutomaticInclusionOfSpousePercent = 0.0;
        quotationForm.iafAutomaticInclusionOfChildrenPercent = 0.0;
        quotationForm.ifpdTotalPartialDisabilityDiseasePercent = 0.0;
        quotationForm.injunctions = false;
        quotationForm.invoiceEstimate = 0.0;
        quotationForm.invoiceForecast = 0.0;
        quotationForm.ipaTotalOrPartialDisabilityByAccPercent = 0.0;
        quotationForm.judicialOrExtrajudicialClaims = false;
        quotationForm.leadId = 'LeadId';
        quotationForm.lowestPriceIn1Year = 0.0;
        quotationForm.mergerAcquisitionOrPurchase = false;
        quotationForm.naturalDeathPercent = 0.0;
        quotationForm.numberOfDirectors = 0.0;
        quotationForm.numberOfFiscalCouncilors = 0.0;
        quotationForm.numberOfMembersOnTheBoardOfDirectors = 0.0;
        quotationForm.pregnants = false;
        quotationForm.priceWhenFillingInTheQuestionnaire = 0.0;
        quotationForm.profitLossPerShare = 0.0;
        quotationForm.ratePerThousand = 0.0;
        quotationForm.readjustmentForecast = 0.0;
        quotationForm.reasonForQuotation = 'QuotationReason';
        quotationForm.recordTypeId = 'RecordTypeId';
        quotationForm.requester = 'Requester';
        quotationForm.Redeemed = false;
        quotationForm.retired = false;
        quotationForm.seriousDiseasesPercent = 0.0;
        quotationForm.serviceProviders = false;
        quotationForm.terminationPenaltyOutsideTheTerm = 0.0;
        quotationForm.tradingCode = 0.0;
        quotationForm.type = 'Type';
        quotationForm.warrantyLimit = 'WarrantyLimit';
        quotationForm.otherWarrantyLimit = 0.0;
        quotationForm.generalObservation = 'GeneralObservation';
        quotationForm.descriptionGoverLevel = 'DescriptionGoverLevel';
        quotationForm.theCompanyGetSomeLevelOfGovernanca = false;
        quotationForm.marketcap = 0.0;

        // Create an InsuranceInformation object
        ConnectWizQuotationFormsTO.InsuranceInformation insuranceInformation = new ConnectWizQuotationFormsTO.InsuranceInformation();

        // Set properties for InsuranceInformation
        insuranceInformation.insuranceInformationId = 'InsuranceId';
        insuranceInformation.company = 'Company';
        insuranceInformation.termOfContractStr = 'ContractStr';
        insuranceInformation.technicalSpecificationQuestionnaireId = 'TechnicalId';
        insuranceInformation.numberOfLives = 0.0;
        insuranceInformation.hiringModel = 'Hiringodel';
        insuranceInformation.indemnitiesPaid = 0.0;
        insuranceInformation.limitOfLiability = 0.0;
        insuranceInformation.countPosition = 0;

        // Create a CurrentPlan object
        ConnectWizQuotationFormsTO.CurrentPlan currentPlan = new ConnectWizQuotationFormsTO.CurrentPlan();

        // Set properties for CurrentPlan
        currentPlan.currentPlanId = 'PlanId';
        currentPlan.currentPlanName = 'PlanName';
        currentPlan.company = 'PlanCompany';
        currentPlan.positionEligibility = 'PositionEligibility';
        currentPlan.insuranceInformationId = 'InsuranceId';
        currentPlan.numberOfLives = 0.0;
        currentPlan.cost = 0.0;
        currentPlan.reimbursement = 0.0;
        currentPlan.contributionHolder = 0.0;
        currentPlan.contributionDependent = 0.0;
        currentPlan.coparticipation = 0.0;
        currentPlan.countPosition = 0;

        // Create an InsuranceSuggestion object
        ConnectWizQuotationFormsTO.InsuranceSuggestion insuranceSuggestion = new ConnectWizQuotationFormsTO.InsuranceSuggestion();

        // Set properties for InsuranceSuggestion
        insuranceSuggestion.insuranceSuggestionId = 'SuggestionId';
        insuranceSuggestion.suggestionPlan = 'SuggestionPlan';
        insuranceSuggestion.currentPlan = 'CurrentPlan';
        insuranceSuggestion.currentPlanId = 'PlanId';
        insuranceSuggestion.suggestionCompany = 'SuggestionCompany';
        insuranceSuggestion.countPosition = 0;

        // Create a ControlledCompany object
        ConnectWizQuotationFormsTO.ControlledCompany controlledCompany = new ConnectWizQuotationFormsTO.ControlledCompany();

        // Set properties for ControlledCompany
        controlledCompany.controlledCompanyId = 'ControlledCompanyId';
        controlledCompany.technicalSpecificationQuestionnaireId = 'TechnicalId';
        controlledCompany.controlledCompanyName = 'CompanyName';
        controlledCompany.activity = 'Activity';
        controlledCompany.countryOfOrigin = 'Country';
        controlledCompany.participationPercentage = 0.0;
        controlledCompany.isControlled = false;
        controlledCompany.countPosition = 0;

        // Create a Shareholder object
        ConnectWizQuotationFormsTO.Shareholder shareholder = new ConnectWizQuotationFormsTO.Shareholder();

        // Set properties for Shareholder
        shareholder.shareholderId = 'ShareholderId';
        shareholder.technicalSpecificationQuestionnaireId = 'TechnicalId';
        shareholder.nameOfShareholderPartner = 'ShareholderName';
        shareholder.countryOfOrigin = 'Country';
        shareholder.percentageOfTotalShares = 0.0;
        shareholder.percentageOfPreferredShares = 0.0;
        shareholder.percentageOfCommonShares = 0.0;
        shareholder.countPosition = 0;
    }
}