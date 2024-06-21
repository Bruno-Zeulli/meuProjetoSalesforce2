@isTest
public class ConnectWizQuotionFormsControllerTest{
	@isTest
    static void getQuotationFormsByOppId(){
        User usuario = UserDataFactory.getAdminUser();

        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.CloseDate = Date.today() + 3;
        insert opp;

        Technical_Specification_Questionnaire__c tsq = new Technical_Specification_Questionnaire__c();
        tsq.OpportunityId__c = opp.Id;
        tsq.RecordTypeId = Schema.SObjectType.Technical_Specification_Questionnaire__c.getRecordTypeInfosByName().get('Benefícios - Vida').getRecordTypeId();
        tsq.Type__c = ' Vida';
        insert tsq;

        InsuranceInformation__c  insuranceinfo = new  InsuranceInformation__c();
        insuranceinfo.Type__c = 'Dados da Operadora';
        insuranceinfo.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo;

        ConnectWizQuotationFormsController.getQuotationFormsByOppId(opp.Id);
    }

    @isTest
    static void getQuotationFormsById(){
        User usuario = UserDataFactory.getAdminUser();

        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.CloseDate = Date.today() + 3;
        insert opp;

        Technical_Specification_Questionnaire__c tsq = new Technical_Specification_Questionnaire__c();
        tsq.RecordTypeId = Schema.SObjectType.Technical_Specification_Questionnaire__c.getRecordTypeInfosByName().get('Benefícios - Saúde').getRecordTypeId();
        tsq.OpportunityId__c = opp.Id;
        tsq.Type__c = ' Saúde';
        insert tsq;

         InsuranceInformation__c  insuranceinfo = new  InsuranceInformation__c();
        insuranceinfo.Type__c =  'Dados da Operadora';
        insuranceinfo.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo;

         InsuranceInformation__c  insuranceinfo2 = new  InsuranceInformation__c();
        insuranceinfo2.Type__c = 'Plano atual';
        insuranceinfo2.ParentId__c = insuranceinfo.Id;
        insuranceinfo2.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo2;

        InsuranceInformation__c  insuranceinfo3 = new  InsuranceInformation__c();
        insuranceinfo3.Type__c =  'Sugestão de plano';
        insuranceinfo3.PlanId__c = insuranceinfo2.Id;
        insuranceinfo3.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo3;

        ConnectWizQuotationFormsController.getQuotationFormsById(tsq.Id);
    }

     @isTest
    static void getQuotationFormsByIdDAO()
    {
        User usuario = UserDataFactory.getAdminUser();

        Opportunity opp = new Opportunity();
        opp.Name = 'Teste';
        opp.StageName = 'Open';
        opp.Amount = 0;
        opp.OwnerId = usuario.Id;
        opp.CloseDate = Date.today() + 3;
        insert opp;

        Technical_Specification_Questionnaire__c tsq = new Technical_Specification_Questionnaire__c();
        tsq.RecordTypeId = Schema.SObjectType.Technical_Specification_Questionnaire__c.getRecordTypeInfosByName().get('Casualidades - D&O').getRecordTypeId();
        tsq.OpportunityId__c = opp.Id;
        tsq.Type__c = ' D&O';
        insert tsq;

         InsuranceInformation__c  insuranceinfo = new  InsuranceInformation__c();
        insuranceinfo.Type__c =  'Dados da Operadora';
        insuranceinfo.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo;

         InsuranceInformation__c  insuranceinfo2 = new  InsuranceInformation__c();
        insuranceinfo2.Type__c = 'Plano atual';
        insuranceinfo2.ParentId__c = insuranceinfo.Id;
        insuranceinfo2.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo2;

        InsuranceInformation__c  insuranceinfo3 = new  InsuranceInformation__c();
        insuranceinfo3.Type__c =  'Sugestão de plano';
        insuranceinfo3.PlanId__c = insuranceinfo2.Id;
        insuranceinfo3.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert insuranceinfo3;

        Contact c = new Contact();
        c.FirstName = 'Teste';
        c.LastName = 'Teste';
        c.TechnicalSpecificationQuestionnaireId__c = tsq.Id;
        insert c;

        ConnectWizQuotationFormsController.getQuotationFormsById(tsq.Id);
    }
}