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
public class ContactDataFactory {
  public static Contact createContact(){
    Contact contactVariable = new Contact(
      FirstName = 'Primeiro',
      LastName = 'Último',
      IndividualIdentificationNumber__c = PersonalInformationUtil.generateRandomCPF()
    );
    return contactVariable;
  }

  public static Contact insertContact(){
    Contact contactVariable = createContact();
    insert contactVariable;
    return contactVariable;
  }
}