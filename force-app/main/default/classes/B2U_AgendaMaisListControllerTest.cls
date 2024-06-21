/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class B2U_AgendaMaisListControllerTest {
  @isTest
  static void testController() {
    Id lead2BusinessRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('B2U_Lead2Business')
      .getRecordTypeId();
    Account acc = AccountDataFactory.insertBusinessAccount();
    Opportunity opp = OpportunityDataFactory.createOpportunity();
    opp.RecordTypeId = lead2BusinessRecordType;
    opp.AccountId = acc.Id;
    insert opp;

    List<Object> returnModelList = B2U_AgendaMaisListController.getOppsList(null, null, null, null, 0);
    List<Object> returnModelList1 = B2U_AgendaMaisListController.getOppsList(
      'L2BCORP',
      'Brasília',
      'Aberto',
      'SINDI',
      0
    );
    System.assert(
      returnModelList != returnModelList1,
      'List shouls not be the same as they have different parameters '
    );
  }
}