/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD | removido código comentado
 **/
@isTest
public class DataFactoriesTest {
  static testMethod void testDataFactories(){
    AccountDataFactory.insertBusinessAccount();
    Account acc = AccountDataFactory.insertPersonAccount();
    AccountDataFactory.createPersonAccount(PersonalInformationUtil.generateRandomCPF());
    System.assert(acc != null, 'Expected account created');
  }
}