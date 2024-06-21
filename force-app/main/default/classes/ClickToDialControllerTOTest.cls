/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 09-22-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class ClickToDialControllerTOTest {

    @isTest
    static void testContactToDial() {
        // Crie uma instância da classe ContactToDial e defina seus atributos
        ClickToDialControllerTO.ContactToDial contactToDial = new ClickToDialControllerTO.ContactToDial();
        contactToDial.sobjectname = 'Contact';
        contactToDial.objectId = '001123456789';
        contactToDial.name = 'John Doe';
        contactToDial.mobilephone = '123-456-7890';
        contactToDial.homephone = '987-654-3210';
        contactToDial.otherphone = '555-555-5555';
        contactToDial.assistantphone = '999-999-9999';
        contactToDial.bestphone = '777-777-7777';
        contactToDial.email = 'johndoe@example.com';

        // Verifique se os atributos da classe ContactToDial foram definidos corretamente
        System.assertEquals('Contact', contactToDial.sobjectname);
        System.assertEquals('001123456789', contactToDial.objectId);
        System.assertEquals('John Doe', contactToDial.name);
        System.assertEquals('123-456-7890', contactToDial.mobilephone);
        System.assertEquals('987-654-3210', contactToDial.homephone);
        System.assertEquals('555-555-5555', contactToDial.otherphone);
        System.assertEquals('999-999-9999', contactToDial.assistantphone);
        System.assertEquals('777-777-7777', contactToDial.bestphone);
        System.assertEquals('johndoe@example.com', contactToDial.email);
    }

    @isTest
    static void testPhoneFieldInfo() {
        // Crie uma instância da classe PhoneFieldInfo e defina seus atributos
        ClickToDialControllerTO.PhoneFieldInfo phoneFieldInfo = new ClickToDialControllerTO.PhoneFieldInfo('MobilePhone', 'Mobile Phone');

        // Verifique se os atributos da classe PhoneFieldInfo foram definidos corretamente
        System.assertEquals('MobilePhone', phoneFieldInfo.apiName);
        System.assertEquals('Mobile Phone', phoneFieldInfo.label);
    }
}