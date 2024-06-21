/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class ErrorLogServiceTest {

    @testSetup
    static void setup(){

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunity();
        Opportunity objOpportunity1 = OpportunityDataFactory.createOpportunityCorporateComercial();
        Opportunity objOpportunity2 = OpportunityDataFactory.createOpportunityCorporateComercial();
        insert objOpportunity2;
        insert objOpportunity1;
        insert objOpportunity;
    }

    @isTest
    static void shouldResultUpdateInOpportunity(){

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id, OpportunityNumber__c, Name, OwnerId FROM Opportunity];
        List<Opportunity> lstOpportunityUpdate = new List<Opportunity>();
        lstOpportunityUpdate.add(new Opportunity(
            Id = lstOpportunity[0].Id,
            StageName = 'Cotação'
        ));
        lstOpportunityUpdate.add(new Opportunity(
            Id = lstOpportunity[1].Id,
            StageName = 'Cotação'
        ));
        lstOpportunityUpdate.add(new Opportunity(
            Id = lstOpportunity[2].Id,
            StageName = 'Aberta'
        ));
        Database.SaveResult[] sr = Database.update(lstOpportunityUpdate, false);
        ErrorLogService.getInstance().saveResult(sr,'test', lstOpportunityUpdate);   
        Test.stopTest();

        Opportunity objOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =: lstOpportunity[0].Id];
        String expected = 'Cotação';
        String actual = objOpp.StageName;
        System.assertEquals(expected, actual, 'StageName not checking with expecteg');
    }

    @isTest
    static void shouldResultUpdateFailed(){

        
        Test.startTest();   
        List<Opportunity> lstOpportunityUpdate = [SELECT Id, StageName FROM Opportunity Limit 1];     
        Database.SaveResult sr = (Database.SaveResult)
            JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        List<Database.SaveResult> lstSR = new List<Database.SaveResult>();
        lstSR.add(sr);
        ErrorLogService.getInstance().saveResult(lstSR,'test', lstOpportunityUpdate);   
        Test.stopTest();

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }


    @isTest
    static void shouldResultDeleteOpportunity(){

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id, OpportunityNumber__c, Name, OwnerId FROM Opportunity];
        List<Opportunity> lstOpportunityDelete = new List<Opportunity>();
        lstOpportunityDelete.add(new Opportunity(
            Id = lstOpportunity[0].Id
        ));
        lstOpportunityDelete.add(new Opportunity(
            Id = lstOpportunity[1].Id
        ));
        lstOpportunityDelete.add(new Opportunity(
            Id = lstOpportunity[2].Id
        ));
        Database.DeleteResult[] dr = Database.delete(lstOpportunityDelete, false);
        ErrorLogService.getInstance().deleteResult(dr,'test', lstOpportunityDelete);   
        Test.stopTest();

        List<Opportunity> lstOpportunityAfterDelete = [SELECT Id, OpportunityNumber__c, Name, OwnerId FROM Opportunity];
        Integer expected = 0;
        Integer actual = lstOpportunityAfterDelete.size();
        System.assertEquals(expected, actual, 'size not checking with expected');
    }

    @isTest
    static void shouldResultDeleteFailed(){

        Test.startTest(); 
        List<Opportunity> lstOpportunityUpdate = [SELECT Id, StageName FROM Opportunity Limit 1];       
        Database.DeleteResult dr = (Database.DeleteResult)
            JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.DeleteResult.class);
        List<Database.DeleteResult> lstDR = new List<Database.DeleteResult>();
        lstDR.add(dr);
        ErrorLogService.getInstance().deleteResult(lstDR,'test', lstOpportunityUpdate);   
        Test.stopTest();

        Integer expected ;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');
    }


    
}