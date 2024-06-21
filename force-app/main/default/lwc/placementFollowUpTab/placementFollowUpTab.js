import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import getCaseByOpportunityId from '@salesforce/apex/PlacementFollowUpController.getCaseByOpportunityId';
import getOpportunityById from '@salesforce/apex/PlacementFollowUpController.getOpportunityById';
import getOpportunityLineItemByOppId from '@salesforce/apex/PlacementFollowUpController.getOpportunityLineItemByOppId';
import getDocumentsFromOppByOppId from '@salesforce/apex/PlacementFollowUpController.getDocumentsFromOppByOppId';
import getDocumentsSusep382FromOppByOppId from '@salesforce/apex/PlacementFollowUpController.getDocumentsSusep382FromOppByOppId';
import getContactByAccId from '@salesforce/apex/PlacementFollowUpController.getContactByAccId';
import getQuestionaryByOppId from '@salesforce/apex/PlacementFollowUpController.getQuestionaryByOppId';
import getQuotesByOppId from '@salesforce/apex/PlacementFollowUpController.getQuotesByOppId';
import getCoinsuranceProposalsByOppId from '@salesforce/apex/PlacementFollowUpController.getCoinsuranceProposalsByOppId';
import deleteQuoteById from '@salesforce/apex/PlacementFollowUpController.deleteQuoteById';
import getQuoteById from '@salesforce/apex/PlacementFollowUpController.getQuoteById';
import updateQuotes from '@salesforce/apex/PlacementFollowUpController.updateQuotes';
import createQuoteIntegralizations from '@salesforce/apex/PlacementFollowUpController.createQuoteIntegralizations';
import getIntegralizationsByProposalId from '@salesforce/apex/PlacementFollowUpController.getIntegralizationsByProposalId';
import deleteIntegralizations from '@salesforce/apex/PlacementFollowUpController.deleteIntegralizations';
import getApprovedProposalByOppId from '@salesforce/apex/PlacementFollowUpController.getApprovedProposalByOppId';
import QUOTE_COMPANIES from '@salesforce/schema/Quote.Company__c';
import getQuoteRecordTypeId from '@salesforce/apex/PlacementFollowUpController.getQuoteRecordTypeId';
import getOrderRecordTypeId from '@salesforce/apex/PlacementFollowUpController.getOrderRecordTypeId';
import updateOpportunity from '@salesforce/apex/PlacementFollowUpController.updateOpportunity';
import getOrderByOppId from '@salesforce/apex/PlacementFollowUpController.getOrderByOppId';
import getQuoteDocumentsByQuoteId from '@salesforce/apex/PlacementFollowUpController.getQuoteDocumentsByQuoteId';
import getApoliceBoletosFromOrderByOrderId from '@salesforce/apex/PlacementFollowUpController.getApoliceBoletosFromOrderByOrderId';
import { sendDocumentForAPI } from 'c/fileUtil';
import createQuoteWithLineItems from '@salesforce/apex/PlacementFollowUpController.createQuoteWithLineItems';
import createOrderWithLineItems from '@salesforce/apex/PlacementFollowUpController.createOrderWithLineItems';


//Constantes
const COLUMNS_QUESTIONARIES = [
    { label: 'Pergunta', fieldName: 'Question_Label__c', type: 'text'},
    { label: 'Tipo', fieldName: 'Question_Type__c', type: 'text' },
    { label: 'Resposta', fieldName: 'Answer__c', type: 'text' },
    { label: 'Comentário', fieldName: 'Comment__c', type: 'text' },
];

const actions = [
    { iconName: 'utility:edit', label: 'Edit', name: 'editQuote', class: 'editQuoteButton'},
    { iconName: 'utility:delete', label: 'Delete', name: 'deleteQuote', class: 'deleteQuoteButton'}
];

const COLUMNS_QUOTES = [
    { label: 'Número da Cotação', fieldName: 'QuoteNumber', type: 'text', hideDefaultActions: true, sortable: true },
    { label: 'Seguradora', fieldName: 'Company__c', type: 'text', hideDefaultActions: true, sortable: true },
    { label: 'Data de Envio', fieldName: 'QuoteRequestDate__c', type: 'date', hideDefaultActions: true, sortable: true},
    { label: 'Prêmio', fieldName: 'PrizeAmount__c', type: 'currency', hideDefaultActions: true, editable: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Importância Segurada', fieldName: 'InsuredAmount__c', type: 'currency', hideDefaultActions: true, editable: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Status', fieldName: 'Status_Quote_Placement__c', type: 'text', hideDefaultActions: true, sortable: true,
    cellAttributes: {
        class: 'badge-cell'
    },
    typeAttributes: {
        class: 'badge-cell'
    }},
    {
        type: 'action', hideDefaultActions:true,
        typeAttributes: { 
            rowActions: actions,
            class: 'actionRowButton'
        }
    }
];

const COLUMNS_COINSURANCE_PROPOSAL = [
    {},
    { label: 'Número da Cotação', fieldName: 'QuoteNumber', type: 'text', hideDefaultActions: true, sortable: true },
    { label: 'Seguradora', fieldName: 'Company__c', type: 'text', hideDefaultActions: true, sortable: true },
    { label: 'Data de Envio', fieldName: 'QuoteRequestDate__c', type: 'date', hideDefaultActions: true, sortable: true},
    { label: 'Prêmio', fieldName: 'PrizeAmount__c', type: 'currency', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Importância Segurada', fieldName: 'InsuredAmount__c', type: 'currency', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Status', fieldName: 'Status_Quote_Placement__c', type: 'text', hideDefaultActions: true, sortable: true,
    cellAttributes: {
        class: 'badge-cell'
    },
    typeAttributes: {
        class: 'badge-cell'
    }},
    {
        type: 'action', hideDefaultActions:true,
        typeAttributes: { 
            rowActions: actions,
            class: 'actionRowButton'
        }
    }
];

