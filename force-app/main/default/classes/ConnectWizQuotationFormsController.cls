public without sharing class ConnectWizQuotationFormsController {

    @AuraEnabled(cacheable=true)
    public static String getQuotationFormsByOppId(String opportunityId){
         try{
            Map<Id, List<ConnectWizQuotationFormsTO.InsuranceInformation>> mapInsuranceInfoTOByFormId = new Map<Id, List<ConnectWizQuotationFormsTO.InsuranceInformation>>();
            Map<Id, InsuranceInformation__c> mapInsuranceInformationByFormId = new Map<Id, InsuranceInformation__c>();
            List<ConnectWizQuotationFormsTO.SimpleQuoteForm> lSimpleQuoteForms = new List<ConnectWizQuotationFormsTO.SimpleQuoteForm>();
            String whereConditionByOppId = 'WHERE OpportunityId__c =  \'' + opportunityId + '\'';
            List<Technical_Specification_Questionnaire__c> lForms = TechnicalSpecificationQuestionnaireDAO.getListAllFieldsByWhereCondition(whereConditionByOppId);
            List<InsuranceInformation__c> lInsuranceInformation = InsuranceInformationDAO.getInsuranceInformationByOppId(opportunityId);

            for(InsuranceInformation__c objInsuranceInformation : lInsuranceInformation){

                ConnectWizQuotationFormsTO.InsuranceInformation insuranceInfoTO = new ConnectWizQuotationFormsTO.InsuranceInformation();
                insuranceInfoTO.company = objInsuranceInformation.Company__c != null ? objInsuranceInformation.Company__c : '-';
                insuranceInfoTO.termOfContractStr = objInsuranceInformation.TermOfContract__c != null ? objInsuranceInformation.TermOfContract__c.format() : '-';
                insuranceInfoTO.insuranceInformationId = objInsuranceInformation.Id;

                List<ConnectWizQuotationFormsTO.InsuranceInformation> lstInsuranceInfoTO = new List<ConnectWizQuotationFormsTO.InsuranceInformation>();
                if(mapInsuranceInfoTOByFormId.containsKey(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c)){
                    lstInsuranceInfoTO = mapInsuranceInfoTOByFormId.get(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c);
                    lstInsuranceInfoTO.add(insuranceInfoTO);
                    mapInsuranceInfoTOByFormId.put(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c, lstInsuranceInfoTO);
                }else{
                    lstInsuranceInfoTO.add(insuranceInfoTO);
                    mapInsuranceInfoTOByFormId.put(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c , lstInsuranceInfoTO);
                }

                mapInsuranceInformationByFormId.put(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c, objInsuranceInformation);
            }

            for(InsuranceInformation__c objInsuranceInformation : mapInsuranceInformationByFormId.values()){
                ConnectWizQuotationFormsTO.SimpleQuoteForm objSimpleQuoteForm = new ConnectWizQuotationFormsTO.SimpleQuoteForm();

                objSimpleQuoteForm.formId = objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c;
                objSimpleQuoteForm.type = objInsuranceInformation.TechnicalSpecificationQuestionnaireId__r.Type__c;
                objSimpleQuoteForm.InsuranceInformation = mapInsuranceInfoTOByFormId.get(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c);
                lSimpleQuoteForms.add(objSimpleQuoteForm);
            }

            for(Technical_Specification_Questionnaire__c objForm : lForms){
                if(!mapInsuranceInfoTOByFormId.containsKey(objForm.Id)){
                    List<ConnectWizQuotationFormsTO.InsuranceInformation> lstInsuranceInfoTO = new List<ConnectWizQuotationFormsTO.InsuranceInformation>();
                    ConnectWizQuotationFormsTO.InsuranceInformation insuranceInfoTO = new ConnectWizQuotationFormsTO.InsuranceInformation();
                    insuranceInfoTO.company = '-';
                    insuranceInfoTO.termOfContractStr = '-';

                    lstInsuranceInfoTO.add(insuranceInfoTO);

                    ConnectWizQuotationFormsTO.SimpleQuoteForm objSimpleQuoteForm = new ConnectWizQuotationFormsTO.SimpleQuoteForm();

                    objSimpleQuoteForm.formId = objForm.Id;
                    objSimpleQuoteForm.type = objForm.Type__c;
                    objSimpleQuoteForm.InsuranceInformation = lstInsuranceInfoTO;
                    lSimpleQuoteForms.add(objSimpleQuoteForm);
                }
            }

        return JSOn.serialize(lSimpleQuoteForms);

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static String getQuotationFormsById(String formId){

         try{
            String whereConditionByFormId = 'WHERE Id =  \'' + formId + '\'';
            List<Technical_Specification_Questionnaire__c> lForms = TechnicalSpecificationQuestionnaireDAO.getListAllFieldsByWhereCondition(whereConditionByFormId);
            Technical_Specification_Questionnaire__c quotationForm = lForms[0];
            Map<Id, List<InsuranceInformation__c>> mapInsuranceInformationByFormId = new Map<Id, List<InsuranceInformation__c>>();
            Map<Id, List<InsuranceInformation__c>> mapCurrentPlansByInsuranceInformationId = new Map<Id, List<InsuranceInformation__c>>();
            Map<Id, List<InsuranceInformation__c>> mapInsuranceSuggestionByInsuranceInformationId = new Map<Id, List<InsuranceInformation__c>>();
            Map<Id, List<Contact>> mapControlledCompanyByFormId = new Map<Id, List<Contact>>();
            Map<Id, List<Contact>> mapShareholderPartnerByFormId = new Map<Id, List<Contact>>();
            Set<Id> lFormsId = new Set<Id>();
            Set<Id> lInsuranceInformationId = new Set<Id>();
            Set<Id> lCurrentPlanId = new Set<Id>();

            lFormsId.add(quotationForm.Id);

            for(InsuranceInformation__c objInsuranceInformation : InsuranceInformationDAO.getInsuranceInformationByFormsId(lFormsId)){

                List<InsuranceInformation__c> lstInsuranceInformation = new List<InsuranceInformation__c>();

                if(mapInsuranceInformationByFormId.containsKey(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c)){
                    lstInsuranceInformation = mapInsuranceInformationByFormId.get(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c);
                    lstInsuranceInformation.add(objInsuranceInformation);
                    mapInsuranceInformationByFormId.put(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c, lstInsuranceInformation);
                }else{
                    lstInsuranceInformation.add(objInsuranceInformation);
                    mapInsuranceInformationByFormId.put(objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c, lstInsuranceInformation);
                }

                lInsuranceInformationId.add(objInsuranceInformation.Id);
            }

            if( quotationForm.Type__c == 'Saúde' ||
                quotationForm.Type__c == 'Odontológico'
            ){

                for(InsuranceInformation__c objCurrentPlan : InsuranceInformationDAO.getCurrentPlansByInsurancesInformationId(lInsuranceInformationId)){

                    List<InsuranceInformation__c> lstCurrentPlan = new List<InsuranceInformation__c>();

                    if(mapCurrentPlansByInsuranceInformationId.containsKey(objCurrentPlan.ParentId__c)){
                        lstCurrentPlan = mapCurrentPlansByInsuranceInformationId.get(objCurrentPlan.ParentId__c);
                        lstCurrentPlan.add(objCurrentPlan);
                        mapCurrentPlansByInsuranceInformationId.put(objCurrentPlan.ParentId__c, lstCurrentPlan);
                    }else{
                        lstCurrentPlan.add(objCurrentPlan);
                        mapCurrentPlansByInsuranceInformationId.put(objCurrentPlan.ParentId__c, lstCurrentPlan);
                    }

                    lCurrentPlanId.add(objCurrentPlan.Id);

                }

                for(InsuranceInformation__c objInsuranceSuggestion : InsuranceInformationDAO.getInsuranceSuggestionByCurrentPlanId(lCurrentPlanId)){
                    List<InsuranceInformation__c> lstInsuranceSuggestion = new List<InsuranceInformation__c>();

                    if(mapInsuranceSuggestionByInsuranceInformationId.containsKey(objInsuranceSuggestion.PlanId__c)){
                        lstInsuranceSuggestion = mapInsuranceSuggestionByInsuranceInformationId.get(objInsuranceSuggestion.PlanId__c);
                        lstInsuranceSuggestion.add(objInsuranceSuggestion);
                        mapInsuranceSuggestionByInsuranceInformationId.put(objInsuranceSuggestion.PlanId__c, lstInsuranceSuggestion);
                    }else{
                        lstInsuranceSuggestion.add(objInsuranceSuggestion);
                        mapInsuranceSuggestionByInsuranceInformationId.put(objInsuranceSuggestion.PlanId__c, lstInsuranceSuggestion);
                    }
                }

            }else if(quotationForm.Type__c == 'D&O'){
                for(Contact objContact : ContactDao.getContactByQuotationFormId(lFormsId)){
                    List<Contact> lstContact = new List<Contact>();

                    if(objContact.Type__c == 'Sociedade Controlada'){
                        if(mapControlledCompanyByFormId.containsKey(objContact.TechnicalSpecificationQuestionnaireId__c)){
                            lstContact = mapControlledCompanyByFormId.get(objContact.TechnicalSpecificationQuestionnaireId__c);
                            lstContact.add(objContact);
                            mapControlledCompanyByFormId.put(objContact.TechnicalSpecificationQuestionnaireId__c, lstContact);
                        }else{
                            lstContact.add(objContact);
                            mapControlledCompanyByFormId.put(objContact.TechnicalSpecificationQuestionnaireId__c, lstContact);
                        }
                    }else if(objContact.Type__c == 'Acionista'){

                        if(mapShareholderPartnerByFormId.containsKey(objContact.TechnicalSpecificationQuestionnaireId__c)){
                            lstContact = mapShareholderPartnerByFormId.get(objContact.TechnicalSpecificationQuestionnaireId__c);
                            lstContact.add(objContact);
                            mapShareholderPartnerByFormId.put(objContact.TechnicalSpecificationQuestionnaireId__c, lstContact);
                        }else{
                            lstContact.add(objContact);
                            mapShareholderPartnerByFormId.put(objContact.TechnicalSpecificationQuestionnaireId__c, lstContact);
                        }
                    }
                }
            }

            ConnectWizQuotationFormsTO.QuotationForms objQuotationFormsTO = new ConnectWizQuotationFormsTO.QuotationForms();
            if(quotationForm != null){
                objQuotationFormsTO.formId = quotationForm.Id;
                objQuotationFormsTO.accidentalDeathPercent = quotationForm.AccidentalDeathPercent__c;
                objQuotationFormsTO.accountId = quotationForm.AccountId__c;
                objQuotationFormsTO.areForHeritageProtectionPurposes = quotationForm.AreForHeritageProtectionPurposes__c;
                objQuotationFormsTO.affFamilyFuneralAssistancePercent = quotationForm.AFF_FamilyFuneralAssistancePercent__c;
                objQuotationFormsTO.afiIndividualFuneralAssistancePercent = quotationForm.AFI_IndividualFuneralAssistancePercent__c;
                objQuotationFormsTO.aggregated = quotationForm.Aggregated__c;
                objQuotationFormsTO.averageTradedVolumePerDay = quotationForm.AverageTradedVolumePerDay__c;
                objQuotationFormsTO.basketBasicPercent = quotationForm.BasketBasicPercent__c;
                objQuotationFormsTO.branchOfActivity = quotationForm.BranchOfActivity__c;
                objQuotationFormsTO.bidderFollowingInvestmentPolicy = quotationForm.BidderFollowingInvestmentPolicy__c;
                objQuotationFormsTO.bidderHasFormalPolicy = quotationForm.BidderHasFormalPolicy__c;
                objQuotationFormsTO.capitalAmount = quotationForm.capitalAmount__c;
                objQuotationFormsTO.capitalModel = quotationForm.CapitalModel__c;
                objQuotationFormsTO.caseId = quotationForm.CaseId__c;
                objQuotationFormsTO.changeInCorporateName = quotationForm.ChangeInCorporateName__c;
                objQuotationFormsTO.changeInMajorityPartner = quotationForm.ChangeInMajorityPartner__c;
                objQuotationFormsTO.childrenOver24YearsOfAge = quotationForm.ChildrenOver24YearsOfAge__c;
                objQuotationFormsTO.chronicCases = quotationForm.ChronicCases__c;
                objQuotationFormsTO.contractingProponentOfInsurance = quotationForm.ContractingProponentOfInsurance__c;
                objQuotationFormsTO.coverageForDrunkennessPercent = quotationForm.CoverageForDrunkennessPercent__c;
                objQuotationFormsTO.covid19AdoptedProcedures = quotationForm.Covid19AdoptedProcedures__c;
                objQuotationFormsTO.covid19BusinessContinuityPlan = quotationForm.Covid19BusinessContinuityPlan__c;
                objQuotationFormsTO.covid19Remote = quotationForm.ProtocolsAgainstCOVID19__c;
                objQuotationFormsTO.createdById = quotationForm.CreatedById;
                objQuotationFormsTO.dateOf1stOffer = quotationForm.DateOf1stOffer__c;
                objQuotationFormsTO.descriptionOfCapital = quotationForm.descriptionOfCapital__c;
                objQuotationFormsTO.disabilityRetirees = quotationForm.DisabilityRetirees__c;
                objQuotationFormsTO.dismissedByLaw = quotationForm.DismissedByLaw__c;
                objQuotationFormsTO.dismissedRetired = quotationForm.DismissedRetired__c;
                objQuotationFormsTO.ditTemporaryDisabilityDailyPercent = quotationForm.DIT_TemporaryDisabilityDailyPercent__c;
                objQuotationFormsTO.dmhHospitalDoctorExpensesPercent = quotationForm.DMH_HospitalDoctorExpensesPercent__c;
                objQuotationFormsTO.expectationRegardingJudicialDemands = quotationForm.ExpectationRegardingJudicialDemands__c;
                objQuotationFormsTO.firstOfferPrice = quotationForm.FirstOfferPrice__c;
                objQuotationFormsTO.formalPolicyForTradingShares = quotationForm.FormalPolicyForTradingShares__c;
                objQuotationFormsTO.funeralAidPercent = quotationForm.FuneralAidPercent__c;
                objQuotationFormsTO.hasAClaimReport = quotationForm.HasAClaimReport__c;
                objQuotationFormsTO.hasDerivativeOperations = quotationForm.HasDerivativeOperations__c;
                objQuotationFormsTO.highestPriceIn1Year = quotationForm.HighestPriceIn1Year__c;
                objQuotationFormsTO.homecare = quotationForm.Homecare__c;
                objQuotationFormsTO.hospitalizationsInProgress = quotationForm.HospitalizationsInProgress__c;
                objQuotationFormsTO.iacAutomaticInclusionOfSpousePercent = quotationForm.IAC_AutomaticInclusionOfSpousePercent__c;
                objQuotationFormsTO.iafAutomaticInclusionOfChildrenPercent = quotationForm.IAF_AutomaticInclusionOfChildrenPercent__c;
                objQuotationFormsTO.ifpdTotalPartialDisabilityDiseasePercent = quotationForm.IFPDTotalPartialDisabilityDiseasePercent__c;
                objQuotationFormsTO.injunctions = quotationForm.Injunctions__c;
                objQuotationFormsTO.invoiceEstimate = quotationForm.InvoiceEstimate__c;
                objQuotationFormsTO.invoiceForecast = quotationForm.InvoiceForecast__c;
                objQuotationFormsTO.ipaTotalOrPartialDisabilityByAccPercent = quotationForm.IPA_TotalOrPartialDisabilityByAccPercent__c;
                objQuotationFormsTO.judicialOrExtrajudicialClaims = quotationForm.JudicialOrExtrajudicialClaims__c;
                objQuotationFormsTO.lastModifiedById = quotationForm.LastModifiedById;
                objQuotationFormsTO.leadId = quotationForm.LeadId__c;
                objQuotationFormsTO.lowestPriceIn1Year = quotationForm.LowestPriceIn1Year__c;
                objQuotationFormsTO.mergerAcquisitionOrPurchase = quotationForm.MergerAcquisitionOrPurchase__c;
                objQuotationFormsTO.naturalDeathPercent = quotationForm.NaturalDeathPercent__c;
                objQuotationFormsTO.noOfShareholdersMeetings = quotationForm.NoOfShareholdersMeetings__c;
                objQuotationFormsTO.numberOfAuditBoardMeetings = quotationForm.NumberOfAuditBoardMeetings__c;
                objQuotationFormsTO.numberOfDirectors = quotationForm.NumberOfDirectors__c;
                objQuotationFormsTO.numberOfFiscalCouncilors = quotationForm.NumberOfFiscalCouncilors__c;
                objQuotationFormsTO.numberOfMembersOnTheBoardOfDirectors = quotationForm.NumberOfMembersOnTheBoardOfDirectors__c;
                objQuotationFormsTO.pregnants = quotationForm.Pregnants__c;
                objQuotationFormsTO.priceWhenFillingInTheQuestionnaire = quotationForm.PriceWhenFillingInTheQuestionnaire__c;
                objQuotationFormsTO.profitLossPerShare = quotationForm.ProfitLossPerShare__c;
                objQuotationFormsTO.ratePerThousand = quotationForm.ratePerThousand__c;
                objQuotationFormsTO.readjustmentForecast = quotationForm.readjustmentForecast__c;
                objQuotationFormsTO.reasonForQuotation = quotationForm.ReasonForQuotation__c;
                objQuotationFormsTO.recordTypeId = quotationForm.RecordTypeId;
                objQuotationFormsTO.requester = quotationForm.Requester__c;
                objQuotationFormsTO.Redeemed = quotationForm.Redeemed__c;
                objQuotationFormsTO.retired = quotationForm.Retired__c;
                objQuotationFormsTO.seriousDiseasesPercent = quotationForm.SeriousDiseasesPercent__c;
                objQuotationFormsTO.serviceProviders = quotationForm.ServiceProviders__c;
                objQuotationFormsTO.sharesTradedOutsideTheBrMarket = quotationForm.SharesTradedOutsideTheBrMarket__c;
                objQuotationFormsTO.terminationPenaltyOutsideTheTerm = quotationForm.terminationPenaltyOutsideTheTerm__c;
                objQuotationFormsTO.tradingCode = quotationForm.TradingCode__c;
                objQuotationFormsTO.type = quotationForm.Type__c;
                objQuotationFormsTO.warrantyLimit = quotationForm.WarrantyLimit__c;
                objQuotationFormsTO.otherWarrantyLimit = quotationForm.OtherWarrantyLimit__c;
                objQuotationFormsTO.generalObservation = quotationForm.GeneralObservation__c;
                objQuotationFormsTO.descriptionGoverLevel = quotationForm.DescriptionGoverLevel__c;
                objQuotationFormsTO.theCompanyGetSomeLevelOfGovernanca = quotationForm.TheCompanyGetSomeLevelOfGovernanca__c;
                objQuotationFormsTO.marketcap = quotationForm.Marketcap__c;
                objQuotationFormsTO.InsuranceInformations = getInsuranceInformationsTO(
                    mapInsuranceInformationByFormId,
                    mapCurrentPlansByInsuranceInformationId,
                    mapInsuranceSuggestionByInsuranceInformationId,
                    quotationForm.Id
                );
                objQuotationFormsTO.ControlledCompanies = getControlledCompaniesTO(
                    mapControlledCompanyByFormId,
                    quotationForm.Id
                );
                objQuotationFormsTO.Shareholders = getShareholdersTO(
                    mapShareholderPartnerByFormId,
                    quotationForm.Id
                );
            }

            System.debug('JSON.serialize(objQuotationFormsTO) ==>'  + JSON.serialize(objQuotationFormsTO));

            return JSON.serialize(objQuotationFormsTO);

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static List<ConnectWizQuotationFormsTO.InsuranceInformation> getInsuranceInformationsTO(
        Map<Id, List<InsuranceInformation__c>> mapInsuranceInformationByFormId,
        Map<Id, List<InsuranceInformation__c>> mapCurrentPlansByInsuranceInformationId,
        Map<Id, List<InsuranceInformation__c>> mapInsuranceSuggestionByInsuranceInformationId,
        String quotationFormId
    ){
        List<ConnectWizQuotationFormsTO.InsuranceInformation> lInsuranceInformations = new List<ConnectWizQuotationFormsTO.InsuranceInformation>();
        Integer countPosition = 1;

        if(mapInsuranceInformationByFormId.containsKey(quotationFormId)){

            for(InsuranceInformation__c objInsuranceInformation : mapInsuranceInformationByFormId.get(quotationFormId)){

                ConnectWizQuotationFormsTO.InsuranceInformation insuranceInformationTO = new ConnectWizQuotationFormsTO.InsuranceInformation();
                insuranceInformationTO.insuranceInformationId = objInsuranceInformation.Id;
                insuranceInformationTO.company = objInsuranceInformation.Company__c;
                insuranceInformationTO.hiringModel = objInsuranceInformation.HiringModel__c;
                insuranceInformationTO.indemnitiesPaid = objInsuranceInformation.IndemnitiesPaid__c;
                insuranceInformationTO.limitOfLiability = objInsuranceInformation.LimitOfLiability__c;
                insuranceInformationTO.numberOfLives = objInsuranceInformation.NumberOfLives__c;
                insuranceInformationTO.technicalSpecificationQuestionnaireId = objInsuranceInformation.TechnicalSpecificationQuestionnaireId__c;
                insuranceInformationTO.termOfContractDate = objInsuranceInformation.TermOfContract__c;
                insuranceInformationTO.termOfContractStr = objInsuranceInformation.TermOfContract__c != null ? objInsuranceInformation.TermOfContract__c.format() : '-';
                insuranceInformationTO.countPosition = countPosition;
                insuranceInformationTO.CurrentPlans = getCurrentPlansTO(
                    mapCurrentPlansByInsuranceInformationId,
                    mapInsuranceSuggestionByInsuranceInformationId,
                    objInsuranceInformation.Id
                );

                lInsuranceInformations.add(insuranceInformationTO);
                countPosition++;
            }
        }
        return lInsuranceInformations;
    }

    private static List<ConnectWizQuotationFormsTO.CurrentPlan> getCurrentPlansTO(
        Map<Id, List<InsuranceInformation__c>> mapCurrentPlansByInsuranceInformationId,
        Map<Id, List<InsuranceInformation__c>> mapInsuranceSuggestionByInsuranceInformationId,
        String insuranceInformationId
    ){
        List<ConnectWizQuotationFormsTO.CurrentPlan> lCurrentPlans = new List<ConnectWizQuotationFormsTO.CurrentPlan>();
        Integer countPosition = 1;

        if(mapCurrentPlansByInsuranceInformationId.containsKey(insuranceInformationId)){

            for(InsuranceInformation__c objCurrentPlan : mapCurrentPlansByInsuranceInformationId.get(insuranceInformationId)){

                ConnectWizQuotationFormsTO.CurrentPlan currentPlanTO = new ConnectWizQuotationFormsTO.CurrentPlan();
                currentPlanTO.currentPlanId = objCurrentPlan.Id;
                currentPlanTO.insuranceInformationId = objCurrentPlan.ParentId__c;
                currentPlanTO.currentPlanName = objCurrentPlan.PlanName__c;
                currentPlanTO.company = objCurrentPlan.ParentId__r.Company__c;
                currentPlanTO.positionEligibility = objCurrentPlan.PositionEligibility__c;
                currentPlanTO.numberOfLives = objCurrentPlan.NumberOfLives__c;
                currentPlanTO.cost = objCurrentPlan.Cost__c;
                currentPlanTO.reimbursement = objCurrentPlan.Reimbursement__c;
                currentPlanTO.contributionHolder = objCurrentPlan.ContributionHolder__c;
                currentPlanTO.contributionDependent = objCurrentPlan.ContributionDependent__c;
                currentPlanTO.coparticipation = objCurrentPlan.coparticipation__c;
                currentPlanTO.countPosition = countPosition;
                currentPlanTO.InsuranceSuggestions = getInsuranceSuggestionsTO(
                    mapInsuranceSuggestionByInsuranceInformationId,
                    objCurrentPlan.Id
                );
                System.debug('currentPlanTO == >' + currentPlanTO);
                lCurrentPlans.add(currentPlanTO);
                countPosition++;
            }
        }

        return lCurrentPlans;
    }

    private static List<ConnectWizQuotationFormsTO.InsuranceSuggestion> getInsuranceSuggestionsTO(
        Map<Id, List<InsuranceInformation__c>> mapInsuranceSuggestionByInsuranceInformationId,
        String currentPlanId
    ){
        List<ConnectWizQuotationFormsTO.InsuranceSuggestion> lInsuranceSuggestions = new List<ConnectWizQuotationFormsTO.InsuranceSuggestion>();
        Integer countPosition = 1;

        if(mapInsuranceSuggestionByInsuranceInformationId.containsKey(currentPlanId)){

            for(InsuranceInformation__c objInsuranceSuggestion : mapInsuranceSuggestionByInsuranceInformationId.get(currentPlanId)){

                ConnectWizQuotationFormsTO.InsuranceSuggestion insuranceSuggestionTO = new ConnectWizQuotationFormsTO.InsuranceSuggestion();
                insuranceSuggestionTO.insuranceSuggestionId = objInsuranceSuggestion.Id;
                insuranceSuggestionTO.suggestionPlan = objInsuranceSuggestion.PlanName__c;
                insuranceSuggestionTO.currentPlan = objInsuranceSuggestion.PlanId__r.PlanName__c;
                insuranceSuggestionTO.currentPlanId = objInsuranceSuggestion.PlanId__c;
                insuranceSuggestionTO.suggestionCompany = objInsuranceSuggestion.Company__c;
                insuranceSuggestionTO.countPosition = countPosition;

                lInsuranceSuggestions.add(insuranceSuggestionTO);
                countPosition++;
            }
        }

        return lInsuranceSuggestions;
    }

    private static List<ConnectWizQuotationFormsTO.ControlledCompany> getControlledCompaniesTO(
        Map<Id, List<Contact>> mapControlledCompanyByFormId,
        String quotationFormId
    ){
        List<ConnectWizQuotationFormsTO.ControlledCompany> lControlledCompanies = new List<ConnectWizQuotationFormsTO.ControlledCompany>();
        Integer countPosition = 1;

        if(mapControlledCompanyByFormId.containsKey(quotationFormId)){

            for(Contact objControlledCompany : mapControlledCompanyByFormId.get(quotationFormId)){

                ConnectWizQuotationFormsTO.ControlledCompany controlledCompanyTO = new ConnectWizQuotationFormsTO.ControlledCompany();
                controlledCompanyTO.controlledCompanyId = objControlledCompany.Id;
                controlledCompanyTO.technicalSpecificationQuestionnaireId = objControlledCompany.TechnicalSpecificationQuestionnaireId__c;
                controlledCompanyTO.controlledCompanyName = objControlledCompany.Name;
                controlledCompanyTO.activity = objControlledCompany.Activity__c;
                controlledCompanyTO.countryOfOrigin = objControlledCompany.CountryOfOrigin__c;
                controlledCompanyTO.participationPercentage =  objControlledCompany.ParticipationPercentage__c;
                controlledCompanyTO.isControlled =  objControlledCompany.IsControlled__c;
                controlledCompanyTO.countPosition = countPosition;

                lControlledCompanies.add(controlledCompanyTO);
                countPosition++;
            }
        }

        return lControlledCompanies;

    }

     private static List<ConnectWizQuotationFormsTO.Shareholder> getShareholdersTO(
        Map<Id, List<Contact>> mapShareholderPartnerByFormId,
        String quotationFormId
    ){
        List<ConnectWizQuotationFormsTO.Shareholder> lShareholders = new List<ConnectWizQuotationFormsTO.Shareholder>();
        Integer countPosition = 1;

        if(mapShareholderPartnerByFormId.containsKey(quotationFormId)){

            for(Contact objShareholder : mapShareholderPartnerByFormId.get(quotationFormId)){

                ConnectWizQuotationFormsTO.Shareholder shareholderTO = new ConnectWizQuotationFormsTO.Shareholder();
                shareholderTO.shareholderId = objShareholder.Id;
                shareholderTO.technicalSpecificationQuestionnaireId = objShareholder.TechnicalSpecificationQuestionnaireId__c;
                shareholderTO.nameOfShareholderPartner = objShareholder.Name;
                shareholderTO.countryOfOrigin = objShareholder.CountryOfOrigin__c;
                shareholderTO.percentageOfTotalShares =  objShareholder.PercentageOfTotalShares__c;
                shareholderTO.percentageOfPreferredShares =  objShareholder.PercentageOfPreferredShares__c;
                shareholderTO.percentageOfCommonShares =  objShareholder.PercentageOfCommonShares__c;
                shareholderTO.countPosition = countPosition;

                lShareholders.add(shareholderTO);
                countPosition++;
            }
        }

        return lShareholders;
    }
}