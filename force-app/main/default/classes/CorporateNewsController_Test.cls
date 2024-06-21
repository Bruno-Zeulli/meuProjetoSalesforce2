/**
 * @description Classe para prover o teste na classse de corporate news
 * @author Peterson Silva
 */
@isTest
public with sharing class CorporateNewsController_Test {
    Date dtSystemCC;
    public CorporateNewsController_Test(){
        dtSystemCC = Date.today();
    }
    /**
     * @description Método para implementar o teste na classe
     */
    public static testMethod void runCNewsTest(){
        try
        {
            /**
             * @description Método que inicia o ciclo de testes
             */
            Test.startTest();

            Profile profilegr = [Select Id from Profile where name = 'Administrador'];
                User userADM = new User(
                    ProfileId = profilegr.Id,
                    Username = 'manageruser@cc.com',
                    Alias = 'usr_mg',
                    Email='testmge@cc.net.com',
                    EmailEncodingKey='UTF-8',
                    Firstname='Teste',
                    Lastname='Class',
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US',
                    isActive = true,
                    TimeZoneSidKey ='America/Sao_Paulo');
                INSERT userADM;

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

                CMS_INTERNAL__c cmsRecord = new CMS_INTERNAL__c(Name = 'Teste', title__c = 'Teste de classe', body__c = ' asd asd asd as 61542490000142', summary__c = 'as asd asd as d', isactive__c = true);
                Insert cmsRecord;
                String strCmstId = cmsRecord.Id;

                cms_interaction__c cmsIntRecord = new cms_interaction__c  (Name = 'Teste I', comments__c = 'teste', OwnerId = strUserId);
                Insert cmsIntRecord;

                CorporateNewsController.getCorporateNews();
                CorporateNewsController.getRecordCNews(strCmstId);
                CorporateNewsController.putCommentsCNews('Comentários',strCmstId);
                CorporateNewsController.putLikeCNews(strCmstId);

            /**
             * @description Método que inicia o ciclo de testes
             */
            Test.stopTest();
        }
        catch(exception e){
            system.debug('Erro causa: '+ e.getCause());
            system.debug('Erro mensage - dados: ' + e.getMessage());
        }
    }
}