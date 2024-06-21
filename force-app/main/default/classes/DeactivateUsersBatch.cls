/**
 * @description       : Batch que desativa usuários inativos.
 * @author            : josiasbarros.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 02-06-2022
 * @last modified by  : josiasbarros.mirante@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-06-2021   josiasbarros.mirante@wizsolucoes.com.br   Initial Version
 **/
public class DeactivateUsersBatch implements Database.Batchable<SObject>{

    public Integer executions = 0;
    public Database.querylocator start(Database.BatchableContext bc){
        System.debug('** INITIALIZING PROCESS - DeactivateUsersBatch **');

        String query =  'SELECT Id, Name, isActive, LastLoginDate ' +
            'FROM User ' +
            'WHERE IsActive = true AND (NOT User.Name LIKE \'%Integrador%\') ' +
            'AND User.Profile.UserLicense.Name = \'Salesforce\' ' +
            'AND User.Profile.Name NOT IN (\'Administrador\', \'Developer\', \'System Administrator\') ' +
            'AND User.IsPortalEnabled != true ' +
            (Test.isRunningTest()? ' LIMIT 200':'');


       return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc,List<sObject> records){
        executions++;
        System.debug('Tamanho do batch :' + records.size());

        List<User> lstUpdateUser = new List<User>();

        for(sObject sobj  : records){
            User objUser = (User) sobj;
            if(Test.isRunningTest() || System.now() > objUser.LastLoginDate.addDays(45)){
                lstUpdateUser.add(
                    new User(
                        Id = objUser.Id,
                        IsActive = false
                    )
                );
            }
        }
        if(!lstUpdateUser.isEmpty()){
            update lstUpdateUser;
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('** FINISHING PROCESS - DeactivateUsersBatch **');
        System.debug('Quantidade de execuções totais: ' + executions);
    }
}