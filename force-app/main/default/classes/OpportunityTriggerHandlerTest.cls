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
public class OpportunityTriggerHandlerTest {
    @isTest
    static void testOpportunityTriggerHandler(){
        Opportunity opp;
        opp = testInsert();
        System.assert(opp != null, 'On test opportunity Insert');
        opp = testUpdate(opp);
        System.assert(opp != null, 'On test opportunity Update');
        opp = testDelete(opp);
        System.assert(opp != null, 'On test opportunity Delete');
        opp = testUndelete(opp);
        System.assert(opp != null, 'On test opportunity Undelete');

        Opportunity oppCorporate;
        oppCorporate = testInsertCorporateComercial();
        //oppCorporate = testDeleteCorporateComercial(oppCorporate);
        System.assert(oppCorporate != null, 'On test insert Corporete Comercial');

        Opportunity oppCorporateClosed;
        oppCorporateClosed = testInsertCorporateClosed();
        //oppCorporateClosed = testDeleteCorporateClosed(oppCorporateClosed);
        System.assert(oppCorporateClosed != null, 'On test opportynity Corporete Closed');

        Opportunity oppConseg;
        oppConseg = testInsertOppConseg();
        System.assert(oppConseg != null, 'On test opportynity Conseg');


        Opportunity oppBPOTelevendas;
        oppBPOTelevendas = testInsertOppBPOTelevendas();
        System.assert(oppConseg != null, 'On test opportynity BPOTelevendas');

    }

    static Opportunity testInsert(){
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        Account acc = AccountDataFactory.insertPersonAccount();
        opp.AccountId = acc.Id;
        insert opp;
        return opp;
    }

    static Opportunity testInsertCorporateComercial(){
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order ord = OrderDataFactory.createOrderCorporateApolice();
        opp.AccountId = acc.Id;
        insert opp;
        ord.OpportunityId = opp.Id;
        ord.AccountId = acc.Id;
        insert ord;
        return opp;
    }

    static Opportunity testInsertCorporateClosed(){
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        Account acc = AccountDataFactory.insertPersonAccount();
        opp.AccountId = acc.Id;
        insert opp;
        return opp;
    }

    static Opportunity testUpdate(Opportunity opp){
        update opp;
        return opp;
    }

    static Opportunity testDelete(Opportunity opp){
        delete opp;
        return opp;
    }

