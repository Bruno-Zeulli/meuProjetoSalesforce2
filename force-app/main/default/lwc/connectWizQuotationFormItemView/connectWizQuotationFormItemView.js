import { api, LightningElement, track, wire } from 'lwc';
import {exportCSVFile} from 'c/utils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuotationForm from '@salesforce/apex/ConnectWizQuotationFormsController.getQuotationFormsById';
import { NavigationMixin } from "lightning/navigation";

export default class ConnectWizQuotationFormItemView extends NavigationMixin(LightningElement){

    @api formId;
    isHealth = false;
    isHealthOrDental = false;
    isLive = false;
    isDeO = false;
    @track quotationForm = [];
    @track quotationFormOriginal = [];
    csvData = [];
    csvHeaders = [];
    csvDataLive =[];
    csvHeadersLive = [];

    connectedCallback(){
        this.getQuotationForm();
    }

    async getQuotationForm(){
        getQuotationForm({formId : this.formId}).then(result => {
            console.log('backend getQuotationForm' + JSON.stringify(result));
            this.quotationFormOriginal = JSON.parse(result);

            let quotationFormModified = this.quotationFormOriginal;
            this.validateTypeForm(quotationFormModified.type);
            quotationFormModified = this.convertBooleanInString(quotationFormModified);
            quotationFormModified = this.toFixedDecimal(quotationFormModified);

             console.log('after quotationFormModified' + JSON.stringify(quotationFormModified));

            this.quotationForm = quotationFormModified;

        })
        .catch(error =>{
            console.log('Deu errado retrieve' + JSON.stringify(error));
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error loading data',
                            message,
                            variant: 'error',
                        }),
                    );
        });
    }

    handleEditForm(){
        let quotationForm = this.quotationFormOriginal;
        console.log('quotationForm' + JSON.stringify(quotationForm));

        const selectedEvent = new CustomEvent("editquotationform", {
            detail: quotationForm
        });
        this.dispatchEvent(selectedEvent);
    }

    validateTypeForm(formType){
        this.clearTypeForm();
        switch (formType){
            case 'Saúde':
                this.isHealth = true;
                this.isHealthOrDental = true;
                this.isBenefits = true;
                break;
            case 'Vida':
                this.isBenefits = true;
                this.isLive = true;
                this.isHealthOrDental = false;
            case 'Odontológico':
                this.isBenefits = true;
                this.isHealthOrDental = true;
                break;
            case 'D&O':
                this.isDeO = true;
                break;
            default:
        }
    }

    convertBooleanInString(quotationFormModified){

        quotationFormModified.aggregated = quotationFormModified.aggregated ? 'Sim' : 'Não';
        quotationFormModified.areForHeritageProtectionPurposes = quotationFormModified.areForHeritageProtectionPurposes ? 'Sim' : 'Não';
        quotationFormModified.bidderHasFormalPolicy = quotationFormModified.bidderHasFormalPolicy ? 'Sim' : 'Não';
        quotationFormModified.bidderFollowingInvestmentPolicy = quotationFormModified.bidderFollowingInvestmentPolicy ? 'Sim' : 'Não';
        quotationFormModified.changeInCorporateName = quotationFormModified.changeInCorporateName ? 'Sim' : 'Não';
        quotationFormModified.changeInMajorityPartner = quotationFormModified.changeInMajorityPartner ? 'Sim' : 'Não';
        quotationFormModified.childrenOver24YearsOfAge = quotationFormModified.childrenOver24YearsOfAge ? 'Sim' : 'Não';
        quotationFormModified.chronicCases = quotationFormModified.chronicCases ? 'Sim' : 'Não';
        quotationFormModified.contractingProponentOfInsurance = quotationFormModified.contractingProponentOfInsurance ? 'Sim' : 'Não';
        quotationFormModified.disabilityRetirees = quotationFormModified.disabilityRetirees ? 'Sim' : 'Não';
        quotationFormModified.dismissedByLaw = quotationFormModified.dismissedByLaw ? 'Sim' : 'Não';
        quotationFormModified.dismissedRetired = quotationFormModified.dismissedRetired ? 'Sim' : 'Não';
        quotationFormModified.expectationRegardingJudicialDemands = quotationFormModified.expectationRegardingJudicialDemands ? 'Sim' : 'Não';
        quotationFormModified.formalPolicyForTradingShares = quotationFormModified.formalPolicyForTradingShares ? 'Sim' : 'Não';
        quotationFormModified.hasAClaimReport = quotationFormModified.hasAClaimReport ? 'Sim' : 'Não';
        quotationFormModified.hasDerivativeOperations = quotationFormModified.hasDerivativeOperations ? 'Sim' : 'Não';
        quotationFormModified.homecare = quotationFormModified.homecare ? 'Sim' : 'Não';
        quotationFormModified.hospitalizationsInProgress = quotationFormModified.hospitalizationsInProgress ? 'Sim' : 'Não';
        quotationFormModified.injunctions = quotationFormModified.injunctions ? 'Sim' : 'Não';
        quotationFormModified.judicialOrExtrajudicialClaims = quotationFormModified.judicialOrExtrajudicialClaims ? 'Sim' : 'Não';
        quotationFormModified.mergerAcquisitionOrPurchase = quotationFormModified.mergerAcquisitionOrPurchase ? 'Sim' : 'Não';
        quotationFormModified.pregnants = quotationFormModified.pregnants ? 'Sim' : 'Não';
        quotationFormModified.Redeemed = quotationFormModified.Redeemed ? 'Sim' : 'Não';
        quotationFormModified.retired = quotationFormModified.retired ? 'Sim' : 'Não';
        quotationFormModified.serviceProviders = quotationFormModified.serviceProviders ? 'Sim' : 'Não';
        quotationFormModified.sharesTradedOutsideTheBrMarket = quotationFormModified.sharesTradedOutsideTheBrMarket ? 'Sim' : 'Não';
        quotationFormModified.theCompanyGetSomeLevelOfGovernanca = quotationFormModified.theCompanyGetSomeLevelOfGovernanca ? 'Sim' : 'Não';
        quotationFormModified.generalObservation = quotationFormModified.generalObservation ? quotationFormModified.generalObservation : 'Não informado';
        quotationFormModified.descriptionGoverLevel = quotationFormModified.descriptionGoverLevel ? quotationFormModified.descriptionGoverLevel : 'Não informado';

        quotationFormModified.ControlledCompanies.forEach(item => {
            item.isControlled = item.isControlled ? 'Sim' : 'Não';
        });

        return quotationFormModified;
    }

    toFixedDecimal(quotationFormModified){
        quotationFormModified.accidentalDeathPercent = Number(quotationFormModified.accidentalDeathPercent).toFixed(2);
        quotationFormModified.affFamilyFuneralAssistancePercent = Number(quotationFormModified.affFamilyFuneralAssistancePercent).toFixed(2);
        quotationFormModified.afiIndividualFuneralAssistancePercent = Number(quotationFormModified.afiIndividualFuneralAssistancePercent).toFixed(2);
        quotationFormModified.averageTradedVolumePerDay = Number(quotationFormModified.averageTradedVolumePerDay).toFixed(0);
        quotationFormModified.basketBasicPercent = Number(quotationFormModified.basketBasicPercent).toFixed(2);
        quotationFormModified.capitalAmount = Number(quotationFormModified.capitalAmount).toFixed(2);
        quotationFormModified.coverageForDrunkennessPercent = Number(quotationFormModified.coverageForDrunkennessPercent).toFixed(2);
        quotationFormModified.ditTemporaryDisabilityDailyPercent = Number(quotationFormModified.ditTemporaryDisabilityDailyPercent).toFixed(2);
        quotationFormModified.dmhHospitalDoctorExpensesPercent = Number(quotationFormModified.dmhHospitalDoctorExpensesPercent).toFixed(2);
        quotationFormModified.firstOfferPrice = Number(quotationFormModified.firstOfferPrice).toFixed(2);
        quotationFormModified.funeralAidPercent = Number(quotationFormModified.funeralAidPercent).toFixed(2);
        quotationFormModified.highestPriceIn1Year = Number(quotationFormModified.highestPriceIn1Year).toFixed(2);
        quotationFormModified.iacAutomaticInclusionOfSpousePercent = Number(quotationFormModified.iacAutomaticInclusionOfSpousePercent).toFixed(2);
        quotationFormModified.iafAutomaticInclusionOfChildrenPercent = Number(quotationFormModified.iafAutomaticInclusionOfChildrenPercent).toFixed(2);
        quotationFormModified.ifpdTotalPartialDisabilityDiseasePercent = Number(quotationFormModified.ifpdTotalPartialDisabilityDiseasePercent).toFixed(2);
        quotationFormModified.invoiceEstimate = Number(quotationFormModified.invoiceEstimate).toFixed(2);
        quotationFormModified.invoiceForecast = Number(quotationFormModified.invoiceForecast).toFixed(2);
        quotationFormModified.ipaTotalOrPartialDisabilityByAccPercent = Number(quotationFormModified.ipaTotalOrPartialDisabilityByAccPercent).toFixed(2);
        quotationFormModified.lowestPriceIn1Year = Number(quotationFormModified.lowestPriceIn1Year).toFixed(2);
        quotationFormModified.naturalDeathPercent = Number(quotationFormModified.naturalDeathPercent).toFixed(2);
        quotationFormModified.noOfShareholdersMeetings = Number(quotationFormModified.noOfShareholdersMeetings).toFixed(0);
        quotationFormModified.numberOfAuditBoardMeetings = Number(quotationFormModified.numberOfAuditBoardMeetings).toFixed(0);
        quotationFormModified.numberOfDirectors = Number(quotationFormModified.numberOfDirectors).toFixed(0);
        quotationFormModified.numberOfFiscalCouncilors = Number(quotationFormModified.numberOfFiscalCouncilors).toFixed(0);
        quotationFormModified.numberOfMembersOnTheBoardOfDirectors = Number(quotationFormModified.numberOfMembersOnTheBoardOfDirectors).toFixed(0);
        quotationFormModified.priceWhenFillingInTheQuestionnaire = Number(quotationFormModified.priceWhenFillingInTheQuestionnaire).toFixed(2);
        quotationFormModified.profitLossPerShare = Number(quotationFormModified.profitLossPerShare).toFixed(2);
        quotationFormModified.ratePerThousand = Number(quotationFormModified.ratePerThousand).toFixed(2);
        quotationFormModified.readjustmentForecast = Number(quotationFormModified.readjustmentForecast).toFixed(2);
        quotationFormModified.seriousDiseasesPercent = Number(quotationFormModified.seriousDiseasesPercent).toFixed(2);
        quotationFormModified.terminationPenaltyOutsideTheTerm = Number(quotationFormModified.terminationPenaltyOutsideTheTerm).toFixed(2);
        quotationFormModified.tradingCode = Number(quotationFormModified.tradingCode).toFixed(0);
        quotationFormModified.marketcap = Number(quotationFormModified.marketcap).toFixed(2);

        quotationFormModified.InsuranceInformations.forEach(item => {
            item.indemnitiesPaid = Number(item.indemnitiesPaid).toFixed(0);
            item.limitOfLiability = Number(item.limitOfLiability).toFixed(2);
            item.CurrentPlans.forEach(item => {
                item.cost = Number(item.cost).toFixed(2);
                item.reimbursement = Number(item.reimbursement).toFixed(2);
                item.contributionHolder = Number(item.contributionHolder).toFixed(2);
                item.contributionDependent = Number(item.contributionDependent).toFixed(2);
                item.coparticipation = Number(item.coparticipation).toFixed(2);
            });
        });

        return quotationFormModified;
    }

    clearTypeForm(){
        this.isHealth = false;
        this.isHealthOrDental = false;
        this.isLive = false;
        this.isDeO = false;
    }

    async exportAsCSV(){
        console.log('ExportASCSV');
        console.log('health ' +this.isHealth + " dental " +this.isHealthOrDental + " Live " + this.isLive);
        if(this.isDeO){
            await this.createCSVHeadersDEO();
            await this.createCSVDataDEO();
            exportCSVFile(this.csvHeaders, this.csvData, "Questionário DEO");
        }else if(this.isBenefits){
            if(this.isHealth && this.isHealthOrDental){
                await this.createCSVHeadersHealth();
                await this.createCSVDataHealth();
                exportCSVFile(this.csvHeaders, this.csvData, "Questionário Health");
            }
            else if(this.isLive){
                await this.createCSVHeadersLive();
                await this.createCSVDataLive();
                exportCSVFile(this.csvHeadersLive, this.csvDataLive, "Questionário Live");
            }
            else if(this.isHealthOrDental && !this.isHealth){
                await this.createCSVHeadersHealthOrDental();
                await this.createCSVDataHealthOrDental();
                exportCSVFile(this.csvHeaders, this.csvData, "Questionário Health Or Dental");
            }
        }
    }

    exportAsPDF(){
        const hostname = window.location.hostname;
        const url = `//${hostname}/connectatwiz/apex/pdfPrintForm?formId=${this.formId}`;

        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: { url }
            }).then(generatedUrl => {
            window.open(generatedUrl);
            }).catch(() => {
            window.open(url);
        });
    }

    saveByteArray(pdfName , byte){
        var blob = new Blob([byte], { type: "application/pdf" });
        var link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        var fileName = pdfName;
        link.download = fileName;
        link.click();
    }

    async createCSVHeadersDEO(){
        this.csvHeaders = {
        composition:'DADOS ACIONISTA(S)',
        controlledCompanies:'SOCIEDADE(S) CONTROLADA(S)',
        gorvernance:'GOVERNANÇA CORPORATIVA',
        gorvernanceLevel : 'A COMPANHIA OBTÉM ALGUM NÍVEL DE GOVERNANÇA CARPORATIVA?',
        descriptionGoverLevel : 'DESCREVA',
        generalObservation : 'OBSERVAÇÔES GERAIS',
        boardOfDirectors : 'COMITÊ DE INVESTIMENTO',
        boardOfDirectorsNumberOfMembers : 'NÚMERO DE MEMBROS DA DIRETORIA',
        boardOfDirectorsNumberOfCouncilors : "NÚMERO DE CONSELHEIROS",
        boardOfDirectorsNumberOfCouncilorsFiscal : "NÚMERO DE CONSELHEIROS FISCAIS",
        boardOfDirectorsNumberOfAuditBoardMeetings : "NÚMERO DE RENIÕES DO CONSELHO FICAIS NO ANO ANTERIOR",
        boardOfDirectorsNoOfShareholdersMeetings : "NÚMERO DE ASSEMBLEIAS ACIONISTAS DURANTE O ANO ANTERIOR",
        formalPolicyForTradingShares : "A EMPRESA POSSUI ALGUMA POLITÍCA FORMAL PARA NEGOCIAÇÃO DE AÇÕES DA PRÓPRIA EMPRESA POR PARTE DOS CONSELHEIROS DIRETORES OU GERENTES?",
        sharesTradedOutsideTheBrMarket : "AS AÇÕES SÃO NEGOCIADAS FORA DO MERCADO BRASILEIRO ATRAVÉS DE ADRS?",
        aboutADRSLevel : "SOBRE O NÍVEL DAS ADRS",
        negotiationCode : "CÓDIGO DE NEGOCIAÇÃO",
        dateOf1stOffer : "DATA DA 1º OFERTA",
        firstOfferPrice : "PREÇO DA 1ª OFERTA",
        priceWhenFillingInTheQuestionnaire : "PREÇO NA DATA DE PREENCHIMENTO DO QUESTIONÁRIO",
        lowestPriceIn1Year : "MENOR PREÇO EM 1 ANO",
        marketcap : "MARKETCAP",
        profitLossPerShare : "LUCRO OU PREJUÍZO POR AÇÃO ",
        averageTradedVolumePerDay : "VOLUME MÉDIO NEGOCIADO POR DIA",
        last5Years : "INFORMAR SE NOS ÚLTIMOS 5 ANOS OCORRERAM OS FATOS ABAIXO",
        changeInCorporateName : "MUDANÇA NA RAZÃO SOCIAL",
        changeInMajorityPartner : "MUDANÇA NO SÓCIO MAJORITÁRIO",
        mergerAcquisitionOrPurchase : "FUSÃO AQUISIÇÃO OU COMPRA DE PARTICIPAÇÃO EM OUTRA SOCIEDADE",
        judicialOrExtrajudicialClaims : "DEMANDAS JUDICIAIS OU EXTRAJUDICIAIS INCLUSIVE INQUÉRITOS ADMINISTRATIVOS CONTRA OS ADMINISTRADORES ATUAIS E/OU CONTRA OS ADMINISTRADORES DE GESTÃO ANTERIORES",
        expectationRegardingJudicialDemands : "INFORMA SE HÁ EXPECTATIVA QUANTO A OCORRÊNCIA DE DEMANDA JUDICIAL OU EXTRAJUDICIAL CONTRA OS ADMINISTRADORES RELACIONADA AOS SEUS ATOS DE GESTÃO",
        contractingProponentOfInsurance : "PROPONENTE E/OU SUAS SOCIEDADES CONTROLADAS JÁ FORAM OU ATUALMENTE SÃO CONTRATANTES DO SEGURO DE RESPONSABILIDADE CIVEL DE ADMINISTRADORES?",
        insuranceInformation : "INFORMAÇÃO DO SEGURO",
        financialOperation : "OPERAÇÕES FINANCEIRAS",
        bidderHasFormalPolicy : "A PROPONENTE E/OU SUAS SOCIEDADES CONTROLADAS POSSUEM ALGUMA POLÍTICA FORMAL DE INVESTIMENTOS?",
        bidderFollowingInvestmentPolicy : "A PROPONENTE E/OU SUAS SOCIEDADES CONTROLADAS ESTÃO SEGUINDO FIELMENTE A POLÍTICA DE INVESTIMENTOS NOS ÚLTIMOS 5 ANOS?",
        hasDerivativeOperations : "A PROPONENTE E/OU SUAS SOCIEDADES CONTROLADAS POSSUEM OPERAÇÕES COM DERIVATIVOS?",
        areForHeritageProtectionPurposes : "AS OPERAÇÕES COM DERIVATIVOS SÃO EXCLUSIVAMENTE PARA FINS DE PROTEÇÃO DO PATRIMÔNIO DA COMPANHIA (OPERAÇÕES DE HEDGE)?",
        warranty : "GARANTIA",
        warrantyLimit : "VALORES SELECIONADOS",
        otherWarrantyLimit : "OUTRO VALOR SELECIONADO",
        covid19 : "Questões COVID-19",
        covid19AdoptedProcedures : "QUAIS OS PROCEDIMENTOS ADOTADOS PELA COMPANHIA PARA PROTEGER SEUS FUNCIONÁRIOS DA EXPOSIÇÃO AO COVID-19?",
        covid19BusinessContinuityPlan : "INFORMAR QUAL É O PLANO DE CONTINUIDADE DE NEGÓCIOS DEVIDO AO COVID 19 INCLUINDO O DETALHAMENTO DAS QUAIS AÇÕES QUE ESTÃO SENDO TOMADAS (DESCREVER OS PILARES CHAVES DO PLANO DE RESPOSTA DA COMPANHIA PARA MINIMIZAR O IMPACTO DO COVID-19) ",
        covid19Remote : "HÁ COLABORADORES TRABALHANDO REMOTAMENTE? QUE PROTOCOLOS FORAM IMPLANTADOS PARA ELES? A EMPRESA POSSUI UM PLANO PARA REDUZIR O QUADRO DE COLABORADORES NO CASO DE UM DECLÍNIO ECONÔMICO CONTINUO IMPACTANDO A EMPRESA NEGATIVAMENTE? QUE MEDIDAS A EMPRESA TOMOU PARA CONCILIAR ISSO COM SUAS OBRIGAÇÕES TRABALHISTAS? ",
        };
    }

    async createCSVDataDEO(){
        let composition = '';
        let controlledCompanies ='';
        let insuranceInformation = '';
        console.log('inside createCSVData' + JSON.stringify(this.quotationForm));
        for(let objShareHolder of this.quotationForm.Shareholders)  {
             composition += objShareHolder.countPosition+ 'º Acionista' + ' NOME DO ACIONISTA/SÓCIO: ' + objShareHolder.nameOfShareholderPartner +
            ' PAIS DE ORIGEM: ' + objShareHolder.countryOfOrigin + ' PORCENTAGEM DAS AÇÕES ORDINÁRIAS: ' + objShareHolder.percentageOfTotalShares+ '%' +
            ' PORCENTAGEM DAS AÇÕES PREFERENCIAIS: ' + objShareHolder.percentageOfPreferredShares + '%' + ' PORCENTAGEM DO TOTAL DAS AÇÕES: ' +
            objShareHolder.percentageOfCommonShares + '%' + ' / ';
        }

        for(let objContoledCompany of this.quotationForm.ControlledCompanies){
            controlledCompanies+=  objContoledCompany.countPosition+'ª Sociedade Controlada' + ' NOME DA SOCIEDADE CONTROLADA: ' + objContoledCompany.objContoledCompanyName +
            'ATIVIDADE: ' + objContoledCompany.activity + 'PAIS DE ORIGEM: ' + objContoledCompany.countryOfOrigin + 'PORCENTAGEM DE PARTICIPAÇÃO: ' +
            objContoledCompany.participationPercentage+'%'+ 'É CONTROLADA? ' + objContoledCompany.isControlled + ' / ' ;
        }

        for(let objInsuranceInformation of this.quotationForm.InsuranceInformations){
            insuranceInformation += 'Informações do Seguro - ' + objInsuranceInformation.countPosition + ' NOME DA SEGURADORA: ' + objInsuranceInformation.company + ' LIMITE DE RESPONSABILIDADE: ' +
            objInsuranceInformation.limitOfLiability + ' DATA DE VENCIMENTO/CANCELAMENTO: ' + objInsuranceInformation.termOfContractStr + ' INDENIZAÇÕES PAGAS: ' + objInsuranceInformation.indemnitiesPaid + ' / ';
        }

            this.csvData = [...this.csvData, {
                composition : composition,
                controlledCompanies : controlledCompanies,
                gorvernance : '',
                gorvernanceLevel : this.quotationForm.theCompanyGetSomeLevelOfGovernanca == null ? '' : this.quotationForm.theCompanyGetSomeLevelOfGovernanca,
                generalObservation : this.quotationForm.generalObservation == null ? '' : this.quotationForm.generalObservation,
                descriptionGoverLevel : this.quotationForm.descriptionGoverLevel == null ? '' : this.quotationForm.descriptionGoverLevel,
                boardOfDirectors : '',
                boardOfDirectorsNumberOfMembers : this.quotationForm.numberOfMembersOnTheBoardOfDirectors == null ? '' : this.quotationForm.numberOfMembersOnTheBoardOfDirectors,
                boardOfDirectorsNumberOfCouncilors : this.quotationForm.numberOfDirectors == null ? '' : this.quotationForm.numberOfDirectors,
                boardOfDirectorsNumberOfCouncilorsFiscal : this.quotationForm.numberOfFiscalCouncilors == null ? '' : this.quotationForm.numberOfFiscalCouncilors,
                boardOfDirectorsNumberOfAuditBoardMeetings : this.quotationForm.numberOfAuditBoardMeetings == null ? '' : this.quotationForm.numberOfAuditBoardMeetings,
                boardOfDirectorsNoOfShareholdersMeetings : this.quotationForm.noOfShareholdersMeetings == null ? '' : this.quotationForm.noOfShareholdersMeetings,
                formalPolicyForTradingShares : this.quotationForm.formalPolicyForTradingShares == null ? '' : this.quotationForm.formalPolicyForTradingShares,
                sharesTradedOutsideTheBrMarket : this.quotationForm.sharesTradedOutsideTheBrMarket == null ? '' : this.quotationForm.sharesTradedOutsideTheBrMarket,
                aboutADRSLevel : '',
                negotiationCode : this.quotationForm.tradingCode == null ? '' : this.quotationForm.tradingCode,
                dateOf1stOffer : this.quotationForm.dateOf1stOffer == null ? '' : this.quotationForm.dateOf1stOffer,
                firstOfferPrice : this.quotationForm.firstOfferPrice == null ? '' : 'R$' + this.quotationForm.firstOfferPrice,
                priceWhenFillingInTheQuestionnaire : this.quotationForm.priceWhenFillingInTheQuestionnaire == null ? '' : 'R$' + this.quotationForm.priceWhenFillingInTheQuestionnaire,
                lowestPriceIn1Year : this.quotationForm.lowestPriceIn1Year == null ? '' : 'R$' + this.quotationForm.lowestPriceIn1Year,
                marketcap : this.quotationForm.marketcap == null ? '' : 'R$' + this.quotationForm.marketcap,
                profitLossPerShare : this.quotationForm.profitLossPerShare == null ? '' : 'R$'+this.quotationForm.profitLossPerShare,
                averageTradedVolumePerDay : this.quotationForm.averageTradedVolumePerDay == null ? '' : this.quotationForm.averageTradedVolumePerDay,
                last5Years : '',
                changeInCorporateName : this.quotationForm.changeInCorporateName == null ? '' : this.quotationForm.changeInCorporateName,
                changeInMajorityPartner : this.quotationForm.changeInMajorityPartner == null ? '' : this.quotationForm.changeInMajorityPartner,
                mergerAcquisitionOrPurchase : this.quotationForm.mergerAcquisitionOrPurchase == null ? '' : this.quotationForm.mergerAcquisitionOrPurchase,
                judicialOrExtrajudicialClaims : this.quotationForm.judicialOrExtrajudicialClaims == null ? '' : this.quotationForm.judicialOrExtrajudicialClaims,
                expectationRegardingJudicialDemands : this.quotationForm.expectationRegardingJudicialDemands == null ? '' : this.quotationForm.expectationRegardingJudicialDemands,
                contractingProponentOfInsurance : this.quotationForm.contractingProponentOfInsurance == null ? '' : this.quotationForm.contractingProponentOfInsurance,
                insuranceInformation : insuranceInformation,
                financialOperation : '',
                bidderHasFormalPolicy : this.quotationForm.bidderHasFormalPolicy == null ? '' : this.quotationForm.bidderHasFormalPolicy,
                bidderFollowingInvestmentPolicy : this.quotationForm.bidderFollowingInvestmentPolicy == null ? '' : this.quotationForm.bidderFollowingInvestmentPolicy,
                hasDerivativeOperations : this.quotationForm.hasDerivativeOperations == null ? '' : this.quotationForm.hasDerivativeOperations,
                areForHeritageProtectionPurposes : this.quotationForm.areForHeritageProtectionPurposes == null ? '' : this.quotationForm.areForHeritageProtectionPurposes,
                warranty : '',
                warrantyLimit : this.quotationForm.warrantyLimit == null ? '' : this.quotationForm.warrantyLimit,
                otherWarrantyLimit : this.quotationForm.otherWarrantyLimit == null ? '' : this.quotationForm.otherWarrantyLimit,
                covid19 : '',
                covid19AdoptedProcedures : this.quotationForm.covid19AdoptedProcedures == null ? '' : this.quotationForm.covid19AdoptedProcedures,
                covid19BusinessContinuityPlan : this.quotationForm.covid19BusinessContinuityPlan == null ? '' : this.quotationForm.covid19BusinessContinuityPlan,
                covid19Remote : this.quotationForm.covid19Remote == null ? '' : this.quotationForm.covid19Remote
            }]
    }

    async createCSVHeadersHealth(){
        this.csvHeaders = {
            insuranceInformations : "INFORMAÇÕES DA SEGURADORA",
            moreInformation : "INFORMAÇÕES COMPLEMENTARES",
            hasAClaimReport : "POSSUI RELATÓRIO DE SINISTRO",
            retired : "AFASTADOS",
            dismissedByLaw: "DEMITIDOS POR LEI",
            disabilityRetirees : "APOSENTADOS POR INVALIDEZ",
            hospitalizationsInProgress : "INTERNAÇÕES EM ANDAMENTO",
            childrenOver24YearsOfAge : "FILHOS COM MAIS DE 24 ANOS",
            homeCare : "HOMECARE",
            pregnants : "GESTANTES",
            serviceProviders : "PRESTADORES DE SERVIÇO",
            injunctions : "LIMINARES",
            chronicCases : "CASOS CRÔNICOS",
            redeemed : "REMIDOS",
            aggregated : "AGREGADOS",
            plans : "TABELA DE PLANOS",
            invoiceForecast : "PREVISÃO DE FATURA",
            insurancePlans : "PLANOS DE SAÚDE",
        }
    }

    async createCSVDataHealth(){
        let insuranceInformation = '';
        let insurancePlans = '';
        this.csvData = [];
        if(JSON.stringify(this.quotationForm.InsuranceInformations) !== {}){
            if(this.quotationForm.InsuranceInformations.CurrentPlans != null && this.quotationForm.InsuranceInformations.CurrentPlans != undefined){
            for(let objInsurancePlan of Object.entries(this.quotationForm.InsuranceInformations.CurrentPlans)){
            insurancePlans +=  'Plano ' + objInsurancePlan.company + "-" + objInsurancePlan.countPosition + " NOME DO PLANO: " + objInsurancePlan.currentPlanName + " OPERADORA: " + objInsurancePlan.company +
            " CARGO E/OU ELEGIBILIDADE: " + objInsurancePlan.positionEligibility+ " QUANTIDADE DE VIDAS: " + objInsurancePlan.numberOfLives + " CUSTO: R$" + objInsurancePlan.cost + " REEMBOLSO: " + objInsurancePlan.reimbursement + "% " +  
            "CONTRIBUIÇÃO TITULAR: " + objInsurancePlan.contributionHolder + "% " +" CONTRIBUIÇÃO DEPENDENTE: R$" + objInsurancePlan.contributionDependent + " COPARTICIPAÇÃO: " + objInsurancePlan.coparticipation + "% / ";
            }
        }

            for(let objInsuranceInfo of this.quotationForm.InsuranceInformations){
                insuranceInformation += 'Operadora Atual - ' + objInsuranceInfo.countPosition + ' OPERADORA: ' + objInsuranceInfo.company + ' NÚMERO TOTAL DE VIDAS: ' + objInsuranceInfo.numberOfLives +
                ' VIGÊNCIA CONTRATUAL: ' + objInsuranceInfo.termOfContractStr + ' MODELO DE CONTRATAÇÃO: ' + objInsuranceInfo.hiringModel + ' / ';
            }
        }else{
            insuranceInformation = "N/T";
        }

        this.csvData = [...this.csvData,{
            insuranceInformations : insuranceInformation,
            moreInformation : '',
            hasAClaimReport : this.quotationForm.hasAClaimReport == null ? '' : this.quotationForm.hasAClaimReport,
            retired : this.quotationForm.retired == null ? '' : this.quotationForm.retired,
            dismissedByLaw : this.quotationForm.dismissedByLaw == null ? '' : this.quotationForm.dismissedByLaw,
            disabilityRetirees : this.quotationForm.disabilityRetirees == null ? '' : this.quotationForm.disabilityRetirees,
            hospitalizationsInProgress : this.quotationForm.hospitalizationsInProgress == null ? '' : this.quotationForm.hospitalizationsInProgress,
            childrenOver24YearsOfAge : this.quotationForm.childrenOver24YearsOfAge == null ? '' : this.quotationForm.childrenOver24YearsOfAge,
            homeCare : this.quotationForm.homecare == null ? '' : this.quotationForm.homecare,
            pregnants : this.quotationForm.pregnants == null ? '' : this.quotationForm.pregnants,
            serviceProviders : this.quotationForm.serviceProviders == null ? '' : this.quotationForm.serviceProviders,
            injunctions : this.quotationForm.injunctions == null ? '' : this.quotationForm.injunctions,
            chronicCases : this.quotationForm.chronicCases == null ? '' : this.quotationForm.chronicCases,
            redeemed : this.quotationForm.redeemed == null ? '' : this.quotationForm.redeemed,
            aggregated : this.quotationForm.aggregated == null ? '' : this.quotationForm.aggregated,
            plans : '',
            invoiceForecast : this.quotationForm.invoiceForecast == null ? '' : this.quotationForm.invoiceForecast,
            insurancePlans : insurancePlans,
        }];
    }

    async createCSVHeadersHealthOrDental(){
        this.csvHeaders = {
            insuranceInformations : "INFORMAÇÕES DA SEGURADORA",
            moreInformation : "INFORMAÇÕES COMPLEMENTARES",
            retired : "AFASTADOS",
            dismissedRetired : "DEMITIDOS/APOSENTADOS",
            serviceProviders : "PRESTADORES DE SERVIÇO",
            aggregated : "AGREGADOS",
            plans : "TABELA DE PLANOS",
            invoiceForecast : "PREVISÃO DE FATURA",
            insurancePlans : "PLANOS DE SAÚDE",

        };
    }

    async createCSVDataHealthOrDental(){
        let insuranceInformation = '';
        let insurancePlans = '';
        this.csvData = [];
        if(JSON.stringify(this.quotationForm.InsuranceInformations) !== {}){
            if(this.quotationForm.InsuranceInformations.CurrentPlans != null && this.quotationForm.InsuranceInformations.CurrentPlans != undefined){
            for(let objInsurancePlan of Object.entries(this.quotationForm.InsuranceInformations.CurrentPlans)){
            insurancePlans +=  'Plano ' + objInsurancePlan.company + "-" + objInsurancePlan.countPosition + " NOME DO PLANO: " + objInsurancePlan.currentPlanName + " OPERADORA: " + objInsurancePlan.company +
            " CARGO E/OU ELEGIBILIDADE: " + objInsurancePlan.positionEligibility+ " QUANTIDADE DE VIDAS: " + objInsurancePlan.numberOfLives + " CUSTO: R$" + objInsurancePlan.cost + " REEMBOLSO: " + objInsurancePlan.reimbursement + "% " +
            "CONTRIBUIÇÃO TITULAR: " + objInsurancePlan.contributionHolder + "% " + " CONTRIBUIÇÃO DEPENDENTE: R$" + objInsurancePlan.contributionDependent + " COPARTICIPAÇÃO: " + objInsurancePlan.coparticipation + " % / ";
            }
        }

            for(let objInsuranceInfo of this.quotationForm.InsuranceInformations){
                insuranceInformation += 'Operadora Atual - ' + objInsuranceInfo.countPosition + ' OPERADORA: ' + objInsuranceInfo.company + ' NÚMERO TOTAL DE VIDAS: ' + objInsuranceInfo.numberOfLives +
                ' VIGÊNCIA CONTRATUAL: ' + objInsuranceInfo.termOfContractStr + ' MODELO DE CONTRATAÇÃO: ' + objInsuranceInfo.hiringModel + ' / ';
            }
        }else{
            insuranceInformation = "N/T";
        }

        this.csvData = [...this.csvData,{
            insuranceInformations : insuranceInformation,
            moreInformation : '',
            retired : this.quotationForm.retired == null ? '' : this.quotationForm.retired,
            dismissedRetired : this.quotationForm.dismissedRetired == null ? '' : this.quotationForm.dismissedRetired,
            serviceProviders : this.quotationForm.serviceProviders == null ? '' : this.quotationForm.serviceProviders,
            aggregated : this.quotationForm.aggregated == null ? '' : this.quotationForm.aggregated,
            plans : '',
            invoiceForecast : this.quotationForm.invoiceForecast == null ? '' : this.quotationForm.invoiceForecast,
            insurancePlans : insurancePlans

        }];
    }

    async createCSVHeadersLive(){
        this.csvHeadersLive = {
            insuranceInformations : "INFORMAÇÕES DA SEGURADORA",
            moreInformation : "INFORMAÇÕES COMPLEMENTARES",
            retired : "AFASTADOS",
            dismissedRetired : "DEMITIDOS/APOSENTADOS",
            serviceProviders : "PRESTADORES DE SERVIÇO",
            aggregated : "AGREGADOS",
            capitalAndTax: "CAPITAL E TAXA",
            capitalModel : "MODELO DE CAPITAL",
            capitalAmount : "MONTANTE DO CAPITAL",
            ratePerThousand : "TAXA POR MIL (%)",
            invoiceEstimate : "ESTIMATIVA DE FATURA",
            descriptionOfCapital : "DESCRIÇÃO DO CAPITAL",
            coverage : "COBERTURAS",
            naturalDeathPercent : "MORTE NATURAL (QUALQUER CAUSA)",
            accidentalDeathPercent : " MORTE ACIDENTAL (COBERTURA CUMULATIVA COM A MORTE NATURAL)",
            ipaTotalOrPartialDisabilityByAccPercent : "IPA - INVALIDEZ TOTAL OU PARCIAL POR ACIDENTE",
            ifpdTotalPartialDisabilityDiseasePercent : "IFPD - INVALIDEZ FUNCIONAL TOTAL OU PARCIAL POR DOENÇA",
            iacAutomaticInclusionOfSpousePercent : "IAC - INCLUSÃO AUTOMÁTICA DE CÔNJUGE",
            iafAutomaticInclusionOfChildrenPercent : "IAF - INCLUSÃO AUTOMÁTICA DE FILHOS",
            ditTemporaryDisabilityDailyPercent : "DIT - DIÁRIA DE INCAPACIDADE TEMPORÁRIA",
            dmhHospitalDoctorExpensesPercent : "DMH - DESPESAS MÉDICO HOSPITALARES",
            seriousDiseasesPercent : "DOENÇAS GRAVES",
            affFamilyFuneralAssistancePercent : "AFF - ASSISTÊNCIA FUNERAL FAMILIAR",
            afiIndividualFuneralAssistancePercent : "AFI - ASSISTÊNCIA FUNERAL INDIVIDUAL",
            funeralAidPercent : "AUXÍLIO FUNERAL",
            basketBasicPercent : "CESTA BÁSICA",
            coverageForDrunkennessPercent : "COBERTURA PARA EMBRIAGUEZ",
        };
    }

    async createCSVDataLive(){
        let insuranceInformation = "";
        if(JSON.stringify(this.quotationForm.InsuranceInformations) !== {}){
            console.log("Entrou no if" + typeof(this.quotationForm.InsuranceInformations) + JSON.stringify(this.quotationForm.InsuranceInformations));
            for(let objInsuranceInfo of this.quotationForm.InsuranceInformations){
            insuranceInformation += 'Operadora Atual - ' + objInsuranceInfo.countPosition + ' OPERADORA: ' + objInsuranceInfo.company + ' NÚMERO TOTAL DE VIDAS: ' + objInsuranceInfo.numberOfLives +
            ' VIGÊNCIA CONTRATUAL: ' + objInsuranceInfo.termOfContractStr + ' MODELO DE CONTRATAÇÃO: ' + objInsuranceInfo.hiringModel + ' / ';
            }
        }else{
            insuranceInformation = "N/T";
        }

        this.csvDataLive = [...this.csvDataLive,{
            insuranceInformations : insuranceInformation,
            moreInformation : '',
            retired : this.quotationForm.retired == null ? '' : this.quotationForm.retired,
            dismissedRetired : this.quotationForm.dismissedRetired == null ? '' : this.quotationForm.dismissedRetired,
            serviceProviders : this.quotationForm.serviceProviders == null ? '' : this.quotationForm.serviceProviders,
            aggregated : this.quotationForm.aggregated == null ? '' : this.quotationForm.aggregated,
            capitalAndTax : '',
            capitalModel : this.quotationForm.CapitalModel == null ? '' : this.quotationForm.CapitalModel,
            capitalAmount : this.quotationForm.capitalAmount == null ? '' :  "R$" + this.quotationForm.capitalAmount,
            ratePerThousand : this.quotationForm.ratePerThousand == null ? '' : this.quotationForm.ratePerThousand + '%',
            invoiceEstimate : this.quotationForm.InvoiceEstimate == null ? '' : "R$" + this.quotationForm.InvoiceEstimate,
            descriptionOfCapital : this.quotationForm.descriptionOfCapital == null ? '' : this.quotationForm.descriptionOfCapital,
            coverage : '',
            naturalDeathPercent : this.quotationForm.naturalDeathPercent == null ? '' : this.quotationForm.naturalDeathPercent + "%",
            accidentalDeathPercent : this.quotationForm.accidentalDeathPercent == null ? '' : this.quotationForm.accidentalDeathPercent + "%",
            ipaTotalOrPartialDisabilityByAccPercent : this.quotationForm.ipaTotalOrPartialDisabilityByAccPercent == null ? '' : this.quotationForm.ipaTotalOrPartialDisabilityByAccPercent + "%",
            ifpdTotalPartialDisabilityDiseasePercent : this.quotationForm.ifpdTotalPartialDisabilityDiseasePercent == null ? '' : this.quotationForm.ifpdTotalPartialDisabilityDiseasePercent + "%",
            iacAutomaticInclusionOfSpousePercent : this.quotationForm.iacAutomaticInclusionOfSpousePercent == null ? '' : this.quotationForm.iacAutomaticInclusionOfSpousePercent + "%",
            iafAutomaticInclusionOfChildrenPercent : this.quotationForm.iafAutomaticInclusionOfChildrenPercent == null ? '' : this.quotationForm.iafAutomaticInclusionOfChildrenPercent + "%",
            ditTemporaryDisabilityDailyPercent : this.quotationForm.ditTemporaryDisabilityDailyPercent == null ? '' : this.quotationForm.ditTemporaryDisabilityDailyPercent + "%",
            dmhHospitalDoctorExpensesPercent : this.quotationForm.dmhHospitalDoctorExpensesPercent == null ? '' : this.quotationForm.dmhHospitalDoctorExpensesPercent + "%",
            seriousDiseasesPercent : this.quotationForm.seriousDiseasesPercent == null ? '' : this.quotationForm.seriousDiseasesPercent + "%",
            affFamilyFuneralAssistancePercent : this.quotationForm.affFamilyFuneralAssistancePercent == null ? '' : this.quotationForm.affFamilyFuneralAssistancePercent + "%",
            afiIndividualFuneralAssistancePercent : this.quotationForm.afiIndividualFuneralAssistancePercent == null ? '' : this.quotationForm.afiIndividualFuneralAssistancePercent + "%",
            funeralAidPercent : this.quotationForm.funeralAidPercent == null ? '' : this.quotationForm.funeralAidPercent + "%",
            basketBasicPercent : this.quotationForm.basketBasicPercent == null ? '' : this.quotationForm.basketBasicPercent + "%",
            coverageForDrunkennessPercent : this.quotationForm.coverageForDrunkennessPercent == null ? '' : this.quotationForm.coverageForDrunkennessPercent + "%"
        }];
    }
}