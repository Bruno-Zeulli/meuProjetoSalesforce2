/**
 * @author Peterson Silva
 */

@isTest
public with sharing class CorporateLeadController_Test {
    public CorporateLeadController_Test(){

    }
    public static testMethod void runLeadTeste(){
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

                for(Integer i = 0; i < 5; i++){
                    if(i < 3){
                        Lead leadrecord = new Lead(
                            LastName = 'Teste_'+i, FirstName = 'TesteFirstName'+i, Status = 'Qualified', OwnerId = strUserId
                        );
                    }
                    else{
                        Lead leadrecord = new Lead(
                            LastName = 'Teste_'+i, FirstName = 'TesteFirstName'+i, Status = 'Contato realizado', OwnerId = strUserId
                        );
                    }
                }

                for(Integer i = 0; i < 5; i++){
                    if(i < 3){
                        Lead leadrecord = new Lead(
                            LastName = 'Teste_'+i, FirstName = 'TesteFirstName'+i, Status = 'Qualified', OwnerId = userGR.Id
                        );
                    }
                    else{
                        Lead leadrecord = new Lead(
                            LastName = 'Teste_'+i, FirstName = 'TesteFirstName'+i, Status = 'Contato realizado', OwnerId = userGR.Id
                        );
                    }
                }

                System.runAs(userGN)
                {
                    CorporateLeadController.getUserLeads();
                }
                System.runAs(userGR)
                {
                    CorporateLeadController.getUserLeads();
                }
            Test.stopTest();
        }
        catch(exception e){
            system.debug('Erro causa: '+ e.getCause());
            system.debug('Erro mensage - dados: ' + e.getMessage());
        }
    }
}