const COLUMNS_COSSEGURO = [
    { label: 'Nome', fieldName: 'Name', type: 'text', hideDefaultActions: true , sortable: true},
    { label: 'Seguradora', fieldName: 'Company__c', type: 'text', hideDefaultActions: true, sortable: true },
    { label: 'Prêmio', fieldName: 'PrizeAmount__c', type: 'currency', hideDefaultActions: true, sortable: true, 
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Importância Segurada', fieldName: 'InsuredAmount__c', type: 'currency', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
];

const COLUMNS_PROPOSTA = [
    { label: 'Cotação', fieldName: 'Name', type: 'text', hideDefaultActions: true, sortable: true},
    { label: 'Prêmio', fieldName: 'PrizeAmount__c', type: 'currency', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: '% Participação', fieldName: 'Participation_Percentage__c', type: 'percent', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
    { label: 'Importância Segurada', fieldName: 'InsuredAmount__c', type: 'currency', hideDefaultActions: true, sortable: true,
    cellAttributes: { 
        alignment: 'left'
    }},
];

export default class PlacementFollowUpTab extends LightningElement {

    dataLoaded = false;

//----------URL ID's-----------//
    caseId; //Recebe id do caso
    oppId; //Recebe id da oportunidade
//--------------------------//

//--------RECORD ID's---------//
    accountId; //Recebe id da conta
//--------------------------//

//------RECORD VARIABLES------//
    @track oppRecord; //Recebe registro de oportunidade
    @track oppLineItemRecords; //Recebe registros de produtos de oportunidade
    @track oppDocuments; //Recebe registros de documentos de oportunidade
    @track oppSusep382Documents;
    @track orderApoliceBoletos = [];
    @track cttRecords; //Recebe lista de contatos da conta
    @track questionaryRecords; //Recebe registro de questionário
    @track caseRecord;
//--------------------------//

//----DATA TABLE VARIABLES----//
    @track sortedBy;
    @track sortedDirection = 'asc';
//--------------------------//

//----QUESTIONARY-------//
    columnsQuestionary = COLUMNS_QUESTIONARIES;
    rowOffset = 0;
    questionaryLoaded = false;

    //Accordion Properties
    questionaryActiveSections = ['C1'];

    @track questionnaryId;
//--------------------------//

//----------------------QUOTE--------------------------//
    //TABELA COTAÇÕES
    columnsQuote = COLUMNS_QUOTES;
    @track quoteList = []; //Recebe lista de cotações parciais e propostas que não são de cosseguro.
    @track draftValues = []; //Lista de atualizações em células da tabela.
    loadedQuoteTables = false; //Variável que controla a exibição das tabelas na página de cotação.


    //TABELA COTAÇÕES DE SEGURADORA LIDER E COPARTICIPANTE EM MODAL DE NOVA PROPOSTA
    columnsCosseguro =  COLUMNS_COSSEGURO;
    @track cosseguroList = []; //Recebe lista de cotações parciais.
    selectedRowsLider = []; //Recebe lista de linhas selecionadas na tabela de cotações lider.
    selectedRowsCoparticipantes = []; //Recebe lista de linhas selecionadas na tabela de cotações coparticipantes.

    preSelectedRowsLider = []; //Recebe lista de pre-seleção de linhas na tabela de cotação lider.
    preSelectedRowsCopart = []; //Recebe lista de pre-seleção de linhas na tabela de cotações copartcicipantes.
    
    //TABELA DE PROPOSTA DINÂMICA COM AS LINHAS SELECIONADAS NAS TABELAS DE COTAÇÕES DE SEGURADORA LIDER E COPARTICIPANTES
    columnsProposta = COLUMNS_PROPOSTA;
    @track proposalList = []; //Recebe as linhas selecionadas nas duas tabelas de cotações lider e coparticipantes.
    
    //TABELA DE PROPOSTAS DE COSSEGURO
    columnsCoinsuranceProposal = COLUMNS_COINSURANCE_PROPOSAL;
    @track coinsuranceProposalsList = []; //Recebe lista com todas as propostas integrais de cosseguro.
//-----------------------------------------------------//

//------------OPPORTUNITY FIELDS----------------//
    insuredAmount;
    estimatedPrize;
    estimatedCommission;
    requestDate;
    closingDate;
    opportunityStatus;
    commercialName;
    thisOppIsAnAppointment;
    probabilityOfClosingDeal;
    opportunityDescription;
//---------------------------------------------//

//---------CONTACTS--------------//
    @track listContacts = []; //Recebe lista de contatos com os dados tratados para exibição na página.

    //Accordion Properties
    activeContactSections = ['C1']; //Define qual accordion que virá aberto inicialmente

//------------------------------//

//-----------------------NEW QUOTE MODAL PROPERTIES-------------------//
    @track showQuoteModal = false;

    //Modal Input Fields
    @track quoteNumber;

    @track integralizationInput; //	Integralization__c
    @track quoteKitInput; //Quote_Kit__c
    @track selectedInsurerInput; // Company__c
    @track sendDateInput; // QuoteRequestDate__c
    @track receiptDateInput; //	QuoteReceiptDate__c
    @track prizeAmountInput; //	PrizeAmount__c
    @track insuredAmountInput; // InsuredAmount__c
    @track viewValueDetailInput;
    @track netValueInput; //Net_Prize_Value__c
    @track iofValueInput; //IOF_Prize_Value__c
    @track comissionPercentageInput; //PercentCommission__c
    @track agencyPercentageInput;//	Agency_Percentage__c
    @track commentsInput; //Description

    @track quoteId;

    //MODAL VALIDATION REQUIRED FIELDS VARIABLES
    @track requiredFieldErrorInsurer = false;
    @track requiredFieldErrorSendDate = false;
    @track requiredFieldErrorPrizeAmount = false;
    @track requiredFieldErrorInsuredAmount = false;

    //Modal Insurer Values In Quote Creation
    insurerValues = [];

    //QUOTE FILES 
    @track quoteFiles = [];
    quoteEdit = false;
//--------------------------------------------------------------//


//----------DELETE QUOTE MODAL CONFIRMATION PROPERTIES------------//
    @track showConfirmDelete = false; //Controla a exibição do modal de confirmação de exclusão de uma cotação
//--------------------------------------------------------------//


//--------------NEW PROPOSAL MODAL PROPERTIES------------//
    @track showNewProposalModal = false; //Controla a exibição do modal de construção de proposta de cosseguro
    showNewProposalModalLoaded = true;
//-------------------------------------------------------//    


//-----------------MODAL EVENT VARIABLES----------------//
    selectedRecordId; //Id do registro selecionado para edição ou exclusão
    loadedQuoteModal = true; //Variável que controla se o modal de edição de cotação será exibido ou não
    loadedProposalModal = true; //Variável que controla se o modal de edição de proposta será exibido ou não
//-----------------------------------------------------//


//--------------FILES VARIABLES-----------------//
    @track estudoDeMercadoFooterButtons = false; //Controla a exibição dos botões do componente de arquivos na parte de estudo de mercado da aba de cotações
    oppSession = true; //Controla se o componente de arquivos está sendo utilizado nos dados da oportunidade ou não
    emissionSession = true;
    emissionSessionBoletos = true;

    selectedFiles = []; //Lista para receber os arquivos selecionados


    //TESTE UPLOAD FILES
    selectedFilesToUpload = [];
    filesList = [];
    loadingFilesOpp = false;

    quoteDocumentsToSave = [];
    orderDocumentsToSave = [];

    orderApoliceToSave = [];
    orderBoletosToSave = [];

    tipoDocumento;
    isOpportunityOFCorporate;
//-----------------------------------------------//

//------------------ROW SELECT VARIABLES----------------//
    listIndexesLiderSelected = [];
    listIndexesCopartSelected = [];


    liderIndexesSelected = [];
    copartIndexesSelected = [];

//------------------------------------------------------//

//------------------EMISSION TAB VARIABLES-----------------//

    approvedProposal = false;
    @track approvedProposalRecord;
    @track approvedProposalPrizeAmount;
    policyNumberInput;
    policyNumber;
    @track requiredFieldErrorPolicyNumber;

    loadingEmissionPage = false;

    blockedInput = false;

    newOrderActiveButton;

    @track orderRecord;

    showDropZone = true;
    showDropZoneEmission = false;

    fileItemEmissionClass =  'file-item-emission';

    hasApolicesAndBoletos = false;
//------------------------------------------//

//--------------------RECORD-TYPE-IDs-------------------//
    @track quoteRecordTypeId;
    @track orderRecordTypeId;
//----------------------------------------------------//

//-----------------------HISTORY-VARIABLES---------------//
    historyClass;
//-----------------------------------------------//

//-----------------------PATH-VARIABLES---------------//
    pathLoaded = true;
//----------------------------------------------------//

//---------------WIRE METHODS------------//
    @wire(getQuoteRecordTypeId, {recordTypeName : 'Corporate'})
    wiredQuoteRecordTypeId({error, data}) {
        if(data) {
            this.quoteRecordTypeId = data;
        } else if (error) {
            console.error('Error retrieving record type id: ', error);
        }
    }

    @wire(getOrderRecordTypeId, {recordTypeName : 'CorporateApolice'})
    wiredOrderRecordTypeId({error, data}) {
        if(data) {
            this.orderRecordTypeId = data;
        } else if (error) {
            console.error('Error retrieving record type id: ', error);
        }
    }


    @wire(getPicklistValues, { recordTypeId: '$quoteRecordTypeId', fieldApiName: QUOTE_COMPANIES})
    wiredPicklistValues({ error, data }) {

        if (data) {

            let insurerData = data.values.map(picklistValue => picklistValue.label);

            this.insurerValues = insurerData.map(insurer => {
                return {label: insurer, value: insurer};
            });

        } else if (error) {
            console.error('Error retrieving picklist insurer values: ', error);
        }
    }
//--------------------------------------//

    //INIT
    async connectedCallback() {
        const currentURL = window.location.href;
        const urlParams = new URLSearchParams(new URL(currentURL).search);

        this.caseId = urlParams.get('caseId');
        this.oppId = urlParams.get('opportunityId');

        await this.loadCase();
        await this.loadOpportunity();
        await this.loadOpportunityLineItems();
        await this.loadOpportunityDocuments();
        await this.loadContacts();
        await this.loadQuestionaries();
        await this.loadQuotes();
        await this.loadCoinsuranceProposals();

        this.dataLoaded = true;
    }

    //CATCH SOME DATA 
    async loadCase() {
        try {
            const data = await getCaseByOpportunityId({ recordId: this.oppId });
            if (data) {
                this.caseRecord = data;
            }
        } catch (error) {
            console.error('Erro ao obter registro de caso: ', error);
        }
    }

    async loadOpportunity() {
        try {
            const data = await getOpportunityById({ recordId: this.oppId });
            if (data) {
                this.oppRecord = data;
                this.accountId = data.AccountId;

                if((this.oppRecord.StageName == 'Em Emissão' || this.oppRecord.StageName == 'Fechado e ganho')) {
                    await this.loadApprovedProposal();
                    await this.loadOpportunityDocumentsSusep382();

                    if(this.oppSusep382Documents.length > 0) {

                        if(this.oppRecord.StageName == 'Em Emissão'){
                            this.newOrderActiveButton = true;
                            this.showDropZoneEmission = true;
                            this.fileItemEmissionClass = 'file-item-emission';
                            this.hasApolicesAndBoletos = false;
                        } else {
                            await this.loadOrder();
                        }
                        this.approvedProposal = true;
                    }
                } else {
                    this.approvedProposal = false;
                }

                this.handleActive({ target: { value: 'Opportunity' } });
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registro de oportunidade',
                variant: 'error',
            }));

            console.error('Erro ao obter registro de oportunidade: ', error);
        }
    }

    async loadOpportunityLineItems() {
        try {
            const data = await getOpportunityLineItemByOppId ({ recordId: this.oppId });
            if(data) {
                this.oppLineItemRecords = data;
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registro de itens de oportunidade',
                variant: 'error',
            }));

            console.error('Erro ao obter registro de itens de oportunidade: ', error);
        }
    }

    async loadOpportunityDocuments() {
        try {
            const data = await getDocumentsFromOppByOppId ({ recordId: this.oppId });
            if (data) {
                this.oppDocuments = data;
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter documentos de oportunidade',
                variant: 'error',
            }));

            console.error('Erro ao obter documentos de oportunidade: ', error);
        }
    }

    async loadOpportunityDocumentsSusep382() {
        try {
            const data = await getDocumentsSusep382FromOppByOppId ({ recordId: this.oppId });
            if(data) {
                this.oppSusep382Documents = data;
            }
        } catch(error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter resolução susesp 382 de oportunidade',
                variant: 'error',
            }));

            console.error('Erro ao obter resolução susep 382 de oportunidade: ', error);
        }
    }

    async loadContacts() {
        try {
            const data = await getContactByAccId({ recordId: this.accountId });
            if (data) {
                this.cttRecords = data;

                 for (let rec in this.cttRecords) {
                    this.listContacts.push({Id: this.cttRecords[rec].Id, Name: this.cttRecords[rec].Name, AccountId: this.cttRecords[rec].AccountId, Phone: this.cttRecords[rec].Phone, MobilePhone: this.cttRecords[rec].MobilePhone, Email: this.cttRecords[rec].Email, Birthdate: this.cttRecords[rec].Birthdate, Department: this.cttRecords[rec].Department, TeamYouCheerFor__c: this.cttRecords[rec].TeamYouCheerFor__c, Label: `Contato ${parseInt(rec) + 1} | ${this.cttRecords[rec].Name}`})
                }
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registros de contato',
                variant: 'error',
            }));

            console.error('Erro ao obter registros de contato: ', error);
        }
    }

    async loadQuestionaries() {
        try{
            const data = await getQuestionaryByOppId( {recordId: this.oppId});
            if (data) {
                this.questionaryRecords = data;
                this.questionaryLoaded = true;
                this.questionnaryId = data[0].Id;
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registro de questionário',
                variant: 'error',
            }));

            console.error('Erro ao obter registros de questionário: ', error);
        }
    }

    async loadQuotes() {
        try {
            const data = await getQuotesByOppId( {recordId: this.oppId} );
            if (data) {
                this.quoteList = data;
                console.log(this.quoteList);

                this.cosseguroList = [];

                for(let i in this.quoteList) {
                    if(this.quoteList[i].Integralization__c == true) {
                        this.cosseguroList.push(this.quoteList[i]);
                    }
                }
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registros de cotação',
                variant: 'error',
            }));

            console.error('Erro ao obter registros de cotação: ', error)
        }
    }

    async loadCoinsuranceProposals () {
        try {
            const data = await getCoinsuranceProposalsByOppId( {recordId: this.oppId} );
            if (data) {
                this.coinsuranceProposalsList = data;
                this.loadedQuoteTables = true;
            }
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter propostas de cosseguro',
                variant: 'error',
            }));

            console.error('Erro ao obter propostas de cosseguro: ', error)
        }
    }

    async loadApprovedProposal () {
        try{
            const data = await getApprovedProposalByOppId( {recordId: this.oppId} );
            if(data) {
                this.approvedProposalRecord = data;
      
                this.approvedProposalPrizeAmount = this.approvedProposalRecord.PrizeAmount__c.toLocaleString('pt-BR', {
                    style: 'currency',
                    currency: 'BRL',
                    minimumFractionDigits: 2
                });
            }
        }  catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter proposta aprovada',
                variant: 'error',
            }));
            
            console.error('Erro ao obter proposta aprovada: ', error)
        }
    }

    async loadOrder() {
        try {
            const data = await getOrderByOppId({ recordId: this.oppId});
            if(data) {
                this.orderRecord = data;
                this.policyNumber = data.PoNumber;
                this.blockedInput = true;
                this.newOrderActiveButton = false;
                this.showDropZoneEmission = false;
                this.fileItemEmissionClass = 'file-item-emission-without-margin-bottom';

                await this.loadOrderApoliceBoletosDocuments(data.Id);
                this.hasApolicesAndBoletos = true;
            } else {
                this.hasApolicesAndBoletos = false; //
            }
        } catch(error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter pedido',
                variant: 'error',
            }));

            console.error('Erro ao obter pedido: ', error);
        }
    }

    async loadOrderApoliceBoletosDocuments(orderId) {
        try {
            const data = await getApoliceBoletosFromOrderByOrderId ({ recordId: orderId });
            if(data) {
                this.orderApoliceBoletos = data;
            }
        } catch(error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter documentos de apólice e boletos',
                variant: 'error',
            }));

            console.error('Erro ao obter documentos de apólice e boletos: ', error);
        }
    }

    //HANDLE DATA INIT FOLLOW UP PAGE
    handleActive(event) {
        const tab = event.target;
        const tabValue = tab.value;

        this.dispatchEvent(new CustomEvent('tabactive', { detail: tabValue }));

        if (tab.value === "Opportunity" && this.oppRecord){

            this.historyClass = 'historyCustomClass_global';

            if(this.oppRecord.InsuredAmount__c != null){
                this.insuredAmount = this.oppRecord.InsuredAmount__c.toLocaleString('pt-BR', {
                    style: 'currency',
                    currency: 'BRL',
                    minimumFractionDigits: 2
                });
            } else {
                this.insuredAmount = 'Não Informado';
            }


            if(this.oppRecord.Amount != null){
                this.estimatedPrize = this.oppRecord.Amount.toLocaleString('pt-BR', {
                    style: 'currency',
                    currency: 'BRL',
                    minimumFractionDigits: 2
                });

            } else {
                this.estimatedPrize = 'Não Informado';
            }


            if (this.oppRecord.CloseDate != null){

                let dateString = this.oppRecord.CloseDate;

                let date = new Date(dateString);

                let formattedCloseDate = `${('0' + date.getDate()).slice(-2)}/${('0' + (date.getMonth() + 1)).slice(-2)}/${date.getFullYear()}`;

                this.closingDate = formattedCloseDate;
            } else {
                this.closingDate = 'Não Informado';
            }


            if(this.oppRecord.StageName != null){
                this.opportunityStatus = this.oppRecord.StageName;
            } else {
                this.opportunityStatus = 'Não Informado';
            }


            if (this.oppRecord.IsOpportunityNomination__c != null){

                if(this.oppRecord.IsOpportunityNomination__c == true) {
                    this.thisOppIsAnAppointment = 'Sim';
                }
                else {
                    this.thisOppIsAnAppointment = 'Não';
                }

            } else {
                this.thisOppIsAnAppointment = 'Não Informado';
            }


            if(this.oppRecord.Description!= null){
                this.opportunityDescription = this.oppRecord.Description;
            } else {
                this.opportunityDescription = 'Não Informado';
            }


            if (this.oppRecord.ProbabilityOfWinning__c != null){
                this.probabilityOfClosingDeal = this.oppRecord.ProbabilityOfWinning__c;
            } else {
                this.probabilityOfClosingDeal = 'Não Informado';
            }

            if(this.oppRecord.CreatedDate != null) {

                let dateString = this.oppRecord.CreatedDate;

                let date = new Date(dateString);

                let formattedCreatedDate = `${('0' + date.getDate()).slice(-2)}/${('0' + (date.getMonth() + 1)).slice(-2)}/${date.getFullYear()}`;

                this.requestDate = formattedCreatedDate;
            } else {
                this.requestDate = 'Não Informado';
            }


            if(this.oppRecord.OpportunityOwner__c != null) {
                this.commercialName = this.oppRecord.OpportunityOwner__c;
            } else {
                this.commercialName = 'Não Informado';
            }

            this.estimatedCommission = 'R$ 100.000,00';
            
        } else if(tab.value === "Contact") {
            this.historyClass = 'historyCustomClass_global';

        } else if(tab.value === "Questionary") {
            this.historyClass = 'historyCustomClass_global';

        } else if(tab.value === "Quote") {
            this.historyClass = 'historyCustomClass_quotePage';

        } else if(tab.value === "Emission") {
            this.historyClass = 'historyCustomClass_global';
        }
    }

    //MODAL METHODS - CREATE PROPOSAL
    openProposalModal() {
        this.quoteEdit = false;
        this.quoteId = null;
        let selectedRowsLiderIndexes = [];
        let selectedRowsCoparticipantesIndexes = [];

        if(this.selectedRowsLider.length > 0){

            this.selectedRowsLider.forEach(row => {
                let quoteRec = this.cosseguroList.find(quote => quote.Id === row.Id);
                if (quoteRec) {
                    const quoteRecIndex = this.cosseguroList.indexOf(quoteRec);
                    selectedRowsLiderIndexes.push('row-' + quoteRecIndex);
                }
            })

        }

        if(this.selectedRowsCoparticipantes.length > 0 ) {

            this.selectedRowsCoparticipantes.forEach(row => {
                let quoteRec = this.cosseguroList.find(quote => quote.Id === row.Id);
                if (quoteRec) {
                    const quoteRecIndex = this.cosseguroList.indexOf(quoteRec);
                    selectedRowsCoparticipantesIndexes.push('row-' + quoteRecIndex);
                }
            })

        }

        // Restaurar seleções para a tabela líder
        if (selectedRowsLiderIndexes) {
            this.preSelectedRowsLider = selectedRowsLiderIndexes;
        }

        // Restaurar seleções para a tabela de coparticipantes
        if (selectedRowsCoparticipantesIndexes) {
            this.preSelectedRowsCopart= selectedRowsCoparticipantesIndexes;
        }
        

        this.showNewProposalModal = true;
    }

    closeProposalModal() {
        this.showNewProposalModal = false;
        if(this.quoteId != null) {
            this.proposalList = [];
            this.selectedRowsLider = [];
            this.selectedRowsCoparticipantes = [];
            this.quoteNumber = null;
        }
    }
