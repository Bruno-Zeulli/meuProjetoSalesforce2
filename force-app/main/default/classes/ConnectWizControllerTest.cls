@isTest
public class ConnectWizControllerTest
{

    @testSetup static void setup() {

        Group gp = new Group(Name='CONSEG_TEST', Type = 'Queue', DeveloperName='TEST');
        insert gp;

        Id p = [SELECT Id FROM Profile WHERE Name='Administrador'].id;

        Account ac = new Account(name ='Test Account', CompanyIdentificationNumber__c = '14343271000154') ;
        insert ac;

        Contact con = new Contact(LastName ='Test Contact',AccountId = ac.Id);
        insert con;

        String orgId = UserInfo.getOrganizationId();
        Date dToday = Date.today();
        String dateStr = dToday.year() + '_' + dToday.month() + '_' + dToday.day();
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));

        User usuario = new User(alias = 'tester', email='test123@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                                BusinessUnit__c = 'CONSEG',
                                timezonesidkey='America/Los_Angeles', username='tester'+randomInt+'test'+dateStr+'@wizcorp'+orgId+'.com');

        insert usuario;

    }

    @isTest
    static void getQuoteRequests()
    {

        User usuario = [SELECT Id FROM User WHERE Email = 'test123@noemail.com'];

        Group gp = [SELECT Id, Name FROM Group WHERE Name = 'CONSEG_TEST'];
        GroupMember gpm = new GroupMember(GroupId=gp.Id, UserOrGroupId=usuario.Id);
        insert gpm;

        System.runAs(usuario)
        {

            Opportunity opp = new Opportunity();
            opp.Name = 'Teste';
            opp.StageName = 'Open';
            opp.Amount = 0;
            opp.OwnerId = usuario.Id;
            opp.CloseDate = Date.today() + 3;
            insert opp;
            Product2 prod = new Product2();
            prod.Name = 'Teste';
            prod.Family = 'Garantia';
            prod.ProductCode = '10101010';
            prod.IsActive = true;
            insert prod;
            Pricebook2 priceb = new Pricebook2();
            priceb.Name = 'Pricebook Teste';
            priceb.IsActive = true;
            insert priceb;

            Id standardPB = Test.getStandardPricebookId();

            PricebookEntry pbe = new PricebookEntry();
            pbe.isActive = true;
            pbe.Pricebook2Id = standardPB;
            pbe.Product2Id = prod.Id;
            pbe.UnitPrice = 10;
            insert pbe;
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.Id;
            oli.Quantity = 1;
            oli.TotalPrice = 10;
            oli.PricebookEntryId = pbe.Id;
            insert oli;
            Case caso = new Case();
            caso.Status = 'Novo pedido';
            caso.OwnerId = usuario.Id;
            caso.Opportunity__c = opp.Id;
            insert caso;

            Task t = new Task();
            t.WhatId = caso.Id;
            insert t;

            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Name = 'TESTE';
            insert q;
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.Product2Id = prod.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 10;
            qli.PricebookEntryId = pbe.Id;
            insert qli;


            ConnectWizController.getQuoteRequests();
            //ConnectWizController.getQuoteSLAInfo();
            //ConnectWizController.getNumberOfCases();
            ConnectWizController.getUsersInfo();
            ConnectWizController.updateOwnerCaseFromPlacement(caso.Id, usuario.Id, 'New');
            ConnectWizController.getCaseStatus(Caso.Id);
            ConnectWizController.getCaseInfo(Caso.Id);
            ConnectWizController.getOpportunity(opp.Id);
            ConnectWizController.updateStageOpportunity(opp.Id, 'Open');
            ConnectWizController.getTaskHistory(t.WhatId);
            ConnectWizController.createTaskHistory(null,null,null,null,null);
            ConnectWizController.deleteTaskHistory(t.Id);
            ConnectWizController.updateCaseFromPlacement(caso.Id, null, null);
        }
    }

    @IsTest
    static void getQuestionnairesShouldReturnData(){
        
        Questionnaire__c questionnaire = QuestionnaireDataFactory.insertQuestionnaire();

        Test.startTest();
        List<ConnectWizCMPTO.Questionnaire> questionnaires = ConnectWizController.getQuestionnaireAnswers(questionnaire.Opportunity__c);
        Test.stopTest();
        
        Assert.areEqual(1, questionnaires.size(), 'The questionnaire list size is not as expected');
    }

    @IsTest
    static void getQuestionnairesWithInvalidDataShouldReturnEmpty(){

        Test.startTest();
        List<ConnectWizCMPTO.Questionnaire> questionnaires = ConnectWizController.getQuestionnaireAnswers('1');
        Test.stopTest();
        
        Assert.areEqual(0, questionnaires.size(), 'The questionnaire list size is not as expected');
    }

    @IsTest
    static void testPartialQuotes(){

        User usuario = [SELECT Id FROM User WHERE UserNickName__c Like '%Marcelo Martins%'];

        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.CloseDate = Date.today() + 3;
        insert opp;

        Product2 prod = new Product2();
        prod.Name = 'Teste';
        prod.Family = 'Garantia';
        prod.ProductCode = '10101010';
        prod.IsActive = true;
        insert prod;

        Pricebook2 priceb = new Pricebook2();
        priceb.Name = 'Pricebook Teste';
        priceb.IsActive = true;
        insert priceb;

        Id standardPB = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry();
        pbe.isActive = true;
        pbe.Pricebook2Id = standardPB;
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 10;
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 10;
        oli.PricebookEntryId = pbe.Id;
        insert oli;

        Case caso = new Case();
        caso.OwnerId = usuario.Id;
        caso.Opportunity__c = opp.Id;
       	insert caso;

        Task t = new Task();
        t.WhatId = caso.Id;
        insert t;

        ConnectWizCMPTO.PartialQuote partialQuote = new ConnectWizCMPTO.PartialQuote();
        partialQuote.name = 'Test';
        partialQuote.integralization = false;
        partialQuote.requestDate = Date.today();
        partialQuote.receiptDate = Date.today();
        partialQuote.insuranceCompany = 'ACBR';
        partialQuote.insurancePremium = 1000;
        partialQuote.amountInsurance = 10000;
        partialQuote.netInsurancePremium = 1;
        partialQuote.taxInsurancePremium = 1;
        partialQuote.comissionValue = 1;
        partialQuote.agencyValue = 1;
        partialQuote.observations = 'Description';
        
        Quote quote = ConnectWizController.insertPartialQuote(partialQuote, opp.Id);
        partialQuote.Id = quote.Id;
        ConnectWizController.updatePartialQuote(partialQuote);
        ConnectWizController.getPartialQuotes(quote.OpportunityId, new List<String>{quote.id});

        ConnectWizCMPTO.Proposal proposal = new ConnectWizCMPTO.Proposal();
        ConnectWizCMPTO.ProposalComposition composition = new ConnectWizCMPTO.ProposalComposition();
        composition.partialQuote = partialQuote;
        composition.isLead = true;
        composition.amountInsuranceUsed = partialQuote.amountInsurance;
        proposal.composition = new List<ConnectWizCMPTO.ProposalComposition>{composition};
        proposal.compositeQuote = partialQuote;
        ConnectWizController.insertProposal(proposal, opp.Id);
        List<ConnectWizCMPTO.Proposal> proposalList = ConnectWizController.getProposal(opp.Id);
        ConnectWizController.updateProposal(proposalList.get(0), proposalList.get(0).compositeQuote.Id);
        ConnectWizController.deleteProposal(proposalList.get(0).compositeQuote.Id);

        ConnectWizController.deletePartialQuote(quote.Id);
    }
}