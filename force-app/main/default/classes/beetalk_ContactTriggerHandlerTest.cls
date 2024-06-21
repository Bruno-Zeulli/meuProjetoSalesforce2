@isTest
public class beetalk_ContactTriggerHandlerTest
{
	@isTest
    static void testBeetalkContact()
     {
          // Inicialização da classe de teste
        beetalk_ContactTriggerHandler handler = new beetalk_ContactTriggerHandler(true);
       datetime myDate = datetime.newInstance(2008, 12, 1);

       

         beetalk__Contact__c testContact = new beetalk__Contact__c();
        insert testContact;

         beetalk__Message__c testMessage = new beetalk__Message__c();
         testMessage.beetalk__ServerDateTime__c = myDate;
         testMessage.beetalk__Contact2__c = testContact.Id;
        insert testMessage;



         testContact.beetalk_Business_Hours_Exceeded_Flag__c = true;
         testContact.beetalk__LastInboundMessage__c = testMessage.Id;
         update testContact;
     }
}