//------------------MODAL METHODS - CREATE QUOTE-------------------//

    openModal() {
        this.quoteId = null;
        this.showQuoteModal = true;
        this.quoteEdit = false;
    }

    closeModal() {
        this.showQuoteModal = false;
        this.requiredFieldError = false;
        if(this.quoteId != null) {
            this.clearInputs();
        }
    }

    deleteDataModal() {
        this.showQuoteModal = false;
        this.clearInputs();
        //this.clearFiles();
        this.requiredFieldError = false;
    }

    validateInputs() {
        const fields = [
            {input: this.selectedInsurerInput, errorField: 'requiredFieldErrorInsurer'},
            {input: this.sendDateInput, errorField: 'requiredFieldErrorSendDate'},
            {input: this.prizeAmountInput, errorField: 'requiredFieldErrorPrizeAmount'},
            {input: this.insuredAmountInput, errorField: 'requiredFieldErrorInsuredAmount'}
        ];
    
        // Define se todos os campos são válidos
        let allValid = true;
    
        fields.forEach(field => {
            if (!field.input) {
                this[field.errorField] = true;
                allValid = false;
            } else {
                this[field.errorField] = false;
            }
        });
    
        return allValid;
    }

    async saveDataModal() {
        if (!this.validateInputs()) {
            return; // Se algum campo estiver inválido, interrompe a execução
        }
    
        this.loadedQuoteTables = false;
        this.showQuoteModal = false;
    
        try {
            let quoteRecord = {
                Name : 'Cotação | ' + this.selectedInsurerInput,
                Status : 'Draft',
                OpportunityId: this.oppId,
                Id: this.quoteId,
                Integralization__c: this.integralizationInput,
                Quote_Kit__c: this.quoteKitInput,
                Company__c: this.selectedInsurerInput, 
                QuoteRequestDate__c: this.sendDateInput,
                QuoteReceiptDate__c: this.receiptDateInput, 
                PrizeAmount__c: this.prizeAmountInput,
                InsuredAmount__c: this.insuredAmountInput,
                Net_Prize_Value__c: this.netValueInput,
                IOF_Prize_Value__c: this.iofValueInput,
                PercentCommission__c: this.comissionPercentageInput,
                Agency_Percentage__c: this.agencyPercentageInput,
                Description: this.commentsInput
            };

            let quoteLineItems = [];

            this.oppLineItemRecords.forEach(record => {
                let quoteLineItem = {
                    Product2Id : record.Product2Id,
                    PricebookEntryId : record.PricebookEntryId,
                    UnitPrice : record.UnitPrice, 
                    Quantity : record.Quantity,
                    NumberOfLifes__c : record.NumberOfLifes__c,
                    CommissionPercent__c : this.comissionPercentageInput,
                    AgencyPercentage__c : this.agencyPercentageInput,
                    IOFPrizeValue__c : this.iofValueInput,
                    PrizeNetValue__c : this.netValueInput
                } 
                quoteLineItems.push(quoteLineItem);
            })

            const result = await createQuoteWithLineItems({quoteInfo: quoteRecord, lineItems: quoteLineItems});
    
            if (this.quoteId == null) {
                this.caseRecord[0].Status = 'Aguardando cotação';
                await this.handleNewQuote(result);
                console.log('COTAÇÃO CRIADA: ' + result);
            } else {
                await this.updateQuote(result);
                console.log('COTAÇÃO ATUALIZADA: ' + result);
            }
    
            this.clearInputs();
        } catch (error) {
            this.handleError(error);
        }
    }
    
    async handleNewQuote(result) {
        await this.loadQuotes();
        this.loadedQuoteTables = true;
    
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Registro criado com sucesso!',
            variant: 'success',
        }));
    
        if(this.quoteDocumentsToSave.length > 0) {
            this.processAllFiles(this.quoteDocumentsToSave, result);
        }
    }
    
    async updateQuote(result) {
        await this.loadQuotes();
        this.loadedQuoteTables = true;
    
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Registro atualizado com sucesso!',
            variant: 'success',
        }));
    
        if(this.quoteDocumentsToSave.length > 0) {
            this.processAllFiles(this.quoteDocumentsToSave, result);
        }
    }

    handleError(error) {
        this.loadedQuoteTables = true;
        console.error('ERR: ', error);
        let errorMessage = error.body.message;
        let errorMessageFormatted = errorMessage.replace(/\"/g, '').replace(/message:/g, '').replace(/:/g, '').replace(/{|}/g, '').replace(/\[|\]/g, '');
    
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: `Falha ao ${this.quoteId == null ? 'inserir' : 'atualizar'} registro: ${errorMessageFormatted}`,
            variant: 'error',
        }));
    
        this.clearInputs();
    }
    

    async handleEditModal(event) {
        let quoteRec;
        this.showQuoteModal = true;
        this.loadedQuoteModal = false;
        this.selectedRecordId = event.detail.recordId;

        try {
            const data = await getQuoteById( {recordId: this.selectedRecordId} );
            if (data) {
                quoteRec = data;

                this.integralizationInput = quoteRec.Integralization__c;
                this.quoteKitInput = quoteRec.Quote_Kit__c;
                this.selectedInsurerInput = quoteRec.Company__c;
                this.sendDateInput = quoteRec.QuoteRequestDate__c;
                this.receiptDateInput = quoteRec.QuoteReceiptDate__c;
                this.prizeAmountInput = quoteRec.PrizeAmount__c;
                this.insuredAmountInput = quoteRec.InsuredAmount__c;
                this.netValueInput = quoteRec.Net_Prize_Value__c;
                this.iofValueInput = quoteRec.IOF_Prize_Value__c;
                this.comissionPercentageInput = quoteRec.PercentCommission__c;
                this.agencyPercentageInput = quoteRec.Agency_Percentage__c;
                this.commentsInput = quoteRec.Description;
                this.quoteId = quoteRec.Id;
                this.quoteNumber = ' - ' + quoteRec.QuoteNumber;
            }

            const documents = await getQuoteDocumentsByQuoteId( {recordId: this.selectedRecordId} );
            if (documents){
                this.quoteFiles = documents;
            }
            if(this.quoteFiles.length > 0){
                this.quoteEdit = true;
            } else {
                this.quoteEdit = false;
            }

            this.loadedQuoteModal = true;
        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registro de cotação',
                variant: 'error',
            }));
            
            console.error('Erro ao obter registro de cotação: ', error)
        }
    
    }

    
    handleDeleteModal(event) {
        this.selectedRecordId = event.detail.recordId;
        this.showConfirmDelete = true;
    }

    //HANDLE POLICY NUMBER FIELD CHANGE IN EMISSION TAB
    handlePolicyNumberChange(event) {
        this.policyNumberInput = event.target.value;
    } 

    //HANDLE OPP FIELDS CHANGE 
    handleIntegralizationChange(event) {
        this.integralizationInput = event.target.checked;
    }

    handleQuoteKitChange (event) {
        this.quoteKitInput = event.target.checked;
    }

    handleInsurerChange (event) {
        this.selectedInsurerInput = event.target.value;
        this.validateInsurerInput();
    }

    handleSendDateChange (event) {
        this.sendDateInput = event.target.value;
        this.validateSendDateInput();
    }

    handleReceiptDateChange(event) {
        this.receiptDateInput = event.target.value;
    }

    handlePrizeAmountChange(event) {
        this.prizeAmountInput = event.target.value;
        this.validatePrizeAmountInput();
    }
    
    handleInsuredAmountChange (event){
        this.insuredAmountInput = event.target.value;
        this.validateInsuredAmountInput();
    }

    handleViewValueDetailChange(event) {
        this.viewValueDetailInput = event.target.checked;
    }

    handleNetValueChange(event){
        this.netValueInput = event.target.value;
    }

    handleIofValueChange(event) {
        this.iofValueInput = event.target.value;
    }

    handleComissionPercentChange(event) {
        this.comissionPercentageInput = event.target.value;
    }

    handleAgencyPercentageChange(event) {
        this.agencyPercentageInput = event.target.value;
    }

    handleCommentsInputChange(event) {
        this.commentsInput = event.target.value;
        this.validatePolicyNumberInput();
        this.validateValuePolicyNumberInput();
    }

    //LIMPA OS INPUTS DO MODAL
    clearInputs() {
        this.quoteId = null;
        this.quoteNumber = null;
        this.integralizationInput = false;
        this.quoteKitInput = false;
        this.selectedInsurerInput = '';
        this.sendDateInput = '';
        this.receiptDateInput = '';
        this.prizeAmountInput = '';
        this.insuredAmountInput = '';
        this.viewValueDetailInput = false;
        this.netValueInput = '';
        this.iofValueInput = '';
        this.comissionPercentageInput = '';
        this.agencyPercentageInput = '';
        this.commentsInput = '';
    }

    //Validation Methods
    validateInsurerInput() {
        if (!this.selectedInsurerInput) {
            this.requiredFieldErrorInsurer = true;
        } else {
            this.requiredFieldErrorInsurer = false;
        }
    }

    validateSendDateInput() {
        if (!this.sendDateInput) {
            this.requiredFieldErrorSendDate = true;
        } else {
            this.requiredFieldErrorSendDate = false;
        }
    }

    validatePrizeAmountInput(){
        if (!this.prizeAmountInput) {
            this.requiredFieldErrorPrizeAmount = true;
        } else {
            this.requiredFieldErrorPrizeAmount = false;
        }
    }

    validateInsuredAmountInput() {
        if (!this.insuredAmountInput) {
            this.requiredFieldErrorInsuredAmount = true;
        } else {
            this.requiredFieldErrorInsuredAmount = false;
        }
    }

    //VALIDATION POLICY NUMBER FIELD IN EMISSION TAB
    validatePolicyNumberInput() {
        if(!this.policyNumberInput) {
            this.requiredFieldErrorPolicyNumber = true;
        } else {
            this.requiredFieldErrorPolicyNumber = false;
        }
    } 

