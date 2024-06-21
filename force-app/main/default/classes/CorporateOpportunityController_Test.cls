/**
 * @description Classe para prover o teste na classse de opportunitycontroller da home de oportunidade
 * @author Peterson Silva
 */
@isTest
public with sharing class CorporateOpportunityController_Test {
    public CorporateOpportunityController_Test(){

    }
    /**
     * @description Método para implementar o teste na classe
     */
    public static testMethod void runOppTeste(){
        try
        {
            Test.startTest();

            Profile profilegr = [Select Id from Profile where name = 'Corporate - Gerente Regional'];
                User userGR = new User(
                    ProfileId = profilegr.Id,
                    Username = 'manageruser@cc.com',
                    Alias = 'usr_mg',
                    Email='testmge@cc.net.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='Teste MG',
                    Lastname='Class MG',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    isActive = true,
                    TimeZoneSidKey ='America/Sao_Paulo');
                INSERT userGR;

                Profile profile1 = [Select Id from Profile where name = 'Corporate - Gerente de Negócios'];
                User userGN = new User(
                    ProfileId = profile1.Id,
                    ManagerId = userGR.Id,
                    Username = 'testeusuariocc@cc.com',
                    Alias = 'usr_cc',
                    Email='teste@cc.net.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='Teste',
                    Lastname='Class',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    isActive = true,
                    TimeZoneSidKey ='America/Sao_Paulo');
                INSERT userGN;

                String strUserId = userGN.Id;

                Account accRecord = new Account(Name = 'Teste', CompanyIdentificationNumber__c = '61542490000142', IdentificationNumber__c = '61542490000142', OwnerId = strUserId);
                Insert accRecord;
                String strAccountId = accRecord.Id;

                List<Opportunity> lstOpp = new List<Opportunity>();
                for(Integer i = 0; i < 4; i++)
                {
                    Opportunity oppRecord = new Opportunity(
                        OwnerId = strUserId,
                        Name = 'Nova Oportunidade__'+i,
                        Accountid = strAccountId,
                        Type = 'New',
                        StageName = 'Levantamento de Necessidades',
                        Closedate = Date.Today()
                    );
                    lstOpp.add(oppRecord);
                }
                Insert lstOpp;

                List<Opportunity> lstOppGR = new List<Opportunity>();
                for(Integer i = 0; i < 4; i++)
                {
                    Opportunity oppRecord = new Opportunity(
                        OwnerId = userGR.Id,
                        Name = 'Nova Oportunidade__'+i,
                        Accountid = strAccountId,
                        Type = 'New',
                        StageName = 'Levantamento de Necessidades',
                        Closedate = Date.Today()
                    );
                    lstOppGR.add(oppRecord);
                }
                Insert lstOppGR;

                System.runAs(userGN)
                {
                    CorporateOpportunityController.getUserOpportunity();
                    CorporateOpportunityController.fetchUser();
                }
                System.runAs(userGR)
                {
                    CorporateOpportunityController.getUserOpportunity();
                    CorporateOpportunityController.fetchUser();
                }
            Test.stopTest();
        }
        catch(exception e){
            system.debug('Erro causa: '+ e.getCause());
            system.debug('Erro mensage - dados: ' + e.getMessage());
        }
    }
}