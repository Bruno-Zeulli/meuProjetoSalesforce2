/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class CreateUmbrellaOppControllerTest {
  @isTest
  static void testController(){
    //Arrange
    List<Id> childrenOpportunitiesId = new List<Id>();
    Account acc = AccountDataFactory.insertBusinessAccount();
    Opportunity opp = OpportunityDataFactory.createOpportunity();
    opp.AccountId = acc.Id;
    insert opp;
    childrenOpportunitiesId.add(opp.Id);
    Order ord = new Order(
      OpportunityId = opp.Id,
      AccountId = acc.Id,
      PoNumber = '123456789',
      EffectiveDate = Date.today(),
      Status = 'CarriedOut',
      OwnerId = UserInfo.getUserId(),
      Company__c = 'CAIXA Seguradora'
    );
    insert ord;

    //Act
    CreateUmbrellaOppController.getOptions();
    Id id = CreateUmbrellaOppController.createUmbrellaOpportunity(childrenOpportunitiesId);
    Opportunity oppUpdated = [SELECT ParentOpportunity__c FROM Opportunity WHERE Id = :opp.Id WITH SECURITY_ENFORCED];

    //Assert
    System.assertEquals(oppUpdated.ParentOpportunity__c, id, 'Return does not correspond to the expected');
  }
}