//-----------------------------------------------------------------------//

//--------------------MODAL METHODS - CONFIRM DELETE QUOTE---------------------//
    async confirmDeleteQuote () {

        this.showConfirmDelete = false;
        this.loadedQuoteTables = false;

        try {
            const data = await deleteQuoteById( {quoteId: this.selectedRecordId} );

            await this.loadQuotes();
            await this.loadCoinsuranceProposals();

            this.loadedQuoteTables = true;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Registro deletado com sucesso!',
                    variant: 'success',
                })
            );

            this.proposalList=[];
         
        } catch (error) {
            this.loadedQuoteTables = true;
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Falha ao deletar registro!',
                    variant: 'error',
                })
            );

        }

    }

    cancelDeleteQuote() {
        this.showConfirmDelete = false;
    }

//--------------------------------------------------------------//


//-------------HANDLE SELECTED FILES FROM CHILD COMPONENT-------------------//
    async handleSelectedFiles(event) {
        const files = event.detail.files;
        const objectToSave = event.detail.objectToSave;
        this.selectedFiles = files;
        this.isOpportunityOFCorporate = true;

        let recordId;

        if(objectToSave == 'OpportunityOutros' || objectToSave == 'OpportunityEstudoDeMercado') {

            if(objectToSave == 'OpportunityOutros') {
                this.tipoDocumento = 'Outros';
            } else {
                this.tipoDocumento = 'Estudo de Mercado';
            }

            recordId = this.oppId;
            this.loadingFilesOpp = true;
            this.processAllFiles(files, recordId); //Vai recebe o tipo de documento como parâmetro
        }

        if(objectToSave == 'Quote') {
            this.tipoDocumento = 'Proposta de Seguro';
            this.quoteDocumentsToSave = files;
        }

        if(objectToSave == 'OrderApolice') {
            this.orderApoliceToSave = files;
        }

        if(objectToSave == 'OrderBoleto') {
            this.orderBoletosToSave = files;
        }
    }

    sendDocumentForAPI(files, recordId){
        sendDocumentForAPI(files, recordId, this)
        .then(async data => {
            try{
                this.filesList = JSON.parse(JSON.stringify(this.filesList));
                let arquivo = await this.renderFile(data);
            }catch(error){
                console.error('Erro ao exibir arquivo: ', error);
                showToast('Erro', 'Erro para exibir arquivo.', 'error', this);
                return false;
            }
        })
        .catch(error => {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao criar arquivo: ' + error,
                variant: 'error',
            }));

            return false;
        })
        .finally(() => {
            this.loadingFilesOpp = false;
        })
    }

    processAllFiles(files, recordId) {
        let fileBuffer = [];
        Array.prototype.push.apply(fileBuffer, files);
        console.log('esse cara aqui é o arquivo: ',files);
        fileBuffer.forEach(item => {
            let file = item;
            this.selectedFilesToUpload.push(file);
        });
        this.sendDocumentForAPI(files, recordId); //Vai recebe o tipo de documento como parâmetro

    };

    createFile(data){
        let fields = data.fields;
        let file = {
            id: data.id,
            type: fields.DocumentType__r.displayValue, //Atribuí tipo de documento
            name: fields.Name.value,
            status: fields.Status__c.value,
            url: fields.ExternalUrl__c.value,
            hasPreview: false,
            dataCriacao: fields.CreatedDate.displayValue,
            isIntegrated: true
        }
        return file;
    }

    async renderFile(data){
        let arquivo = this.createFile(data); //Vai recebe o tipo de documento como parâmetro
        this.pushFileForList(arquivo);
        return arquivo;
    }

    pushFileForList(arquivo){
        this.filesList = JSON.parse(JSON.stringify(this.filesList));
        this.filesList.push(arquivo);
   }

