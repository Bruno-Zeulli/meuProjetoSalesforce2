@isTest
public class FlowCreateOppAndOppProductTest 
{
    @isTest
    static void testUpdate()
    {
        FlowCreateOppAndOppProduct.InputVariables up = new FlowCreateOppAndOppProduct.InputVariables();
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ());
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;

        insert acc;
         Opportunity opp1 = new Opportunity(
            AccountId = acc.Id,
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Fechada E Ganho',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4)
        );
        insert opp1;
        User u = [SELECT Id FROM User LIMIT 1];
         Id pricebookId = Test.getStandardPricebookId();

        Product2 product = ProductDataFactory.insertProductAuto();

        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = product.Id, IsActive = true, UnitPrice = 1);
        insert pbEntry;
        
      	 List<String> accountIdFromFlow = new List<String>();
         List<String> pricebookEntryIdFromFlow = new List<String>();
         List<String> pklTypeFromFlow = new List<String>();
        
        
        accountIdFromFlow.add(acc.Id);
        pricebookEntryIdFromFlow.add(pbEntry.Id);
        pklTypeFromFlow.add('New');
	
		
        up.accountIdFromFlow = accountIdFromFlow;
        up.pricebookEntryIdFromFlow = pricebookEntryIdFromFlow;
        up.pklTypeFromFlow = pklTypeFromFlow;
        
        List<FlowCreateOppAndOppProduct.InputVariables> lstAh = new List<FlowCreateOppAndOppProduct.InputVariables>();
        lstAh.add(up);
        FlowCreateOppAndOppProduct.createOppAndOppProduct(lstAh);
    }
}