@isTest
public class ContactDAOTest
{
	@isTest
    static  void testInstance(){
       System.assertNotEquals(null, ContactDAO.getInstance());
    }

    @isTest
    static void testgetBusinessPartnerContactByAccountOpportunityId(){
        Account acc = new Account();
        acc.Name = 'Italo Test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'New';
        
        opp.AccountId = acc.Id;
        opp.CloseDate = System.today();
        insert opp;
        
        Contact c = new Contact();
        c.FirstName = 'Teste';
        c.IsBusinessPartner__c = true;
        c.LastName = 'Teste';
        c.AccountId = acc.Id;
        insert c;

        System.assertEquals(1, ContactDAO.getBusinessPartnerContactByAccountOpportunityId(opp.Id).size());
    }
    
  	@isTest
    static void testWhereCondition(){
        Contact c = new Contact();
         c.FirstName = 'Teste';
        c.LastName = 'Teste';
        insert c;

        ContactDAO cd = new ContactDAO();

        String whereCondition = 'WHERE FirstName = \'Teste\'';
        System.assertNotEquals(null, cd.getAllFieldsByWhereCondition(whereCondition));
    }

    	@isTest
        static void getContactByQuotationFormId(){

            Technical_Specification_Questionnaire__c form = new Technical_Specification_Questionnaire__c();
            form.recordTypeId = Schema.SObjectType.Technical_Specification_Questionnaire__c.getRecordTypeInfosByName().get('Benefícios - Vida').getRecordTypeId();
            form.Type__c = 'Vida';
            insert form;

            Set<Id> setForm = new Set<Id>();
            setForm.add(form.Id);

            Contact c = new Contact();
             c.FirstName = 'Teste';
            c.LastName = 'Teste';
            c.TechnicalSpecificationQuestionnaireId__c = form.Id;
            insert c;


            System.assertNotEquals(null, ContactDAO.getContactByQuotationFormId(setForm));
        }

}