//-----------------------------------------------------------------------//
//-----------------HANDLE PREVIEW FILE IN QUOTES------------------------//
    handlePreviewFile(event) {
        const fileId = event.target.dataset.fileid;

        let file;

        if (this.quoteFiles.length > 0) {
            file = this.quoteFiles.find(file => file.Id === fileId);
        }

        if(file) {
            if(file.ExternalUrl__c != null){
                this.downloadAndViewFile(file.ExternalUrl__c);
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: `Esse arquivo não possui referência no blob.`,
                        variant: 'error',
                    })
                );
            }
        }
    }

    async downloadAndViewFile(downloadURL) {

        const type = downloadURL.split('.').pop();

        if(type === 'pdf'){
            try {
                let blob = new Blob([await fetch(downloadURL).then(response => response.blob())],{type: 'application/pdf'});
                let url = URL.createObjectURL(blob)
                window.open(url, '_blank');
    
            } catch(error) {

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro ao baixar arquivo: ' + error,
                    variant: 'error',
                }));

                console.error('Erro ao baixar arquivo:', error);
            }
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `Esse arquivo não possui a visualização habilitada, realize o download para acessá-lo.`,
                    variant: 'error',
                })
            ); 
        }

    }


//----------------------SORT DATA TABLE METHODS--------------------------//
    /*
    handleSort (event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        this.data = this.sortData(fieldName, sortDirection);
    }

    sortData(fieldName, sortDirection) {
        var data = JSON.parse(JSON.stringify(this.cosseguroList));
        var key = (a) => {
            if (typeof a[fieldName] === 'string') {
                return a[fieldName].toLowerCase();
            } else if (typeof a[fieldName] === 'number') {
                return a[fieldName];
            } else if (typeof a[fieldName] === 'object' && a[fieldName] !== null && a[fieldName].value) {
                // Se o campo for um objeto com uma propriedade 'value' (como campos de moeda no LWC)
                return a[fieldName].value;
            } else {
                return 0; // Valor padrão para outros tipos de dados
            }
        };
        var reverse = sortDirection === 'asc' ? 1 : -1;
        data.sort((a, b) => {
            let valueA = key(a);
            let valueB = key(b);
            if (typeof valueA === 'string') {
                valueA = valueA.toLowerCase();
            }
            if (typeof valueB === 'string') {
                valueB = valueB.toLowerCase();
            }
            return reverse * ((valueA > valueB) - (valueB > valueA));
        });
    
        this.cosseguroList = data;
    }
    */

