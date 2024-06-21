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
public class ContactTriggerHandlerTest {
  @isTest
  static void testContactTriggerHandler(){
    Contact contactVariable;
    contactVariable = testInsert();
    System.assert(contactVariable != null, 'test Insert');
    contactVariable = testUpdate(contactVariable);
    contactVariable = testDelete(contactVariable);
    contactVariable = testUndelete(contactVariable);
  }

  static Contact testInsert(){
    return ContactDataFactory.insertContact();
  }

  static Contact testUpdate(Contact contactVariable){
    update contactVariable;
    return contactVariable;
  }

  static Contact testDelete(Contact contactVariable){
    delete contactVariable;
    return contactVariable;
  }

  static Contact testUndelete(Contact contactVariable){
    undelete contactVariable;
    return contactVariable;
  }
}