@isTest
public class IntegrationAPICRMTest {
  private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateApolice')
    .getRecordTypeId();

  @isTest
  public static void integrationCorpAPICRMTest(){
    Account acc = AccountDataFactory.insertPersonAccount();
    Order orderAlfa = new Order();
    orderAlfa.Name = TestDataFactory.generateRandomStringNumber(10);
    orderAlfa.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
    orderAlfa.PoNumber = '2/93/2205';
    orderAlfa.Company__c = 'Alfa Seguros';
    orderAlfa.Type = 'New';
    orderAlfa.Status = 'CarriedOut';
    orderAlfa.EffectiveDate = Date.today();
    orderAlfa.DateOfFirstInstallment__c = Date.today();
    orderAlfa.PoDate = Date.today();
    orderAlfa.EndDate = Date.today() + 1;
    orderAlfa.NumberOfInstallments__c = '1';
    orderAlfa.RecordTypeId = corporateApoliceRecordType;
    orderAlfa.AccountId = acc.Id;

    insert orderAlfa;

    //  try{

    //     IntegrationAPICRM.integrationCorpAPICRMTest(orderAlfa.PoNumber);

    // }catch(Exception e){
    //     System.assert(e.getMessage().contains('Erro'),'Erro inesperado, contate o administrador do sistema');
    // }

    //IntegrationAPICRM.integrationCorpAPICRMTest(orderAlfa.Id);
  }
}