//---------------------------------------------------------------//


//--------------PROPOSAL BUILDER METHODS---------------------//

    handleRowSelectionLider(event) {
        this.liderIndexesSelected = [];
        this.listIndexesLiderSelected = [];
        this.preSelectedRowsCopart = [];

        this.selectedRowsLider = event.detail.selectedRows;

        this.selectedRowsLider.forEach(row => {
            let cosseguroListRec = this.cosseguroList.find(rec => rec.Id === row.Id);
            let cosseguroListRecIndex = this.cosseguroList.indexOf(cosseguroListRec);

            this.liderIndexesSelected.push(cosseguroListRecIndex);
            this.listIndexesLiderSelected.push('row-' + cosseguroListRecIndex);
        })

        this.listIndexesCopartSelected = this.listIndexesCopartSelected.filter(itemCopart => !this.listIndexesLiderSelected.includes(itemCopart));
        this.copartIndexesSelected = this.copartIndexesSelected.filter(itemCopart => !this.liderIndexesSelected.includes(itemCopart));

        this.preSelectedRowsCopart = this.listIndexesCopartSelected;

        this.selectedRowsLider = [];
        this.liderIndexesSelected.forEach(index => {
            this.selectedRowsLider.push(this.cosseguroList[index]);
        })

        this.selectedRowsCoparticipantes = [];
        this.copartIndexesSelected.forEach(index => {
            this.selectedRowsCoparticipantes.push(this.cosseguroList[index]);
        });

        this.updateProposalList();
    }

    handleRowSelectionCoparticipantes(event) {
        this.copartIndexesSelected = [];
        this.listIndexesCopartSelected = [];
        this.preSelectedRowsLider = [];

        this.selectedRowsCoparticipantes = event.detail.selectedRows;

        this.selectedRowsCoparticipantes.forEach(row => {
            let cosseguroListRec = this.cosseguroList.find(rec => rec.Id === row.Id);
            let cosseguroListRecIndex = this.cosseguroList.indexOf(cosseguroListRec);

            this.copartIndexesSelected.push(cosseguroListRecIndex);
            this.listIndexesCopartSelected.push('row-' + cosseguroListRecIndex);
        })

        this.listIndexesLiderSelected = this.listIndexesLiderSelected.filter(itemLider => !this.listIndexesCopartSelected.includes(itemLider));
        this.liderIndexesSelected = this.liderIndexesSelected.filter(itemLider => !this.copartIndexesSelected.includes(itemLider));

        this.preSelectedRowsLider = this.listIndexesLiderSelected;

        this.selectedRowsCoparticipantes = [];
        this.copartIndexesSelected.forEach(index => {
            this.selectedRowsCoparticipantes.push(this.cosseguroList[index]);
        });

        this.selectedRowsLider = [];
        this.liderIndexesSelected.forEach(index => {
            this.selectedRowsLider.push(this.cosseguroList[index]);
        });

        this.updateProposalList();
    }

    updateProposalList() {
        this.proposalList = [...this.selectedRowsLider, ...this.selectedRowsCoparticipantes];
        //Adicionar lógica para lidar com duplicatas se necessário

        if (this.proposalList.length >= 2) {
            let totalPrizeAmount = 0;
            let totalInsuredAmount = 0;
            let totalParticipationPercentage = 0;

    
            this.proposalList.forEach(row => {
                totalPrizeAmount += row.PrizeAmount__c || 0;
                totalInsuredAmount += row.InsuredAmount__c || 0;
            });

            this.proposalList.forEach(row => {
                if(totalInsuredAmount !== 0){
                    row.Participation_Percentage__c = ((row.InsuredAmount__c || 0) / totalInsuredAmount);
                } else {
                    row.Participation_Percentage__c = 0;
                }
            });

            this.proposalList.forEach(row => {
                totalParticipationPercentage += row.Participation_Percentage__c || 0;
            });


    
            // Adicionando a linha fixa com os totais calculados
            this.proposalList.push({
                Name: 'SUBTOTAL',
                PrizeAmount__c: totalPrizeAmount,
                InsuredAmount__c: totalInsuredAmount,
                Participation_Percentage__c: totalParticipationPercentage,
            });

        } else {
            this.proposalList.forEach(row => {
                row.Participation_Percentage__c = 0;
            });
        }
    }

    
    deleteCoinsuranceDataModal() {
        // Limpar seleção na tabela 'lider'
        const liderDataTable = this.template.querySelector('lightning-datatable[data-table-id="lider"]');
        if (liderDataTable) {
            liderDataTable.selectedRows = [];
            this.selectedRowsLider = [];
        }
    
        // Limpar seleção na tabela 'coparticipantes'
        const coparticipantesDataTable = this.template.querySelector('lightning-datatable[data-table-id="coparticipantes"]');
        if (coparticipantesDataTable) {
            coparticipantesDataTable.selectedRows = [];
            this.selectedRowsCoparticipantes = [];
        }

        //Limpa montagem de propostas
        this.proposalList = [];
    }

    async saveCoinsuranceDataModal() {
        if (!this.validateProposalList()) {
            this.showToast('Error', 'Nenhuma proposta encontrada', 'error');
            return;
        }

        const copartQuotes = this.extractCopartQuotes();
        const segLider = this.proposalList[0];
        const lastRow = this.proposalList[this.proposalList.length - 1];

        if (this.listIndexesLiderSelected.length <= 0) {
            this.showToast('Error', 'Selecione uma seguradora líder para prosseguir', 'error');
            return;
        }

        if (this.listIndexesCopartSelected.length <= 0) {
            this.showToast('Error', 'Selecione ao menos uma seguradora coparticipante para prosseguir', 'error');
            return;
        }

        this.prepareAndSaveQuote(segLider, lastRow, copartQuotes);

        this.loadedQuoteTables = false;
        this.showNewProposalModal = false;
    }

    extractCopartQuotes() {
        return this.proposalList.slice(0, this.proposalList.length - 1);
    }

    validateProposalList() {
        return this.proposalList && this.proposalList.length > 1;
    }

    async prepareAndSaveQuote(segLider, lastRow, copartQuotes) {
        const quoteRecord = this.createQuoteRecord(segLider, lastRow);
        const quoteLineItems = this.createQuoteLineItems();
        try {
            const result = await createQuoteWithLineItems({ quoteInfo: quoteRecord, lineItems: quoteLineItems });
            await this.handleQuoteResult(result, copartQuotes, segLider);
        } catch (error) {
            this.handleQuoteError(error);
        }
    }

    createQuoteRecord(segLider, lastRow) {
        return {
            Name: 'Cotação | ' + this.selectedInsurerInput,
            Status: 'Draft',
            OpportunityId: this.oppId,
            Id: this.quoteId,
            Integralization__c: false,
            Quote_Kit__c: segLider.Quote_Kit__c,
            Company__c: segLider.Company__c,
            QuoteRequestDate__c: segLider.QuoteRequestDate__c,
            QuoteReceiptDate__c: segLider.QuoteReceiptDate__c,
            PrizeAmount__c: lastRow.PrizeAmount__c || 0,
            InsuredAmount__c: lastRow.InsuredAmount__c || 0,
            Net_Prize_Value__c: segLider.Net_Prize_Value__c,
            IOF_Prize_Value__c: segLider.IOF_Prize_Value__c,
            PercentCommission__c: segLider.PercentCommission__c,
            Agency_Percentage__c: segLider.Agency_Percentage__c,
            Description: segLider.Description,
            PartialQuoteCount__c: this.proposalList.length - 1,
            Participation_Percentage__c: lastRow.Participation_Percentage__c || 0
        };
    }

    createQuoteLineItems() {
        return this.oppLineItemRecords.map(record => ({
            Product2Id: record.Product2Id,
            PricebookEntryId: record.PricebookEntryId,
            UnitPrice: record.UnitPrice,
            Quantity: record.Quantity,
            NumberOfLifes__c: record.NumberOfLifes__c,
            CommissionPercent__c: this.comissionPercentageInput,
            AgencyPercentage__c: this.agencyPercentageInput,
            IOFPrizeValue__c: this.iofValueInput,
            PrizeNetValue__c: this.netValueInput
        }));
    }

    async handleQuoteResult(result, copartQuotes, segLider) {
        try {
            if(this.quoteId != null) {
                this.processDeleteIntegralizations(result);
                console.log('COTAÇÃO ATUALIZADA: ' + result);
            } else {
                console.log('COTAÇÃO ATUALIZADA: ' + result);
            }
            this.processCopartQuotes(result, copartQuotes, segLider);

            if(this.quoteDocumentsToSave.length > 0) {
                this.processAllFiles(this.quoteDocumentsToSave, result);
            }

        } finally {
            await this.loadCoinsuranceProposals();
            this.cleanCoinsuranceVariables();
            this.loadedQuoteTables = true;
            
            this.showToast('Success', 'Cotação salva com sucesso!', 'success');
        }
    }

    async processDeleteIntegralizations (result) {
        const getIntegralizations = await getIntegralizationsByProposalId ({recordId : result});
        
        if(getIntegralizations.length > 0) {
            await deleteIntegralizations({integralizations : getIntegralizations});
        }
    }

    async processCopartQuotes(result, copartQuotes, segLider) {
        const integralizationList = this.buildIntegralizationList(result, copartQuotes, segLider);
        if (integralizationList.length > 0) {
            await createQuoteIntegralizations({ integralizations: integralizationList });
        }
    }

    buildIntegralizationList(result, copartQuotes, segLider) {
        return copartQuotes.map(rec => ({
            IntegralQuote__c: result,
            PartialQuote__c: rec.Id,
            InsuredAmount__c : rec.InsuredAmount__c,
            Participation_Percentage__c: rec.Participation_Percentage__c * 100,
            LeadQuote__c : rec.Company__c === segLider.Company__c
        }));
    }

    handleQuoteError(error) {
        this.loadedQuoteTables = true;
        console.error('Error creating quote: ', error);
        this.showToast('Error', 'Erro ao salvar a cotação', 'error');
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
    
    cleanCoinsuranceVariables() {
        this.selectedRowsLider = [];
        this.selectedRowsCoparticipantes = [];
        this.proposalList = [];
    
        this.liderIndexesSelected = [];
        this.listIndexesLiderSelected = [];
        this.preSelectedRowsCopart = [];
        this.copartIndexesSelected = [];
        this.listIndexesCopartSelected = [];
        this.preSelectedRowsLider = [];
    }

    async handleEditProposalModal(event) {
        let quoteRec;
        let integralizationRecords = [];

        let selectedRowsLiderIndexes = [];
        let selectedRowsCoparticipantesIndexes = [];

        let selectedRowsLiderRecs = [];
        let selectedRowsCopartRecs = [];
        
        this.showNewProposalModal = true;
        this.loadedProposalModal = false;
        this.selectedRecordId = event.detail.recordId;
        this.preSelectedRowsLider = [];
        this.preSelectedRowsCopart = [];

        try {
            const data = await getQuoteById( {recordId: this.selectedRecordId} );
            if (data) {
                quoteRec = data;
                this.quoteId = quoteRec.Id;
                this.quoteNumber = ' - ' + quoteRec.QuoteNumber;
            }

            const integralizationData = await getIntegralizationsByProposalId({recordId: this.selectedRecordId});
            if(data) {
                integralizationRecords = integralizationData;

                integralizationRecords.forEach(rec => {
                    let partialQuote = this.cosseguroList.find(partialQt => partialQt.Id === rec.PartialQuote__c);

                    if(partialQuote){
                        const partialQuoteIndex = this.cosseguroList.indexOf(partialQuote);

                        if(partialQuote.Company__c === quoteRec.Company__c) {
                            selectedRowsLiderIndexes.push('row-' + partialQuoteIndex);
                            selectedRowsLiderRecs.push(partialQuote);

                        } else {
                            selectedRowsCoparticipantesIndexes.push('row-' + partialQuoteIndex);
                            selectedRowsCopartRecs.push(partialQuote);
                        }
                    }
                })

                if(selectedRowsLiderIndexes) {
                    this.preSelectedRowsLider = selectedRowsLiderIndexes;
                }
                if(selectedRowsCoparticipantesIndexes){
                    this.preSelectedRowsCopart = selectedRowsCoparticipantesIndexes;
                }

                this.selectedRowsLider = selectedRowsLiderRecs;
                this.selectedRowsCoparticipantes = selectedRowsCopartRecs;

                this.updateProposalList();
            }
            try {

                const documents = await getQuoteDocumentsByQuoteId( {recordId: this.selectedRecordId} );
                if (documents){
                    this.quoteFiles = documents;
                }
                if(this.quoteFiles.length > 0){
                    this.quoteEdit = true;
                } else {
                    this.quoteEdit = false;
                }
            } catch (err) {

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Erro ao obter documentos: ' + err,
                    variant: 'error',
                }));

                console.error('Erro ao obter documentos: ' + err);
            }

            this.loadedProposalModal = true;

        } catch (error) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao obter registro de cotação: ' + err,
                variant: 'error',
            }));

            console.error('Erro ao obter registro de cotação: ', error)
        }
    
    }

    handleDeleteProposalModal(event) {
        this.selectedRecordId = event.detail.recordId;
        this.showConfirmDelete = true;
    }
    

