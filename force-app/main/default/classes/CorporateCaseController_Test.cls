/**
 * @description Classe de testes para o modulo de casos
 *  @author Peterson Silva
 */
@isTest
public with sharing class CorporateCaseController_Test {
  Date dtsystem;
  public CorporateCaseController_Test(){
    dtsystem = Date.today();
  }
  /**
   * @description Método para implementar o teste na classe
   */
  public static testMethod void runcaseTeste(){
     try{
      /**
       * @description Método que inicia os testes
       */
      Test.startTest();

      Profile profilegr = [SELECT Id FROM Profile WHERE name = 'Corporate - Gerente Regional'];
      User userGR = new User(
        ProfileId = profilegr.Id,
        Username = 'manageruser@cc.com',
        Alias = 'usr_mg',
        Email = 'testmge@cc.net.com',
        EmailEncodingKey = 'UTF-8',
        Firstname = 'Teste MG',
        Lastname = 'Class MG',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        isActive = true,
        TimeZoneSidKey = 'America/Sao_Paulo'
      );
      insert userGR;

      Profile profile1 = [SELECT Id FROM Profile WHERE name = 'Corporate - Gerente de Negócios'];
      User userGN = new User(
        ProfileId = profile1.Id,
        ManagerId = userGR.Id,
        Username = 'testeusuariocc@cc.com',
        Alias = 'usr_cc',
        Email = 'teste@cc.net.com',
        EmailEncodingKey = 'UTF-8',
        Firstname = 'Teste',
        Lastname = 'Class',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        isActive = true,
        TimeZoneSidKey = 'America/Sao_Paulo'
      );
      insert userGN;

      String strUserId = userGN.Id;

      Account accRecord = new Account(
        Name = 'Teste',
        CompanyIdentificationNumber__c = '61542490000142',
        IdentificationNumber__c = '61542490000142',
        OwnerId = strUserId
      );
      insert accRecord;
      String strAccountId = accRecord.Id;

      List<Opportunity> lstOpp = new List<Opportunity>();
      for(Integer i = 0; i < 4; i++){
        Opportunity oppRecord = new Opportunity(
          OwnerId = strUserId,
          Name = 'Nova Oportunidade__' + i,
          Accountid = strAccountId,
          Type = 'New',
          StageName = 'Levantamento de Necessidades',
          Closedate = Date.Today()
        );
        lstOpp.add(oppRecord);
      }
      insert lstOpp;

      Case caseRecord = new Case(
        Subject = 'Cotação CT',
        Status = 'New',
        Description = 'teste',
        Opportunity__c = lstOpp[0].Id,
        OwnerId = strUserId
      );
      insert caseRecord;

      System.runAs(userGN){
        CorporateCaseController.getUserCases();
      }
      System.runAs(userGR){
        CorporateCaseController.getUserCases();
      }
      /**
       * @description Método que finaliza os testes
       */
      Test.stopTest();
    } catch (exception e){
      system.debug('Erro causa: ' + e.getCause());
      system.debug('Erro mensage - dados: ' + e.getMessage());
    }
  }
}