    static Opportunity testDeleteCorporateComercial(Opportunity opp){
         try{
            delete opp;
        } catch (DMLException ex){
            System.assert(
                ex.getMessage().contains(OpportunityTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_WITH_ORDERS_CORPORATE),
                ex.getMessage().contains(OpportunityTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_WITH_ORDERS_CORPORATE)
            );
        }
        Opportunity oppDel = [SELECT Id, IsDeleted FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(oppDel.IsDeleted, false, 'Expected False');
        return opp;
    }

    static Opportunity testDeleteCorporateClosed(Opportunity opp){
        opp.StageName = 'Fechado e ganho';
        update opp;
         try{
            delete opp;
        } catch (DMLException ex){
            System.assert(
                ex.getMessage().contains(OpportunityTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_CLOSED_CORPORATE),
                ex.getMessage().contains(OpportunityTriggerHandler.ERROR_MSG_DELETE_OPPORTUNITY_CLOSED_CORPORATE)
            );
        }
        Opportunity oppDel = [SELECT Id, IsDeleted FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(oppDel.IsDeleted, false, 'Expected False');
        return opp;
    }

    static Opportunity testUndelete(Opportunity opp){
        undelete opp;
        return opp;
    }


    static Opportunity testInsertOppConseg (){
        Account objAccount = AccountDataFactory.insertPersonAccount();
        Opportunity objOpportunity = OpportunityDataFactory.setObjectOpportunity(objAccount.Id, 'Auto');
        Campaign objCampaign = CampaignDataFactory.createCampaign();
        objCampaign.Name = 'Five9 Test';
        insert objCampaign;
        objOpportunity.CampaignId = objCampaign.Id;
        objOpportunity.Description = OpportunityDataFactory.createDescriptionOppConseg();
        objOpportunity.Type = 'New';
        objOpportunity.LeadSource = 'CAOA';
        insert objOpportunity;
        return objOpportunity;
    }

    static Opportunity testInsertOppBPOTelevendas (){
        Account objAccount = AccountDataFactory.insertPersonAccount();
        Opportunity objOpportunity = OpportunityDataFactory.setObjectOpportunity(objAccount.Id, 'BPOTelevendas');
        Campaign objCampaign = CampaignDataFactory.createCampaign();
        objCampaign.Name = 'Five9 Test';
        insert objCampaign;
        objOpportunity.CampaignId = objCampaign.Id;
        objOpportunity.Type = Null;
        objOpportunity.LeadSource = 'CAOA';
        insert objOpportunity;
        return objOpportunity;
    }

    @isTest
    static Opportunity testInsertOppBeneficios (){

        Account objAccount = AccountDataFactory.createBusinessAccount();
        Opportunity objOpportunity = OpportunityDataFactory.setObjectOpportunity(objAccount.Id, 'CorporateBeneficios');


        objOpportunity.StageName = 'Em negociação';
        objOpportunity.Type = Null;
        objOpportunity.LeadSource = 'Wiz Benefícios';
        insert objOpportunity;

        Case objCase= CaseDataFactory.createCaseCorporateComercial(objAccount.Id, objOpportunity.Id);

        Test.startTest();
        objOpportunity.StageName = 'Em negociação';
        update objOpportunity;
        List<Case> updatedCases = new List<Case>();
        updatedCases = CaseDAO.getInstance().getCasesByOpportunityId(objOpportunity.Id);
        for(Case cs : updatedCases){

            String expected = cs.Status;
            String actual = 'Aguardando aprovação da cotação';
            String msg = 'Teste Success change case status';

            // System.debug(cs.Status);
            // System.assertEquals(expected, actual, msg);
        }

        Test.stopTest();
        return objOpportunity;
    }

    @isTest
    static void testUpdateParentOpportunity(){
        Id pbId = Test.getStandardPricebookId();
        Product2 product = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista', Renewal_Start_Term__c = 60);
        insert product;
        PricebookEntry pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
        insert pbe;
        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunityCorporateComercial();
        OpportunityLineItem oppLi = OpportunityLineItemDataFactory.createOpportunityLineItem();
        
        opp.AccountId = acc.Id;
        insert opp;
        oppLi.OpportunityId = opp.Id;
        oppLi.PricebookEntryId = pbe.Id;
        insert oppLi;
        
        Opportunity oppParentInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id =:opp.Id];
        Assert.areEqual('Indefinido',oppParentInserted.Status_Portal__c);

        Opportunity oppChild = OpportunityDataFactory.createOpportunityCorporateComercial();
        oppChild.AccountId = acc.Id;
        oppChild.ParentOpportunity__c = opp.Id;
        oppChild.Type = 'ReNew';
        insert oppChild;        
        oppChild.StageName = 'Em Emissão';
        update oppChild;

        Opportunity oppChildInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id = :oppChild.Id];
        Assert.areEqual('Indefinido - Sem Produto',oppChildInserted.Status_Portal__c);
        
        Account accountInserted = [SELECT Id, Product_Count_JSON__c FROM Account];
        Assert.areEqual(null,accountInserted.Product_Count_JSON__c);

        OpportunityLineItem oppLi2 = OpportunityLineItemDataFactory.createOpportunityLineItem();
        oppLi2.OpportunityId = oppChild.Id;
        oppLi2.PricebookEntryId = pbe.Id;
        insert oppLi2;

        oppChildInserted = [SELECT Id, Status_Portal__c FROM Opportunity WHERE Id =:oppChild.Id];

        Assert.areEqual('Em Emissão',oppChildInserted.Status_Portal__c);

        oppParentInserted = [SELECT Id, Status_Portal__c,Latest_Child_Opportunity__c FROM Opportunity WHERE Id =:opp.Id];

        Assert.areEqual(oppChild.Id, oppParentInserted.Latest_Child_Opportunity__c);
        Assert.areEqual('Indefinido - Pai sem Order',oppParentInserted.Status_Portal__c);
        accountInserted = [SELECT Id, Product_Count_JSON__c FROM Account];
        Assert.areNotEqual(null,accountInserted.Product_Count_JSON__c);

        delete oppChild;

        oppParentInserted = [SELECT Id, Status_Portal__c,Latest_Child_Opportunity__c FROM Opportunity WHERE Id =:opp.Id];
        Assert.areEqual('Indefinido',oppParentInserted.Status_Portal__c);
    }
}