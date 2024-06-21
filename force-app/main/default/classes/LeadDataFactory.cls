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
public class LeadDataFactory {
  public static Lead createLead(){
    Lead ld = new Lead(
      FirstName = 'Primeiro',
      LastName = 'Último',
      IdentificationNumber__c = PersonalInformationUtil.generateRandomCPF(),
      Email = 'test@test.com'
    );
    return ld;
  }

  public static Lead insertLead(){
    Lead ld = createLead();
    insert ld;
    return ld;
  }
}