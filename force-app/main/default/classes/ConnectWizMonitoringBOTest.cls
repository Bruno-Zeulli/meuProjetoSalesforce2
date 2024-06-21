@isTest
public class ConnectWizMonitoringBOTest
{
	@isTest
    static  void insertListQuote()
    {
        User usuario = UserDataFactory.getAdminUser();

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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';

        connectWizMonitoringBO.insertListQuote(caso.Id, proposta);

    }

    @isTest
    static  void insertQuote()
    {
        User usuario = UserDataFactory.getAdminUser();

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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';

        connectWizMonitoringBO.insertQuote(caso.Id, proposta);
    }

    @isTest
    static  void retrieveQuotesAndDeleteQuote()
    {
        User usuario = UserDataFactory.getAdminUser();

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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';

        Quote q = new Quote();
        q.Name = 'TESTE';
        q.OpportunityId = opp.Id;
        insert q;

        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.Product2Id = prod.Id;
        qli.Quantity = 1;
        qli.UnitPrice = 10;
        qli.PricebookEntryId = pbe.Id;
        insert qli;

        connectWizMonitoringBO.retrieveQuotes(caso.Id);
    }

    @isTest
    static  void updateQuote()
    {
        User usuario = UserDataFactory.getAdminUser();

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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

        Quote q = new Quote();
        q.Name = 'TESTE';
        q.OpportunityId = opp.Id;
        insert q;

        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.Product2Id = prod.Id;
        qli.Quantity = 1;
        qli.UnitPrice = 10;
        qli.PricebookEntryId = pbe.Id;
        insert qli;

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';
        proposta.QuoteId = q.Id;

        connectWizMonitoringBO.updateQuote(proposta);
        connectWizMonitoringBO.deleteQuote(q.Id);

    }

     @isTest
    static  void getOpportunityAndAccount()
    {
        User usuario = UserDataFactory.getAdminUser();

        Account acc = new Account();
        acc.OwnerId = usuario.Id;
        acc.CompanyIdentificationNumber__c = '19295270000103';
        acc.Name = 'Teste';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.AccountId = acc.Id;
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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

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

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';
        proposta.QuoteId = q.Id;

        connectWizMonitoringBO.getOpportunityByCaseId(caso.Id);
        connectWizMonitoringBO.getAccountByOpportunityId(opp.Id);

    }

     @isTest
    static  void getCaseByIdAndEmitQuote()
    {
        User usuario = UserDataFactory.getAdminUser();

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

        List<String> seguradoras = new List<String>();

        Id idRtCotacao = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Corporate').getRecordTypeId();

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

        ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        seguradoras.add(proposta.seguradora);
        proposta.seguradoras = seguradoras;
        proposta.premio = '20';
        proposta.recordTypeId = (String)idRtCotacao;
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';
        proposta.QuoteId = q.Id;

        connectWizMonitoringBO.getAccountByOpportunityId(caso.Id);
        connectWizMonitoringBO.getCaseById(caso.Id);
        connectWizMonitoringBO.emitQuote(caso.Id);

    }
}