//---------------------------------------------------//

    //HANDLER SAVE INLINE EDIT QUOTE TABLE
    async handleSaveInLineEdit(event) {
        this.loadedQuoteTables = false;
        let draftValues = event.detail.draftValues;
        let quotesToUpdate = [];
    
        // Preparar dados de atualização
        draftValues.forEach(draft => {
            let rowIndex = parseInt(draft.caseId.replace('row-', ''), 10);
            let quoteRecord = this.quoteList[rowIndex];
            let changes = {};
    
            // Iterar sobre as alterações e adicioná-las ao objeto de atualização
            Object.keys(draft).forEach(key => {
                if (key !== 'caseId') {
                    let fieldName = key;
                    let fieldValue = draft[key];
    
                    // Verificar se o campo é um número e convertê-lo
                    if (fieldName === 'InsuredAmount__c' || fieldName === 'PrizeAmount__c') {
                        fieldValue = Number(fieldValue);
                    }
    
                    // Adicionar o campo e seu novo valor ao objeto de alterações
                    changes[fieldName] = fieldValue;
                }
            });
    
            // Combinar as alterações com o registro da cotação
            quotesToUpdate.push({ Id: quoteRecord.Id, ...changes });
        });
    
        // Chamar método Apex para atualizar os registros
        try {
            await updateQuotes({ quotesToUpdate: quotesToUpdate });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Registros atualizados com sucesso!',
                    variant: 'success',
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Falha ao atualizar registros: ' + error,
                    variant: 'error',
                })
            );
        } finally {
            // Carregar novamente os dados após a atualização
            await Promise.all([this.loadQuotes()]);
            this.loadedQuoteTables = true;
        }
    }
    
    //CREATE ORDER
    async handleCreateOrder() {
        try {
            this.validatePolicyNumberInput();
    
            if (this.requiredFieldErrorPolicyNumber) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Falha ao criar registro, número da apólice inválido',
                        variant: 'error',
                    })
                );
                return;
            }
    
    
            this.loadingEmissionPage = true;

            const currentDate = new Date();
            const endDataPolicy = new Date(this.oppRecord.EndDatePolicy__c);
    
            let orderRecord = {
                PoNumber: this.policyNumberInput,
                Company__c: this.approvedProposalRecord.Company__c,
                PoDate: currentDate,
                EffectiveDate: currentDate,
                EndDate: endDataPolicy,
                Status: 'CarriedOut',
                RecordTypeId: this.orderRecordTypeId,
                OpportunityId: this.oppId,
                QuoteId: this.approvedProposalRecord.Id,
                Pricebook2Id: this.oppRecord.Pricebook2Id,
                AccountId: this.accountId
            }

            const orderItems = this.prepareOrderItems();
    
            const orderCreationPromises = [
                createOrderWithLineItems({ orderInfo: orderRecord, lineItems: orderItems}),
            ];
    
            const [orderCreated] = await Promise.all(orderCreationPromises);
    
            if (orderCreated) {
                console.log('ORDER CREATED: ', orderCreated);
                try{
                    this.updateOpportunityStage('Fechado e ganho');

                    if(this.orderApoliceToSave.length > 0) {
                        this.tipoDocumento = 'Apólice'; 
                        this.processAllFiles(this.orderApoliceToSave, orderCreated);
                    }

                    setTimeout(()=>{
                        if(this.orderBoletosToSave.length > 0) {
                            this.tipoDocumento = 'Boleto';
                            this.processAllFiles(this.orderBoletosToSave, orderCreated);
                        }
                    },3000);

                    this.policyNumber = this.policyNumberInput;
                    this.blockedInput = true;
                    this.newOrderActiveButton = false;
                    this.showDropZoneEmission = false;

                    this.caseRecord[0].Status = 'Apólice registrada';

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sucesso',
                            message: 'Apólice criada com sucesso!',
                            variant: 'success',
                        })
                    );

                } catch(err){
                    console.error('ERR: ', err);
                    let errorMessage = err.body.message;
                    let errorMessageFormatted = errorMessage.replace(/\"/g, '');
                    errorMessageFormatted = errorMessageFormatted.replace(/message:/g, '');
                    errorMessageFormatted = errorMessageFormatted.replace(/:/g, '');
                    errorMessageFormatted = errorMessageFormatted.replace(/{|}/g, '');
                    errorMessageFormatted = errorMessageFormatted.replace(/\[|\]/g, '');
            
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: `Falha ao criar apólice: ${errorMessageFormatted}`,
                            variant: 'error',
                        })
                    );

                }
                    
            }
        } catch (error) {

            console.error('ERR: ', error);
            let errorMessage = error.body.message;
            let errorMessageFormatted = errorMessage.replace(/\"/g, '');
            errorMessageFormatted = errorMessageFormatted.replace(/message:/g, '');
            errorMessageFormatted = errorMessageFormatted.replace(/:/g, '');
            errorMessageFormatted = errorMessageFormatted.replace(/{|}/g, '');
            errorMessageFormatted = errorMessageFormatted.replace(/\[|\]/g, '');
    
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `Falha ao criar apólice: ${errorMessageFormatted}`,
                    variant: 'error',
                })
            );
        } finally {
            this.loadingEmissionPage = false;
            this.policyNumberInput = null;
        }
    }
    
    async updateOpportunityStage(stageName) {
        const oppToUpdt = {
            Id: this.oppId,
            StageName: stageName
        };
    
        try {
            return await updateOpportunity({ oppRec: oppToUpdt });
        } catch (err) {

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Erro ao atualizar status de oportunidade: ' + err,
                variant: 'error',
            }));

            console.error('Erro ao atualizar status de oportunidade:', err);
        }
    }
    
    prepareOrderItems() {
        return this.oppLineItemRecords.map(item => ({
            UnitPrice: item.UnitPrice,
            Quantity: item.Quantity,
            PricebookEntryId: item.PricebookEntryId
        }));
    }

    handleComplete(event) {
        const loaded = event.detail.loaded;
        this.pathLoaded = loaded;
    }

}