/**
 * @description Classe para efetuar os testes do painel de performance
 */
@isTest
public with sharing class CorporateUserPerformanceController_Test {
    
    Date dtSystem;
    /**
     * @description Método construtor
     */
    public CorporateUserPerformanceController_Test(){
        dtSystem = Date.today();
    }
    /**
     * @description Método que roda os testes
     */
    public static testMethod void runTeste(){        
        try{

            Test.startTest();

            Profile profile1 = [Select Id from Profile where name = 'Corporate - Gerente de Negócios'];
            User userGN = new User(
                ProfileId = profile1.Id,
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

            List<RecordType> rtEndosso = new List<RecordType>([SELECT id FROM RecordType where DeveloperName  IN ('CorporateEndossoMovimentaoPremio','CorporateApolice') ORDER BY DeveloperName ]);
            String strApolice = rtEndosso[0].Id;
            String strEndosso = rtEndosso[1].Id;

            String strRecordType;
            String strStatus;
            List<Order> lstOrd = new List<Order>();
            for(Integer i = 0; i < 4; i++){
                if(i<2){
                    strRecordType = strApolice;
                    strStatus = 'CarriedOut';
                }
                else
                {
                    strRecordType = strEndosso;
                    strStatus = 'CarriedOut';
                }
                String strtype = 'New';
               
                Order ordRecord = new Order(
                    AccountId = strAccountId,
                    Company__c = 'CAIXA Seguradora',
                    OwnerId = strUserId, 
                    EndDate = Date.Today(),
                    EffectiveDate = Date.Today(), 
                    Status = strStatus, 
                    PoNumber = '01521422'+i,
                    RecordTypeId = strRecordType,
                    Type = strtype
                );
                lstOrd.add(ordRecord);
            }
            Insert lstOrd;
            System.debug(lstOrd.size());

            List<Contract2__c> lstNovoContrato = new List<Contract2__c>();
            Date dtContrato;
            for(Integer i = 0; i < 4; i++)
            {
                if(i == 0){
                    dtContrato = Date.Today() + 90;
                }else if(i == 1){
                    dtContrato = Date.Today() + 60;
                }else if(i == 2){
                    dtContrato = Date.Today() + 45;
                }else if(i == 3){
                    dtContrato = Date.Today() + 30;
                }

                System.debug(dtContrato + ' - ' + i);

                Contract2__c contractRecord = new Contract2__c(
                    Account__c = strAccountId, 
                    Company__c = 'CAIXA Seguradora', 
                    OwnerId = strUserId, 
                    EndDate__c = dtContrato, 
                    Status__c = 'Ativo',
                    BidNumber__c = '01521422'+i,
                    ProductFamily__c = 'Auto'
                    );
                    
                lstNovoContrato.add(contractRecord);
            }
            Insert lstNovoContrato;
            System.debug(lstNovoContrato.size() + ' Contratos inseridos');

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

            Quote quotRecord = new Quote(
                ownerid = strUserId,
                opportunityid = lstOpp[0].id,
                Company__c = 'Caixa Seguradora'
            );
            Insert quotRecord;

            System.runAs(userGN)
            {
                CorporateUserPerformanceController.getUserInformation();
            }

            Test.stopTest();
        }
        catch(exception e){
            system.debug('Erro causa: '+ e.getCause());
            system.debug('Erro mensage - dados: ' + e.getMessage());
        }
    }
}