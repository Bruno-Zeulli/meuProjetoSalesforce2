/**
 * @description Classe para prover o teste na classe CorporateCustomerPainelController que alimenta a home do cockpit de clientes
 */
@isTest
public with sharing class CorporateCustomerDetailView_Test {
    Date dtSystem;
    public CorporateCustomerDetailView_Test(){
        dtSystem = Date.today();

    }

    public static testMethod void runTeste(){        
        try{

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

            List<Contract2__c> lstNovoContratoGr = new List<Contract2__c>();
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
                    OwnerId = userGR.Id, 
                    EndDate__c = dtContrato, 
                    Status__c = 'Ativo',
                    BidNumber__c = '01521429'+i,
                    ProductFamily__c = 'Auto'
                    );
                    
                lstNovoContratoGr.add(contractRecord);
            }
            Insert lstNovoContratoGr;
            System.debug(lstNovoContratoGr.size() + ' Contratos inseridos GR');

                CorporateCustomerDetailView.getVincendosRecordsSumarrized(strAccountId);
                CorporateCustomerDetailView.getCustomerContracts(strAccountId);
                CorporateCustomerDetailView.getReporIds();
            Test.stopTest();
        }
        catch(exception e){
            system.debug('Erro causa: '+ e.getCause());
            system.debug('Erro mensage - dados: ' + e.getMessage());
        }
    }

}