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
public class EventDataFactory {
  public static Event createEvent(){
    Event eventVariable = new Event(
      Subject = 'Reunião',
      Description = 'Reunião presencial',
      Location = 'Ed. Caixa Seguradora',
      StartDateTime = System.now().addDays(1),
      EndDateTime = System.now().addDays(1).addHours(1)
    );
    return eventVariable;
  }
}