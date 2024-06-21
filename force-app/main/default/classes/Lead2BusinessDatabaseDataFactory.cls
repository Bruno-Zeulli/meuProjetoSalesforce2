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
public class Lead2BusinessDatabaseDataFactory {
  public static List<Lead2BusinessDatabase__c> createDatabases(){
    List<Lead2BusinessDatabase__c> databases = new List<Lead2BusinessDatabase__c>();
    Lead2BusinessDatabase__c itajai = new Lead2BusinessDatabase__c(Name = 'Itajaí', DerivedFrom__c = 'L2BITAJAI');
    Lead2BusinessDatabase__c corporate = new Lead2BusinessDatabase__c(Name = 'Corporate', DerivedFrom__c = 'L2BCORP');
    databases.add(itajai);
    databases.add(corporate);
    return databases;
  }

  public static List<Lead2BusinessDatabase__c> insertDatabases(){
    List<Lead2BusinessDatabase__c> databases = createDatabases();
    insert databases;
    return databases;
  }
}