/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-03-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
**/
@isTest
public class MarketingCloudHandlerTest {

    @testsetup static void setup(){
        Id pricebookId = Test.getStandardPricebookId();
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
        ExternalAPIDataFactory.insertExternalAPIs();

        Account sinistradoAccount = AccountDataFactory.insertPersonAccount();
        sinistradoAccount = [SELECT Id, PersonContactId FROM Account WHERE Id = : sinistradoAccount.Id];
        Id sinistradoContact = sinistradoAccount.PersonContactId;
        ContactDetail__c sinistradoContactDetail = ContactDetailDataFactory.insertConciergePersonAccountContactDetail(sinistradoAccount);

        Product2 productHab = ProductDataFactory.insertProductHab();
        Product2 productPres = ProductDataFactory.insertProductPres();
        Product2 productRCPM = ProductDataFactory.insertProductRCPM();
        Product2 productAgro = ProductDataFactory.insertProductAgro();

        Product2 product = ProductDataFactory.insertProductAuto();

        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = product.Id, IsActive = true, UnitPrice = 1);
        insert pbEntry;

        Contract2__c contratoSinistradoHab = ContractDataFactory.insertContractHab(sinistradoAccount.Id, productHab);
        Contract2__c contratoSinistradoPre = ContractDataFactory.insertContractPres(sinistradoAccount.Id, productPres);
        Contract2__c contratoSinistradoRCPM = ContractDataFactory.insertContractHab(sinistradoAccount.Id, productRCPM);
        Contract2__c contratoSinistradoAgro = ContractDataFactory.insertContractAgro(sinistradoAccount.Id, productAgro);

        Case comunicadoPrestamista = CaseDataFactory.insertComunicadoSinistro(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id);

        Case comunicadoPrestamista1 = CaseDataFactory.insertComunicadoSinistro(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id);
        comunicadoPrestamista1.Concierge_ResidualValue__c = 1000.00;
        update comunicadoPrestamista1;

        Case comunicadoPrestamista2 = CaseDataFactory.insertComunicadoSinistro(sinistradoAccount.Id, sinistradoContact, sinistradoContactDetail.Id);
        comunicadoPrestamista2.Concierge_IncidentWorkflowStatus__c = 'BPO - Não É Cliente da Caixa Seguradora';
        update comunicadoPrestamista2;

        Case comunicadoHabitacional = comunicadoPrestamista.clone(false, false, false, false);
        insert comunicadoHabitacional;

        Case habitacional1 = CaseDataFactory.insertSinistro(sinistradoAccount.id, comunicadoPrestamista.Id, sinistradoContact, sinistradoContactDetail.Id, contratoSinistradoHab.Id);

        Case comunicadoVarios = comunicadoPrestamista.clone(false, false, false, false);
        insert comunicadoVarios;

        Case rcpm1 = CaseDataFactory.insertSinistroRCPM(sinistradoAccount.id, sinistradoContact, sinistradoContactDetail.id, contratoSinistradoRCPM.id);

        Case agro = CaseDataFactory.insertSinistroAgro(sinistradoAccount.id, sinistradoContact, sinistradoContactDetail.id, contratoSinistradoAgro.id);

        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Task t = TaskDataFactory.insertCallTaskWithAccountAndOpp(sinistradoAccount.PersonContactId, opp.Id);
    }

    @isTest
    static void sendProductToMarketingcloudTest(){

        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallMktCloudSuccess());
        Test.startTest();
            MarketingCloudHandler.sendProductToMarketingcloud();
        Test.stopTest();
    }
}