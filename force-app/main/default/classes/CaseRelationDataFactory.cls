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
public class CaseRelationDataFactory {
  public static CaseContactRelation__c insertCaseRelation(
    String caseId,
    String contactId,
    String parentesco,
    String relacionamento
  ){
    CaseContactRelation__c caseRelation = new CaseContactRelation__c(
      Case__c = caseId,
      Contact__c = contactId,
      Kinship__c = parentesco,
      Relationship__c = relacionamento
    );
    insert caseRelation;
    return caseRelation;
  }
}