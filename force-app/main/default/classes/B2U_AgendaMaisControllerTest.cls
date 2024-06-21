/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class B2U_AgendaMaisControllerTest {
  //test comment
  @isTest
  static void testController(){
    Id lead2BusinessRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('B2U_Lead2Business')
      .getRecordTypeId();
    Lead2BusinessDatabaseDataFactory.insertDatabases();
    Account acc = AccountDataFactory.insertBusinessAccount();
    Opportunity opp = OpportunityDataFactory.createOpportunity();
    opp.RecordTypeId = lead2BusinessRecordType;
    opp.AccountId = acc.Id;
    insert opp;

    System.assert(acc != null, 'Expected insert Account ');
    System.assert(opp != null, 'Expected insert Opportunity');

    List<AggregateResult> cityList = B2U_AgendaMaisController.getCityList('L2BCORP1', 'Aberto');
    System.assert(cityList != null, 'Expected get list City');
    B2U_AgendaMaisController.getDatabaseList();
    Integer count = B2U_AgendaMaisController.getRecordsCount('L2BCORP1', 'Aberto', 'Brasília');
    System.assert(count != null, 'Expected amount of records');
  }
}