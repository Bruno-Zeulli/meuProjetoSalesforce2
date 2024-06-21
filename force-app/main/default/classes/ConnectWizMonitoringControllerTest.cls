@isTest
public class ConnectWizMonitoringControllerTest 
{
	@isTest
    static void validateQuote()
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
        q.Name = 'test quote';
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
        
        ConnectWizMonitoringController.validateQuote(caso.Id,proposta);
        ConnectWizMonitoringController.insertQuote(caso.Id,proposta);
        ConnectWizMonitoringController.insertListQuote(caso.Id,proposta);
        ConnectWizMonitoringController.updateQuote(proposta);
        
         ConnectWizMonitoringController.deleteQuote(q.Id);
        ConnectWizMonitoringController.retrieveQuotes(caso.Id);
        ConnectWizMonitoringController.getOpportunityByCaseId(caso.Id);
        ConnectWizMonitoringController.getCaseById(caso.Id);
         ConnectWizMonitoringController.getAccountByOpportunityId(opp.Id);
        ConnectWizMonitoringController.emitQuote(caso.Id);
    }
}