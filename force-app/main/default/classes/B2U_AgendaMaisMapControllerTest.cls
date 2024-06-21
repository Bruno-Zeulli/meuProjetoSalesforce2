/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class B2U_AgendaMaisMapControllerTest {
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

    List<Object> pinList = B2U_AgendaMaisMapController.getLocations(null, null, null, null, 0);
    List<Object> pinList1 = B2U_AgendaMaisMapController.getLocations('L2BCORP', 'Brasília', 'Aberto', 'SINDI', 0);
    System.assert(pinList != pinList1, 'List shouls not be the same as they have different parameters');
  }
}